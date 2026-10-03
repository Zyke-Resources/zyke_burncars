return {
    -- Notifications
    ["vehicleTampered"] = {msg = "Motorla oynadın, mesafeni koru.", type = "success"},
    ["vehicleProtected"] = {msg = "Bu araç ateşe verilemez.", type = "error"},
    ["engineDestroyed"] = {msg = "Motor zaten hurdaya dönmüş.", type = "error"},
    ["vehicleMoving"] = {msg = "Araç hareket halindeyken bunu yapamazsın, kazaları önlemek için rahatsız edilmeden çalışman gerekiyor.", type = "error"},
    ["vehicleOccupied"] = {msg = "Bunu yaparsan yakalanırsın, sadece boş araçlarla oyna.", type = "error"},
    ["vehicleRunning"] = {msg = "Aracın kapalı olması gerekiyor, yoksa kendini yakarsın.", type = "error"},
    ["alreadyReserved"] = {msg = "Biri zaten bu araçla oynuyor.", type = "error"},
    ["missingItems"] = {msg = "Eksik eşyaların var, ihtiyacın olan: %s.", type = "error"},
    ["tamperFailed"] = {msg = "Motorla oynanamadı.", type = "error"},

    -- Prompts
    ["tamper"] = "Kurcala",
    ["tamperingWithCar"] = "Motor kurcalanıyor",
    ["pouringFluid"] = "Çakmak benzini dökülüyor",
    ["lightingFluid"] = "Benzin tutuşturuluyor",
    ["hint:vehicleProtected"] = "Ateşe verilemez",
    ["hint:vehicleMoving"] = "Araç hareket ediyor",
    ["hint:vehicleOccupied"] = "İçeride biri var",
    ["hint:vehicleRunning"] = "Motor çalışıyor",
    ["tamperCancel"] = "İptal",

    -- Keybinds
    ["keybind:tamper"] = "Bir aracın motorunu kurcala",
    ["keybind:cancelTamper"] = "Motora yürümeyi iptal et",
}