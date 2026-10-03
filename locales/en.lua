return {
    -- Notifications
    ["vehicleTampered"] = {msg = "You tampered with the engine, keep your distance.", type = "success"},
    ["vehicleProtected"] = {msg = "This vehicle can't be set on fire.", type = "error"},
    ["engineDestroyed"] = {msg = "The engine is already wrecked.", type = "error"},
    ["vehicleMoving"] = {msg = "You can't do this while the vehicle is moving, you need to work undisturbed to avoid accidents.", type = "error"},
    ["vehicleOccupied"] = {msg = "You'll get caught if you do this, make sure to only tamper with unmanned vehicles.", type = "error"},
    ["vehicleRunning"] = {msg = "The vehicle has to be off, otherwise you'll burn yourself.", type = "error"},
    ["alreadyReserved"] = {msg = "Someone is already tampering with this vehicle.", type = "error"},
    ["missingItems"] = {msg = "You're missing items, you need: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Couldn't tamper with the engine.", type = "error"},

    -- Prompts
    ["tamper"] = "Tamper",
    ["tamperingWithCar"] = "Tampering with the engine",
    ["pouringFluid"] = "Pouring lighter fluid",
    ["lightingFluid"] = "Lighting the fluid",
    ["hint:vehicleProtected"] = "Can't be set on fire",
    ["hint:vehicleMoving"] = "Vehicle is moving",
    ["hint:vehicleOccupied"] = "Someone is inside",
    ["hint:vehicleRunning"] = "Engine is running",
    ["tamperCancel"] = "Cancel",

    -- Keybinds
    ["keybind:tamper"] = "Tamper with a vehicle engine",
    ["keybind:cancelTamper"] = "Cancel walking to an engine",
}