-------------------------------------------------------------------------------
-- factions Mod by Sapier
--
-- License WTFPL
--
--! @file chatcommnd.lua
--! @brief factions chat interface
--! @copyright Sapier, agrecascino, shamoanjac, Coder12a 
--! @author Sapier, agrecascino, shamoanjac, Coder12a 
--! @date 2016-08-12
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

local send_error = function(player, message)
    minetest.chat_send_player(player, message)
end

factions_chat = {}

factions.commands = {}

factions.register_command = function(cmd_name, cmd, ignore_param_count)
    factions.commands[cmd_name] = { -- default command
        name = cmd_name,
        faction_permissions = {},
        global_privileges = {},
        format = {},
        infaction = true,
        description = "This command has no description.",
        run = function(self, player, argv)
            --if self.global_privileges then
            --    local tmp = {}
            --    for i in ipairs(self.global_privileges) do
            --        tmp[self.global_privileges[i]] = true
            --    end
            --    local bool, missing_privs = minetest.check_player_privs(player, tmp)
            --    if not bool then
            --        send_error(player, "Unauthorized.")
            --        return false
            --    end
            --end
            -- checks argument formats
            local args = {
                factions = {},
                players = {},
                strings = {},
                other = {}
            }
			if not ignore_param_count then
				if #argv < #(self.format) then
					send_error(player, "Not enough parameters.")
					return false
				end
				else
				if self.format[1] then
					local fm = self.format[1]
					for i in ipairs(argv) do
						if #argv > #(self.format) then
							table.insert(self.format, fm)
						else
							break
						end
					end
				end
			end
			
            for i in ipairs(self.format) do
                local argtype = self.format[i]
                local arg = argv[i]
                if argtype == "faction" then
                    local fac = factions.get_faction(arg)
                    if not fac then
                        send_error(player, "Specified faction "..arg.." does not exist")
                        return false
                    else
                        table.insert(args.factions, fac)
                    end
                elseif argtype == "player" then
                    local pl = arg--minetest.get_player_by_name(arg)
                    if not pl and not factions.players[arg] then
                        send_error(player, "Player is not online.")
                        return false
                    else
                        table.insert(args.players, pl)
                    end
                elseif argtype == "string" then
                    table.insert(args.strings, arg)
                else
                    minetest.log("error", "Bad format definition for function "..self.name)
                    send_error(player, "Internal server error")
                    return false
                end
            end
            for i=2, #argv do
				if argv[i] then
					table.insert(args.other, argv[i])
				end
            end

            -- checks permissions
            local player_faction = factions.get_player_faction(player)
            if self.infaction and not player_faction then
                minetest.chat_send_player(player, "This command is only available within a faction.")
                return false
            end
            if self.faction_permissions then
                for i in ipairs(self.faction_permissions) do
                    if not player_faction:has_permission(player, self.faction_permissions[i]) then
                        send_error(player, "You don't have permissions to do that.")
                        return false
                    end
                end
            end

            -- get some more data
            local pos = minetest.get_player_by_name(player):getpos()
            local parcelpos = factions.get_parcel_pos(pos)
            return self.on_success(player, player_faction, pos, parcelpos, args)
        end,
        on_success = function(player, faction, pos, parcelpos, args)
            minetest.chat_send_player(player, "Not implemented yet!")
        end
    }
    -- override defaults
    for k, v in pairs(cmd) do
        factions.commands[cmd_name][k] = v
    end
end


local init_commands
init_commands = function()
	--[[
	minetest.register_privilege("faction_user",
		{
			description = "this user is allowed to interact with faction mod",
			give_to_singleplayer = true,
		}
	)
	
	--]]
	minetest.register_privilege("faction_admin",
		{
			description = "this user is allowed to create or delete factions",
			give_to_singleplayer = true,
		}
	)
	
	minetest.register_chatcommand("factions",
		{
			params = "<cmd> <parameter 1> .. <parameter n>",
			description = "faction administration functions",
			privs = { interact=true,}, --faction_user=true },
			func = factions_chat.cmdhandler,
		}
	)
	
	
	minetest.register_chatcommand("f",
		{
			params = "<command> parameters",
			description = "Factions commands. Type /f help for available commands.",
            privs = { interact=true,},--faction_user=true},
			func = factions_chat.cmdhandler,
		}
	)
end
	

-------------------------------------------
-- R E G I S T E R E D   C O M M A N D S  |
-------------------------------------------

factions.register_command ("claim", {
    faction_permissions = {"claim"},
    description = "Claim the plot of land you're on.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local can_claim = faction:can_claim_parcel(parcelpos)
        if can_claim then
            minetest.chat_send_player(player, "Claming parcel "..parcelpos)
            faction:claim_parcel(parcelpos)
            return true
        else
            local parcel_faction = factions.get_parcel_faction(parcelpos)
            if not parcel_faction then
                send_error(player, "You faction cannot claim any (more) parcel(s).")
                return false
            elseif parcel_faction.name == faction.name then
                send_error(player, "This parcel already belongs to your faction.")
                return false
            else
                send_error(player, "This parcel belongs to another faction.")
                return false
            end
        end
    end
},false)

factions.register_command("unclaim", {
    faction_permissions = {"claim"},
    description = "Unclaim the plot of land you're on.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local parcel_faction = factions.get_parcel_faction(parcelpos)
		if not parcel_faction then
		    send_error(player, "This parcel does not exist.")
            return false
		end
        if parcel_faction.name ~= faction.name then
            send_error(player, "This parcel does not belong to you.")
            return false
        else
            faction:unclaim_parcel(parcelpos)
            return true
        end
    end
},false)

--list all known factions
factions.register_command("list", {
    description = "List all registered factions.",
    infaction = false,
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local list = factions.get_faction_list()
        local tosend = "Existing factions:"
        
        for i,v in ipairs(list) do
            if i ~= #list then
                tosend = tosend .. " " .. v .. ","
            else
                tosend = tosend .. " " .. v
            end
        end	
        minetest.chat_send_player(player, tosend, false)
        return true
    end
},false)

--show factions mod version
factions.register_command("version", {
    description = "Displays mod version.",
    on_success = function(player, faction, pos, parcelpos, args)
        minetest.chat_send_player(player, "factions: version " .. factions_version , false)
    end
},false)

--show description  of faction
factions.register_command("info", {
    format = {"faction"},
    description = "Shows a faction's description.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        minetest.chat_send_player(player,
            "factions: " .. args.factions[1].name .. ": " ..
            args.factions[1].description, false)
        return true
    end
},false)

factions.register_command("leave", {
    description = "Leave your faction.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
		minetest.chat_send_player(player, "You have left your Faction")
        faction:remove_player(player)
        return true
    end
},false)

factions.register_command("kick", {
    faction_permissions = {"playerslist"},
    format = {"player"},
    description = "Kick a player from your faction.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local victim = args.players[1]
        local victim_faction = factions.get_player_faction(victim)
        if victim_faction and victim ~= faction.leader then -- can't kick da king
            faction:remove_player(victim)
			minetest.chat_send_player(player, "Kicked player '"..victim.."'.")
            return true
        elseif not victim_faction then
            send_error(player, victim.." is not in your faction.")
            return false
        else
            send_error(player, victim.." cannot be kicked from your faction.")
            return false
        end
    end
},false)

--create new faction
factions.register_command("create", {
    format = {"string"},
    infaction = false,
    description = "Create a new faction.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        if faction then
            send_error(player, "You are already in a faction.")
            return false
        end
        local factionname = args.strings[1]
        if factions.can_create_faction(factionname) then
            new_faction = factions.new_faction(factionname, nil)
            new_faction:add_player(player, new_faction.default_leader_rank)
			minetest.chat_send_player(player, "Created Faction.")
            return true
        else
            send_error(player, "Faction cannot be created.")
            return false
        end
    end
},false)

factions.register_command("join", {
    format = {"faction"},
    description = "Join a faction.",
    infaction = false,
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local new_faction = args.factions[1]
        if new_faction:can_join(player) then
            if faction then -- leave old faction
                faction:remove_player(player)
            end
            new_faction:add_player(player)
			minetest.chat_send_player(player, "Joined Faction.")
        else
            send_error(player, "You cannot join this faction.")
            return false
        end
        return true
    end
},false)

factions.register_command("disband", {
    faction_permissions = {"disband"},
    description = "Disband your faction.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
		minetest.chat_send_player(player, "Disbanded Faction.")
        faction:disband()
        return true
    end
},false)

factions.register_command("close", {
    faction_permissions = {"playerslist"},
    description = "Make your faction invite-only.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        faction:toggle_join_free(false)
        return true
    end
},false)

factions.register_command("open", {
    faction_permissions = {"playerslist"},
    description = "Allow any player to join your faction.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        faction:toggle_join_free(true)
        return true
    end
},false)

factions.register_command("description", {
    faction_permissions = {"description"},
    description = "Set your faction's description",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        faction:set_description(table.concat(args.other," "))
        return true
    end
},false)

factions.register_command("invite", {
    format = {"player"},
    faction_permissions = {"playerslist"},
    description = "Invite a player to your faction.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        faction:invite_player(args.players[1])
		minetest.chat_send_player(player, "Invite Sent.")
        return true
    end
},false)

factions.register_command("uninvite", {
    format = {"player"},
    faction_permissions = {"playerslist"},
    description = "Revoke a player's invite.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        faction:revoke_invite(args.players[1])
		minetest.chat_send_player(player, "Invite canceled.")
        return true
    end
},false)

factions.register_command("delete", {
    global_privileges = {"faction_admin"},
    format = {"faction"},
    infaction = false,
    description = "Delete a faction.",
    on_success = function(player, faction, pos, parcelpos, args)
		minetest.chat_send_player(player, "Deleted Faction.")
        args.factions[1]:disband()
        return true
    end
},false)

factions.register_command("ranks", {
    description = "List ranks within your faction",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        for rank, permissions in pairs(faction.ranks) do
            minetest.chat_send_player(player, rank..": "..table.concat(permissions, " "))
        end
        return true
    end
},false)

factions.register_command("who", {
    description = "List players in your faction, and their ranks.",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        if not faction.players then
            minetest.chat_send_player(player, "There is nobody in this faction ("..faction.name..")")
            return true
        end
        minetest.chat_send_player(player, "Players in faction "..faction.name..": ")
        for p, rank in pairs(faction.players) do
            minetest.chat_send_player(player, p.." ("..rank..")")
        end
        return true
    end
},false)

factions.register_command("newrank", {
    description = "Add a new rank.",
    format = {"string"},
    faction_permissions = {"ranks"},
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
		if args.strings[1] then
			local rank = args.strings[1]
			if faction.ranks[rank] then
				send_error(player, "Rank already exists")
				return false
			end
			local success = false
			local failindex = -1
			for _, f in pairs(args.strings) do
				if f then
					for q, r in pairs(factions.permissions) do
						if f == r then
							success = true
							break
						end
					end
					if not success and _ ~= 1 then
						failindex = _
						break
					end
				end
			end
			if not success then
				if args.strings[failindex] then
					send_error(player, "Permission " .. args.strings[failindex] .. " is invalid.")
					else
					send_error(player, "No permission was given.")
				end
				return false
			end
			faction:add_rank(rank, args.other)
			return true
		end
		send_error(player, "No rank was given.")
		return false
    end
},true)

factions.register_command("delrank", {
    description = "Replace and delete a rank.",
    format = {"string", "string"},
    faction_permissions = {"ranks"},
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local rank = args.strings[1]
        local newrank = args.strings[2]
        if not faction.ranks[rank] or not faction.ranks[newrank] then
            send_error(player, "One of the specified ranks do not exist.")
            return false
        end
        faction:delete_rank(rank, newrank)
        return true
    end
},false)

factions.register_command("setspawn", {
    description = "Set the faction's spawn",
    faction_permissions = {"spawn"},
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        faction:set_spawn(pos)
        return true
    end
},false)

factions.register_command("where", {
    description = "See whose parcel you stand on.",
    infaction = false,
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local parcel_faction = factions.get_parcel_faction(parcelpos)
        local place_name = (parcel_faction and parcel_faction.name) or "Wilderness"
        minetest.chat_send_player(player, "You are standing on parcel "..parcelpos..", part of "..place_name)
        return true
    end
},false)

factions.register_command("help", {
    description = "Shows help for commands.",
    infaction = false,
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        factions_chat.show_help(player)
        return true
    end
},false)

factions.register_command("spawn", {
    description = "Shows your faction's spawn",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local spawn = faction.spawn
        if spawn then
            local spawn = {spawn.x, spawn.y, spawn.z}
            minetest.chat_send_player(player, "Spawn is at ("..table.concat(spawn, ", ")..")")
            return true
        else
            minetest.chat_send_player(player, "Your faction has no spawn set.")
            return false
        end
    end
},false)

factions.register_command("promote", {
    description = "Promotes a player to a rank",
    format = {"player", "string"},
    faction_permissions = {"promote"},
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local rank = args.strings[1]
        if faction.ranks[rank] then
            faction:promote(args.players[1], rank)
			minetest.chat_send_player(player, "Promoted "..args.players[1] .. " to " .. rank .. "!")
            return true
        else
            send_error(player, "The specified rank does not exist.")
            return false
        end
    end
},false)

factions.register_command("power", {
    description = "Display your faction's power",
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        minetest.chat_send_player(player, "Power: "..faction.power.."/"..faction.maxpower - faction.usedpower.."/"..faction.maxpower)
        return true
    end
},false)
--[[
factions.register_command("setbanner", {
    description = "Sets the banner you're on as the faction's banner.",
    faction_permissions = {"banner"},
    on_success = function(player, faction, pos, parcelpos, args)
        local meta = minetest.get_meta({x = pos.x, y = pos.y - 1, z = pos.z})
        local banner = meta:get_string("banner")
        if not banner then
            minetest.chat_send_player(player, "No banner found.")
            return false
        end
        faction:set_banner(banner)
    end
},false)
--]]
--[[
factions.register_command("convert", {
    description = "Load factions in the old format",
    infaction = false,
    global_privileges = {"faction_admin"},
    format = {"string"},
    on_success = function(player, faction, pos, parcelpos, args)
        if factions.convert(args.strings[1]) then
            minetest.chat_send_player(player, "Factions successfully converted.")
        else
            minetest.chat_send_player(player, "Error.")
        end
        return true
    end
},false)
--]]
factions.register_command("free", {
    description = "Forcefully frees a parcel",
    infaction = false,
    global_privileges = {"faction_admin"},
    on_success = function(player, faction, pos, parcelpos, args)
        local parcel_faction = factions.get_parcel_faction(parcelpos)
        if not parcel_faction then
            send_error(player, "No claim at this position")
            return false
        else
            parcel_faction:unclaim_parcel(parcelpos)
            return true
        end
    end
},false)

factions.register_command("chat", {
    description = "Send a message to your faction's members",
	format = {"string"},
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local msg = table.concat(args.strings, " ")
        faction:broadcast(msg, player)
    end
},true)

factions.register_command("forceupdate", {
    description = "Forces an update tick.",
    global_privileges = {"faction_admin"},
    on_success = function(player, faction, pos, parcelpos, args)
        factions.faction_tick()
    end
},false)

factions.register_command("which", {
    description = "Gets a player's faction",
    infaction = false,
    format = {"string"},
	--global_privileges = {"faction_user"},
    on_success = function(player, faction, pos, parcelpos, args)
        local playername = args.strings[1]
        local faction = factions.get_player_faction(playername)
        if not faction then
            send_error(player, "Player "..playername.." does not belong to any faction")
            return false
        else
            minetest.chat_send_player(player, "player "..playername.." belongs to faction "..faction.name)
            return true
        end
    end
},false)

factions.register_command("setleader", {
    description = "Set a player as a faction's leader",
    infaction = false,
    global_privileges = {"faction_admin"},
    format = {"faction", "player"},
    on_success = function(player, faction, pos, parcelpos, args)
        local playername = args.players[1]
        local playerfaction = factions.get_player_faction(playername)
        local targetfaction = args.factions[1]
        if playerfaction.name ~= targetfaction.name then
            send_error(player, "Player "..playername.." is not in faction "..targetfaction.name..".")
            return false
        end
        targetfaction:set_leader(playername)
        return true
    end
},false)

factions.register_command("setadmin", {
    description = "Make a faction an admin faction",
    infaction = false,
    global_privileges = {"faction_admin"},
    format = {"faction"},
    on_success = function(player, faction, pos, parcelpos, args)
        args.factions[1].is_admin = false
        return true
    end
},false)

factions.register_command("resetpower", {
    description = "Reset a faction's power",
    infaction = false,
    global_privileges = {"faction_admin"},
    format = {"faction"},
    on_success = function(player, faction, pos, parcelpos, args)
        args.factions[1].power = 0
        return true
    end
},false)


factions.register_command("obliterate", {
    description = "Remove all factions",
    infaction = false,
    global_privileges = {"faction_admin"},
    on_success = function(player, faction, pos, parcelpos, args)
        for _, f in pairs(factions.factions) do
            f:disband("obliterated")
        end
        return true
    end
},false)

factions.register_command("getspawn", {
    description = "Get a faction's spawn",
    infaction = false,
    global_privileges = {"faction_admin"},
    format = {"faction"},
    on_success = function(player, faction, pos, parcelpos, args)
        local spawn = args.factions[1].spawn
        if spawn then
            minetest.chat_send_player(player, spawn.x..","..spawn.y..","..spawn.z)
            return true
        else
            send_error(player, "Faction has no spawn set.")
            return false
        end
    end
},false)

factions.register_command("whoin", {
    description = "Get all members of a faction.",
    infaction = false,
    --global_privileges = {"faction_admin"},
    format = {"faction"},
    on_success = function(player, faction, pos, parcelpos, args)
        local msg = {}
        for player, _ in pairs(args.factions[1].players) do
            table.insert(msg, player)
        end
        minetest.chat_send_player(player, table.concat(msg, ", "))
        return true
    end
},false)

factions.register_command("stats", {
    description = "Get stats of a faction.",
    infaction = false,
    --global_privileges = {"faction_admin"},
    format = {"faction"},
    on_success = function(player, faction, pos, parcelpos, args)
        local f = args.factions[1]
        minetest.chat_send_player(player, "Power: "..f.power.."/"..f.maxpower - f.usedpower.."/"..f.maxpower)
        return true
    end
},false)

factions.register_command("seen", {
    description = "Check the last time a faction had a member logged in",
    infaction = false,
    --global_privileges = {"faction_admin"},
    format = {"faction"},
    on_success = function(player, faction, pos, parcelpos, args)
        local lastseen = args.factions[1].last_logon
        local now = os.time()
        local time = now - lastseen
        local minutes = math.floor(time / 60)
        local hours = math.floor(minutes / 60)
        local days = math.floor(hours / 24)
        minetest.chat_send_player(player, "Last seen "..days.." day(s), "..
            hours % 24 .." hour(s), "..minutes % 60 .." minutes, "..time % 60 .." second(s) ago.")
        return true
    end
},false)

-------------------------------------------------------------------------------
-- name: cmdhandler(playername,parameter)
--
--! @brief chat command handler
--! @memberof factions_chat
--! @private
--
--! @param playername name
--! @param parameter data supplied to command
-------------------------------------------------------------------------------
factions_chat.cmdhandler = function (playername,parameter)

	local player = minetest.env:get_player_by_name(playername)
	local params = parameter:split(" ")
    local player_faction = factions.get_player_faction(playername)

	if parameter == nil or
		parameter == "" then
        if player_faction then
            minetest.chat_send_player(playername, "You are in faction "..player_faction.name..". Type /f help for a list of commands.")
        else
            minetest.chat_send_player(playername, "You are part of no faction")
        end
		return
	end

	local cmd = factions.commands[params[1]]
    if not cmd then
        send_error(playername, "Unknown command.")
        return false
    end

    local argv = {}
    for i=2, #params, 1 do
        table.insert(argv, params[i])
    end
	
    cmd:run(playername, argv)

end

function table_Contains(t,v)
	for k, a in pairs(t) do
		if a == v then
			return true
		end		
	end
	return false
end

-------------------------------------------------------------------------------
-- name: show_help(playername,parameter)
--
--! @brief send help message to player
--! @memberof factions_chat
--! @private
--
--! @param playername name
-------------------------------------------------------------------------------
function factions_chat.show_help(playername)

	local MSG = function(text)
		minetest.chat_send_player(playername,text,false)
	end
	
	MSG("factions mod")
	MSG("Usage:")
	local has, missing = minetest.check_player_privs(playername,  {
    faction_admin = true})
	
    for k, v in pairs(factions.commands) do
        local args = {}
		if has or not table_Contains(v.global_privileges,"faction_admin") then
			for i in ipairs(v.format) do
				table.insert(args, v.format[i])
			end
			MSG("\t/factions "..k.." <"..table.concat(args, "> <").."> : "..v.description)
		end
    end
end

init_commands()

