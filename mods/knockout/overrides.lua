-- No, you don't get to kill yourself
local oldKill = minetest.registered_chatcommands["killme"].func
minetest.override_chatcommand("killme", {
	func = function(name, param)
		if knockout.knocked_out[name] == nil then
			return oldKill(name, param)
		else
			return false, "You can't kill yourself!"
		end
	end
})
