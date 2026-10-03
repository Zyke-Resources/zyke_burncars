return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Hai manomesso il motore, mantieni le distanze.", type = "success"},
    ["vehicleProtected"] = {msg = "Questo veicolo non può essere incendiato.", type = "error"},
    ["engineDestroyed"] = {msg = "Il motore è già distrutto.", type = "error"},
    ["vehicleMoving"] = {msg = "Non puoi farlo mentre il veicolo è in movimento, devi lavorare indisturbato per evitare incidenti.", type = "error"},
    ["vehicleOccupied"] = {msg = "Ti beccheranno se lo fai, manometti solo veicoli vuoti.", type = "error"},
    ["vehicleRunning"] = {msg = "Il veicolo deve essere spento, altrimenti ti bruci.", type = "error"},
    ["alreadyReserved"] = {msg = "Qualcuno sta già manomettendo questo veicolo.", type = "error"},
    ["missingItems"] = {msg = "Ti mancano degli oggetti, ti serve: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Impossibile manomettere il motore.", type = "error"},

    -- Prompts
    ["tamper"] = "Manomettere",
    ["tamperingWithCar"] = "Manomissione del motore",
    ["pouringFluid"] = "Versando la benzina per accendini",
    ["lightingFluid"] = "Accendendo la benzina",
    ["hint:vehicleProtected"] = "Non incendiabile",
    ["hint:vehicleMoving"] = "Il veicolo è in movimento",
    ["hint:vehicleOccupied"] = "C'è qualcuno dentro",
    ["hint:vehicleRunning"] = "Il motore è acceso",
    ["tamperCancel"] = "Annulla",

    -- Keybinds
    ["keybind:tamper"] = "Manomettere il motore di un veicolo",
    ["keybind:cancelTamper"] = "Annulla l'avvicinamento al motore",
}