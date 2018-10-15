minetest.register_on_newplayer(function(player)
	--print("on_newplayer")
	if minetest.setting_getbool("give_initial_stuff") then
		minetest.log("action", "Giving initial stuff to player "..player:get_player_name())
            player:get_inventory():add_item('main', 'default:pick_stone')
			player:get_inventory():add_item('main', 'xdecor:crafting_guide')
            player:get_inventory():add_item('main', 'default:torch')
            player:get_inventory():add_item('main', 'farming:bread 6')
            player:get_inventory():add_item('main', 'default:sapling 4')
            player:get_inventory():add_item('main', 'default:papyrus 8')
			player:get_inventory():add_item('main', 'wiki:wiki')
			player:setpos({x=0,y=0,z=0})
	end
end)