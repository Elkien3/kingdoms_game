minetest.register_craft({
output = "default:coal_lump",
type = "cooking",
cooktime = 15,
recipe = "group:tree"
})

local modpath = minetest.get_modpath(minetest.get_current_modname() )
dofile(modpath.."/graveldirt.lua")