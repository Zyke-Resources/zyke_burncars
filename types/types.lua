---@class TamperTarget
---@field vehicle integer
---@field offset vector3 @ Engine cover marker local to the vehicle
---@field rear boolean @ The engine sits in the rear
---@field bike boolean

---@class EngineLayout
---@field rear boolean @ The engine sits in the rear half of the vehicle
---@field door? integer @ Door index of the engine cover, nil when the model has none that opens
---@field coverZ? number @ Height of the engine cover's hinge, local to the vehicle

---@class PendingTamper
---@field vehicle integer
---@field netId NetId
---@field finishAt integer @ Game timer the tamper can finish from
---@field expiresAt integer @ Game timer the reservation lapses at

---@class VehicleBurnedData
---@field source PlayerId @ Player who tampered with the vehicle
---@field vehicle integer
---@field netId NetId
---@field plate string
---@field coords vector3
---@field rewardable boolean @ False when the vehicle was burned within the cooldown

---@class HeldPropSettings
---@field model integer
---@field bone integer @ Ped bone id the prop attaches to
---@field pos vector3
---@field rot vector3

---@class HeldProp
---@field kind "fluid" | "lighter"
---@field object integer @ Local object on the holding player's hand
---@field flame? integer @ Looped flame particle while the lighter is lit
---@field stream? integer @ Looped fluid stream particle while the tin is tipped over