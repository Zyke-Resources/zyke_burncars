-- Editable reactions to burned vehicles

-- Runs once for every vehicle that is set on fire, where rewards, dispatch alerts or logs go
-- Skip rewards while data.rewardable is false, which means the vehicle was burned within Config.Settings.cooldown
---@param data VehicleBurnedData
function OnVehicleBurned(data)
    -- Add rewards, dispatch exports or custom logic here
end