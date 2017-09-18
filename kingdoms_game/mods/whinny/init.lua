dofile(minetest.get_modpath("whinny").."/api.lua")
dofile(minetest.get_modpath("whinny").."/horse.lua")
--[[
minetest.register_craftitem("whinny:meat", {
    description = "Cooked Meat",
    inventory_image = "whinny_meat.png",
    on_use = minetest.item_eat(4),
})

minetest.register_craftitem("whinny:meat_raw", {
    description = "Raw Meat",
    inventory_image = "whinny_meat_raw.png",
})

minetest.register_craft({
    type = "cooking",
    output = "whinny:meat",
    recipe = "whinny:meat_raw",
})
--]]