-- Marks the engine of nearby vehicles while the player carries the needed items; aiming at one shows
-- the tamper key there through zyke_lib interest points, and pressing it walks the player up to the
-- engine to work on it. The server validates the tamper and burns the vehicle on its owner

local tamperKey = "zyke_burncars_tamper"
local cancelKey = "zyke_burncars_cancel"
local cancelMouseKey = "zyke_burncars_cancelmouse"
local cancelPromptId = "cancelTamper"
local markerSet = "engines"
-- Vehicles whose origin is further away than this get no marker
local searchDistance = 8.0
-- Metres from the player an engine can be tampered with at
local tamperReach = 2.0
-- Markers show a little past the reach, so the player is guided over before they can tamper
local markerDistance = 3.5
local refreshInterval = 250
-- How often the carried items are read while no marker is shown
local itemCheckInterval = 1000
-- A line of sight ray ending this close to a marker still sees it, since it sits on the body
local sightTolerance = 0.5
-- Idle ring opacity of an engine that can't be tampered with, so the ones that can stand out
local blockedOpacity = 0.5
-- Movement stick deflection that cancels the walk over
local cancelDeflection = 0.5
-- Metres out from the bumper the player stands, so they lean over the open engine cover
local standOffset = 0.35
-- Metres out from the side of a bike the player crouches
local bikeStandOffset = 0.45
-- Metres in from the bumper the marker sits on the engine cover
local markerInset = 0.5
local bikeClass = 8
local bonnetDoor, bootDoor = 4, 5
local animBlend = 4.0
-- Opening up the engine keeps both hands down in the bay; pouring and lighting reach over it with
-- the right hand, so the held prop shows above the engine
local carOpenAnim = {dict = "mini@repair", clip = "fixing_a_player"}
local carHoldAnim = {dict = "mini@repair", clip = "fixing_a_ped"}
local bikeAnim = {dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", clip = "machinic_loop_mechandplayer"}
local requestTimeout = 5000
-- Share of the tamper each step starts at: working the engine open, pouring the fluid in, rolling the
-- lighter's wheel and finally holding the flame to the fluid
local pourAt, lightAt, flameAt = .4, .8, .86
local progressInterval = 100
-- The player stands up from the engine this long before the bar fills, so the animation does not
-- cut off right as the tamper finishes
local animLeadMs = 1000
-- The lighter only burns for a moment: the fluid catches shortly after the flame is lit, and the
-- lighter is closed again once it has
local igniteDelayMs, handFlameMs = 300, 700
-- Metres under the engine cover marker the fluid catches at
local engineFlameDrop = 0.1
-- The fluid keeps burning this long into the engine fire, so the two overlap instead of leaving a gap
local engineFlameOverlapMs = 500
---@type table<string, string> @ Held prop state -> progress label
local stepLabels = {
    fluid = "pouringFluid",
    lighter = "lightingFluid",
    lighterLit = "lightingFluid",
}
local fireSpread = 25
-- The vehicle stays invincible this long after the fire is put out, so it does not blow up straight after
local invincibleTailMs = 1000

local tamperLabel = T("tamper")
---@type table<string, string> @ Block reason -> marker hint
local reasonHints = {
    vehicleProtected = T("hint:vehicleProtected"),
    vehicleMoving = T("hint:vehicleMoving"),
    vehicleOccupied = T("hint:vehicleOccupied"),
    vehicleRunning = T("hint:vehicleRunning"),
}

---@type table<string, TamperTarget>
local targets = {}
local tampering = false
local cancelled = false
local movementReleased = false
local markersShown = false
local hasItems = false
local nextItemCheck = 0

---@param ped integer
---@return boolean canTamper
local function canPedTamper(ped)
    if (tampering) then return false end
    if (IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) or IsPedRagdoll(ped) or IsPedSwimming(ped)) then return false end

    return not Z.progressBar.active()
end

-- Read from the client inventory, only to decide whether markers show; the server checks again
---@return boolean carrying
local function isCarryingItems()
    local now = GetGameTimer()
    if (now < nextItemCheck) then return hasItems end

    nextItemCheck = now + itemCheckInterval
    hasItems = #Config.Settings.itemsNeeded == 0 or Z.hasItem(Config.Settings.itemsNeeded)

    return hasItems
end

---@param vehicle integer
---@return boolean isBike
local function isBike(vehicle)
    return GetVehicleClass(vehicle) == bikeClass
end

---@param vehicle integer
---@param bone string
---@return vector3? offset @ Bone position local to the vehicle
local function getBoneOffset(vehicle, bone)
    local boneIndex = GetEntityBoneIndexByName(vehicle, bone)
    if (boneIndex == -1) then return nil end

    local coords = GetWorldPositionOfEntityBone(vehicle, boneIndex)

    return GetOffsetFromEntityGivenWorldCoords(vehicle, coords.x, coords.y, coords.z)
end

---@type table<integer, EngineLayout> @ Model hash -> where its engine and engine cover are
local engineLayouts = {}

-- Read from the model's bones, so add-on vehicles need no list: the engine bone tells which half the
-- engine is in, and the cover is whichever of the bonnet and boot is hinged over that half. Some
-- rear engined models name their engine cover the bonnet, and some have no cover that opens at all
---@param vehicle integer
---@return EngineLayout layout
local function getEngineLayout(vehicle)
    local model = GetEntityModel(vehicle)
    local layout = engineLayouts[model]
    if (layout) then return layout end

    local min, max = GetModelDimensions(model)
    local middle = (min.y + max.y) / 2
    local engine = getBoneOffset(vehicle, "engine")
    local rear = engine ~= nil and engine.y < middle
    local doors = rear and {bootDoor, bonnetDoor} or {bonnetDoor, bootDoor}

    layout = {rear = rear}

    for i = 1, #doors do
        local cover = getBoneOffset(vehicle, doors[i] == bonnetDoor and "bonnet" or "boot")

        if (cover and GetIsDoorValid(vehicle, doors[i]) and (cover.y < middle) == rear) then
            layout.door, layout.coverZ = doors[i], cover.z

            break
        end
    end

    engineLayouts[model] = layout

    return layout
end

-- On the engine cover a little in from the bumper, at the height of the cover's hinge; a bike has
-- its engine bone between the wheels
---@param vehicle integer
---@return vector3 offset @ Marker position local to the vehicle
---@return boolean rear
local function getEngineOffset(vehicle)
    if (isBike(vehicle)) then return getBoneOffset(vehicle, "engine") or vector3(0.0, 0.0, 0.0), false end

    local min, max = GetModelDimensions(GetEntityModel(vehicle))
    local layout = getEngineLayout(vehicle)
    local y = layout.rear and min.y + markerInset or max.y - markerInset

    return vector3(0.0, y, layout.coverZ or max.z * 0.4), layout.rear
end

-- The ray may end on the vehicle's own body, since the marker sits on its engine cover
---@param point vector3
---@param vehicle integer
---@param origin vector3
---@param ped integer
---@return boolean visible
local function isPointVisible(point, vehicle, origin, ped)
    local ray = StartExpensiveSynchronousShapeTestLosProbe(origin.x, origin.y, origin.z, point.x, point.y, point.z, 19, ped, 4)
    local _, hit, hitCoords, _, hitEntity = GetShapeTestResult(ray)
    if (hit ~= true and hit ~= 1) then return true end
    if (hitEntity == vehicle) then return true end

    return #(hitCoords - point) <= sightTolerance
end

---@param markers InterestPoint[]
---@param vehicle integer
---@param reason? string @ Locale key for why the vehicle can't be tampered with
---@param pedCoords vector3
---@param origin vector3
---@param ped integer
local function addEngineMarker(markers, vehicle, reason, pedCoords, origin, ped)
    local offset, rear = getEngineOffset(vehicle)
    local point = GetOffsetFromEntityInWorldCoords(vehicle, offset.x, offset.y, offset.z)
    if (#(point - pedCoords) > markerDistance or not isPointVisible(point, vehicle, origin, ped)) then return end

    local id = tostring(vehicle)

    targets[id] = {vehicle = vehicle, offset = offset, rear = rear, bike = isBike(vehicle)}
    markers[#markers + 1] = {
        id = id,
        entity = vehicle,
        offset = offset,
        key = "+" .. tamperKey,
        label = tamperLabel,
        hint = reason and reasonHints[reason] or nil,
        opacity = reason and blockedOpacity or nil,
        reach = tamperReach,
    }
end

local function hideMarkers()
    if (not markersShown) then return end

    markersShown = false
    Z.clearInterestPoints(markerSet)
end

local function refreshMarkers()
    targets = {}

    local ped = PlayerPedId()
    if (not canPedTamper(ped)) then hideMarkers() return end

    local pedCoords = GetEntityCoords(ped)
    local vehicles = GetGamePool("CVehicle")
    local nearby = {}

    -- Vehicles only this client knows about, such as showroom cars, can't be validated by the server,
    -- and ignored ones are left alone completely
    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        if (#(GetEntityCoords(vehicle) - pedCoords) <= searchDistance and NetworkGetEntityIsNetworked(vehicle) and not IsVehicleIgnored(vehicle)) then
            nearby[#nearby + 1] = vehicle
        end
    end

    -- The inventory is only read once there is a vehicle to mark
    if (#nearby == 0 or not isCarryingItems()) then hideMarkers() return end

    local origin = GetFinalRenderedCamCoord()
    local markers = {}

    for i = 1, #nearby do
        local vehicle = nearby[i]
        local reason = GetBurnBlockReason(vehicle)

        -- A wrecked engine has nothing left to burn, so it gets no marker at all
        if (reason ~= "engineDestroyed" and (not reason or Config.Settings.alwaysShowMarkers)) then
            addEngineMarker(markers, vehicle, reason, pedCoords, origin, ped)
        end
    end

    markersShown = true
    Z.setInterestPoints(markerSet, markers, {aim = true})
end

-- In front of the bumper, or behind it for a rear engine, and beside a bike on the player's side; on
-- the ground, since the walk task judges arrival against the ped's feet rather than the marker
---@param target TamperTarget
---@param pedCoords vector3
---@return vector3 standCoords
local function getStandCoords(target, pedCoords)
    local vehicle = target.vehicle
    local min, max = GetModelDimensions(GetEntityModel(vehicle))
    local coords

    if (target.bike) then
        local pedOffset = GetOffsetFromEntityGivenWorldCoords(vehicle, pedCoords.x, pedCoords.y, pedCoords.z)
        local x = pedOffset.x >= 0.0 and max.x + bikeStandOffset or min.x - bikeStandOffset

        coords = GetOffsetFromEntityInWorldCoords(vehicle, x, target.offset.y, 0.0)
    else
        coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, target.rear and min.y - standOffset or max.y + standOffset, 0.0)
    end

    local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 1.0, false)

    return vector3(coords.x, coords.y, found and groundZ or coords.z)
end

-- The cancel keys set the flag; walking off with the movement keys sets it too, so it holds once
-- the keys are let go. Movement only counts once the keys were let go after the press, since the
-- player is often still walking over when they press the tamper key
---@return boolean cancelled
local function isWalkCancelled()
    local moving = math.abs(GetDisabledControlNormal(0, 30)) > cancelDeflection or math.abs(GetDisabledControlNormal(0, 31)) > cancelDeflection

    if (not moving) then
        movementReleased = true
    elseif (movementReleased) then
        cancelled = true
    end

    return cancelled
end

---@param target TamperTarget
---@return boolean ready @ The player reached the engine and faces it
local function moveToEngine(target)
    local ped = PlayerPedId()
    local vehicle = target.vehicle
    local offset = target.offset
    local engine = GetOffsetFromEntityInWorldCoords(vehicle, offset.x, offset.y, offset.z)
    local standCoords = getStandCoords(target, GetEntityCoords(ped))
    local heading = GetHeadingFromVector_2d(engine.x - standCoords.x, engine.y - standCoords.y)

    cancelled = false
    movementReleased = false
    Z.showPrompt(cancelPromptId, {"+" .. cancelKey, "+" .. cancelMouseKey}, T("tamperCancel"))

    local arrived = WalkPedToCoords(ped, standCoords, heading, vehicle, isWalkCancelled)
    Z.hidePrompt(cancelPromptId)

    if (isWalkCancelled()) then return false end
    -- A blocked walk still tampers from wherever the player stopped, as long as the engine is in reach
    if (not arrived and (not DoesEntityExist(vehicle) or #(GetEntityCoords(ped) - engine) > tamperReach)) then return false end

    TurnPedToFace(ped, engine)

    return true
end

---@param share number @ How far into the tamper, 0-1
---@return "fluid" | "lighter" | "lighterLit" | nil step
local function getTamperStep(share)
    if (share >= flameAt) then return "lighterLit" end
    if (share >= lightAt) then return "lighter" end
    if (share >= pourAt) then return "fluid" end

    return nil
end

---@param target TamperTarget
---@param step? string
---@return {dict: string, clip: string} anim
local function getStepAnim(target, step)
    if (target.bike) then return bikeAnim end

    return step and carHoldAnim or carOpenAnim
end

---@param ped integer
---@param anim {dict: string, clip: string}
local function playStepAnim(ped, anim)
    if (IsEntityPlayingAnim(ped, anim.dict, anim.clip, 3)) then return end

    TaskPlayAnim(ped, anim.dict, anim.clip, animBlend, animBlend, -1, 1, 0.0, false, false, false)
end

---@param ped integer
---@param openAnim {dict: string, clip: string}
---@param holdAnim {dict: string, clip: string}
local function stopStepAnims(ped, openAnim, holdAnim)
    StopAnimTask(ped, openAnim.dict, openAnim.clip, animBlend)
    StopAnimTask(ped, holdAnim.dict, holdAnim.clip, animBlend)
end

-- One manual progress bar for the whole tamper while the steps swap the animation, the held prop
-- and the label; the bar is left without an animation of its own so it never restarts one
---@param target TamperTarget
---@return boolean finished
local function runTamperProgress(target)
    local ped = PlayerPedId()
    local openAnim = getStepAnim(target, nil)
    local holdAnim = getStepAnim(target, "fluid")
    if (not Z.loadDict(openAnim.dict) or not Z.loadDict(holdAnim.dict)) then return false end

    local shown = Z.progressBar.show({
        label = T("tamperingWithCar"),
        progress = 0,
        canCancel = true,
        disableControls = {disableMovement = true, disableCarMovement = true, disableCombat = true},
    })
    if (not shown) then return false end

    local duration = Config.Settings.tamperDuration * 1000
    local startedAt = GetGameTimer()
    local animStopAt = startedAt + duration - animLeadMs
    local finished = false
    local animStopped = false
    local litAt, ignited
    local step

    playStepAnim(ped, openAnim)

    -- Cancelling or getting knocked over closes the bar early
    while (Z.progressBar.active()) do
        local share = (GetGameTimer() - startedAt) / duration

        if (share >= 1.0) then
            finished = true
            Z.progressBar.hide({success = true, progress = 100})

            break
        end

        if (not animStopped and GetGameTimer() >= animStopAt) then
            animStopped = true
            stopStepAnims(ped, openAnim, holdAnim)
        end

        local nextStep = getTamperStep(share)

        if (nextStep == "lighterLit") then
            local now = GetGameTimer()
            litAt = litAt or now

            if (not ignited and not animStopped and now - litAt >= igniteDelayMs) then
                local offset = target.offset

                ignited = true
                StartEngineFlame(target.vehicle, target.bike and offset or vector3(offset.x, offset.y, offset.z - engineFlameDrop))
            end

            -- Closing the lighter keeps it in the hand without its flame
            if (animStopped or now - litAt >= handFlameMs) then nextStep = "lighter" end
        end

        if (nextStep ~= step) then
            step = nextStep
            SetHeldProp(step)
            if (not animStopped) then playStepAnim(ped, getStepAnim(target, step)) end
            Z.progressBar.update({label = T(stepLabels[step] or "tamperingWithCar"), progress = share * 100})
        else
            Z.progressBar.update({progress = share * 100})
        end

        Wait(progressInterval)
    end

    stopStepAnims(ped, openAnim, holdAnim)
    RemoveAnimDict(openAnim.dict)
    RemoveAnimDict(holdAnim.dict)

    return finished
end

---@param reason string @ Locale key the server refused or finished the tamper with
local function notifyResult(reason)
    if (reason ~= "missingItems") then Z.notify(reason) return end

    local _, missing = Z.getMissingItems(Config.Settings.itemsNeeded)
    Z.notify("missingItems", {missing})
end

---@param target TamperTarget
local function tamperVehicle(target)
    if (not moveToEngine(target)) then return end

    local vehicle = target.vehicle
    if (not DoesEntityExist(vehicle)) then return end

    -- The vehicle can drive off or get someone in while the player walks over
    local reason = GetBurnBlockReason(vehicle)
    if (reason) then Z.notify(reason) return end

    -- The server validates and rewards the tamper, so a vehicle only this client knows about is skipped
    local netId = Z.network.getNetId(vehicle)
    if (not netId) then Z.notify("tamperFailed") return end

    local status, refused = Z.callback.request("zyke_burncars:StartTamper", {status = true, timeout = requestTimeout}, netId)
    if (not status.ok) then Z.notify("tamperFailed") return end
    if (refused) then notifyResult(refused) return end

    local finished = runTamperProgress(target)

    if (not finished) then
        SetHeldProp(nil)
        StopEngineFlame()
        TriggerServerEvent("zyke_burncars:CancelTamper")

        return
    end

    local finishStatus, notification = Z.callback.request("zyke_burncars:FinishTamper", {status = true, timeout = requestTimeout})
    SetHeldProp(nil)
    if (not finishStatus.ok or type(notification) ~= "string") then
        StopEngineFlame()
        Z.notify("tamperFailed")

        return
    end

    -- The fluid is left burning until the engine fire has taken over; a refused tamper puts it out
    if (notification == "vehicleTampered") then
        SetTimeout(Config.Settings.fire.delay * 1000 + engineFlameOverlapMs, StopEngineFlame)
    else
        StopEngineFlame()
    end

    notifyResult(notification)
end

local function onTamperPressed()
    -- Read at the press, so it is the engine shown on the marker right now
    local id = Z.getAimedInterestPoint(markerSet)
    local target = id and targets[id]
    if (not target or not DoesEntityExist(target.vehicle)) then return end
    if (not canPedTamper(PlayerPedId())) then return end

    local reason = GetBurnBlockReason(target.vehicle)

    if (reason) then
        Z.shakeInterestPoint(markerSet, id)
        Z.notify(reason)

        return
    end

    -- Set before anything yields, so a second press can not start another tamper
    tampering = true
    hideMarkers()

    -- Key callbacks come in from zyke_lib and the tamper yields through the walk and the progress bar
    CreateThread(function()
        tamperVehicle(target)
        tampering = false
    end)
end

local function onCancelPressed()
    if (tampering) then cancelled = true end
end

Z.registerKey(tamperKey, "E", T("keybind:tamper"), onTamperPressed)
Z.registerKey(cancelKey, "X", T("keybind:cancelTamper"), onCancelPressed)
Z.registerKey(cancelMouseKey, "MOUSE_RIGHT", T("keybind:cancelTamper"), onCancelPressed, nil, "mouse_button")

-- Only the owner's door state replicates, so the server sends this to whoever owns the vehicle
---@param netId NetId
---@param open boolean
RegisterNetEvent("zyke_burncars:SetEngineCoverOpen", function(netId, open)
    local vehicle = Z.network.getEntity(netId)
    if (not vehicle or isBike(vehicle)) then return end

    local door = getEngineLayout(vehicle).door
    if (not door) then return end

    if (open) then
        SetVehicleDoorOpen(vehicle, door, false, false)
    else
        SetVehicleDoorShut(vehicle, door, false)
    end
end)

-- Sent to whoever owns the vehicle, since only the owner's engine damage replicates; the fire starts
-- at the engine bone, or at the engine cover marker when the model has none
---@param netId NetId
RegisterNetEvent("zyke_burncars:BurnVehicle", function(netId)
    local vehicle = Z.network.getEntity(netId)
    if (not vehicle) then return end

    SetVehicleEngineOn(vehicle, false, true, true)
    SetVehicleUndriveable(vehicle, true)
    SetVehicleEngineHealth(vehicle, 0.0)
    -- Keeps the fire from spreading into an explosion
    SetEntityInvincible(vehicle, true)

    Wait(Config.Settings.fire.delay * 1000)
    if (not DoesEntityExist(vehicle)) then return end

    local engineBone = GetEntityBoneIndexByName(vehicle, "engine")
    local offset = getEngineOffset(vehicle)
    local coords = engineBone ~= -1 and GetWorldPositionOfEntityBone(vehicle, engineBone) or GetOffsetFromEntityInWorldCoords(vehicle, offset.x, offset.y, offset.z)
    local fire = StartScriptFire(coords.x, coords.y, coords.z, fireSpread, true)

    Wait(Config.Settings.fire.duration * 1000)
    RemoveScriptFire(fire)

    Wait(invincibleTailMs)
    if (DoesEntityExist(vehicle)) then SetEntityInvincible(vehicle, false) end
end)

CreateThread(function()
    while (true) do
        refreshMarkers()
        Wait(refreshInterval)
    end
end)