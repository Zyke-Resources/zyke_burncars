fx_version "cerulean"
game "gta5"
author "https://discord.zykeresources.com"
description "Tamper with vehicle engines and set them on fire"
lua54 "yes"
version "2.0.0"

shared_scripts {
    "@zyke_lib/imports.lua",
    "shared/config.lua",
    "shared/functions.lua",
}

client_scripts {
    "client/movement.lua",
    "client/props.lua",
    "client/main.lua",
}

server_scripts {
    "server/can_checks.lua",
    "server/hooks.lua",
    "server/main.lua",
}

files {
    "locales/*.lua",
    "stream/zyke_burncars.ytyp",
}

data_file "DLC_ITYP_REQUEST" "stream/zyke_burncars.ytyp"

dependency "zyke_lib"