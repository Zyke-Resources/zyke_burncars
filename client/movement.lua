-- Walks and turns the player into place before tampering, adapted from 2f_blacksmith's anvil positioning

-- Horizontal metres from the target that count as arrived once the walk has finished
local arriveTolerance = 0.3
local goStraightTask = joaat("SCRIPT_TASK_GO_STRAIGHT_TO_COORD")
-- Ped speed under which the player counts as stood still before turning
local stillSpeed = 0.1
local settleTimeout = 500
-- The walk over gives up after this long plus a second per metre
local walkBaseMs = 2000
-- Degrees off the target the player may face before the turn snaps the rest
local headingTolerance = 10.0
local turnTimeout = 1000

---@param from vector3
---@param to vector3
---@return number distance
function GetHorizontalDistance(from, to)
    return #(from.xy - to.xy)
end

-- The walk task is left to finish on its own, so the ped brakes on the spot and turns to the given
-- heading; cutting it short at a distance keeps the walking momentum and overshoots the spot
---@param ped integer
---@param coords vector3
---@param heading number
---@param vehicle integer @ Entity the walk is aborted for once it no longer exists
---@param isCancelled? fun(): boolean @ Polled during the walk, stops it once it returns true
---@return boolean arrived
function WalkPedToCoords(ped, coords, heading, vehicle, isCancelled)
    local distance = GetHorizontalDistance(GetEntityCoords(ped), coords)
    if (distance <= arriveTolerance) then return true end

    local deadline = GetGameTimer() + walkBaseMs + math.floor(distance * 1000)
    TaskGoStraightToCoord(ped, coords.x, coords.y, coords.z, 1.0, -1, heading, 0.1)
    Wait(0)

    while (GetScriptTaskStatus(ped, goStraightTask) ~= 7 and GetGameTimer() < deadline) do
        if (not DoesEntityExist(vehicle) or IsEntityDead(ped) or IsPedRagdoll(ped) or IsPedInAnyVehicle(ped, false)) then break end
        if (isCancelled and isCancelled()) then break end

        Wait(50)
    end

    -- Timed out, cancelled or interrupted, such as by a wall beside the vehicle
    if (GetScriptTaskStatus(ped, goStraightTask) ~= 7) then ClearPedTasks(ped) end
    if (isCancelled and isCancelled()) then return false end

    local settleDeadline = GetGameTimer() + settleTimeout

    while (GetEntitySpeed(ped) > stillSpeed and GetGameTimer() < settleDeadline) do
        Wait(0)
    end

    return GetHorizontalDistance(GetEntityCoords(ped), coords) <= arriveTolerance
end

---@param ped integer
---@param heading number
---@return number difference @ Degrees either way
local function getHeadingDifference(ped, heading)
    return math.abs((GetEntityHeading(ped) - heading + 540.0) % 360.0 - 180.0)
end

-- The turn task alone can stop a few degrees short or get interrupted, so the rest is snapped
---@param ped integer
---@param coords vector3
function TurnPedToFace(ped, coords)
    local pedCoords = GetEntityCoords(ped)
    local heading = GetHeadingFromVector_2d(coords.x - pedCoords.x, coords.y - pedCoords.y)
    if (getHeadingDifference(ped, heading) <= headingTolerance) then return end

    local deadline = GetGameTimer() + turnTimeout
    TaskTurnPedToFaceCoord(ped, coords.x, coords.y, coords.z, turnTimeout)

    while (getHeadingDifference(ped, heading) > headingTolerance and GetGameTimer() < deadline) do
        Wait(50)
    end

    SetEntityHeading(ped, heading)
end