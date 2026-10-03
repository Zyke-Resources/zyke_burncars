return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Has manipulado el motor, mantén la distancia.", type = "success"},
    ["vehicleProtected"] = {msg = "A este vehículo no se le puede prender fuego.", type = "error"},
    ["engineDestroyed"] = {msg = "El motor ya está destrozado.", type = "error"},
    ["vehicleMoving"] = {msg = "No puedes hacer esto mientras el vehículo se mueve, necesitas trabajar sin interrupciones para evitar accidentes.", type = "error"},
    ["vehicleOccupied"] = {msg = "Te pillarán si haces esto, manipula solo vehículos vacíos.", type = "error"},
    ["vehicleRunning"] = {msg = "El vehículo tiene que estar apagado, si no te quemarás.", type = "error"},
    ["alreadyReserved"] = {msg = "Alguien ya está manipulando este vehículo.", type = "error"},
    ["missingItems"] = {msg = "Te faltan objetos, necesitas: %s.", type = "error"},
    ["tamperFailed"] = {msg = "No se pudo manipular el motor.", type = "error"},

    -- Prompts
    ["tamper"] = "Manipular",
    ["tamperingWithCar"] = "Manipulando el motor",
    ["pouringFluid"] = "Vertiendo líquido de mechero",
    ["lightingFluid"] = "Prendiendo el líquido",
    ["hint:vehicleProtected"] = "No se puede quemar",
    ["hint:vehicleMoving"] = "El vehículo se mueve",
    ["hint:vehicleOccupied"] = "Hay alguien dentro",
    ["hint:vehicleRunning"] = "El motor está encendido",
    ["tamperCancel"] = "Cancelar",

    -- Keybinds
    ["keybind:tamper"] = "Manipular el motor de un vehículo",
    ["keybind:cancelTamper"] = "Cancelar el camino hacia un motor",
}