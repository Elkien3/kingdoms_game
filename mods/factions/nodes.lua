function factions.get_chest_formspec(pos)
    local spos = pos.x..","..pos.y..","..pos.z
    return "size[8,9]" ..
           default.gui_bg ..
           default.gui_bg_img ..
           default.gui_slots ..
           "list[nodemeta:"..spos..";main;0,0.3;8,4;]" ..
           "list[current_player;main;0,4.85;8,1;]"..
           "list[current_player;main;0,6.08;8,3;8]"..
           "listring[nodemeta:"..spos..";main]"..
           "listring[current_player;main]"..
           default.get_hotbar_bg(0, 4.85)
end

function factions.can_use_chest(pos, player)
    if not player then
        return false
    end
    local parcel_faction = factions.get_faction_at(pos)
    local player_faction = factions.get_player_faction(player)
    if not parcel_faction then
        return true
    end
    return player_faction and (parcel_faction.name == player_faction.name)
end
--[[
minetest.register_node("factions:chest", {
    tiles = {"factions_chest_top.png", "factions_chest_top.png",
             "factions_chest_side.png", "factions_chest_side.png",
             "factions_chest_side.png", "factions_chest_front.png"},
    groups = {choppy = 2},
    description = "Faction chest",
    paramtype2 = "facedir",
    on_construct = function(pos)
        minetest.get_meta(pos):get_inventory():set_size("main", 8*4)
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        if factions.can_use_chest(pos, player:get_player_name()) then
            return count
        else
            return 0
        end
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if factions.can_use_chest(pos, player:get_player_name()) then
            return stack:get_count()
        else
            return 0
        end
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        if factions.can_use_chest(pos, player:get_player_name()) then
            return stack:get_count()
        else
            return 0
        end
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if factions.can_use_chest(pos, clicker:get_player_name()) then
            minetest.show_formspec(clicker:get_player_name(), "factions:chest", factions.get_chest_formspec(pos))
        end
        return itemstack
    end
})

minetest.register_craft({
    output = "factions:chest",
    type = "shapeless",
    recipe = {"default:chest_locked", "default:steel_ingot"}
})
--]]
