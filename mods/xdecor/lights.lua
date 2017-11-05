minetest.register_node("xdecor:runelamp", {
	description = "Rune Stonelamp",
	tiles = {"default_stone.png^ithildin.png"},
	drawtype = 'normal',
	walkable = true,
	pointable = true,
	sunlight_propagates = false,
	light_source = 13,
	groups = {snappy=2,cracky=3,},
	
})

minetest.register_craft({
        output = 'xdecor:runelamp',
        recipe = {
                {'', 'default:torch', ''},
                {'', 'default:stone', ''},
                {'', 'dye:white', ''},
        }
})

minetest.register_node("xdecor:magma", {
	description = "Magma",
	drawtype = "normal",
	tiles = {
		{
			name = "magma.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	walkable = true,
	pointable = true,
	sunlight_propagates = false,
	light_source = 13,
	groups = {snappy=2,cracky=3,},
	
})

minetest.register_craft({
        output = 'xdecor:magma 2',
        recipe = {
                {'bucket:bucket_lava'},
                {'default:stone'},
        },
        replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
        
})
minetest.register_craft({
	type = "shapeless",
	output = "bucket:bucket_lava",
	recipe = {"xdecor:magma", "xdecor:magma", "bucket:bucket_empty"},
	replacements = {
		{"xdecor:magma", "default:cobble"}
	}
})

minetest.register_node("xdecor:woodbox", {
	description = "Wood Lightbox",
	tiles = {"woodbox.png"},
	drawtype = 'normal',
	walkable = true,
	pointable = true,
	sunlight_propagates = false,
	light_source = 13,
	groups = {snappy=2,cracky=3,},
	
})

minetest.register_craft({
        output = 'xdecor:woodbox 3',
        recipe = {
                {'', 'default:torch', ''},
                {'default:glass', 'group:wood', 'default:glass'},
                {'', 'default:torch', ''},
        }
})



