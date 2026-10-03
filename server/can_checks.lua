-- Editable gate for tampering with vehicles; return true to allow, or false and a locale key to deny
-- Jobs, gangs or cooldowns fit here. Distance, the needed items, protected vehicles and the
-- configured requirements are already checked in server/main.lua before this runs

---@param plyId PlayerId
---@param vehicle integer @ Vehicle being tampered with
---@return boolean allowed
---@return string? reason
function CanBurnVehicle(plyId, vehicle)
    return true
end