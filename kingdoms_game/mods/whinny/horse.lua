local function is_ground(pos)
    local nn = minetest.get_node(pos).name
    return minetest.get_item_group(nn, "crumbly") ~= 0 or
    minetest.get_item_group(nn, "cracky") ~= 0 or
    minetest.get_item_group(nn, "choppy") ~= 0 or
    minetest.get_item_group(nn, "snappy") ~= 0
end

local function get_sign(i)
    if i == 0 then
        return 0
    else
        return i/math.abs(i)
    end
end

local function get_velocity(speed, yaw, y)
    local x = math.cos(yaw)*speed
    local z = math.sin(yaw)*speed
    return {x=x, y=y, z=z}
end

local function get_speed(velocity)
    return math.sqrt(velocity.x^2+velocity.z^2)
end

-- ===================================================================

local function register_wildhorse (basename)
whinny:register_mob ("whinny:horse"..basename, {
    type = "animal",
    hp_min = 10,
    hp_max = 10,
    collisionbox = {-.5, -0.01, -.5, .5, 1.4, .5},
    available_textures = {
        total = 1,
        texture_1 = {"whinny_horse"..basename..".png"},
    },
    visual = "mesh",
    drops = {
        {name = "creatures:flesh",
        chance = 1,
        min = 2,
        max = 3,},
    },
    mesh = "horsemob.x",
    makes_footstep_sound = true,
    walk_velocity = 1,
    armor = 100,
    drawtype = "front",
    water_damage = 1,
    lava_damage = 5,
    light_damage = 0,
     sounds = {
        random = "",
     },
    animation = {
        speed_normal = 20,
        stand_start = 300,
        stand_end = 460,
        walk_start = 10,
        walk_end = 60
    },
    follow = "farming:wheat",
    view_range = 5,
    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "farming:wheat" then
            minetest.add_entity (self.object:getpos(),
"whinny:horse"..basename.."h1")
            if not minetest.setting_getbool("creative_mode") then
                item:take_item()
                clicker:set_wielded_item(item)
            end
            self.object:remove()
        end
    end,
    jump = true,
    step=1,
    passive = true,
})
end

-- ===================================================================

local function register_basehorse(name, craftitem, horse)
    if craftitem ~= nil then
        function craftitem.on_place(itemstack, placer, pointed_thing)
            if pointed_thing.above then
                minetest.env:add_entity(pointed_thing.above, name)
                if not minetest.setting_getbool("creative_mode") then
                    itemstack:take_item()
                end
            end
            return itemstack
        end
        minetest.register_craftitem(name, craftitem)
    end

    function horse:set_animation(type)
        if type == self.animation_current then 
			return
		end
        if type == self.animation.mode_stand then
            if
                self.animation.stand_start
                and self.animation.stand_end
                and self.animation.speed_normal
            then
                self.object:set_animation(
                    {x=self.animation.stand_start,y=self.animation.stand_end},
                    self.animation.speed_normal * 0.6, 0
                )
                self.animation_current = self.animation.mode_stand
            end
        elseif type == self.animation.mode_walk  then
            if
                self.animation.walk_start
                and self.animation.walk_end
                and self.animation.speed_normal
            then
                self.object:set_animation(
                    {x=self.animation.walk_start,y=self.animation.walk_end},
                    self.animation.speed_normal * 3, 0
                )
                self.animation_current = self.animation.mode_walk
            end
		elseif type == self.animation.mode_gallop  then
            if
                self.animation.gallop_start
                and self.animation.gallop_end
                and self.animation.speed_normal
            then
                self.object:set_animation(
                    {x=self.animation.gallop_start,y=self.animation.gallop_end},
                    self.animation.speed_normal * 2, 0
                )
                self.animation_current = self.animation.mode_gallop
            end
        end
    end

    function horse:on_step(dtime)
        local p = self.object:getpos()
        p.y = p.y - 0.1
        local on_ground = is_ground(p)
		local inside_block = self.object:getpos()
		inside_block.y = inside_block.y + 1

        self.speed = get_speed(self.object:getvelocity())*get_sign(self.speed)

        -- driver controls
        if self.driver then
            local ctrl = self.driver:get_player_control()

            -- rotation (the faster we go, the less we rotate)
            if ctrl.left then
                self.object:setyaw(self.object:getyaw()+2*(1.5-math.abs(self.speed/self.max_speed))*math.pi/90 +dtime*math.pi/90)
            end
            if ctrl.right then
                self.object:setyaw(self.object:getyaw()-2*(1.5-math.abs(self.speed/self.max_speed))*math.pi/90 -dtime*math.pi/90)
            end
            -- jumping (only if on ground)
			
			if ctrl.jump then
				if on_ground then
					local v = self.object:getvelocity()
					local vel = 3
--        	      v.y = (self.jump_speed or 3)
					v.y = vel
					self.object:setvelocity(v)
				end
			end

			-- forwards/backwards
			if ctrl.up then
				self.speed = self.speed + self.forward_boost
			elseif ctrl.down then
				if self.speed >= -2.9 then
					self.speed = self.speed - self.forward_boost
				end
			elseif self.speed < 3 then
				--decay speed if not going fast
				self.speed = self.speed * 0.85
			end
        else
            if math.abs(self.speed) < 1 then
                self.speed = 0
            else
                self.speed = self.speed * 0.90
            end
        end

        if math.abs(self.speed) < 1 then
            self.object:setvelocity({x=0,y=0,z=0})
            self:set_animation(self.animation.mode_stand)
        elseif self.speed > 5 then
			self:set_animation(self.animation.mode_gallop)
		else
			self:set_animation(self.animation.mode_walk)
		end

        -- make sure we don't go past the limit
		if minetest.get_item_group(minetest.get_node(inside_block).name, "water") ~= 0 then
			if math.abs(self.speed) > self.max_speed * .2 then
				self.speed = self.max_speed*get_sign(self.speed)*.2
			end
		else
			if math.abs(self.speed) > self.max_speed then
				self.speed = self.max_speed*get_sign(self.speed)
			end
		end

        local p = self.object:getpos()
        p.y = p.y+1
        if not is_ground(p) then
            if minetest.registered_nodes[minetest.get_node(p).name].walkable then
                self.speed = 0
            end
            self.object:setacceleration({x=0, y=-10, z=0})
            self.object:setvelocity(get_velocity(self.speed, self.object:getyaw(), self.object:getvelocity().y))
        else
            self.object:setacceleration({x=0, y=0, z=0})
            -- falling
            if math.abs(self.object:getvelocity().y) < 1 then
                local pos = self.object:getpos()
                pos.y = math.floor(pos.y)+0.5
                self.object:setpos(pos)
                self.object:setvelocity(get_velocity(self.speed, self.object:getyaw(), 0))
            else
                self.object:setvelocity(get_velocity(self.speed, self.object:getyaw(), self.object:getvelocity().y))
            end
        end

        if self.object:getvelocity().y > 0.1 then
            local yaw = self.object:getyaw()
            if self.drawtype == "side" then
                yaw = yaw+(math.pi/2)
            end
            local x = math.sin(yaw) * -2
            local z = math.cos(yaw) * 2
            if minetest.get_item_group(minetest.get_node(inside_block).name, "water") ~= 0 then
                self.object:setacceleration({x = x, y = .1, z = z})
            else
                self.object:setacceleration({x = x, y = -10, z = z})
            end
        else
            if minetest.get_item_group(minetest.get_node(inside_block).name, "water") ~= 0 then
                self.object:setacceleration({x = 0, y = .1, z = 0})
            else
                self.object:setacceleration({x = 0, y = -10, z = 0})
            end
        end

    end

    function horse:on_rightclick(clicker)
        if not clicker or not clicker:is_player() then
            return
        end
        if self.driver and clicker == self.driver then
            self.driver = nil
            clicker:set_detach()
			clicker:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
        elseif not self.driver then
            self.driver = clicker
            clicker:set_attach(self.object, "", {x=0,y=18,z=0}, {x=0,y=90,z=0})
			clicker:set_eye_offset({x=0, y=8, z=0}, {x=0, y=0, z=0})
            --self.object:setyaw(clicker:get_look_yaw())
        end
    end

    function horse:on_activate(staticdata, dtime_s)
        self.object:set_armor_groups({fleshy=100})
        if staticdata then
            self.speed = tonumber(staticdata)
        end
    end

    function horse:get_staticdata()
        return tostring(self.speed)
    end

    function horse:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if self.driver then
		if self.object:get_hp() <= 5 then
            self.driver:set_detach()
			self.driver:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			self.driver = nil
			end
		end
    end

    minetest.register_entity(name, horse)
end

local function register_tamehorse (basename, description)
register_basehorse("whinny:horse"..basename.."h1", {
    description = description,
    inventory_image = "whinny_horse"..basename.."_inventory.png",},{
    physical = true,
    collisionbox = {-.5, -0.01, -.5, .5, 1.4, .5},
    visual = "mesh",
    stepheight = 1.1,
    visual_size = {x=1,y=1},
    mesh = "horse.x",
    textures = {"whinny_horse"..basename..".png"},
    animation = {
        speed_normal = 20,
        stand_start = 300,
        stand_end = 460,
        walk_start = 10,
        walk_end = 59,
		gallop_start = 70,
        gallop_end = 119,
		mode_stand = 1,
		mode_walk = 2,
		mode_gallop = 3,
    },
	animation_current = 0,
    max_speed = 7,
    forward_boost = .2,
    jump_boost = 4,
	speed = 0,
	driver = nil
})
end

register_tamehorse ("", "Brown Horse")
register_wildhorse ("")
register_tamehorse ("peg", "White Horse")
register_wildhorse ("peg")
register_tamehorse ("ara", "Black Horse")
register_wildhorse ("ara")

--function whinny:register_spawn(name, nodes, max_light, min_light, chance, active_object_count, max_height, spawn_func)

whinny:register_spawn("whinny:horse","default:dirt_with_grass",20, 6, 50000, 1, 100)
whinny:register_spawn("whinny:horsepeg","default:dirt_with_dry_grass",20, 6, 50000, 1, 100)
whinny:register_spawn("whinny:horseara","default:dirt_with_grass",20, 6, 50000, 1, 100)
