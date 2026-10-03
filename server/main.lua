-- Validates every tamper and burns the vehicle on the client that owns it, since only the owner's
-- engine damage and door state replicate to everyone else

-- Metres from the vehicle origin the player may stand, past the bumper of a long truck
local maxDistance = 8.0
-- Milliseconds a tamper may finish early by, since the progress bar starts after the server reserved it
local finishTolerance = 1000
-- Milliseconds past the tamper duration a reservation holds, should the client never finish or cancel
local reserveMargin = 15000
local tamperMs = Config.Settings.tamperDuration * 1000
local itemsNeeded = Config.Settings.itemsNeeded

---@type table<PlayerId, PendingTamper>
local pendingTampers = {}
---@type table<integer, integer> @ Vehicle -> os.time it is rewardable again
local cooldowns = {}

-- A vehicle nobody owns is handled by the tampering player, who then owns it
---@param vehicle integer
---@param plyId PlayerId
---@return PlayerId owner
local function getOwner(vehicle, plyId)
    local owner = NetworkGetEntityOwner(vehicle)

    return owner > 0 and owner or plyId
end

---@param vehicle integer
---@return PlayerId? plyId @ Player with an unexpired tamper on the vehicle
local function getReservingPlayer(vehicle)
    local now = GetGameTimer()

    for plyId, pending in pairs(pendingTampers) do
        if (pending.vehicle == vehicle and pending.expiresAt > now) then return plyId end
    end

    return nil
end

---@param pending PendingTamper
---@param plyId PlayerId
local function closeEngineCover(pending, plyId)
    if (Z.network.getEntity(pending.netId) ~= pending.vehicle) then return end

    TriggerClientEvent("zyke_burncars:SetEngineCoverOpen", getOwner(pending.vehicle, plyId), pending.netId, false)
end

---@param plyId PlayerId
local function cancelPending(plyId)
    local pending = pendingTampers[plyId]
    pendingTampers[plyId] = nil
    if (not pending) then return end

    closeEngineCover(pending, plyId)
end

---@param plyId PlayerId
---@param vehicle integer
---@return string? reason @ Locale key the tamper is refused with
local function validateTamper(plyId, vehicle)
    local ped = GetPlayerPed(plyId)
    if (GetVehiclePedIsIn(ped, false) ~= 0) then return "tamperFailed" end
    if (GetPlayerRoutingBucket(plyId) ~= GetEntityRoutingBucket(vehicle)) then return "tamperFailed" end
    if (#(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > maxDistance) then return "tamperFailed" end

    local reason = GetBurnBlockReason(vehicle)
    if (reason) then return reason end
    if (#itemsNeeded > 0 and not Z.hasItem(plyId, itemsNeeded)) then return "missingItems" end

    local allowed, denied = CanBurnVehicle(plyId, vehicle)
    if (not allowed) then return denied or "tamperFailed" end

    return nil
end

---@param plyId PlayerId
---@param pending PendingTamper
---@return string? reason @ Locale key the tamper is refused with
local function validateFinish(plyId, pending)
    local now = GetGameTimer()
    if (now < pending.finishAt or now > pending.expiresAt) then return "tamperFailed" end
    if (Z.network.getEntity(pending.netId) ~= pending.vehicle) then return "tamperFailed" end

    return validateTamper(plyId, pending.vehicle)
end

---@param plyId PlayerId
local function removeUsedItems(plyId)
    for i = 1, #itemsNeeded do
        local item = itemsNeeded[i]
        if (item.remove) then Z.removeItem(plyId, item.name, item.amount) end
    end
end

---@param plyId PlayerId
---@param netId NetId
---@return string? reason @ Locale key the tamper is refused with
Z.callback.register("zyke_burncars:StartTamper", function(plyId, netId)
    local vehicle = Z.network.getEntity(netId)
    if (not vehicle or GetEntityType(vehicle) ~= 2) then return "tamperFailed" end

    local reason = validateTamper(plyId, vehicle)
    if (reason) then return reason end

    -- Checked after the validation, which can yield, so two players can not both reserve the vehicle
    local reservedBy = getReservingPlayer(vehicle)
    if (reservedBy and reservedBy ~= plyId) then return "alreadyReserved" end

    cancelPending(plyId)

    local now = GetGameTimer()
    pendingTampers[plyId] = {
        vehicle = vehicle,
        netId = netId,
        finishAt = now + tamperMs - finishTolerance,
        expiresAt = now + tamperMs + reserveMargin,
    }

    TriggerClientEvent("zyke_burncars:SetEngineCoverOpen", getOwner(vehicle, plyId), netId, true)

    return nil
end)

RegisterNetEvent("zyke_burncars:CancelTamper", function()
    cancelPending(source)
end)

---@param plyId PlayerId
---@return string notification @ Locale key for the tampering player
Z.callback.register("zyke_burncars:FinishTamper", function(plyId)
    local pending = pendingTampers[plyId]
    if (not pending) then return "tamperFailed" end

    -- Cleared before the validation yields, so a repeated call can not burn the vehicle twice
    pendingTampers[plyId] = nil

    local reason = validateFinish(plyId, pending)

    if (reason) then
        closeEngineCover(pending, plyId)

        return reason
    end

    local vehicle = pending.vehicle
    local now = os.time()
    local rewardable = (cooldowns[vehicle] or 0) <= now
    if (rewardable) then cooldowns[vehicle] = now + Config.Settings.cooldown end

    removeUsedItems(plyId)
    TriggerClientEvent("zyke_burncars:BurnVehicle", getOwner(vehicle, plyId), pending.netId)

    local coords = GetEntityCoords(vehicle)

    Z.log({
        action = "BurnCar",
        handler = plyId,
        message = "Player burned a car",
        rawData = {
            netId = pending.netId,
            coords = coords,
            rewardable = rewardable,
        },
    })

    OnVehicleBurned({
        source = plyId,
        vehicle = vehicle,
        netId = pending.netId,
        plate = GetVehicleNumberPlateText(vehicle),
        coords = coords,
        rewardable = rewardable,
    })

    return "vehicleTampered"
end)

AddEventHandler("playerDropped", function()
    cancelPending(source)
end)