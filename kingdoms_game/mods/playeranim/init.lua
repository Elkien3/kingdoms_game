local model = minetest.get_modpath("3d_armor") and "armor" or "normal"

-- Localize functions to avoid table lookups (better performance)
local vector_new = vector.new
local math_sin = math.sin
local math_deg = math.deg
local table_remove = table.remove
local get_animation = default.player_get_animation
local get_connected_players = minetest.get_connected_players

-- Animation alias
local STAND = 1
local WALK = 2
local MINE = 3
local WALK_MINE = 4
local SIT = 5
local LAY = 6

-- Bone alias
local BODY = "Body"
local HEAD = "Head"
local CAPE = "Cape"
local LARM = "Arm_Left"
local RARM = "Arm_Right"
local LLEG = "Leg_Left"
local RLEG = "Leg_Right"

local bone_positions = {
	normal = {
		[BODY] = vector_new(0, -3.5, 0),
		[HEAD] = vector_new(0, 6.5, 0),
		[CAPE] = vector_new(0, 6.5, 1.5),
		[LARM] = vector_new(-3.9, 6.5, 0),
		[RARM] = vector_new(3.9, 6.5, 0),
		[LLEG] = vector_new(-1, 0, 0),
		[RLEG] = vector_new(1, 0, 0)
	},
	armor = {
		[BODY] = vector_new(0, -3.5, 0),
		[HEAD] = vector_new(0, 6.75, 0),
		[CAPE] = vector_new(0, 6.75, 1.5),
		[LARM] = vector_new(2, 6.5, 0),
		[RARM] = vector_new(-2, 6.5, 0),
		[LLEG] = vector_new(1, 0, 0),
		[RLEG] = vector_new(-1, 0, 0)
	}
}

local bone_rotations = {
	normal = {
		[BODY] = vector_new(0, 0, 0),
		[HEAD] = vector_new(0, 0, 0),
		[CAPE] = vector_new(0, 0, 180),
		[LARM] = vector_new(180, 0, 7.5),
		[RARM] = vector_new(180, 0, -7.5),
		[LLEG] = vector_new(0, 0, 0),
		[RLEG] = vector_new(0, 0, 0)
	},
	armor = {
		[BODY] = vector_new(0, 0, 0),
		[HEAD] = vector_new(0, 0, 0),
		[CAPE] = vector_new(180, 0, 180),
		[LARM] = vector_new(180, 0, 9),
		[RARM] = vector_new(180, 0, -9),
		[LLEG] = vector_new(0, 0, 0),
		[RLEG] = vector_new(0, 0, 0)
	}
}

local bone_rotation = bone_rotations[model]
local bone_position = bone_positions[model]

local function rotate(player, bone, x, y, z)
	local default_rotation = bone_rotation[bone]
	local rotation = {
		x = (x or 0) + default_rotation.x,
		y = (y or 0) + default_rotation.y,
		z = (z or 0) + default_rotation.z
	}
	player:set_bone_position(bone, bone_position[bone], rotation)
end

local step = 0
local look_pitch = {}
local animation_speed = {}

local animations = {
	[STAND] = function(player)
		rotate(player, BODY)
		rotate(player, CAPE)
		rotate(player, LARM)
		rotate(player, RARM)
		rotate(player, LLEG)
		rotate(player, RLEG)
	end,

	[WALK] = function(player)
		local name = player:get_player_name()

		local swing = math_sin(step * 4 * animation_speed[name])

		rotate(player, CAPE, swing * 30 + 35)
		rotate(player, LARM, swing * -40)
		rotate(player, RARM, swing * 40)
		rotate(player, LLEG, swing * 40)
		rotate(player, RLEG, swing * -40)
	end,

	[MINE] = function(player)
		local name = player:get_player_name()

		local pitch = look_pitch[name]
		local swing = math_sin(step * 4 * animation_speed[name])
		local hand_swing = math_sin(step * 8 * animation_speed[name])

		rotate(player, CAPE, swing * 5 + 10)
		rotate(player, LARM)
		rotate(player, RARM, hand_swing * 20 + 80 + pitch)
		rotate(player, LLEG)
		rotate(player, RLEG)
	end,

	[WALK_MINE] = function(player)
		local name = player:get_player_name()

		local pitch = look_pitch[name]
		local swing = math_sin(step * 4 * animation_speed[name])
		local hand_swing = math_sin(step * 8 * animation_speed[name])

		rotate(player, CAPE, swing * 30 + 35)
		rotate(player, LARM, swing * -40)
		rotate(player, RARM, hand_swing * 20 + 80 + pitch)
		rotate(player, LLEG, swing * 40)
		rotate(player, RLEG, swing * -40)
	end,

	[SIT] = function(player)
		local body_position = vector_new(bone_position[BODY])
		body_position.y = body_position.y - 6

		player:set_bone_position(BODY, body_position, {x = 0, y = 0, z = 0})

		rotate(player, LARM)
		rotate(player, RARM)
		rotate(player, LLEG, 90)
		rotate(player, RLEG, 90)
	end,

	[LAY] = function(player)
		local body_position = {x = 0, y = -9, z = 0}
		local body_rotation = {x = 270, y = 0, z = 0}

		player:set_bone_position(BODY, body_position, body_rotation)

		rotate(player, HEAD)
	end
}

local function update_look_pitch(player)
	local name = player:get_player_name()
	local pitch = math_deg(player:get_look_pitch())

	if look_pitch[name] ~= pitch then
		look_pitch[name] = pitch
	end
end

local function set_animation_speed(player, bool_sneak)
	local name = player:get_player_name()
	local speed = bool_sneak and 0.75 or 2

	if animation_speed[name] ~= speed then
		animation_speed[name] = speed
	end
end

local previous_animation = {}

local function set_animation(player, anim)
	local name = player:get_player_name()

	if anim == LAY then
		if previous_animation[name] ~= anim then
			previous_animation[name] = anim
			animations[anim](player)
		end
		return
	end

	if anim == WALK or anim == MINE or anim == WALK_MINE then
		previous_animation[name] = anim
		animations[anim](player)
		return
	end

	if previous_animation[name] ~= anim then
		previous_animation[name] = anim
		animations[anim](player)
	end
end

local previous_head = {}

local function head_rotate(player, y)
	local name = player:get_player_name()

	local x = look_pitch[name]
	local old_head = previous_head[name]

	if x ~= old_head.x
	or y ~= old_head.y then
		previous_head[name] = {x = x, y = y}
		rotate(player, HEAD, x, y)
	end
end

local previous_yaw = {}
local previous_body = {}

local function body_moving(player, bool_sneak, no_rotate_body)
	local name = player:get_player_name()
	local yaw = player:get_look_yaw()

	local player_previous_yaw = previous_yaw[name]
	local index = #player_previous_yaw + 1
	player_previous_yaw[index] = yaw

	local next_yaw = yaw
	if index > 7 then
		next_yaw = player_previous_yaw[1]
		table_remove(player_previous_yaw, 1)
	end

	local x, y = 0, 0
	if not no_rotate_body then
		x = bool_sneak and 5 or 0
		y = math_deg(yaw - next_yaw)
	end

	local old_body = previous_body[name]

	if x ~= old_body.x
	or y ~= old_body.y then
		rotate(player, BODY, x, y)
		previous_body[name] = {x = x, y = y}
	end

	head_rotate(player, -y)
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()

	previous_yaw[name] = {}
	previous_head[name] = {x = 0, y = 0}
	previous_body[name] = {x = 0, y = 0}
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()

	look_pitch[name] = nil
	animation_speed[name] = nil

	previous_yaw[name] = nil
	previous_head[name] = nil
	previous_body[name] = nil
	previous_animation[name] = nil
end)

minetest.register_globalstep(function(dtime)
	step = step + dtime
	if step >= 3600 then
		step = 1
	end

	local players = get_connected_players()

	local player_count = #players
	if player_count == 0 then return end

	for i = 1, player_count do
		local player = players[i]
		local animation = get_animation(player).animation

		if animation == "lay" then -- No head rotate
			set_animation(player, STAND) -- Reset
			set_animation(player, LAY)
		else
			local controls = player:get_player_control()
			local bool_sneak = controls.sneak

			update_look_pitch(player)

			if animation == "walk" then
				set_animation_speed(player, bool_sneak)
				set_animation(player, WALK)
				body_moving(player, bool_sneak)
			elseif animation == "mine" then
				set_animation_speed(player, bool_sneak)
				set_animation(player, MINE)
				body_moving(player, bool_sneak)
			elseif animation == "walk_mine" then
				set_animation_speed(player, bool_sneak)
				set_animation(player, WALK_MINE)
				body_moving(player, bool_sneak)
			elseif animation == "sit" then
				set_animation(player, SIT)
				body_moving(player, bool_sneak, true)
			else
				set_animation(player, STAND)
				body_moving(player, bool_sneak)
			end
		end
	end
end)
