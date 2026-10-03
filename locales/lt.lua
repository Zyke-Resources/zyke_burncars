return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Sugadinai variklį, laikykis atstumo.", type = "success"},
    ["vehicleProtected"] = {msg = "Šios transporto priemonės padegti negalima.", type = "error"},
    ["engineDestroyed"] = {msg = "Variklis jau sugadintas.", type = "error"},
    ["vehicleMoving"] = {msg = "Negali to daryti, kol transporto priemonė juda, turi dirbti netrukdomas, kad išvengtum nelaimių.", type = "error"},
    ["vehicleOccupied"] = {msg = "Tave pagaus, jei tai darysi, gadink tik tuščias transporto priemones.", type = "error"},
    ["vehicleRunning"] = {msg = "Transporto priemonė turi būti išjungta, kitaip nusidegsi.", type = "error"},
    ["alreadyReserved"] = {msg = "Kažkas jau gadina šią transporto priemonę.", type = "error"},
    ["missingItems"] = {msg = "Tau trūksta daiktų, reikia: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Nepavyko sugadinti variklio.", type = "error"},

    -- Prompts
    ["tamper"] = "Gadinti",
    ["tamperingWithCar"] = "Gadinamas variklis",
    ["pouringFluid"] = "Pilamas žiebtuvėlių skystis",
    ["lightingFluid"] = "Uždegamas skystis",
    ["hint:vehicleProtected"] = "Negalima padegti",
    ["hint:vehicleMoving"] = "Transporto priemonė juda",
    ["hint:vehicleOccupied"] = "Kažkas viduje",
    ["hint:vehicleRunning"] = "Variklis veikia",
    ["tamperCancel"] = "Atšaukti",

    -- Keybinds
    ["keybind:tamper"] = "Sugadinti transporto priemonės variklį",
    ["keybind:cancelTamper"] = "Atšaukti ėjimą prie variklio",
}