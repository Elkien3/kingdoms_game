minetest.register_chatcommand("msg", {
	func = function(name, param)
		minetest.chat_send_player(name, "/msg is disabled!!")
	end
})
--[[
minetest.register_chatcommand("me", {
	func = function(name, param)
		minetest.chat_send_player(name, "/me is disabled!!")
	end
})--]]