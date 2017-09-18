
-- GHOSTSTONE

default.register_fence("mesecons_random:ghoststone", {
	description="Portcullis",
	texture = "default_stone.png",
	is_ground_content = true,
	groups = {cracky=2},
	material = "default:steel_ingot",
	sounds = default.node_sound_stone_defaults(),
	mesecons = {conductor = {
		state = mesecon.state.off,
		rules = { --axes
			{x = -1, y = 0, z = 0},
			{x = 1, y = 0, z = 0},
			{x = 0, y = -1, z = 0},
			{x = 0, y = 1, z = 0},
			{x = 0, y = 0, z = -1},
			{x = 0, y = 0, z = 1},
		},
		onstate = "mesecons_random:ghoststone_active"
	}}
})

minetest.register_node("mesecons_random:ghoststone_active", {
	drawtype = "airlike",
	pointable = false,
	walkable = false,
	diggable = false,
	sunlight_propagates = true,
	paramtype = "light",
	mesecons = {conductor = {
		state = mesecon.state.on,
		rules = {
			{x = -1, y = 0, z = 0},
			{x = 1, y = 0, z = 0},
			{x = 0, y = -1, z = 0},
			{x = 0, y = 1, z = 0},
			{x = 0, y = 0, z = -1},
			{x = 0, y = 0, z = 1},
		},
		offstate = "mesecons_random:ghoststone"
	}},
	on_construct = function(pos)
		-- remove shadow
		shadowpos = vector.add(pos, vector.new(0, 1, 0))
		if (minetest.get_node(shadowpos).name == "air") then
			minetest.dig_node(shadowpos)
		end
	end
})