return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Mexeste no motor, mantém a distância.", type = "success"},
    ["vehicleProtected"] = {msg = "Não é possível incendiar este veículo.", type = "error"},
    ["engineDestroyed"] = {msg = "O motor já está destruído.", type = "error"},
    ["vehicleMoving"] = {msg = "Não podes fazer isto com o veículo em movimento, precisas de trabalhar sem interrupções para evitar acidentes.", type = "error"},
    ["vehicleOccupied"] = {msg = "Vais ser apanhado se fizeres isto, mexe apenas em veículos vazios.", type = "error"},
    ["vehicleRunning"] = {msg = "O veículo tem de estar desligado, senão vais queimar-te.", type = "error"},
    ["alreadyReserved"] = {msg = "Alguém já está a mexer neste veículo.", type = "error"},
    ["missingItems"] = {msg = "Faltam-te itens, precisas de: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Não foi possível mexer no motor.", type = "error"},

    -- Prompts
    ["tamper"] = "Sabotar",
    ["tamperingWithCar"] = "A sabotar o motor",
    ["pouringFluid"] = "A despejar fluido de isqueiro",
    ["lightingFluid"] = "A acender o fluido",
    ["hint:vehicleProtected"] = "Não pode ser incendiado",
    ["hint:vehicleMoving"] = "O veículo está em movimento",
    ["hint:vehicleOccupied"] = "Está alguém lá dentro",
    ["hint:vehicleRunning"] = "O motor está ligado",
    ["tamperCancel"] = "Cancelar",

    -- Keybinds
    ["keybind:tamper"] = "Sabotar o motor de um veículo",
    ["keybind:cancelTamper"] = "Cancelar a ida até um motor",
}