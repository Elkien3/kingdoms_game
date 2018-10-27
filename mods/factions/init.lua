factions_version = "0.8.1"

core.log("action", "MOD: factions (by sapier) loading ...")

--!path of mod
factions_modpath = minetest.get_modpath("factions")

dofile (factions_modpath .. "/config.lua")
dofile (factions_modpath .. "/hud.lua")
dofile (factions_modpath .. "/ip.lua")
dofile (factions_modpath .. "/factions.lua")
dofile (factions_modpath .. "/chatcommands.lua")
dofile (factions_modpath .. "/nodes.lua")

factions.load()

core.log("action","MOD: factions (by sapier) " .. factions_version .. " loaded.")