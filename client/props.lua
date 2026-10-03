-- Props the player holds while tampering, synced through a player state bag: every client spawns its
-- own local copy on that player's hand, and lights the lighter's flame when the state says so. The
-- fluid catching in the engine bay is a networked particle started by the tampering player

local stateKey = "zyke_burncars:heldProp"
local assetTimeout = 5000
local ptfxDict = "core"
local flameFx, flameScale = "ent_amb_torch_fire", .12
-- Sparks as the flame touches the fluid, then the fluid burning until the engine fire takes over
local sparkFx, sparkScale, sparkMs = "ent_brk_sparking_wires_sp", .3, 300
local engineFlameScale = .5
-- A thin stream out of the tin's spout, which sits at the top of the tin's model space
local pourDict, pourFx, pourScale = "scr_amb_chop", "ent_anim_dog_peeing", 1.0
local spoutOffset = vector3(0.0, 0.0, .095)
-- The lean moves the hand around, so the stream only runs while the spout is tipped this far over;
-- the value is the height of the tin's up direction, 1 upright and 0 on its side
local pourTilt = .35
local pourCheckMs = 100
-- A looped particle cuts off on the frame it is stopped, so it is shrunk away first
local fadeMs = 250
-- Just above the gas nozzle in the lighter's model space
local flameOffset = vector3(0.0, -.0035, .042)

-- Attachments to the right hand's prop bone; tune these with zyke_propaligner
---@type table<string, HeldPropSettings>
local props = {
    fluid = {model = joaat("zyke_lighter_fluid"), bone = 28422, pos = vector3(.02, .01, -.04), rot = vector3(-110.0, 0.0, 0.0)},
    lighter = {model = joaat("zyke_lighter"), bone = 28422, pos = vector3(.01, .0, -.02), rot = vector3(0.0, 0.0, 0.0)},
}

---@type table<integer, HeldProp> @ Server id -> held prop
local held = {}
---@type integer? @ Looped flame in the engine bay the local player lit
local engineFlame

---@param handle integer
---@param scale number @ Scale the particle runs at
local function fadeOutFx(handle, scale)
    CreateThread(function()
        local startedAt = GetGameTimer()
        local left = 1.0

        while (left > 0.0) do
            SetParticleFxLoopedScale(handle, scale * left)
            Wait(0)

            left = 1.0 - (GetGameTimer() - startedAt) / fadeMs
        end

        StopParticleFxLooped(handle, false)
    end)
end

---@param entry HeldProp
---@param fade? boolean @ Shrinks the flame away, for when the lighter stays in the hand
local function stopFlame(entry, fade)
    if (not entry.flame) then return end

    if (fade) then
        fadeOutFx(entry.flame, flameScale)
    else
        StopParticleFxLooped(entry.flame, false)
    end

    entry.flame = nil
end

---@param entry HeldProp
local function stopStream(entry)
    if (not entry.stream) then return end

    StopParticleFxLooped(entry.stream, false)
    entry.stream = nil
end

---@param serverId integer
local function deleteHeldProp(serverId)
    local entry = held[serverId]
    if (not entry) then return end

    stopFlame(entry)
    stopStream(entry)
    if (DoesEntityExist(entry.object)) then DeleteEntity(entry.object) end

    held[serverId] = nil
end

---@param ped integer
---@param kind string
---@return HeldProp? entry
local function createHeldProp(ped, kind)
    local settings = props[kind]
    if (not Z.loadModel(settings.model, true, assetTimeout)) then return nil end

    local coords = GetEntityCoords(ped)
    local object = CreateObject(settings.model, coords.x, coords.y, coords.z, false, false, false)
    SetModelAsNoLongerNeeded(settings.model)
    if (object == 0) then return nil end

    SetEntityCollision(object, false, false)
    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, settings.bone), settings.pos.x, settings.pos.y, settings.pos.z, settings.rot.x, settings.rot.y, settings.rot.z, true, true, false, false, 2, true)

    return {kind = kind, object = object}
end

---@param dict? string @ Defaults to the asset the flames and sparks are in
---@return boolean loaded
local function loadPtfx(dict)
    dict = dict or ptfxDict
    RequestNamedPtfxAsset(dict)

    local timeoutAt = GetGameTimer() + assetTimeout

    while (not HasNamedPtfxAssetLoaded(dict) and GetGameTimer() < timeoutAt) do
        Wait(0)
    end

    return HasNamedPtfxAssetLoaded(dict)
end

-- Runs for as long as the tin is the held prop; the stream is stopped with the prop
---@param serverId integer
---@param entry HeldProp
local function runPourStream(serverId, entry)
    CreateThread(function()
        if (not loadPtfx(pourDict)) then return end

        while (held[serverId] == entry and DoesEntityExist(entry.object)) do
            local _, _, up = GetEntityMatrix(entry.object)
            local tipped = up.z <= pourTilt

            if (tipped and not entry.stream) then
                UseParticleFxAssetNextCall(pourDict)
                entry.stream = StartParticleFxLoopedOnEntity(pourFx, entry.object, spoutOffset.x, spoutOffset.y, spoutOffset.z, 0.0, 0.0, 0.0, pourScale, false, false, false)
            elseif (not tipped) then
                stopStream(entry)
            end

            Wait(pourCheckMs)
        end
    end)
end

---@param entry HeldProp
local function lightFlame(entry)
    if (entry.flame or not loadPtfx()) then return end

    UseParticleFxAssetNextCall(ptfxDict)
    entry.flame = StartParticleFxLoopedOnEntity(flameFx, entry.object, flameOffset.x, flameOffset.y, flameOffset.z, 0.0, 0.0, 0.0, flameScale, false, false, false)
end

-- Networked, so the one call from the tampering player shows for everyone around the vehicle
---@param vehicle integer
---@param offset vector3 @ Where the fluid catches, local to the vehicle
function StartEngineFlame(vehicle, offset)
    if (engineFlame or not DoesEntityExist(vehicle) or not loadPtfx()) then return end

    UseParticleFxAssetNextCall(ptfxDict)
    local sparks = StartNetworkedParticleFxLoopedOnEntity(sparkFx, vehicle, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, sparkScale, false, false, false)
    SetTimeout(sparkMs, function() StopParticleFxLooped(sparks, false) end)

    UseParticleFxAssetNextCall(ptfxDict)
    engineFlame = StartNetworkedParticleFxLoopedOnEntity(flameFx, vehicle, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, engineFlameScale, false, false, false)
end

function StopEngineFlame()
    if (not engineFlame) then return end

    fadeOutFx(engineFlame, engineFlameScale)
    engineFlame = nil
end

-- Sets what the local player holds for everyone; "lighterLit" holds the lighter with its flame on
---@param state? "fluid" | "lighter" | "lighterLit"
function SetHeldProp(state)
    LocalPlayer.state:set(stateKey, state, true)
end

---@param bagName string
---@param key string
---@param value? "fluid" | "lighter" | "lighterLit"
---@param reserved integer
---@param replicated boolean
AddStateBagChangeHandler(stateKey, nil, function(bagName, key, value, reserved, replicated)
    if (replicated) then return end

    local ply = GetPlayerFromStateBagName(bagName)
    if (ply == 0) then return end

    local serverId = GetPlayerServerId(ply)
    local kind = value == "fluid" and "fluid" or (value and "lighter" or nil)
    local entry = held[serverId]

    if (entry and entry.kind ~= kind) then
        deleteHeldProp(serverId)
        entry = nil
    end

    if (not kind) then return end

    local created = not entry

    entry = entry or createHeldProp(GetPlayerPed(ply), kind)
    held[serverId] = entry
    if (not entry) then return end
    if (created and kind == "fluid") then runPourStream(serverId, entry) end

    if (value == "lighterLit") then
        lightFlame(entry)
    else
        stopFlame(entry, true)
    end
end)

---@param serverId integer
RegisterNetEvent("onPlayerDropped", function(serverId)
    deleteHeldProp(serverId)
end)

---@param resourceName string
AddEventHandler("onResourceStop", function(resourceName)
    if (resourceName ~= ResName) then return end

    for serverId in pairs(held) do
        deleteHeldProp(serverId)
    end

    if (engineFlame) then StopParticleFxLooped(engineFlame, false) end
end)