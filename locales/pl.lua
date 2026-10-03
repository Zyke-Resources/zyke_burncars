return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Majstrowałeś przy silniku, trzymaj się z daleka.", type = "success"},
    ["vehicleProtected"] = {msg = "Tego pojazdu nie da się podpalić.", type = "error"},
    ["engineDestroyed"] = {msg = "Silnik jest już zniszczony.", type = "error"},
    ["vehicleMoving"] = {msg = "Nie możesz tego zrobić, gdy pojazd jest w ruchu, musisz pracować w spokoju, aby uniknąć wypadków.", type = "error"},
    ["vehicleOccupied"] = {msg = "Zostaniesz złapany, majstruj tylko przy pustych pojazdach.", type = "error"},
    ["vehicleRunning"] = {msg = "Pojazd musi być wyłączony, inaczej się poparzysz.", type = "error"},
    ["alreadyReserved"] = {msg = "Ktoś już majstruje przy tym pojeździe.", type = "error"},
    ["missingItems"] = {msg = "Brakuje ci przedmiotów, potrzebujesz: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Nie udało się majstrować przy silniku.", type = "error"},

    -- Prompts
    ["tamper"] = "Majstruj",
    ["tamperingWithCar"] = "Majstrowanie przy silniku",
    ["pouringFluid"] = "Wlewanie benzyny do zapalniczek",
    ["lightingFluid"] = "Podpalanie benzyny",
    ["hint:vehicleProtected"] = "Nie da się podpalić",
    ["hint:vehicleMoving"] = "Pojazd jest w ruchu",
    ["hint:vehicleOccupied"] = "Ktoś jest w środku",
    ["hint:vehicleRunning"] = "Silnik pracuje",
    ["tamperCancel"] = "Anuluj",

    -- Keybinds
    ["keybind:tamper"] = "Majstruj przy silniku pojazdu",
    ["keybind:cancelTamper"] = "Anuluj podchodzenie do silnika",
}