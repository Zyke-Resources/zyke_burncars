return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Du hast den Motor manipuliert, halte Abstand.", type = "success"},
    ["vehicleProtected"] = {msg = "Dieses Fahrzeug lässt sich nicht in Brand setzen.", type = "error"},
    ["engineDestroyed"] = {msg = "Der Motor ist bereits zerstört.", type = "error"},
    ["vehicleMoving"] = {msg = "Das geht nicht, während sich das Fahrzeug bewegt, du musst ungestört arbeiten, um Unfälle zu vermeiden.", type = "error"},
    ["vehicleOccupied"] = {msg = "Dabei wirst du erwischt, manipuliere nur unbesetzte Fahrzeuge.", type = "error"},
    ["vehicleRunning"] = {msg = "Das Fahrzeug muss ausgeschaltet sein, sonst verbrennst du dich.", type = "error"},
    ["alreadyReserved"] = {msg = "Jemand manipuliert dieses Fahrzeug bereits.", type = "error"},
    ["missingItems"] = {msg = "Dir fehlen Gegenstände, du brauchst: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Der Motor konnte nicht manipuliert werden.", type = "error"},

    -- Prompts
    ["tamper"] = "Manipulieren",
    ["tamperingWithCar"] = "Motor wird manipuliert",
    ["pouringFluid"] = "Feuerzeugbenzin wird eingefüllt",
    ["lightingFluid"] = "Benzin wird angezündet",
    ["hint:vehicleProtected"] = "Nicht entzündbar",
    ["hint:vehicleMoving"] = "Fahrzeug bewegt sich",
    ["hint:vehicleOccupied"] = "Jemand sitzt drin",
    ["hint:vehicleRunning"] = "Motor läuft",
    ["tamperCancel"] = "Abbrechen",

    -- Keybinds
    ["keybind:tamper"] = "Einen Fahrzeugmotor manipulieren",
    ["keybind:cancelTamper"] = "Gang zum Motor abbrechen",
}