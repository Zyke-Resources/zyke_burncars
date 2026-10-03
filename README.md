## Dependencies
- https://github.com/ZykeWasTaken/zyke_lib (2.11.3 or newer, for interest point markers)

## Items
Copy the item definitions from `extras/` into your inventory resource (`ox_inventory.lua` or `qb_items.lua`), and the icons from `extras/images/256/` into your inventory's image folder.

## Usage
Carry the items from `Config.Settings.itemsNeeded` and aim at the marker on a vehicle's engine cover, then press the tamper keybind (E by default). The player walks up to the engine, opens the cover and works on it. Cancel the walk with X, right mouse or the movement keys, and the tamper itself with X. With `alwaysShowMarkers` on, engines that can't be tampered with still get a marker that says why.

The tamper runs in three steps under one progress bar: working the engine cover open, pouring in the lighter fluid from a tin, then rolling the lighter and touching its flame to the fluid, which catches in the engine bay and burns until the engine fire takes over. Both props are streamed by the resource (`zyke_lighter_fluid` and `zyke_lighter`) and every nearby player sees them in the hand.

Every tamper is validated on the server, which uses up the items and burns the vehicle on the client that owns it, so everyone sees the fire. Rear engined vehicles are listed under `Config.Settings.rearEngineVehicles`.

### Server hooks
- `server/can_checks.lua`: `CanBurnVehicle` allows or denies a tamper, for jobs, gangs or cooldowns.
- `server/hooks.lua`: `OnVehicleBurned` runs for every burned vehicle, for rewards, dispatch alerts or logs.

## Source Media

- [4096×4096 item renders](https://media.zykeresources.com/library?groupBy=folders&path=burn-cars%2F4096)
