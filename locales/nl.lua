return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Je hebt met de motor geknoeid, houd afstand.", type = "success"},
    ["vehicleProtected"] = {msg = "Dit voertuig kan niet in brand worden gestoken.", type = "error"},
    ["engineDestroyed"] = {msg = "De motor is al kapot.", type = "error"},
    ["vehicleMoving"] = {msg = "Dit kan niet terwijl het voertuig rijdt, je moet ongestoord werken om ongelukken te voorkomen.", type = "error"},
    ["vehicleOccupied"] = {msg = "Je wordt betrapt als je dit doet, knoei alleen met onbemande voertuigen.", type = "error"},
    ["vehicleRunning"] = {msg = "Het voertuig moet uit staan, anders verbrand je jezelf.", type = "error"},
    ["alreadyReserved"] = {msg = "Iemand knoeit al met dit voertuig.", type = "error"},
    ["missingItems"] = {msg = "Je mist spullen, je hebt nodig: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Kon niet met de motor knoeien.", type = "error"},

    -- Prompts
    ["tamper"] = "Knoeien",
    ["tamperingWithCar"] = "Knoeien met de motor",
    ["pouringFluid"] = "Aanstekervloeistof gieten",
    ["lightingFluid"] = "Vloeistof aansteken",
    ["hint:vehicleProtected"] = "Kan niet branden",
    ["hint:vehicleMoving"] = "Voertuig rijdt",
    ["hint:vehicleOccupied"] = "Er zit iemand in",
    ["hint:vehicleRunning"] = "Motor draait",
    ["tamperCancel"] = "Annuleren",

    -- Keybinds
    ["keybind:tamper"] = "Met een voertuigmotor knoeien",
    ["keybind:cancelTamper"] = "Lopen naar een motor annuleren",
}