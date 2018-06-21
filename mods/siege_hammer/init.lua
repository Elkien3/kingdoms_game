material_Strengths = {}
black_list = {"ctf_flag:flag","ctf_flag:flag_captured_top"}
for color, _ in pairs(ctf.flag_colors) do
	table.insert(black_list,"ctf_flag:flag_top_"..color)
end
siegehammer_Damage = 1

minetest.register_chatcommand("node_strength", {
	params = "<node_name>",
	description = "Read HP of node. Example /node_strength default:dirt. To see all nodes strength /node_strength all.",
	func = function(name, param)
		if material_Strengths[param] then
			return true, "HP: " .. tostring(material_Strengths[param])
			else if string.lower(param) == "all" then
				local list = ""
				for i,j in pairs(material_Strengths) do
					list = list .. i .. " = " .. tostring(j) .. "\n"
				end
				return true,list
			else
				return false,param .. " does not exist."
			end
		end
	end
	})

local function div(base,value)
	if value then
		return base / value
	end
	return 0
end

local function mul(base,value)
	if value then
		return base * value
	end
	return 0
end

local function cac_Material_Strengths()
	local list = minetest.registered_nodes
	local node = nil
	for i in pairs(list) do
		node = list[i]
		local strength_Pool = 0
		local cracky = div(47,node.groups.cracky)
		local stone = div(68,node.groups.stone)
		local level = mul(150,node.groups.level)
		local crumbly = div(25,node.groups.crumbly)
		local oddly_breakable_by_hand = mul(5,node.groups.oddly_breakable_by_hand)
		local dig_immediate = mul(2,node.groups.dig_immediate)
		local choppy = div(35,node.groups.choppy)
		local snappy = div(15,node.groups.snappy)
		strength_Pool = strength_Pool + cracky
		strength_Pool = strength_Pool + stone
		strength_Pool = strength_Pool + level
		strength_Pool = strength_Pool + crumbly
		strength_Pool = strength_Pool - oddly_breakable_by_hand
		strength_Pool = strength_Pool - dig_immediate
		strength_Pool = strength_Pool + choppy
		strength_Pool = strength_Pool + snappy
		if strength_Pool < 0 then
			strength_Pool = 1
		end
		-- Round value.
		strength_Pool = math.floor(strength_Pool+0.5)
		material_Strengths[node.name] = strength_Pool
	end
end

-- siege hammer
minetest.register_tool("siege_hammer:siege_hammer", {
	description = "Siege Hammer",
	image           = "siege_hammer.png",
	inventory_image = "siege_hammer.png",

	tool_capabilities = {
		full_punch_interval = 5,
		max_drop_level = 0,
		range = 1,
		groupcaps={
			cracky = {times={[1]=8.0, [2]=4.0, [3]=2.0}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
	on_use = function(itemstack, user, pointed_thing)
		local pos = nil
		local node = nil
		local realNode = nil
		local damage_number = siegehammer_Damage
		if pointed_thing.under then
			pos = pointed_thing.under
		end
		if pointed_thing.above then
			pos = pointed_thing.under
		end
		if pos then
			node = minetest.get_node_or_nil(pos)
			realNode = minetest.registered_nodes[node.name]
			local name = user:get_player_name()
			local team = ctf.get_territory_owner(pos)
			local p_team = ctf.player(name).team
			for i in pairs(black_list) do
				if black_list[i] == node.name then
					minetest.chat_send_player(name, "None siegeable block.")
					return itemstack
				end
			end
			if not team then
				minetest.chat_send_player(name, "This only works in protected areas.")
				return itemstack
			end
			if p_team == team then
				minetest.chat_send_player(name, "You can not use a siege hammer on your own team!")
				return itemstack
			end
			if not p_team then
				minetest.chat_send_player(name, "You need to be in a team in order to use this siege weapon.")
				return itemstack
			end
			if p_team ~= team then
				local state = ctf.diplo.get(p_team,team)
				if state ~= "war" then
					minetest.chat_send_player(name, "You need to be at war in order to use this siege weapon.")
					return itemstack
				end
			end
			--[[local online = false
			local playerslist = minetest.get_connected_players()
			for i in pairs(playerslist) do
				local player = playerslist[i]
				local player_name = player:get_player_name()
				local player_team = ctf.player(player_name).team
				if player_team then
					if player_team == team then
						online = true
						break
					end
				end
			end
			if not online then
				minetest.chat_send_player(name, "There needs to be at least one member of this team online in order to siege them.")
				return itemstack
			end--]]
			itemstack:add_wear(100)
			local meta = minetest.get_meta(pos)
			local health = 1
			if meta then
				local tmp = meta:to_table()
				if tmp then
					if not tmp.fields.siege_health then
						tmp.fields.siege_health = material_Strengths[realNode.name]
					end
					-- Damage code.
					tmp.fields.siege_health = tmp.fields.siege_health - damage_number
					health = tmp.fields.siege_health
					meta:from_table(tmp)
				end
			end
			if health <= 0 then
				local drops = minetest.get_node_drops(minetest.get_node(pos).name, "siege_hammer:siege_hammer")
				minetest.remove_node(pos)
				nodeupdate(pos)
				local dropitem = ItemStack(drops[1])
				minetest.add_item(pos, dropitem)
				local msg = "Siege alert! Protected node at (" .. tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z) .. ")" .. " Was removed by " .. name .. "."
				ctf.post(team, {
				msg = msg,
				icon="flag_red" })
				for i in pairs(playerslist) do
					local player = playerslist[i]
					local player_name = player:get_player_name()
					local player_team = ctf.player(player_name).team
					if player_team then
						if player_team == team then
							minetest.chat_send_player(player_name, msg)
						end
					end
				end
				if realNode then
					if realNode.sounds then
						if realNode.sounds.dug then
							minetest.sound_play("default_tool_breaks", {pos = pos, gain = 2.1,max_hear_distance = 127})
						end
					end
				end
				return itemstack
			end
		end
		if realNode then
			if realNode.sounds then
				if realNode.sounds.dug then
					minetest.sound_play(realNode.sounds.dug.name, {pos = pos, gain = 1.6,max_hear_distance = 95})
				end
			end
		end
		return itemstack
	end,
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_craft({
	output = "siege_hammer:siege_hammer",
	recipe = {
                {'default:obsidian','default:obsidian','default:obsidian'},
                {'default:obsidian','default:obsidian','default:obsidian'},
                {'',                   'default:stick',      ''                   } }
})

cac_Material_Strengths()