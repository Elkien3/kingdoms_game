-- This mod is used to protect nodes in the capture the flag game
ctf.register_on_init(function()
	ctf.log("chat", "Initialising...")

	-- Settings: Chat
	ctf._set("node_ownership",          true)
end)

local old_is_protected = minetest.is_protected

function minetest.is_protected(pos, name)
	if not ctf.setting("node_ownership") then
		return old_is_protected(pos, name)
	end

	local team = ctf.get_territory_owner(pos)

	if not team or not ctf.team(team) then
		return old_is_protected(pos, name)
	end

	if ctf.player(name).team == team then
		return old_is_protected(pos, name)
	else
		local player = minetest.get_player_by_name(name)
		if player then
			--[[ yaw + 180°
			local yaw = player:get_look_horizontal() + math.pi
			if yaw > 2 * math.pi then
				yaw = yaw - 2 * math.pi
			end
			player:set_look_yaw(yaw)

			-- invert pitch
			player:set_look_vertical(-player:get_look_vertical())
			--]]
			-- if digging below player, move up to avoid falling through hole
			local pla_pos = player:get_pos()

			if pos.y < pla_pos.y then
				player:setpos({
					x = pla_pos.x,
					y = pla_pos.y + 0.8,
					z = pla_pos.z
				})
			else
				player:setpos(pla_pos)
			end
		end
		minetest.chat_send_player(name, "You cannot dig on team "..team.."'s land")
		return true
	end
end
