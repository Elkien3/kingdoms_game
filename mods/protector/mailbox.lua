minetest.register_craft({
  output ="protector:mailbox 4",
  recipe = {
    {"","default:steel_ingot",""},
    {"default:steel_ingot","","default:steel_ingot"},
    {"default:steel_ingot","default:steel_ingot","default:steel_ingot"}
  }
})

minetest.register_node("protector:mailbox", {
	description = "Mailbox",
          drawtype = "nodebox",
  node_box = { 
    type = "fixed",
    fixed = {
      {-4/12, -6/12, -6/12, 4/12, 0/12, 6/12},
      {-3/12, 0/12, -6/12, 3/12, 2/12, 6/12},
      {3/12, 0/12, -4/12, 4/12, 5/12, -2/12},
      {3/12, 3/12, -2/12, 4/12, 5/12, 0/12}
    }
  },
  paramtype = "light",
  tiles = {"inbox_top.png", "inbox_bottom.png", "inbox_east.png",
    "inbox_west.png", "inbox_back.png", "inbox_front.png"},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, unbreakable = 1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		meta:set_string("infotext", "Mailbox")
		meta:set_string("name", "")
		inv:set_size("main", 4 * 4)
	end,

	can_dig = function(pos,player)

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if inv:is_empty("main") then

			if not minetest.is_protected(pos, player:get_player_name()) then
				return true
			end
		end
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)

		minetest.log("action", player:get_player_name()
		.. " moves stuff to mailbox at "
		.. minetest.pos_to_string(pos))
	end,

	on_metadata_inventory_take = function(pos, listname, index, stack, player)

		minetest.log("action", player:get_player_name()
		.. " takes stuff from mailbox at "
		.. minetest.pos_to_string(pos))
	end,
        
        allow_metadata_inventory_take = function(pos, listname, index, stack, player)
            if minetest.is_protected(pos, player:get_player_name()) then
                return 0
            else return stack:get_count()
            end
        end,
        
	on_rightclick = function(pos, node, clicker)

		--if minetest.is_protected(pos, clicker:get_player_name()) then
		--	return
		--end

		local meta = minetest.get_meta(pos)

		if not meta then
			return
		end

		local spos = pos.x .. "," .. pos.y .. "," ..pos.z
		local formspec = "size[8,9]"
			.. default.gui_bg
			.. default.gui_bg_img
			.. default.gui_slots
			.. "list[nodemeta:".. spos .. ";main;0,0.3;8,4;]"
			--.. "button[0,4.5;2,0.25;toup;To Chest]"
			--.. "field[2.3,4.8;4,0.25;chestname;;"
			.. meta:get_string("name") .. "]"
			--.. "button[6,4.5;2,0.25;todn;To Inventory]"
			.. "list[current_player;main;0,5;8,1;]"
			.. "list[current_player;main;0,6.08;8,3;8]"
			.. "listring[nodemeta:" .. spos .. ";main]"
			.. "listring[current_player;main]"

			minetest.show_formspec(
				clicker:get_player_name(),
				"protector:chest_" .. minetest.pos_to_string(pos),
				formspec)
	end,

	on_blast = function() end,
})