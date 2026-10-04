# [> Download](https://github.com/ZykeWasTaken/zyke_burncars/releases/latest)

## Dependencies
- https://github.com/ZykeWasTaken/zyke_lib (2.11.3 or newer, for interest point markers)

## Items
Copy the item definitions from `extras/` into your inventory resource (`ox_inventory.lua` or `qb_items.lua`), and the icons from `extras/images/256/` into your inventory's image folder.

## Usage
Carry the items from `Config.Settings.itemsNeeded` and aim at the marker on a vehicle's engine cover, then press the tamper keybind (E by default). The player walks up to the engine, opens the cover and works on it. Cancel the walk with X, right mouse or the movement keys, and the tamper itself with X. With `alwaysShowMarkers` on, engines that can't be tampered with still get a marker that says why.

Set `Config.Settings.interaction` to `"target"` to use a "Tamper" option in ox_target or qb-target instead of the engine markers. Selecting it walks the player to the engine the same way. Without a target resource started it falls back to the markers.

The tamper runs in three steps under one progress bar: working the engine cover open, pouring in the lighter fluid from a tin, then rolling the lighter and touching its flame to the fluid, which catches in the engine bay and burns until the engine fire takes over. Both props are streamed by the resource (`zyke_lighter_fluid` and `zyke_lighter`) and every nearby player sees them in the hand.

Every tamper is validated on the server, which uses up the items and burns the vehicle on the client that owns it, so everyone sees the fire. Whether the engine sits in the front or the rear is read from the vehicle model itself, so add-on vehicles need no setup.

### Ignored vehicles
Some vehicles should never be touched, such as showroom and garage display cars. They get no marker at all and the server refuses them.

- Vehicles that only exist on one client (not networked) are always skipped.
- `Config.Settings.ignoreStates` lists state bags that mark a vehicle as ignored. `zyke_garages:ignore` and `interiorDisplay` from zyke_garages are in there by default, which covers zyke_dealerships showrooms.
- Other resources can mark their own vehicles: `exports["zyke_burncars"]:SetVehicleIgnored(vehicle, true)`, from the server or from the client that owns the vehicle. `exports["zyke_burncars"]:IsVehicleIgnored(vehicle)` reads it.

### Server hooks
- `server/can_checks.lua`: `CanBurnVehicle` allows or denies a tamper, for jobs, gangs or cooldowns.
- `server/hooks.lua`: `OnVehicleBurned` runs for every burned vehicle, for rewards, dispatch alerts or logs.

## Source Media

- [4096×4096 item renders](https://media.zykeresources.com/library?groupBy=folders&path=burn-cars%2F4096)
