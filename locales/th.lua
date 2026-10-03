return {
    -- Notifications
    ["vehicleTampered"] = {msg = "คุณแอบดัดแปลงเครื่องยนต์แล้ว ถอยออกไปให้ห่าง", type = "success"},
    ["vehicleProtected"] = {msg = "ไม่สามารถจุดไฟเผารถคันนี้ได้", type = "error"},
    ["engineDestroyed"] = {msg = "เครื่องยนต์พังไปแล้ว", type = "error"},
    ["vehicleMoving"] = {msg = "ทำไม่ได้ขณะที่รถกำลังเคลื่อนที่ ต้องทำงานโดยไม่ถูกรบกวนเพื่อหลีกเลี่ยงอุบัติเหตุ", type = "error"},
    ["vehicleOccupied"] = {msg = "ถ้าทำแบบนี้คุณจะโดนจับได้ ให้ดัดแปลงเฉพาะรถที่ไม่มีคนอยู่", type = "error"},
    ["vehicleRunning"] = {msg = "ต้องดับเครื่องยนต์ก่อน ไม่อย่างนั้นคุณจะโดนไฟลวก", type = "error"},
    ["alreadyReserved"] = {msg = "มีคนกำลังดัดแปลงรถคันนี้อยู่แล้ว", type = "error"},
    ["missingItems"] = {msg = "คุณมีไอเทมไม่ครบ ต้องใช้: %s", type = "error"},
    ["tamperFailed"] = {msg = "ไม่สามารถดัดแปลงเครื่องยนต์ได้", type = "error"},

    -- Prompts
    ["tamper"] = "ดัดแปลง",
    ["tamperingWithCar"] = "กำลังดัดแปลงเครื่องยนต์",
    ["pouringFluid"] = "กำลังเทน้ำมันไฟแช็ก",
    ["lightingFluid"] = "กำลังจุดไฟน้ำมัน",
    ["hint:vehicleProtected"] = "จุดไฟไม่ได้",
    ["hint:vehicleMoving"] = "รถกำลังเคลื่อนที่",
    ["hint:vehicleOccupied"] = "มีคนอยู่ข้างใน",
    ["hint:vehicleRunning"] = "เครื่องยนต์ติดอยู่",
    ["tamperCancel"] = "ยกเลิก",

    -- Keybinds
    ["keybind:tamper"] = "ดัดแปลงเครื่องยนต์รถ",
    ["keybind:cancelTamper"] = "ยกเลิกการเดินไปที่เครื่องยนต์",
}