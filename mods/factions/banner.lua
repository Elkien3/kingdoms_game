-- nodes
minetest.register_node("factions:power_banner", {
    drawtype = "normal",
    tiles = {"power_banner.png"},
    description = "Power Banner",
    groups = {cracky=3},
    diggable = true,
    stack_max = 1,
    paramtype = "light",
    paramtype2 = "facedir",
    after_place_node = function (pos, player, itemstack, pointed_thing)
        after_powerbanner_placed(pos, player, itemstack, pointed_thing)
      end,
    on_dig = function(pos, n, p)
        if minetest.is_protected(pos, p:get_player_name()) then
            return
        end
        local meta = minetest.get_meta(pos)
        local facname = meta:get_string("faction")
        if facname then
            local faction = factions.factions[facname]
            if faction then
                faction:decrease_maxpower(config.power_per_banner)
            end
        end
		minetest.node_dig(pos, n, p)
    end,
})

minetest.register_node("factions:death_banner", {
    drawtype = "normal",
    tiles = {"death_banner.png"},
    description = "Death Banner",
    groups = {cracky=3},
    diggable = true,
    stack_max = 1,
    paramtype = "light",
    paramtype2 = "facedir",
    after_place_node = function (pos, player, itemstack, pointed_thing)
        after_deathbanner_placed(pos, player, itemstack, pointed_thing)
      end,
    on_dig = function(pos, n, p)
        if minetest.is_protected(pos, p:get_player_name()) then
            return
        end
        local meta = minetest.get_meta(pos)
        local defending_facname = meta:get_string("faction")
        local parcelpos = factions.get_parcel_pos(pos)
        if defending_facname then
            local faction = factions.factions[defending_facname]
            if faction then
                faction:stop_attack(parcelpos)	
            end
        end
        minetest.remove_node(pos)
    end,
})

after_powerbanner_placed = function(pos, player, itemstack, pointed_thing)
    --minetest.get_node(pos).param2 = determine_flag_direction(pos, pointed_thing)
    local faction = factions.players[player:get_player_name()]
    if not faction then
        minetest.get_meta(pos):set_string("banner", "bg_white.png")
    else
        local banner_string = "bg_white.png"--factions[faction].banner
        minetest.get_meta(pos):set_string("banner", banner_string)
        minetest.get_meta(pos):set_string("faction", faction)
        factions.factions[faction]:increase_maxpower(config.power_per_banner)
    end
end

after_deathbanner_placed = function(pos, player, itemstack, pointed_thing)
   -- minetest.get_node(pos).param2 = determine_flag_direction(pos, pointed_thing)
    local attacking_faction = factions.players[player:get_player_name()]
    if attacking_faction ~= nil then
        local parcelpos = factions.get_parcel_pos(pos)
        attacking_faction = factions.factions[attacking_faction]
        attacking_faction:attack_parcel(parcelpos)
        minetest.get_meta(pos):set_string("faction", attacking_faction.name)
    end
    minetest.get_meta(pos):set_string("banner", "death_uv.png")
end

if minetest.get_modpath("default") then
	minetest.register_craft({
		output = 'factions:power_banner',
		recipe = {
			{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
			{'default:mese_crystal','default:goldblock','default:mese_crystal'},
			{'default:mese_crystal','default:mese_crystal','default:mese_crystal'}
		}
	})
end

if minetest.get_modpath("default") and minetest.get_modpath("bones") then
	minetest.register_craft({
		output = 'factions:death_banner',
		recipe = {
			{'default:obsidian','default:obsidian','default:obsidian'},
			{'default:obsidian','bones:bones','default:obsidian'},
			{'default:obsidian','default:obsidian','default:obsidian'}
		}
	})
end