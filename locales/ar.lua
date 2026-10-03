return {
    -- Notifications
    ["vehicleTampered"] = {msg = "لقد عبثت بالمحرك، ابتعد مسافة آمنة.", type = "success"},
    ["vehicleProtected"] = {msg = "لا يمكن إشعال النار في هذه المركبة.", type = "error"},
    ["engineDestroyed"] = {msg = "المحرك محطم بالفعل.", type = "error"},
    ["vehicleMoving"] = {msg = "لا يمكنك فعل ذلك والمركبة تتحرك، عليك العمل دون إزعاج لتجنب الحوادث.", type = "error"},
    ["vehicleOccupied"] = {msg = "سيُقبض عليك إن فعلت هذا، اعبث بالمركبات الفارغة فقط.", type = "error"},
    ["vehicleRunning"] = {msg = "يجب أن تكون المركبة مطفأة، وإلا ستحرق نفسك.", type = "error"},
    ["alreadyReserved"] = {msg = "هناك من يعبث بهذه المركبة بالفعل.", type = "error"},
    ["missingItems"] = {msg = "تنقصك أغراض، تحتاج إلى: %s.", type = "error"},
    ["tamperFailed"] = {msg = "تعذر العبث بالمحرك.", type = "error"},

    -- Prompts
    ["tamper"] = "عبث",
    ["tamperingWithCar"] = "جارٍ العبث بالمحرك",
    ["pouringFluid"] = "جارٍ سكب سائل الولاعة",
    ["lightingFluid"] = "جارٍ إشعال السائل",
    ["hint:vehicleProtected"] = "لا يمكن إشعالها",
    ["hint:vehicleMoving"] = "المركبة تتحرك",
    ["hint:vehicleOccupied"] = "يوجد أحد بالداخل",
    ["hint:vehicleRunning"] = "المحرك يعمل",
    ["tamperCancel"] = "إلغاء",

    -- Keybinds
    ["keybind:tamper"] = "العبث بمحرك مركبة",
    ["keybind:cancelTamper"] = "إلغاء المشي إلى المحرك",
}