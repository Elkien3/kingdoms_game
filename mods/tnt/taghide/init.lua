minetest.register_on_joinplayer(function(player)
    if not player.tag then
			player:set_nametag_attributes({
				color = {a = 0, r = 0, g = 0, b = 0}
			})
    end
end)

minetest.register_globalstep(function(dtime)
for _, player in ipairs(minetest.get_connected_players()) do
    if not player.tag then
    			player:set_nametag_attributes({
				color = {a = 0, r = 0, g = 0, b = 0}
			})
    end
end
end)