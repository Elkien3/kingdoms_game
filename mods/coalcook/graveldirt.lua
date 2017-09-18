minetest.register_craft({
output = "default:cobble",
type = "cooking",
recipe = "default:gravel"
})
minetest.register_craft({
	output = "default:gravel",
	recipe = {
		{"default:sand"}
	}
})
minetest.register_craft({
	output = "default:sand",
	recipe = {
		{"default:dirt"}
	}
})
minetest.register_craft({
	output = "default:gravel",
	recipe = {
		{"default:cobble"}
	}
})
minetest.register_craft({
	output = "default:sand",
	recipe = {
		{"default:gravel"}
	}
})
minetest.register_craft({
	output = "default:dirt",
	recipe = {
		{"default:sand", "default:leaves"}
	}
})