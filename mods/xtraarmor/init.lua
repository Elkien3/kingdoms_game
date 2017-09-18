minetest.register_craftitem("xtraarmor:soap", {
	description = "soap (for washing a dye out of a piece of dyed armor)",
	inventory_image = "xtraarmor_soap.png",
	groups = {flammable = 2},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:soap 5",
	recipe = {"default:leaves", "dye:white"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather",
	recipe = {"group:leather_helmet", "xtraarmor:soap"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather",
	recipe = {"group:leather_leggings", "xtraarmor:soap"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather",
	recipe = {"group:leather_chestplate", "xtraarmor:soap"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather",
	recipe = {"group:leather_boots", "xtraarmor:soap"},
})

-------------------------------------------------------

	minetest.register_tool("xtraarmor:helmet_leather", {
		description = "Wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather.png",
		groups = {armor_head=5, armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather", {
		description = "Wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather.png",
		groups = {armor_torso=10, armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather", {
		description = "Wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather.png",
		groups = {armor_legs=5, armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather", {
		description = "Wool boots",
		inventory_image = "xtraarmor_inv_boots_leather.png",
		groups = {armor_feet=5, physics_speed=0.05, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	output = 'xtraarmor:helmet_leather',
	recipe = {
		{'group:wool', 'group:wool', 'group:wool'},
		{'group:wool', '', 'group:wool'},
		{'', '', ''},
	}
})

minetest.register_craft({
	output = 'xtraarmor:chestplate_leather',
	recipe = {
		{'group:wool', '', 'group:wool'},
		{'group:wool', 'group:wool', 'group:wool'},
		{'group:wool', 'group:wool', 'group:wool'},
	}
})

minetest.register_craft({
	output = 'xtraarmor:leggings_leather',
	recipe = {
		{'group:wool', 'group:wool', 'group:wool'},
		{'group:wool', '', 'group:wool'},
		{'group:wool', '', 'group:wool'},
	}
})

minetest.register_craft({
	output = 'xtraarmor:boots_leather',
	recipe = {
		{'', '', ''},
		{'group:wool', '', 'group:wool'},
		{'group:wool', '', 'group:wool'},
	}
})

	minetest.register_tool("xtraarmor:helmet_leather_green", {
		description = "green wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_green.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_green", {
		description = "green wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_green.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_green", {
		description = "green wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_green.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_green", {
		description = "green wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_green.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_green",
	recipe = {"xtraarmor:helmet_leather", "dye:green"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_green",
	recipe = {"xtraarmor:chestplate_leather", "dye:green"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_green",
	recipe = {"xtraarmor:leggings_leather", "dye:green"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_green",
	recipe = {"xtraarmor:boots_leather", "dye:green"},
})

	minetest.register_tool("xtraarmor:helmet_leather_blue", {
		description = "blue wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_blue.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_blue", {
		description = "blue wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_blue.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_blue", {
		description = "blue wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_blue.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_blue", {
		description = "blue wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_blue.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_blue",
	recipe = {"xtraarmor:helmet_leather", "dye:blue"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_blue",
	recipe = {"xtraarmor:chestplate_leather", "dye:blue"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_blue",
	recipe = {"xtraarmor:leggings_leather", "dye:blue"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_blue",
	recipe = {"xtraarmor:boots_leather", "dye:blue"},
})

	minetest.register_tool("xtraarmor:helmet_leather_red", {
		description = "red wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_red.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_red", {
		description = "red wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_red.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_red", {
		description = "red wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_red.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_red", {
		description = "red wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_red.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_red",
	recipe = {"xtraarmor:helmet_leather", "dye:red"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_red",
	recipe = {"xtraarmor:chestplate_leather", "dye:red"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_red",
	recipe = {"xtraarmor:leggings_leather", "dye:red"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_red",
	recipe = {"xtraarmor:boots_leather", "dye:red"},
})

	minetest.register_tool("xtraarmor:helmet_leather_yellow", {
		description = "yellow wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_yellow.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_yellow", {
		description = "yellow wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_yellow.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_yellow", {
		description = "yellow wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_yellow.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_yellow", {
		description = "yellow wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_yellow.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_yellow",
	recipe = {"xtraarmor:helmet_leather", "dye:yellow"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_yellow",
	recipe = {"xtraarmor:chestplate_leather", "dye:yellow"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_yellow",
	recipe = {"xtraarmor:leggings_leather", "dye:yellow"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_yellow",
	recipe = {"xtraarmor:boots_leather", "dye:yellow"},
})

	minetest.register_tool("xtraarmor:helmet_leather_white", {
		description = "white wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_white.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_white", {
		description = "white wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_white.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_white", {
		description = "white wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_white.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_white", {
		description = "white wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_white.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_white",
	recipe = {"xtraarmor:helmet_leather", "dye:white"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_white",
	recipe = {"xtraarmor:chestplate_leather", "dye:white"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_white",
	recipe = {"xtraarmor:leggings_leather", "dye:white"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_white",
	recipe = {"xtraarmor:boots_leather", "dye:white"},
})

	minetest.register_tool("xtraarmor:helmet_leather_black", {
		description = "black wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_black.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_black", {
		description = "black wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_black.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_black", {
		description = "black wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_black.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_black", {
		description = "black wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_black.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})
minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_black",
	recipe = {"xtraarmor:helmet_leather", "dye:black"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_black",
	recipe = {"xtraarmor:chestplate_leather", "dye:black"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_black",
	recipe = {"xtraarmor:leggings_leather", "dye:black"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_black",
	recipe = {"xtraarmor:boots_leather", "dye:black"},
})

	minetest.register_tool("xtraarmor:helmet_leather_grey", {
		description = "grey wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_grey.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_grey", {
		description = "grey wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_grey.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_grey", {
		description = "grey wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_grey.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_grey", {
		description = "grey wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_grey.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_grey",
	recipe = {"xtraarmor:helmet_leather", "dye:grey"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_grey",
	recipe = {"xtraarmor:chestplate_leather", "dye:grey"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_grey",
	recipe = {"xtraarmor:leggings_leather", "dye:grey"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_grey",
	recipe = {"xtraarmor:boots_leather", "dye:grey"},
})

	minetest.register_tool("xtraarmor:helmet_leather_orange", {
		description = "orange wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_orange.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_orange", {
		description = "orange wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_orange.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_orange", {
		description = "orange wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_orange.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_orange", {
		description = "orange wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_orange.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_orange",
	recipe = {"xtraarmor:helmet_leather", "dye:orange"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_orange",
	recipe = {"xtraarmor:chestplate_leather", "dye:orange"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_orange",
	recipe = {"xtraarmor:leggings_leather", "dye:orange"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_orange",
	recipe = {"xtraarmor:boots_leather", "dye:orange"},
})

	minetest.register_tool("xtraarmor:helmet_leather_dark_grey", {
		description = "dark grey wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_dark_grey.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_dark_grey", {
		description = "dark grey wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_dark_grey.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_dark_grey", {
		description = "dark grey wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_dark_grey.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_dark_grey", {
		description = "dark grey wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_dark_grey.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_dark_grey",
	recipe = {"xtraarmor:helmet_leather", "dye:dark_grey"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_dark_grey",
	recipe = {"xtraarmor:chestplate_leather", "dye:dark_grey"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_dark_grey",
	recipe = {"xtraarmor:leggings_leather", "dye:dark_grey"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_dark_grey",
	recipe = {"xtraarmor:boots_leather", "dye:dark_grey"},
})

	minetest.register_tool("xtraarmor:helmet_leather_dark_green", {
		description = "dark green wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_dark_green.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_dark_green", {
		description = "dark green wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_dark_green.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_dark_green", {
		description = "dark green wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_dark_green.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_dark_green", {
		description = "dark green wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_dark_green.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_dark_green",
	recipe = {"xtraarmor:helmet_leather", "dye:dark_green"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_dark_green",
	recipe = {"xtraarmor:chestplate_leather", "dye:dark_green"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_dark_green",
	recipe = {"xtraarmor:leggings_leather", "dye:dark_green"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_dark_green",
	recipe = {"xtraarmor:boots_leather", "dye:dark_green"},
})

	minetest.register_tool("xtraarmor:helmet_leather_cyan", {
		description = "cyan wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_cyan.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_cyan", {
		description = "cyan wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_cyan.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_cyan", {
		description = "cyan wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_cyan.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_cyan", {
		description = "cyan wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_cyan.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_cyan",
	recipe = {"xtraarmor:helmet_leather", "dye:cyan"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_cyan",
	recipe = {"xtraarmor:chestplate_leather", "dye:cyan"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_cyan",
	recipe = {"xtraarmor:leggings_leather", "dye:cyan"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_cyan",
	recipe = {"xtraarmor:boots_leather", "dye:cyan"},
})

	minetest.register_tool("xtraarmor:helmet_leather_pink", {
		description = "pink wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_pink.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_pink", {
		description = "pink wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_pink.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_pink", {
		description = "pink wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_pink.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_pink", {
		description = "pink wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_pink.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_pink",
	recipe = {"xtraarmor:helmet_leather", "dye:pink"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_pink",
	recipe = {"xtraarmor:chestplate_leather", "dye:pink"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_pink",
	recipe = {"xtraarmor:leggings_leather", "dye:pink"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_pink",
	recipe = {"xtraarmor:boots_leather", "dye:pink"},
})

	minetest.register_tool("xtraarmor:helmet_leather_magenta", {
		description = "magenta wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_magenta.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_magenta", {
		description = "magenta wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_magenta.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_magenta", {
		description = "magenta wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_magenta.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_magenta", {
		description = "magenta wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_magenta.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_magenta",
	recipe = {"xtraarmor:helmet_leather", "dye:magenta"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_magenta",
	recipe = {"xtraarmor:chestplate_leather", "dye:magenta"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_magenta",
	recipe = {"xtraarmor:leggings_leather", "dye:magenta"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_magenta",
	recipe = {"xtraarmor:boots_leather", "dye:magenta"},
})

	minetest.register_tool("xtraarmor:helmet_leather_violet", {
		description = "violet wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_violet.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_violet", {
		description = "violet wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_violet.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_violet", {
		description = "violet wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_violet.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_violet", {
		description = "violet wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_violet.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})
	
minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_violet",
	recipe = {"xtraarmor:helmet_leather", "dye:violet"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_violet",
	recipe = {"xtraarmor:chestplate_leather", "dye:violet"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_violet",
	recipe = {"xtraarmor:leggings_leather", "dye:violet"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_violet",
	recipe = {"xtraarmor:boots_leather", "dye:violet"},
})

	minetest.register_tool("xtraarmor:helmet_leather_brown", {
		description = "brown wool cap",
		inventory_image = "xtraarmor_inv_helmet_leather_brown.png",
		groups = {leather_helmet=1, armor_head=7,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:chestplate_leather_brown", {
		description = "brown wool tunic",
		inventory_image = "xtraarmor_inv_chestplate_leather_brown.png",
		groups = {leather_chestplate=1, armor_torso=12,  armor_use=1000},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:leggings_leather_brown", {
		description = "brown wool trousers",
		inventory_image = "xtraarmor_inv_leggings_leather_brown.png",
		groups = {leather_leggings=1, armor_legs=7,  armor_use=150},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:boots_leather_brown", {
		description = "brown wool boots",
		inventory_image = "xtraarmor_inv_boots_leather_brown.png",
		groups = {leather_boots=1, armor_feet=7, physics_speed=0.15, armor_use=1000},
		wear = 0,
	})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_leather_brown",
	recipe = {"xtraarmor:helmet_leather", "dye:brown"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_leather_brown",
	recipe = {"xtraarmor:chestplate_leather", "dye:brown"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_leather_brown",
	recipe = {"xtraarmor:leggings_leather", "dye:brown"},
})

minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_leather_brown",
	recipe = {"xtraarmor:boots_leather", "dye:brown"},
})

--------------------------------------------------------------------

	minetest.register_tool("xtraarmor:helmet_chainmail", {
		description = "chainmail Helmet",
		inventory_image = "xtraarmor_inv_helmet_chainmail.png",
		groups = {armor_head=7, armor_heal=0, armor_use=750, physics_speed=-0.02},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:chestplate_chainmail", {
		description = "chainmail Chestplate",
		inventory_image = "xtraarmor_inv_chestplate_chainmail.png",
		groups = {armor_torso=10, armor_heal=0, armor_use=750, physics_speed=-0.05},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:leggings_chainmail", {
		description = "chainmail Leggings",
		inventory_image = "xtraarmor_inv_leggings_chainmail.png",
		groups = {armor_legs=10, armor_heal=0, armor_use=750, physics_speed=-0.05},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:boots_chainmail", {
		description = "chainmail Boots",
		inventory_image = "xtraarmor_inv_boots_chainmail.png",
		groups = {armor_feet=7, armor_heal=0, armor_use=750, physics_speed=-0.02},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:shield_chainmail", {
		description = "chainmail shield",
		inventory_image = "xtraarmor_inv_shield_chainmail.png",
		groups = {armor_shield=7, armor_heal=0, armor_use=750},
		wear = 0,
	})

minetest.register_craft({
	output = 'xtraarmor:helmet_chainmail',
	recipe = {
		{'xpanes:bar', 'xpanes:bar', 'xpanes:bar'},
		{'xpanes:bar', '', 'xpanes:bar'},
		{'', '', ''},
	}
})

minetest.register_craft({
	output = 'xtraarmor:chestplate_chainmail',
	recipe = {
		{'xpanes:bar', '', 'xpanes:bar'},
		{'xpanes:bar', 'xpanes:bar', 'xpanes:bar'},
		{'xpanes:bar', 'xpanes:bar', 'xpanes:bar'},
	}
})

minetest.register_craft({
	output = 'xtraarmor:leggings_chainmail',
	recipe = {
		{'xpanes:bar', 'xpanes:bar', 'xpanes:bar'},
		{'xpanes:bar', '', 'xpanes:bar'},
		{'xpanes:bar', '', 'xpanes:bar'},
	}
})

minetest.register_craft({
	output = 'xtraarmor:boots_chainmail',
	recipe = {
		{'', '', ''},
		{'xpanes:bar', '', 'xpanes:bar'},
		{'xpanes:bar', '', 'xpanes:bar'},
	}
})

minetest.register_craft({
	output = 'xtraarmor:shield_chainmail',
	recipe = {
		{'xpanes:bar', 'xpanes:bar', 'xpanes:bar'},
		{'xpanes:bar', 'xpanes:bar', 'xpanes:bar'},
		{'', 'xpanes:bar', ''},
	}
})


	minetest.register_tool("xtraarmor:helmet_studded", {
		description = "studded Helmet",
		inventory_image = "xtraarmor_inv_helmet_studded.png",
		groups = {armor_head=8, armor_heal=0, armor_use=400, physics_speed=-0.03},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:chestplate_studded", {
		description = "studded Chestplate",
		inventory_image = "xtraarmor_inv_chestplate_studded.png",
		groups = {armor_torso=14, armor_heal=0, armor_use=400, physics_speed=-0.06},
		wear = 0,
	})
	minetest.register_tool("xtraarmor:leggings_studded", {
		description = "studded Leggings",
		inventory_image = "xtraarmor_inv_leggings_studded.png",
		groups = {armor_legs=14, armor_heal=0, armor_use=400, physics_speed=-0.06},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:boots_studded", {
		description = "studded Boots",
		inventory_image = "xtraarmor_inv_boots_studded.png",
		groups = {armor_feet=8, armor_heal=0, armor_use=400, physics_speed=-0.03},
		wear = 0,
	})

	minetest.register_tool("xtraarmor:shield_studded", {
		description = "studded shield",
		inventory_image = "xtraarmor_inv_shield_studded.png",
		groups = {armor_shield=8, armor_heal=0, armor_use=400},
		wear = 0,
	})


minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:helmet_studded",
	recipe = {"xtraarmor:helmet_chainmail", "xtraarmor:helmet_leather"},
})
minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:chestplate_studded",
	recipe = {"xtraarmor:chestplate_chainmail", "xtraarmor:chestplate_leather"},
})
minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:leggings_studded",
	recipe = {"xtraarmor:leggings_chainmail", "xtraarmor:leggings_leather"},
})
minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:boots_studded",
	recipe = {"xtraarmor:boots_chainmail", "xtraarmor:boots_leather"},
})
minetest.register_craft({
	type = "shapeless",
	output = "xtraarmor:shield_studded",
	recipe = {"xtraarmor:shield_chainmail", "xtraarmor:shield_leather"},
})