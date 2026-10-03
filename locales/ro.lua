return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Ai umblat la motor, păstrează distanța.", type = "success"},
    ["vehicleProtected"] = {msg = "Acestui vehicul nu i se poate da foc.", type = "error"},
    ["engineDestroyed"] = {msg = "Motorul este deja distrus.", type = "error"},
    ["vehicleMoving"] = {msg = "Nu poți face asta cât timp vehiculul se mișcă, trebuie să lucrezi netulburat ca să eviți accidentele.", type = "error"},
    ["vehicleOccupied"] = {msg = "Vei fi prins dacă faci asta, umblă doar la vehicule goale.", type = "error"},
    ["vehicleRunning"] = {msg = "Vehiculul trebuie să fie oprit, altfel te arzi.", type = "error"},
    ["alreadyReserved"] = {msg = "Cineva umblă deja la acest vehicul.", type = "error"},
    ["missingItems"] = {msg = "Îți lipsesc obiecte, ai nevoie de: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Nu ai putut umbla la motor.", type = "error"},

    -- Prompts
    ["tamper"] = "Sabotează",
    ["tamperingWithCar"] = "Sabotezi motorul",
    ["pouringFluid"] = "Torni benzină de brichetă",
    ["lightingFluid"] = "Aprinzi benzina",
    ["hint:vehicleProtected"] = "Nu poate fi incendiat",
    ["hint:vehicleMoving"] = "Vehiculul se mișcă",
    ["hint:vehicleOccupied"] = "Cineva e înăuntru",
    ["hint:vehicleRunning"] = "Motorul merge",
    ["tamperCancel"] = "Anulează",

    -- Keybinds
    ["keybind:tamper"] = "Sabotează motorul unui vehicul",
    ["keybind:cancelTamper"] = "Anulează mersul spre un motor",
}