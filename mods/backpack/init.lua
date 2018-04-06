--- backpack Minetest mod
 --
 -- @author prestidigitator
 -- @copyright 2013, licensed under WTFPL


---- Configuration

--- Width and height of bag inventory (>0)
local BAG_WIDTH = 4
local BAG_HEIGHT = 3
player_backpack = {}

--- Sound played when placing/dropping a bag on the ground
local DROP_BAG_SOUND = "prestibags_drop_bag"
local DROP_BAG_SOUND_GAIN = 1.0
local DROP_BAG_SOUND_DIST = 5.0

--- Sound played when opening a bag's inventory
local OPEN_BAG_SOUND = "prestibags_rustle_bag"
local OPEN_BAG_SOUND_GAIN = 1.0
local OPEN_BAG_SOUND_DIST = 5.0

--- HP of undamaged bag (integer >0).
local BAG_MAX_HP = 4

--- How often the inventories of destroyed bags are checked and cleaned up
 -- (>0.0).
local CLEANUP_PERIOD__S = 10.0

--- How often environmental effects like burning are checked (>0.0).
local ENV_CHECK_PERIOD__S = 0.5

--- Max distance an igniter node can be and still ignite/burn the bag (>=1).
local MAX_IGNITE_DIST = 4.0

--- Probability (0.0 <= p <= 1.0) bag will be damaged for each igniter touching
 --    it (increases if igniter's max range is greater than current distance).
 --    Always damaged if in lava.
local BURN_DAMAGE_PROB = 0.25

--- Probability (0.0 <= p <= 1.0) bag will ignite and spawn some flames on or
 --    touching it for each igniter within igniter range (increases if
 --    igniter's max range is greater than current distance).  Alawys ignites
 --    if in lava.  Ignition is ignored if "fire:basic_flame" is not available.
local IGNITE_PROB = 0.25

--- Amount of damage bag takes each time it is burned.  Note that a bag can be
 --    burned at most once each update cycle, so this is the MAXIMUM damage
 --    taken by burning each ENV_CHECK_PERIOD__S period.
local BURN_DAMAGE__HP = 1

---- end of configuration

local EPSILON = 0.001  -- "close enough"


local function serializeContents(contents)
   if not contents then return "" end

   local tabs = {}
   for i, stack in ipairs(contents) do
      tabs[i] = stack and stack:to_table() or ""
   end

   return minetest.serialize(tabs)
end

local function deserializeContents(data)
   if not data or data == "" then return nil end
   local tabs = minetest.deserialize(data)
   if not tabs or type(tabs) ~= "table" then return nil end

   local contents = {}
   for i, tab in ipairs(tabs) do
      contents[i] = ItemStack(tab)
   end

   return contents
end


-- weak references to keep track of what detached inventory lists to remove
local idSet = {}
local idToWeakEntityMap = {}

setmetatable(idToWeakEntityMap, { __mode = "v" })

local entityInv
local function cleanInventory()
   for id, dummy in pairs(idSet) do
      if not idToWeakEntityMap[id] then
         entityInv:set_size(id, 0)
         idSet[id] = nil
      end
   end
   minetest.after(CLEANUP_PERIOD__S, cleanInventory)
end
minetest.after(CLEANUP_PERIOD__S, cleanInventory)

dropbackpack = function(player)
	local player = player
		local name = player:get_player_name()
		if player_backpack[name] then
		local pos = player:getpos()
		local pack = player_backpack[name]
		local obj = pack.object
		pos.y = pos.y + 0.4
		pack.owner = nil
		obj:set_detach()
		local addnewentity = rezEntity(nil, pos, player, pack.contents)
		if obj:remove() then
			addnewentity()
		end
		player_backpack[name] = nil
	end
end

minetest.register_on_leaveplayer(function(player)
	dropbackpack(player)
end)
minetest.register_on_joinplayer(function(player)
	inventory_plus.register_button(player,"backpack", "Backpack")
end)
minetest.register_on_dieplayer(function(player)
	dropbackpack(player)
end)
minetest.register_on_player_receive_fields(function(player, formname, fields)
if fields.backpack then
		dropbackpack(player)
	end
end)

entityInv = minetest.create_detached_inventory(
   "backpack:bags",
   {
      allow_move = function(inv,
                            fromList, fromIndex,
                            toList, toIndex,
                            count,
                            player)
         return idToWeakEntityMap[fromList] and idToWeakEntityMap[toList]
                   and count
                   or 0
      end,

      allow_put = function(inv, toList, toIndex, stack, player)
         return idToWeakEntityMap[toList] and stack:get_count() or 0
      end,

      allow_take = function(inv, fromList, fromIndex, stack, player)
         return idToWeakEntityMap[fromList] and stack:get_count() or 0
      end,

      on_move = function(inv,
                         fromList, fromIndex,
                         toList, toIndex,
                         count,
                         player)
         local fromEntity = idToWeakEntityMap[fromList]
         local toEntity = idToWeakEntityMap[toList]
         local fromStack = fromEntity.contents[fromIndex]
         local toStack = toEntity.contents[toIndex]

         local moved = fromStack:take_item(count)
         toStack:add_item(moved)
      end,

      on_put = function(inv, toList, toIndex, stack, player)
         local toEntity = idToWeakEntityMap[toList]
         local toStack = toEntity.contents[toIndex]

         toStack:add_item(stack)
      end,

      on_take = function(inv, fromList, fromIndex, stack, player)
         local fromEntity = idToWeakEntityMap[fromList]
         local fromStack = fromEntity.contents[fromIndex]

         fromStack:take_item(stack:get_count())
      end
   })
local function bag_envUpdate(self, dt)
end
minetest.register_entity(
   "backpack:bag_entity",
   {
      initial_properties =
         {
            hp_max = BAG_MAX_HP,
            physical = false,
            collisionbox = { -0.2, -0.3, -0.2, 0.2, 0.3, 0.2 },--collisionbox = { -0.44, -0.5, -0.425, 0.44, 0.35, 0.425 },
            visual = "mesh",
            visual_size = { x = 1, y = 1 },
            mesh = "backpack.obj",
            textures = { "backpack.png" }
         },

      on_activate = function(self, staticData, dt)
         local id
         repeat
            id = "bag"..(math.random(0, 2^15-1)*2^15 + math.random(0, 2^15-1))
         until not idSet[id]
         idSet[id] = id
         idToWeakEntityMap[id] = self

         self.id = id

         self.object:set_armor_groups({ punch_operable = 1, immortal = 1 })

         local contents = deserializeContents(staticData)
         if not contents then
            contents = {}
            for i = 1, BAG_WIDTH*BAG_HEIGHT do
               contents[#contents+1] = ItemStack(nil)
            end
         end
         self.contents = contents

         self.timer = ENV_CHECK_PERIOD__S
      end,

      get_staticdata = function(self)
         return serializeContents(self.contents)
      end,

    on_punch = function(self, puncher, timeSinceLastPunch, toolCaps, dir)
	  	local name = puncher:get_player_name()
		if puncher:get_player_control().sneak then
			if entityInv:is_empty(self.id) then
				local playerInv = puncher:get_inventory()
				if not name or not playerInv then return end
				local contentData = serializeContents(self.contents)
				local hp = self.object:get_hp()
				local newItem =
					ItemStack({ name = "backpack:backpack",
							metadata = contentData,
							wear = (2^16) * (BAG_MAX_HP - hp) / BAG_MAX_HP })
				if not playerInv:room_for_item("main", newItem) then return end
				self.object:remove()
				playerInv:add_item("main", newItem)
			end
		end--[[else
			if player_backpack[name] == nil then
				self.object:set_attach(puncher, "", {x=0,y=0,z=-2.5}, {x=0,y=0,z=0})
				self.object:setpos(puncher:getpos())
				player_backpack[name] = self
				self.owner = puncher
			end
		end--]]
	end,


      on_rightclick = function(self, player)
         local invLoc = "detached:"..self.id
         local w = math.max(8, 2 + BAG_WIDTH)
         local h = math.max(5 + BAG_HEIGHT)
         local yImg = math.floor(BAG_HEIGHT/2)
         local yPlay = BAG_HEIGHT + 1

         if not self.contents or #self.contents <= 0 then return end

         entityInv:set_size(self.id, #self.contents)
         for i, stack in ipairs(self.contents) do
            entityInv:set_stack(self.id, i, stack)
         end

         local formspec =
            "size["..w..","..h.."]"..
            "image[1,"..yImg..";1,1;inventory_plus_backpack.png]"..
            "list[detached:backpack:bags;"..self.id..";2,0;"..
                  BAG_WIDTH..","..BAG_HEIGHT..";]"..
            "list[current_player;main;0,"..yPlay..";8,4;]"

         minetest.show_formspec(
            player:get_player_name(), "backpack:backpack", formspec)

         minetest.sound_play(
            OPEN_BAG_SOUND,
            {
               object = self.object,
               gain = OPEN_BAG_SOUND_GAIN,
               max_hear_distance = OPEN_BAG_SOUND_DIST,
               loop = false
            })
      end,
		--[[on_step = function(self, dt)
			if self.owner then
				self.object:setpos(self.owner:getpos())
			end
		end--]]
      --[[on_step = function(self, dt)
         self.timer = self.timer - dt
         if self.timer > 0.0 then return end
         self.timer = ENV_CHECK_PERIOD__S

         local haveFlame = minetest.registered_nodes["fire:basic_flame"]
         local pos = self.object:getpos()
         local node = minetest.env:get_node(pos)
         local nodeType = node and minetest.registered_nodes[node.name]

         if nodeType and nodeType.walkable and not nodeType.buildable_to then
            --return self:remove()
         end

         if minetest.get_item_group(node.name, "lava") > 0 then
            if haveFlame then
               local flamePos = minetest.env:find_node_near(pos, 1.0, "air")
               if flamePos then
                  minetest.env:add_node(flamePos,
                                        { name = "fire:basic_flame" })
               end
            end
            return self:burn()
         end

         if minetest.env:find_node_near(pos, 1.0, "group:puts_out_fire") then
            return
         end

         local minPos = { x = pos.x - MAX_IGNITE_DIST,
                          y = pos.y - MAX_IGNITE_DIST,
                          z = pos.z - MAX_IGNITE_DIST }
         local maxPos = { x = pos.x + MAX_IGNITE_DIST,
                          y = pos.y + MAX_IGNITE_DIST,
                          z = pos.z + MAX_IGNITE_DIST }
         local wasIgnited = false
         local burnLevels = 0.0

         local igniterPosList =
            minetest.env:find_nodes_in_area(minPos, maxPos, "group:igniter")
         for i, igniterPos in ipairs(igniterPosList) do
            local distSq = (igniterPos.x - pos.x)^2 +
                           (igniterPos.y - pos.y)^2 +
                           (igniterPos.z - pos.z)^2
            if distSq <= MAX_IGNITE_DIST^2 + EPSILON then
               local igniterNode = minetest.env:get_node(igniterPos)
               local igniterLevel =
                  minetest.get_item_group(igniterNode.name, "igniter")
                     - math.max(1.0, math.sqrt(distSq) - EPSILON)

               if igniterLevel >= 0.0 then
                  if distSq <= 1.0 then
                     wasIgnited = true
                  end
                  burnLevels = burnLevels + 1.0 + igniterLevel
               end
            end
         end

         if burnLevels >= 1.0 then
            if haveFlame and (not wasIgnited) and
               math.random() >= (1.0 - IGNITE_PROB)^burnLevels
            then
               local flamePos =
                  (node.name == "air")
                     and pos
                     or minetest.env:find_node_near(pos, 1.0, "air")
               if flamePos then
                  minetest.env:add_node(flamePos,
                                        { name = "fire:basic_flame" })
               end
            end

            if math.random() >= (1.0 - BURN_DAMAGE_PROB)^burnLevels then
               self:burn()
            end
         end
      end,

      remove = function(self)
         entityInv:set_size(self.id, 0)
         idSet[self.id] = nil
         self.object:remove()
      end,

      burn = function(self)
         local hp = self.object:get_hp() - BURN_DAMAGE__HP
         self.object:set_hp(hp)
         print("DEBUG - bag HP = "..hp)
         if hp <= 0 then
            return self:remove()
         end
      end--]]
   })

function rezEntity(stack, pos, player, contents)
   local x = pos.x
   local y = math.floor(pos.y)
   local z = pos.z

   while true do
      local node = minetest.env:get_node({ x = x, y = y-1, z = z})
      local nodeType = node and minetest.registered_nodes[node.name]
      if not nodeType or nodeType.walkable then
         break
      end
      y = y - 1
   end

   local obj = minetest.env:add_entity(pos, "backpack:bag_entity")
   if not obj then return stack end
   if stack then
		local contentData = stack:get_metadata()
		contents = deserializeContents(contentData)
		obj:set_hp(BAG_MAX_HP - BAG_MAX_HP * stack:get_wear() / 2^16)
	end
	if contents then
		obj:get_luaentity().contents = contents
	end
	obj:set_hp(4)
	
   minetest.sound_play(
      DROP_BAG_SOUND,
      {
         object = obj,
         gain = DROP_BAG_SOUND_GAIN,
         max_hear_distance = DROP_BAG_SOUND_DIST,
         loop = false
      })

   return ItemStack(nil)
end

-- DEBUG minetest.register_craftitem(
minetest.register_tool(
   "backpack:backpack",
   {
      description = "Backpack (WORK IN PROGRESS, USE AT YOUR OWN RISK)",
      groups = { bag = BAG_WIDTH*BAG_HEIGHT, flammable = 1 },
      inventory_image = "inventory_plus_backpack.png",
      wield_image = "inventory_plus_backpack.png",
      stack_max = 1,

      --[[on_place = function(stack, player, pointedThing)
         local pos = pointedThing and pointedThing.under
         local node = pos and minetest.env:get_node(pos)
         local nodeType = node and minetest.registered_nodes[node.name]
         if not nodeType or not nodeType.buildable_to then
            pos = pointedThing and pointedThing.above
            node = pos and minetest.env:get_node(pos)
            nodeType = node and minetest.registered_nodes[node.name]
         end
         if not pos then pos = player:getpos() end

         return rezEntity(stack, pos, player)
      end,

      on_drop = function(stack, player, pos)
         return rezEntity(stack, pos, player)
      end--]]

      -- Eventually add on_use(stack, player, pointedThing) which actually
      --    opens the bag from player inventory; trick is, has to track whether
      --    bag is still in inventory OR replace "player inventory" with a
      --    detached proxy that doesn't allow the bag's stack to be changed
      --    while open!
   })
minetest.register_craft(
   {
      output = "backpack:backpack",
      recipe =
         {
            { "",           "group:wool", "" },
            { "group:wool", "",           "group:wool" },
            { "group:wool", "group:wool", "group:wool" },
         }
   })