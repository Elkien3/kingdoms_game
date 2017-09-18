function throwing_register_arrow_standard (kind, desc, eq, toughness, craft)
	minetest.register_craftitem("throwing:arrow_" .. kind, {
		description = desc .. " arrow",
		inventory_image = "throwing_arrow_" .. kind .. ".png",
	})
	
	minetest.register_node("throwing:arrow_" .. kind .. "_box", {
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				-- Shaft
				{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
				--Spitze
				{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
				{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
				--Federn
				{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
				{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
				{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
				{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},
				
				{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
				{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
				{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
				{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
			}
		},
		tiles = {"throwing_arrow_" .. kind .. ".png", "throwing_arrow_" .. kind .. ".png", "throwing_arrow_" .. kind .. "_back.png", "throwing_arrow_" .. kind .. "_front.png", "throwing_arrow_" .. kind .. "_2.png", "throwing_arrow_" .. kind .. ".png"},
		groups = {not_in_creative_inventory=1},
	})
	
	local THROWING_ARROW_ENTITY={
		physical = false,
		timer=0,
		visual = "wielditem",
		visual_size = {x=0.1, y=0.1},
		textures = {"throwing:arrow_" .. kind .. "_box"},
		lastpos={},
		collisionbox = {0,0,0,0,0,0},
	}
	
function throwing_is_player(name, obj)
	return (obj:is_player() and obj:get_player_name() ~= name)
end

function throwing_is_entity(obj)
	return (obj:get_luaentity() ~= nil
			and not string.find(obj:get_luaentity().name, "throwing:")
			and obj:get_luaentity().name ~= "__builtin:item"
			and obj:get_luaentity().name ~= "nametag:tag"
			and obj:get_luaentity().name ~= "signs:text")
end
function throwing_touch(pos, objpos)
	local rx = pos.x - objpos.x
	local ry = pos.y - (objpos.y+1)
	local rz = pos.z - objpos.z
	if (ry < 1 and ry > -1) and (rx < 1 and rx > -1) and (rz < 1 and rz > -1) then
		return true
	end
	return false
end
	THROWING_ARROW_ENTITY.on_step = function(self, dtime)
		self.timer=self.timer+dtime
		local pos = self.object:getpos()
		local node = minetest.get_node(pos)
	
		if self.timer>0.2 then
			local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
			for k, obj in pairs(objs) do
			objpos = obj:getpos()
				if throwing_is_player(self.player, obj) or throwing_is_entity(obj) then
						if throwing_touch(pos, objpos) then
							local puncher = self.object
							if self.player then
								puncher = self.player
							end
							local damage = eq
							if self.bow_damage and self.bow_damage > 0 then
								damage = damage + (self.bow_damage/12)
							end
							obj:punch(puncher, 1.0, {
								full_punch_interval=1.0,
								damage_groups={fleshy=damage},
							}, nil)
						self.object:remove()
						--if math.random() < toughness then
							--minetest.add_item(self.lastpos, 'throwing:arrow_' .. kind)
						--else
							--minetest.add_item(self.lastpos, 'default:stick')
						--end
					end
				end
			end
		end
	
		if self.lastpos.x~=nil then
			if node.name ~= "air" and not (string.find(node.name, 'grass') and not string.find(node.name, 'dirt')) and not string.find(node.name, 'flowers:') and not string.find(node.name, 'farming:') then
				self.object:remove()
				if math.random() < toughness then
					minetest.add_item(self.lastpos, 'throwing:arrow_' .. kind)
				else
					minetest.add_item(self.lastpos, 'default:stick')
				end
			end
		end
		self.lastpos={x=pos.x, y=pos.y, z=pos.z}
	end
	
	minetest.register_entity("throwing:arrow_" .. kind .. "_entity", THROWING_ARROW_ENTITY)
	
	minetest.register_craft({
		output = 'throwing:arrow_' .. kind .. ' 16',
		recipe = {
			{'default:stick', 'default:stick', craft},
		}
	})
	
	minetest.register_craft({
		output = 'throwing:arrow_' .. kind .. ' 16',
		recipe = {
			{craft, 'default:stick', 'default:stick'},
		}
	})
end

if not DISABLE_STONE_ARROW then
	throwing_register_arrow_standard ('stone', 'Flint', 7, 0.90, 'default:flint')
end

if not DISABLE_STEEL_ARROW then
	throwing_register_arrow_standard ('steel', 'Steel', 9, 0.99, 'default:steel_ingot')
end

if not DISABLE_DIAMOND_ARROW then
	throwing_register_arrow_standard ('diamond', 'Diamond', 10, 0.97, 'default:diamond')
end

if not DISABLE_OBSIDIAN_ARROW then
	throwing_register_arrow_standard ('obsidian', 'Obsidian', 15, 0.88, 'default:obsidian')
end
