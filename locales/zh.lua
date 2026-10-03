return {
    -- Notifications
    ["vehicleTampered"] = {msg = "你动了发动机的手脚，保持距离。", type = "success"},
    ["vehicleProtected"] = {msg = "这辆车无法被点燃。", type = "error"},
    ["engineDestroyed"] = {msg = "发动机已经报废了。", type = "error"},
    ["vehicleMoving"] = {msg = "车辆移动时无法这样做，你需要不受打扰地操作以免发生意外。", type = "error"},
    ["vehicleOccupied"] = {msg = "这样做会被抓住，只对无人的车辆下手。", type = "error"},
    ["vehicleRunning"] = {msg = "车辆必须熄火，否则你会烧伤自己。", type = "error"},
    ["alreadyReserved"] = {msg = "已经有人在对这辆车动手脚了。", type = "error"},
    ["missingItems"] = {msg = "你缺少物品，需要：%s。", type = "error"},
    ["tamperFailed"] = {msg = "无法对发动机动手脚。", type = "error"},

    -- Prompts
    ["tamper"] = "动手脚",
    ["tamperingWithCar"] = "正在对发动机动手脚",
    ["pouringFluid"] = "正在倒入打火机油",
    ["lightingFluid"] = "正在点燃打火机油",
    ["hint:vehicleProtected"] = "无法点燃",
    ["hint:vehicleMoving"] = "车辆在移动",
    ["hint:vehicleOccupied"] = "里面有人",
    ["hint:vehicleRunning"] = "发动机正在运转",
    ["tamperCancel"] = "取消",

    -- Keybinds
    ["keybind:tamper"] = "对车辆发动机动手脚",
    ["keybind:cancelTamper"] = "取消走向发动机",
}