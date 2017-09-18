	minetest.register_tool("moreclothes:crown", {
		description = "Crown",
		inventory_image = "moreclothes_inv_crown.png",
		groups = {armor_head=5, armor_heal=0, armor_use=500},
		wear = 0,
	})
	minetest.register_tool("moreclothes:cloak_dark_green", {
		description = "Cloak",
		inventory_image = "moreclothes_inv_cloak_dark_green.png",
		groups = {armor_head=5, armor_heal=0, armor_use=500},
		wear = 0,
	})
		minetest.register_tool("moreclothes:wrappedcloak_dark_green", {
		description = "Wrapped Cloak",
		inventory_image = "moreclothes_inv_wrappedcloak_dark_green.png",
		groups = {armor_head=5, armor_heal=0, armor_use=500},
		wear = 0,
	})	
		minetest.register_craft({
		output = "moreclothes:crown",
		recipe = {
			{"default:gold_ingot", "default:diamond", "default:gold_ingot"},
		},
	})
	
			minetest.register_craft({
		output = "moreclothes:cloak_dark_green",
		recipe = {
			{"group:wool", "group:wool"},
			{"group:wool", "group:wool"},
		},
	})
				minetest.register_craft({
		output = "moreclothes:wrappedcloak_dark_green",
		recipe = {
			{"moreclothes:cloak_dark_green"},
		},
	})
				minetest.register_craft({
		output = "moreclothes:cloak_dark_green",
		recipe = {
			{"moreclothes:wrappedcloak_dark_green"},
		},
	})