return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Du har mixtrat med motorn, håll avståndet.", type = "success"},
    ["vehicleProtected"] = {msg = "Det här fordonet går inte att sätta eld på.", type = "error"},
    ["engineDestroyed"] = {msg = "Motorn är redan förstörd.", type = "error"},
    ["vehicleMoving"] = {msg = "Du kan inte göra det här medan fordonet rör sig, du måste få jobba ostört för att undvika olyckor.", type = "error"},
    ["vehicleOccupied"] = {msg = "Du kommer att åka fast om du gör det här, mixtra bara med obemannade fordon.", type = "error"},
    ["vehicleRunning"] = {msg = "Fordonet måste vara avstängt, annars bränner du dig.", type = "error"},
    ["alreadyReserved"] = {msg = "Någon mixtrar redan med det här fordonet.", type = "error"},
    ["missingItems"] = {msg = "Du saknar föremål, du behöver: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Det gick inte att mixtra med motorn.", type = "error"},

    -- Prompts
    ["tamper"] = "Mixtra",
    ["tamperingWithCar"] = "Mixtrar med motorn",
    ["pouringFluid"] = "Häller i tändvätska",
    ["lightingFluid"] = "Tänder vätskan",
    ["hint:vehicleProtected"] = "Går inte att sätta eld på",
    ["hint:vehicleMoving"] = "Fordonet rör sig",
    ["hint:vehicleOccupied"] = "Någon sitter i",
    ["hint:vehicleRunning"] = "Motorn är igång",
    ["tamperCancel"] = "Avbryt",

    -- Keybinds
    ["keybind:tamper"] = "Mixtra med en fordonsmotor",
    ["keybind:cancelTamper"] = "Avbryt gången fram till en motor",
}