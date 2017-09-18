-- Minetest 0.4 mod: bandages
-- 
-- See README.txt for licensing and other information.

minetest.register_craftitem("bandages:bandage_1", {
        range = 1,
	description = "Simple bandage",
	inventory_image = "bandage_1.png",
	on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type == "object" then
            local object = pointed_thing.ref
            if object:is_player() then
                local hp=object:get_hp()
                if hp > 0 and hp+1 < 20 then
                    object:set_hp(hp+2)
                    itemstack:take_item()
                    return itemstack
                end
            else
                minetest.log("error", "not player!")
            end
        else
            minetest.log("error", "not object!")
        end
    end,
})

minetest.register_craft({
	output = 'bandages:bandage_1',
	recipe = {
        {'', '', ''},
		{'default:paper', 'default:paper', 'default:paper'},
        {'', '', ''},
	}
})

minetest.register_craftitem("bandages:bandage_2", {
        range = 1,
	description = "Bandage",
	inventory_image = "bandage_2.png",
	on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type == "object" then
            local object = pointed_thing.ref
            if object:is_player() then
                local hp=object:get_hp()
                if hp > 0 and hp+3 < 20 then
                    object:set_hp(hp+6)
                    itemstack:take_item()
                    return itemstack
                end
            end
        end
    end,
})

minetest.register_craft({
	output = 'bandages:bandage_2',
	recipe = {
        {'', '', ''},
		{'default:paper', 'default:leaves', 'default:paper'},
        {'', '', ''},
	}
})

minetest.register_craftitem("bandages:bandage_3", {
        range = 1,
	description = "Advanced bandage",
	inventory_image = "bandage_3.png",
	on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type == "object" then
            local object = pointed_thing.ref
            if object:is_player() then
                local hp=object:get_hp()
                if hp > 0 and hp+5 < 20 then
                    object:set_hp(hp+8)
                    itemstack:take_item()
                    return itemstack
                end
            end
        end
    end,
})

minetest.register_craft({
	output = 'bandages:bandage_3',
	recipe = {
        {'', '', ''},
		{'default:paper', 'wool:white', 'default:paper'},
        {'', '', ''},
	}
})