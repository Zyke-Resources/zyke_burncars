return {
    -- Notifications
    ["vehicleTampered"] = {msg = "エンジンに細工をした。距離を取れ。", type = "success"},
    ["vehicleProtected"] = {msg = "この車両には火をつけられない。", type = "error"},
    ["engineDestroyed"] = {msg = "エンジンはすでに壊れている。", type = "error"},
    ["vehicleMoving"] = {msg = "車両が動いている間はできない。事故を避けるには邪魔されずに作業する必要がある。", type = "error"},
    ["vehicleOccupied"] = {msg = "これをやれば捕まる。無人の車両だけに細工しよう。", type = "error"},
    ["vehicleRunning"] = {msg = "車両のエンジンを切る必要がある。そうしないと火傷する。", type = "error"},
    ["alreadyReserved"] = {msg = "すでに誰かがこの車両に細工している。", type = "error"},
    ["missingItems"] = {msg = "アイテムが足りない。必要なもの: %s", type = "error"},
    ["tamperFailed"] = {msg = "エンジンに細工できなかった。", type = "error"},

    -- Prompts
    ["tamper"] = "細工する",
    ["tamperingWithCar"] = "エンジンに細工中",
    ["pouringFluid"] = "ライターオイルを注いでいる",
    ["lightingFluid"] = "オイルに火をつけている",
    ["hint:vehicleProtected"] = "火をつけられない",
    ["hint:vehicleMoving"] = "車両が動いている",
    ["hint:vehicleOccupied"] = "誰かが乗っている",
    ["hint:vehicleRunning"] = "エンジンがかかっている",
    ["tamperCancel"] = "キャンセル",

    -- Keybinds
    ["keybind:tamper"] = "車両のエンジンに細工する",
    ["keybind:cancelTamper"] = "エンジンへの移動をキャンセル",
}