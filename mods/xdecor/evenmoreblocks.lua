--Credit goes to Extex101, original mod https://github.com/Extex101/Even-More-Blocks

minetest.register_node("xdecor:jungle_wood_tile", {
    description = "Jungle Wood Tile",
    tiles = {"jungle_wood_tile.png"},
    groups = {choppy = 2,level = 2},
})
minetest.register_craft({
	output = 'xdecor:jungle_wood_tile 5',
	recipe = {
		{'', 'default:wood', ''},
		{ 'default:wood','default:junglewood', 'default:wood'},
		{'', 'default:wood', ''},
	}
})
minetest.register_node("xdecor:obsidian_runestone", {
    description = "Obsidian Runestone",
    tiles = {"obsidian_rune.png"},
    groups = {cracky = 1,level = 2},
})
minetest.register_craft({
	output = 'xdecor:obsidian_runestone 8',
	recipe = {
		{'default:obsidian','default:obsidian', 'default:obsidian'},
		{'default:obsidian','', 'default:obsidian'},
		{'default:obsidian','default:obsidian', 'default:obsidian'},
	}
})
minetest.register_node("xdecor:desert_runestone", {
    description = "Desert Runestone",
    tiles = {"desert_stone_rune.png"},
    groups = {cracky = 2},
})
minetest.register_craft({
	output = 'xdecor:desert_runestone 8',
	recipe = {
		{'default:desert_stone', 'default:desert_stone', 'default:desert_stone'},
		{ 'default:desert_stone','', 'default:desert_stone'},
		{'default:desert_stone', 'default:desert_stone', 'default:desert_stone'},
	}
})