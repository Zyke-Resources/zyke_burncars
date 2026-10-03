return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Poškodil jsi motor, drž si odstup.", type = "success"},
    ["vehicleProtected"] = {msg = "Toto vozidlo nelze zapálit.", type = "error"},
    ["engineDestroyed"] = {msg = "Motor je už zničený.", type = "error"},
    ["vehicleMoving"] = {msg = "Tohle nejde, dokud se vozidlo pohybuje, musíš pracovat v klidu, abys předešel nehodám.", type = "error"},
    ["vehicleOccupied"] = {msg = "Tímhle se nachytáš, manipuluj jen s prázdnými vozidly.", type = "error"},
    ["vehicleRunning"] = {msg = "Vozidlo musí být vypnuté, jinak se popálíš.", type = "error"},
    ["alreadyReserved"] = {msg = "Někdo už s tímto vozidlem manipuluje.", type = "error"},
    ["missingItems"] = {msg = "Chybí ti předměty, potřebuješ: %s.", type = "error"},
    ["tamperFailed"] = {msg = "S motorem se nepodařilo manipulovat.", type = "error"},

    -- Prompts
    ["tamper"] = "Manipulovat",
    ["tamperingWithCar"] = "Manipulace s motorem",
    ["pouringFluid"] = "Nalévání benzínu do zapalovačů",
    ["lightingFluid"] = "Zapalování benzínu",
    ["hint:vehicleProtected"] = "Nelze zapálit",
    ["hint:vehicleMoving"] = "Vozidlo se pohybuje",
    ["hint:vehicleOccupied"] = "Někdo je uvnitř",
    ["hint:vehicleRunning"] = "Motor běží",
    ["tamperCancel"] = "Zrušit",

    -- Keybinds
    ["keybind:tamper"] = "Manipulovat s motorem vozidla",
    ["keybind:cancelTamper"] = "Zrušit chůzi k motoru",
}