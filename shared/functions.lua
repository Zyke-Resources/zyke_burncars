-- Rules shared by the client markers and the server's validation, so both always agree on what can
-- be set on fire

-- Metres per second a vehicle may still be rolling at and be tampered with
local maxSpeed = 0.5
-- Highest seat index the server checks, since it has no native for a vehicle's seat count
local maxSeatIndex = 14
local requirements = Config.Settings.requirements

---@type table<integer, true> @ Model hash -> protected from burning
local disabledModels = {}
---@type table<integer, true> @ Model hash -> engine in the rear
local rearEngineModels = {}

for i = 1, #Config.Settings.disabledVehicles do
    disabledModels[joaat(Config.Settings.disabledVehicles[i])] = true
end

for i = 1, #Config.Settings.rearEngineVehicles do
    rearEngineModels[joaat(Config.Settings.rearEngineVehicles[i])] = true
end

-- Set through the SetVehicleIgnored export by resources that spawn vehicles nobody should burn
local ignoreState = "zyke_burncars:ignore"
local ignoreStates = Config.Settings.ignoreStates

-- Ignored vehicles are left alone completely, unlike protected ones, which still explain themselves
---@param vehicle integer
---@return boolean ignored
function IsVehicleIgnored(vehicle)
    if (not DoesEntityExist(vehicle)) then return false end

    local state = Entity(vehicle).state
    if (state[ignoreState] == true) then return true end

    for i = 1, #ignoreStates do
        if (state[ignoreStates[i]] == true) then return true end
    end

    return false
end

exports("IsVehicleIgnored", IsVehicleIgnored)

-- Set on the server, or on the client that owns the vehicle, for the state to reach everyone
---@param vehicle integer
---@param ignored boolean
---@return boolean applied
function SetVehicleIgnored(vehicle, ignored)
    if (not DoesEntityExist(vehicle)) then return false end

    Entity(vehicle).state:set(ignoreState, ignored == true or nil, true)

    return true
end

exports("SetVehicleIgnored", SetVehicleIgnored)

---@param model integer
---@return boolean rear
function IsRearEngineModel(model)
    return rearEngineModels[model] == true
end

-- Clients read the class directly; the server has no class native, so zyke_lib looks it up from a client
---@param vehicle integer
---@return boolean protected
local function isVehicleProtected(vehicle)
    local model = GetEntityModel(vehicle)
    if (disabledModels[model]) then return true end

    local class = Context == "client" and GetVehicleClass(vehicle) or Z.getVehicleClass(model)

    return Config.Settings.disabledClasses[class] == true
end

---@param vehicle integer
---@return boolean occupied
local function isVehicleOccupied(vehicle)
    if (Context == "client") then return GetVehicleNumberOfPassengers(vehicle) > 0 or not IsVehicleSeatFree(vehicle, -1) end

    for seat = -1, maxSeatIndex do
        if (GetPedInVehicleSeat(vehicle, seat) ~= 0) then return true end
    end

    return false
end

-- Why the vehicle can't be tampered with right now, as a locale key, or nil when it can
---@param vehicle integer
---@return "vehicleProtected" | "engineDestroyed" | "vehicleMoving" | "vehicleOccupied" | "vehicleRunning" | nil reason
function GetBurnBlockReason(vehicle)
    if (IsVehicleIgnored(vehicle) or isVehicleProtected(vehicle)) then return "vehicleProtected" end
    if (GetVehicleEngineHealth(vehicle) <= 0.0) then return "engineDestroyed" end
    if (#GetEntityVelocity(vehicle) > maxSpeed) then return "vehicleMoving" end
    if (requirements.emptyVehicle and isVehicleOccupied(vehicle)) then return "vehicleOccupied" end
    if (requirements.vehicleOff and GetIsVehicleEngineRunning(vehicle)) then return "vehicleRunning" end

    return nil
end