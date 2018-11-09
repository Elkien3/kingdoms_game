factions.sieges = {}

local function format_pos(pos) 
    return "(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"
end

local function siege_banner_onplace_check(player, pointed_thing, attacking_player, attacking_faction, pointedpos, parcelpos, defending_faction) 
    if attacking_player == nil then            
        minetest.chat_send_player(player:get_player_name(), "You don't belong to a faction")
        return false
    end

    if not pointed_thing.type == "node" then
        minetest.chat_send_player(player:get_player_name(), "Point a node to place a Siege Banner")
        return false
    end

    if attacking_faction == nil then
        minetest.chat_send_player(player:get_player_name(), "You don't belong to a faction")
        return false
    end

    if pointedpos.y <= config.protection_max_depth then 
        minetest.chat_send_player(player:get_player_name(), "You can't place a Siege Banner that deep")
        return false
    end

    if defending_faction == nil then
        minetest.chat_send_player(player:get_player_name(), "This parcel doesn't belong to a faction")
        return false
    end

    if defending_faction == attacking_faction then
        minetest.chat_send_player(player:get_player_name(), "This parcel belongs to your own faction")
        return false
    end

    if attacking_faction.power < config.power_per_parcel then
        minetest.chat_send_player(player:get_player_name(), "Your faction doesn't have enough power to siege")
        return false
    end

    local is_defending_faction_online = false

    for i, _player in pairs(minetest.get_connected_players()) do
        local playername = _player:get_player_name()

        if factions.get_player_faction(playername) == defending_faction then
            is_defending_faction_online = true
            break
        end
    end

    if not is_defending_faction_online then
        minetest.chat_send_player(player:get_player_name(), "There are no players from the defending faction online")
        return false
    end

    return true
end

minetest.register_craftitem("factions:siege_banner", {
    description = "Siege Banner",
    inventory_image = "siege_banner.png",
    stack_max = 1,
    groups = {banner = 1},
    
    on_place = function(itemstack, player, pointed_thing)        
        local attacking_player = factions.players[player:get_player_name()]
        local attacking_faction = factions.factions[attacking_player]
        local pointedpos = pointed_thing.above
        local parcelpos = factions.get_parcel_pos(pointedpos)
        local defending_faction = factions.get_parcel_faction(parcelpos)

        if not siege_banner_onplace_check(player, pointed_thing, attacking_player, attacking_faction, pointedpos, parcelpos, defending_faction) then
            return nil
        end

        minetest.chat_send_player(player:get_player_name(), "Sieging parcel at " .. format_pos(pointed_thing.above))
        
        local defending_faction = factions.get_faction_at(pointed_thing.above)

        defending_faction:broadcast(player:get_player_name() .. " is sieging your parcel at " .. format_pos(pointed_thing.above))

        minetest.set_node(pointed_thing.above, {
            name = "factions:siege_banner_1"
        })

        local meta = minetest.get_meta(pointed_thing.above)

        meta:set_string("attacking_faction", attacking_faction.name)
        meta:set_string("defending_faction", defending_faction.name)
            
        minetest.get_meta(pointed_thing.above):set_string("infotext", "Siege Banner 1/4 (" .. attacking_faction.name .. " vs " .. defending_faction.name .. ")")

        return "" 
    end
})

local siege_banner_stages = 4

for i = 1, siege_banner_stages do
    minetest.register_node("factions:siege_banner_" .. i, {
        drawtype = "normal",
        tiles = {"siege_banner.png"},
        description = "Siege Banner (" .. i .. "/" .. siege_banner_stages .. ")",
        groups = {cracky=3},
        diggable = true,
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "",
    })
end

for j = 1, siege_banner_stages - 1 do
    minetest.register_abm({
        label = "Siege Banner state change (" .. j .. ")",
        nodenames = {"factions:siege_banner_" .. j},
        
        interval = config.siege_banner_interval,
        chance = 1,
        action = function(pos, node, active_object_count, active_object_count_wider)
            local meta = minetest.get_meta(pos)
            local att_fac_name = meta:get_string("attacking_faction")
            local def_fac_name = meta:get_string("defending_faction")

            minetest.set_node(pos, { name = "factions:siege_banner_" .. j + 1 })
            minetest.get_meta(pos):set_string("infotext", "Siege Banner " .. j + 1 .. "/" .. siege_banner_stages .. " (" .. att_fac_name .. " vs " .. def_fac_name .. ")")
        
            meta:set_string("attacking_faction", att_fac_name)
            meta:set_string("defending_faction", def_fac_name)
        end
    })
end

minetest.register_abm({
    label = "Siege Banner state change (4)",
    nodenames = {"factions:siege_banner_4"},
    
    interval = config.siege_banner_interval,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local meta = minetest.get_meta(pos)

        local att_fac_name = meta:get_string("attacking_faction")
        local def_fac_name = meta:get_string("defending_faction")

        local attacking_faction = factions.get_faction(att_fac_name)
        local defending_faction = factions.get_faction(def_fac_name)

        local parcelpos = factions.get_parcel_pos(pos)

        defending_faction:bulk_unclaim_parcel(parcelpos)
        defending_faction:decrease_usedpower(factions.power_per_parcel)
        attacking_faction:bulk_claim_parcel(parcelpos)
        attacking_faction:increase_usedpower(factions.power_per_parcel)

        defending_faction:broadcast(att_fac_name .. " has successfully conquered your parcel at " .. format_pos(pos))
        attacking_faction:broadcast("Successfully conquered parcel at " .. format_pos(pos) .. " !")

        minetest.set_node(pos, { name = "bones:bones" })
    end
})

if minetest.get_modpath("default") and minetest.get_modpath("bones") then
	minetest.register_craft({
		output = 'factions:siege_banner',
		recipe = {
			{'default:diamond','default:diamond','default:diamond'},
			{'default:diamond','bones:bones','default:diamond'},
			{'default:diamond','default:diamond','default:diamond'}
		}
	})
end


