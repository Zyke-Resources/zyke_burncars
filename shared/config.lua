Config = Config or {}

Config.Settings = {
    -- A vehicle that fails these still gets a marker that says why, and refuses the tamper when used
    requirements = {
        emptyVehicle = true, -- Nobody may sit in the vehicle
        vehicleOff = true, -- The engine has to be off
    },

    -- Markers only show while carrying every item; items with remove = true are used up by each tamper
    itemsNeeded = {
        {name = "lighter", amount = 1, remove = false},
        {name = "lighter_fluid", amount = 1, remove = true},
    },

    -- true marks every engine nearby; one that can't be tampered with says why on its marker, and
    -- shakes with a notification when used. false only marks engines that can be tampered with right now
    alwaysShowMarkers = true,

    -- Seconds the whole tamper takes: working the engine open, pouring the lighter fluid in and lighting it
    tamperDuration = 15,

    fire = {
        delay = 2, -- Seconds from lighting the fluid until the engine catches fire
        duration = 20, -- Seconds the fire burns before it is put out
    },

    -- Seconds before a burned vehicle counts as rewardable again, should it be repaired and burned once more
    -- Storing and taking a vehicle out of a garage spawns a new entity, which starts without a cooldown
    cooldown = 900,

    -- Vehicles carrying any of these state bags as true are left alone completely: no marker, and the
    -- server refuses them. Other resources can mark their vehicles through the SetVehicleIgnored
    -- export instead, see the README
    ignoreStates = {
        "zyke_garages:ignore", -- Showroom, preview and other vehicles zyke_garages is told to skip
        "interiorDisplay", -- Vehicles on display inside zyke_garages interiors
    },

    -- Vehicle classes that can't be set on fire, which also covers add-on vehicles in them
    -- Class ids: https://docs.fivem.net/natives/?_0x29439776AAA00A62
    disabledClasses = {
        [13] = true, -- Cycles
        [14] = true, -- Boats
        [15] = true, -- Helicopters
        [16] = true, -- Planes
        [21] = true, -- Trains
    },

    -- Models protected on top of the classes above, by spawn name
    disabledVehicles = {
        "police",
        "police2",
        "police3",
        "police4",
        "policeb",
        "policet",
        "sheriff",
        "sheriff2",
        "fbi",
        "fbi2",
        "pranger",
        "ambulance",
        "firetruk",
        "riot",
        "riot2",
        "barracks",
        "barracks2",
        "barracks3",
        "crusader",
        "rhino",
    },

    -- Vehicles tampered with from the rear, by spawn name; there is no native for the engine placement
    -- Credit to https://github.com/qbcore-framework/qb-vehiclefailure for the list
    rearEngineVehicles = {
        "ninef",
        "adder",
        "vagner",
        "t20",
        "infernus",
        "zentorno",
        "reaper",
        "comet2",
        "jester",
        "jester2",
        "cheetah",
        "cheetah2",
        "prototipo",
        "turismor",
        "pfister811",
        "ardent",
        "nero",
        "nero2",
        "tempesta",
        "vacca",
        "bullet",
        "osiris",
        "entityxf",
        "turismo2",
        "fmj",
        "re7b",
        "tyrus",
        "italigtb",
        "penetrator",
        "monroe",
        "ninef2",
        "stingergt",
        "surfer",
        "surfer2",
        "comet3",
        "xa21",
    },
}