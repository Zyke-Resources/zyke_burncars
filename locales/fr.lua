return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Tu as saboté le moteur, garde tes distances.", type = "success"},
    ["vehicleProtected"] = {msg = "Ce véhicule ne peut pas être incendié.", type = "error"},
    ["engineDestroyed"] = {msg = "Le moteur est déjà détruit.", type = "error"},
    ["vehicleMoving"] = {msg = "Impossible pendant que le véhicule roule, tu dois travailler sans être dérangé pour éviter les accidents.", type = "error"},
    ["vehicleOccupied"] = {msg = "Tu vas te faire prendre, ne sabote que des véhicules inoccupés.", type = "error"},
    ["vehicleRunning"] = {msg = "Le véhicule doit être éteint, sinon tu vas te brûler.", type = "error"},
    ["alreadyReserved"] = {msg = "Quelqu'un sabote déjà ce véhicule.", type = "error"},
    ["missingItems"] = {msg = "Il te manque des objets, il te faut : %s.", type = "error"},
    ["tamperFailed"] = {msg = "Impossible de saboter le moteur.", type = "error"},

    -- Prompts
    ["tamper"] = "Saboter",
    ["tamperingWithCar"] = "Sabotage du moteur",
    ["pouringFluid"] = "Versement de l'essence à briquet",
    ["lightingFluid"] = "Allumage de l'essence",
    ["hint:vehicleProtected"] = "Ne peut pas brûler",
    ["hint:vehicleMoving"] = "Le véhicule bouge",
    ["hint:vehicleOccupied"] = "Quelqu'un est à bord",
    ["hint:vehicleRunning"] = "Le moteur tourne",
    ["tamperCancel"] = "Annuler",

    -- Keybinds
    ["keybind:tamper"] = "Saboter le moteur d'un véhicule",
    ["keybind:cancelTamper"] = "Annuler la marche vers un moteur",
}