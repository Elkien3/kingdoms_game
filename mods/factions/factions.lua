-------------------------------------------------------------------------------
-- factions Mod by Sapier
--
-- License WTFPL
--
--! @file factions.lua
--! @brief factions core file
--! @copyright Sapier, agrecascino, shamoanjac, Coder12a
--! @author Sapier, agrecascino, shamoanjac, Coder12a
--! @date 2016-08-12
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

--read some basic information
local factions_worldid = minetest.get_worldpath()

--! @class factions
--! @brief main class for factions
factions = {}

--! @brief runtime data
factions.factions = {}
factions.parcels = {}
factions.players = {}


factions.factions = {}
--- settings
factions.protection_max_depth = config.protection_max_depth
factions.power_per_parcel = config.power_per_parcel
factions.power_per_death = config.power_per_death
factions.power_per_tick = config.power_per_tick
factions.tick_time = config.tick_time
factions.power_per_attack = config.power_per_attack
factions.faction_name_max_length = config.faction_name_max_length
factions.rank_name_max_length = config.rank_name_max_length
factions.maximum_faction_inactivity = config.maximum_faction_inactivity

---------------------
--! @brief returns whether a faction can be created or not (allows for implementation of blacklists and the like)
--! @param name String containing the faction's name
factions.can_create_faction = function(name)
    if #name > factions.faction_name_max_length then
        return false
    elseif factions.factions[name] then
        return false
    else
        return true
    end
end


factions.Faction = {
}

util = {
    coords3D_string = function(coords)
        return coords.x..", "..coords.y..", "..coords.z
    end
}

factions.Faction.__index = factions.Faction

-- Faction permissions:
--
-- disband: disband the faction
-- claim: (un)claim parcels
-- playerslist: invite/kick players and open/close the faction
-- build: dig and place nodes
-- description: set the faction's description
-- ranks: create and delete ranks
-- spawn: set the faction's spawn
-- banner: set the faction's banner
-- promote: set a player's rank

factions.permissions = {"disband", "claim", "playerslist", "build", "description", "ranks", "spawn", "banner", "promote"}

function factions.Faction:new(faction) 
    faction = {
        --! @brief power of a faction (needed for parcel claiming)
        power = config.power,
        --! @brief maximum power of a faction
        maxpower = config.maxpower,
        --! @brief power currently in use
        usedpower = 0.,
        --! @brief list of player names
        players = {},
        --! @brief table of ranks/permissions
        ranks = {["leader"] = {"disband", "claim", "playerslist", "build", "description", "ranks", "spawn", "banner", "promote"},
                 ["moderator"] = {"claim", "playerslist", "build", "spawn"},
                 ["member"] = {"build"}
                },
        --! @brief name of the leader
        leader = nil,
        --! @brief default joining rank for new members
        default_rank = "member",
        --! @brief default rank assigned to the leader
        default_leader_rank = "leader",
        --! @brief faction's description string
        description = "Default faction description.",
        --! @brief list of players currently invited (can join with /f join)
        invited_players = {},
        --! @brief table of claimed parcels (keys are parcelpos strings)
        land = {},
        --! @brief table of allies
        allies = {},
        --! @brief table of enemies
        enemies = {},
        --! @brief table of parcels/factions that are under attack
        attacked_parcels = {},
        --! @brief whether faction is closed or open (boolean)
        join_free = false,
        --! @brief banner texture string
        banner = "bg_white.png",
        --! @brief gives certain privileges
        is_admin = false,
        --! @brief last time anyone logged on
        last_logon = os.time(),
    } or faction
    setmetatable(faction, self)
    return faction
end


--! @brief create a new empty faction
factions.new_faction = function(name)
    local faction =  factions.Faction:new(nil)
    faction.name = name
    factions.factions[name] = faction
    faction:on_create()
    factions.save()
    return faction
end

function factions.Faction.increase_power(self, power)
    self.power = self.power + power
    if self.power > self.maxpower  - self.usedpower then
        self.power = self.maxpower - self.usedpower
    end
	local playerslist = minetest.get_connected_players()
	for i in pairs(playerslist) do
		for player, _ in pairs(self.players) do
			local realplayer = playerslist[i]
			if realplayer:get_player_name() == player then
				updateHudPower(realplayer,self)
			end
		end
	end
    factions.save()
end

function factions.Faction.decrease_power(self, power)
    self.power = self.power - power
	local playerslist = minetest.get_connected_players()
	for i in pairs(playerslist) do
		for player, _ in pairs(self.players) do
			local realplayer = playerslist[i]
			if realplayer:get_player_name() == player then
				updateHudPower(realplayer,self)
			end
		end
	end
    factions.save()
end

function factions.Faction.increase_maxpower(self, power)
    self.maxpower = self.maxpower + power
	local playerslist = minetest.get_connected_players()
	for i in pairs(playerslist) do
		for player, _ in pairs(self.players) do
			local realplayer = playerslist[i]
			if realplayer:get_player_name() == player then
				updateHudPower(realplayer,self)
			end
		end
	end
    factions.save()
end

function factions.Faction.decrease_maxpower(self, power)
    self.maxpower = self.maxpower - power
    if self.maxpower < 0. then -- should not happen
        self.maxpower = 0.
    end
	local playerslist = minetest.get_connected_players()
	for i in pairs(playerslist) do
		for player, _ in pairs(self.players) do
			local realplayer = playerslist[i]
			if realplayer:get_player_name() == player then
				updateHudPower(realplayer,self)
			end
		end
	end
end

function factions.Faction.increase_usedpower(self, power)
    self.usedpower = self.usedpower + power
	local playerslist = minetest.get_connected_players()
	for i in pairs(playerslist) do
		for player, _ in pairs(self.players) do
			local realplayer = playerslist[i]
			if realplayer:get_player_name() == player then
				updateHudPower(realplayer,self)
			end
		end
	end
end

function factions.Faction.decrease_usedpower(self, power)
    self.usedpower = self.usedpower - power
    if self.usedpower < 0. then
        self.usedpower = 0.
    end
	local playerslist = minetest.get_connected_players()
	for i in pairs(playerslist) do
		for player, _ in pairs(self.players) do
			local realplayer = playerslist[i]
			if realplayer:get_player_name() == player then
				updateHudPower(realplayer,self)
			end
		end
	end
end

function factions.Faction.count_land(self)
    local count = 0.
    for k, v in pairs(self.land) do
        count = count + 1
    end
    return count
end

function factions.Faction.add_player(self, player, rank)
    self:on_player_join(player)
    self.players[player] = rank or self.default_rank
    factions.players[player] = self.name
    self.invited_players[player] = nil
	local playerslist = minetest.get_connected_players()
	for i in pairs(playerslist) do
		local realplayer = playerslist[i]
		if realplayer:get_player_name() == player then
			createHudFactionName(realplayer,self.name)
			createHudPower(realplayer,self)
			break
		end
	end
    factions.save()
end

function factions.Faction.check_players_in_faction(self)
	local i = 0
	if self.players then
		for player in pairs(self.players) do
			i = i + 1
		end
	end
	--local players = #self.players
	if i < 1 then
		self:disband("Zero players on faction.")
	end
end

function factions.Faction.remove_player(self, player)
    self.players[player] = nil
    factions.players[player] = nil
    self:on_player_leave(player)
	self:check_players_in_faction(self)
	local playerslist = minetest.get_connected_players()
	for i in pairs(playerslist) do
		local realplayer = playerslist[i]
		if realplayer:get_player_name() == player then
			removeHud(realplayer,"1")
			removeHud(realplayer,"2")
		end
	end
    factions.save()
end

--! @param parcelpos position of the wanted parcel
--! @return whether this faction can claim a parcelpos
function factions.Faction.can_claim_parcel(self, parcelpos)
    local fac = factions.parcels[parcelpos]
    if fac then
        if factions.factions[fac].power < 0. and self.power >= factions.power_per_parcel then
            return true
        else
            return false
        end
    elseif self.power < factions.power_per_parcel then
        return false
    end
    return true
end

--! @brief claim a parcel, update power and update global parcels table
function factions.Faction.claim_parcel(self, parcelpos)
    -- check if claiming over other faction's territory
    local otherfac = factions.parcels[parcelpos]
    if otherfac then
        local faction = factions.factions[otherfac]
        faction:unclaim_parcel(parcelpos)
    end
    factions.parcels[parcelpos] = self.name
    self.land[parcelpos] = true
    self:decrease_power(factions.power_per_parcel)
    self:increase_usedpower(factions.power_per_parcel)
    self:on_claim_parcel(parcelpos)
    factions.save()
end

--! @brief claim a parcel, update power and update global parcels table
function factions.Faction.unclaim_parcel(self, parcelpos)
    factions.parcels[parcelpos] = nil
    self.land[parcelpos] = nil
    self:increase_power(factions.power_per_parcel)
    self:decrease_usedpower(factions.power_per_parcel)
    self:on_unclaim_parcel(parcelpos)
    factions.save()
end

--! @brief disband faction, updates global players and parcels table
function factions.Faction.disband(self, reason)
	local playerslist = minetest.get_connected_players()
    for k, _ in pairs(factions.players) do -- remove players affiliation
        factions.players[k] = nil
    end
    for k, v in pairs(self.land) do -- remove parcel claims
        factions.parcels[k] = nil
    end
    self:on_disband(reason)
    factions.factions[self.name] = nil
	for i in pairs(playerslist) do
		local realplayer = playerslist[i]
		local faction = factions.get_player_faction(realplayer:get_player_name())
        if not faction then
			removeHud(realplayer,"1")
			removeHud(realplayer,"2")
		end
	end
    factions.save()
end

--! @brief change the faction leader
function factions.Faction.set_leader(self, player)
    if self.leader then
        self.players[self.leader] = self.default_rank
    end
    self.leader = player
    self.players[player] = self.default_leader_rank
    self:on_new_leader()
    factions.save()
end

--! @brief check permissions for a given player
--! @return boolean indicating permissions. Players not in faction always receive false
function factions.Faction.has_permission(self, player, permission)
    local p = self.players[player]
    if not p then
        return false
    end
    local perms = self.ranks[p]
    for i in ipairs(perms) do
        if perms[i] == permission then
            return true
        end
    end
    return false
end
function factions.Faction.set_description(self, new)
    self.description = new
    self:on_change_description()
    factions.save()
end

--! @brief places player in invite list
function factions.Faction.invite_player(self, player)
    self.invited_players[player] = true
    self:on_player_invited(player)
    factions.save()
end

--! @brief removes player from invite list (can no longer join via /f join)
function factions.Faction.revoke_invite(self, player)
    self.invited_players[player] = nil
    self:on_revoke_invite(player)
    factions.save()
end
--! @brief set faction openness
function factions.Faction.toggle_join_free(self, bool)
    self.join_free = bool
    self:on_toggle_join_free()
    factions.save()
end

--! @return true if a player can use /f join, false otherwise
function factions.Faction.can_join(self, player)
    return self.join_free or self.invited_players[player]
end

function factions.Faction.new_alliance(self, faction)
    self.allies[faction] = true
    self:on_new_alliance(faction)
    if self.enemies[faction] then
        self:end_enemy(faction)
    end
    factions.save()
end
function factions.Faction.end_alliance(self, faction)
    self.allies[faction] = nil
    self:on_end_alliance(faction)
    factions.save()
end
function factions.Faction.new_enemy(self, faction)
    self.enemies[faction] = true
    self:on_new_enemy(faction)
    if self.allies[faction] then
        self:end_alliance(faction)
    end
    factions.save()
end
function factions.Faction.end_enemy(self, faction)
    self.enemies[faction] = nil
    self:on_end_enemy(faction)
    factions.save()
end

--! @brief faction's member will now spawn in a new place
function factions.Faction.set_spawn(self, pos)
    self.spawn = {x=pos.x, y=pos.y, z=pos.z}
    self:on_set_spawn()
    factions.save()
end

--! @brief create a new rank with permissions
--! @param rank the name of the new rank
--! @param rank a list with the permissions of the new rank
function factions.Faction.add_rank(self, rank, perms)
    self.ranks[rank] = perms
    self:on_add_rank(rank)
    factions.save()
end

--! @brief delete a rank and replace it
--! @param rank the name of the rank to be deleted
--! @param newrank the rank given to players who were previously "rank"
function factions.Faction.delete_rank(self, rank, newrank)
    for player, r in pairs(self.players) do
        if r == rank then
            self.players[player] = newrank
        end
    end
    self.ranks[rank] = nil
    self:on_delete_rank(rank, newrank)
    factions.save()
end

--! @param newbanner texture string of the new banner
function factions.Faction.set_banner(self, newbanner)
    self.banner = newbanner
    self:on_new_banner()
end

--! @brief set a player's rank
function factions.Faction.promote(self, member, rank)
    self.players[member] = rank
    self:on_promote(member)
end

--! @brief send a message to all members
function factions.Faction.broadcast(self, msg, sender)
    local message = self.name.."> "..msg
    if sender then
        message = sender.."@"..message
    end
    message = "Faction<"..message
    for k, _ in pairs(self.players) do
        minetest.chat_send_player(k, message)
    end
end

--! @brief checks whether a faction has at least one connected player
function factions.Faction.is_online(self)
    for playername, _ in pairs(self.players) do
        if minetest.get_player_by_name(playername) then
            return true
        end
    end
    return false
end

function factions.Faction.attack_parcel(self, parcelpos)
	if config.attack_parcel then
		local attacked_faction = factions.get_parcel_faction(parcelpos)
		if attacked_faction then
			if self.power < factions.power_per_attack then
				self:broadcast("You do not have enough power to attack!!")
				return
			end
			self.power = self.power - factions.power_per_attack
			if attacked_faction.attacked_parcels[parcelpos] then 
				attacked_faction.attacked_parcels[parcelpos][self.name] = true
			else
				attacked_faction.attacked_parcels[parcelpos] = {[self.name] = true}
			end
			attacked_faction:broadcast("Parcel ("..parcelpos..") is being attacked by "..self.name.."!!")
			if self.power < 0. then -- punish memers
				minetest.chat_send_all("Faction "..self.name.." has attacked too much and has now negative power!")
			end
			factions.save()
		end    
	end
end

function factions.Faction.stop_attack(self, parcelpos)
    local attacked_faction = factions.parcels[parcelpos]
    if attacked_faction then
        attacked_faction = factions.factions[attacked_faction]
        if attacked_faction.attacked_parcels[parcelpos] then
            attacked_faction.attacked_parcels[parcelpos][self.name] = nil
            attacked_faction:broadcast("Parcel ("..parcelpos..") is no longer under attack from "..self.name..".")
            self:broadcast("Parcel ("..parcelpos..") has been reconquered by "..attacked_faction.name..".")
        end
        factions.save()
    end
end

function factions.Faction.parcel_is_attacked_by(self, parcelpos, faction)
    if self.attacked_parcels[parcelpos] then
        return self.attacked_parcels[parcelpos][faction.name]
    else
        return false
    end
end

--------------------------
-- callbacks for events --
function factions.Faction.on_create(self)  --! @brief called when the faction is added to the global faction list
    minetest.chat_send_all("Faction "..self.name.." has been created.")
end

function factions.Faction.on_player_leave(self, player)
    self:broadcast(player.." has left this faction.")
end

function factions.Faction.on_player_join(self, player)
    self:broadcast(player.." has joined this faction.")
end

function factions.Faction.on_claim_parcel(self, pos)
    self:broadcast("Parcel ("..pos..") has been claimed.")
end

function factions.Faction.on_unclaim_parcel(self, pos)
    self:broadcast("Parcel ("..pos..") has been unclaimed.")
end

function factions.Faction.on_disband(self, reason)
    local msg = "Faction "..self.name.." has been disbanded."
    if reason then
        msg = msg.." ("..reason..")"
    end
    minetest.chat_send_all(msg)
end

function factions.Faction.on_new_leader(self)
    self:broadcast(self.leader.." is now the leader of this faction.")
end

function factions.Faction.on_change_description(self)
    self:broadcast("Faction description has been modified to: "..self.description)
end

function factions.Faction.on_player_invited(self, player)
    minetest.chat_send_player(player, "You have been invited to faction "..self.name)
end

function factions.Faction.on_toggle_join_free(self, player)
    if self.join_free then
        self:broadcast("This faction is now invite-free.")
    else
        self:broadcast("This faction is no longer invite-free.")
    end
end

function factions.Faction.on_new_alliance(self, faction)
    self:broadcast("This faction is now allied with "..faction)
end

function factions.Faction.on_end_alliance(self, faction)
    self:broadcast("This faction is no longer allied with "..faction.."!")
end

function factions.Faction.on_set_spawn(self)
    self:broadcast("The faction spawn has been set to ("..util.coords3D_string(self.spawn)..").")
end

function factions.Faction.on_add_rank(self, rank)
    self:broadcast("The rank "..rank.." has been created with privileges: "..table.concat(self.ranks[rank], ", "))
end

function factions.Faction.on_delete_rank(self, rank, newrank)
    self:broadcast("The rank "..rank.." has been deleted and replaced by "..newrank)
end

function factions.Faction.on_new_banner(self)
    self:broadcast("A new banner has been set.")
end

function factions.Faction.on_promote(self, member)
    minetest.chat_send_player(member, "You have been promoted to "..self.players[member])
end

function factions.Faction.on_revoke_invite(self, player)
    minetest.chat_send_player(player, "You are no longer invited to faction "..self.name)
end

--??????????????

function factions.get_parcel_pos(pos)
    return math.floor(pos.x / 64.)..","..math.floor(pos.z / 64.)
end

function factions.get_player_faction(playername)
    local facname = factions.players[playername]
    if facname then
        local faction = factions.factions[facname]
        return faction
    end
    return nil
end

function factions.get_parcel_faction(parcelpos)
    local facname = factions.parcels[parcelpos]
    if facname then
        local faction = factions.factions[facname]
        return faction
    end
    return nil
end

function factions.get_faction(facname)
    return factions.factions[facname]
end

function factions.get_faction_at(pos)
    local parcelpos = factions.get_parcel_pos(pos)
    return factions.get_parcel_faction(parcelpos)
end


-------------------------------------------------------------------------------
-- name: add_faction(name)
--
--! @brief add a faction
--! @memberof factions
--! @public
--
--! @param name of faction to add
--!
--! @return faction object/false (succesfully added faction or not)
-------------------------------------------------------------------------------
function factions.add_faction(name)
    if factions.can_create_faction(name) then
        local fac = factions.new_faction(name)
        fac:on_create()
        return fac
    else
        return nil
    end
end

-------------------------------------------------------------------------------
-- name: get_faction_list()
--
--! @brief get list of factions
--! @memberof factions
--! @public
--!
--! @return list of factions
-------------------------------------------------------------------------------
function factions.get_faction_list()

    local retval = {}

    for key,value in pairs(factions.factions) do
        table.insert(retval,key)
    end

    return retval
end

-------------------------------------------------------------------------------
-- name: save()
--
--! @brief save data to file
--! @memberof factions
--! @private
-------------------------------------------------------------------------------
function factions.save()

    --saving is done much more often than reading data to avoid delay
    --due to figuring out which data to save and which is temporary only
    --all data is saved here
    --this implies data needs to be cleant up on load

    local file,error = io.open(factions_worldid .. "/" .. "factions.conf","w")

    if file ~= nil then
        file:write(minetest.serialize(factions.factions))
        file:close()
    else
        minetest.log("error","MOD factions: unable to save factions world specific data!: " .. error)
    end

end

-------------------------------------------------------------------------------
-- name: load()
--
--! @brief load data from file
--! @memberof factions
--! @private
--
--! @return true/false
-------------------------------------------------------------------------------
function factions.load()
    local file,error = io.open(factions_worldid .. "/" .. "factions.conf","r")

    if file ~= nil then
        local raw_data = file:read("*a")
        factions.factions = minetest.deserialize(raw_data)
        for facname, faction in pairs(factions.factions) do
            minetest.log("action", facname..","..faction.name)
            for player, rank in pairs(faction.players) do
                minetest.log("action", player..","..rank)
                factions.players[player] = facname
            end
            for parcelpos, val in pairs(faction.land) do
                factions.parcels[parcelpos] = facname
            end
            setmetatable(faction, factions.Faction)
            -- compatiblity and later additions
            if not faction.maxpower or faction.maxpower <= 0. then
                faction.maxpower = faction.power
                if faction.power < 0. then
                    faction.maxpower = 0.
                end
            end
            if not faction.attacked_parcels then
                faction.attacked_parcels = {}
            end
            if not faction.usedpower then
                faction.usedpower = faction:count_land() * factions.power_per_parcel
            end
            if #faction.name > factions.faction_name_max_length then
                faction:disband()
            end
            if not faction.last_logon then
                faction.last_logon = os.time()
            end
        end
        file:close()
    end
end

function factions.convert(filename)
    local file, error = io.open(factions_worldid .. "/" .. filename, "r")
    if not file then
        minetest.chat_send_all("Cannot load file "..filename..". "..error)
        return false
    end
    local raw_data = file:read("*a")
    local data = minetest.deserialize(raw_data)
    local factionsmod = data.factionsmod
    local objects = data.objects
    for faction, attrs in pairs(factionsmod) do
        local newfac = factions.new_faction(faction)
        newfac:add_player(attrs.owner, "leader")
        for player, _ in pairs(attrs.adminlist) do
            if not newfac.players[player] then
                newfac:add_player(player, "moderator")
            end
        end
        for player, _ in pairs(attrs.invitations) do
            newfac:invite_player(player)
        end
        for i in ipairs(attrs.parcel) do
            local parcelpos = table.concat(attrs.parcel[i],",")
            newfac:claim_parcel(parcelpos)
        end
    end
    for player, attrs in pairs(objects) do
        local facname = attrs.factionsmod
        local faction = factions.factions[facname]
        if faction then
            faction:add_player(player)
        end
    end
    return true
end

minetest.register_on_dieplayer(
function(player)
    local faction = factions.get_player_faction(player:get_player_name())
    if not faction then
        return true
    end
    faction:decrease_power(factions.power_per_death)
    return true
end
)


factions.faction_tick = function()
    local now = os.time()
    for facname, faction in pairs(factions.factions) do
        if faction:is_online() then
            faction:increase_power(factions.power_per_tick)
        end
        if now - faction.last_logon > factions.maximum_faction_inactivity then
            faction:disband()
        end
    end
end
--[[
local hudUpdate = 0.
local factionUpdate = 0.

minetest.register_globalstep(
function(dtime)
    hudUpdate = hudUpdate + dtime
    factionUpdate = factionUpdate + dtime
    if hudUpdate > .5 then
        local playerslist = minetest.get_connected_players()
        for i in pairs(playerslist) do
            local player = playerslist[i]
            local faction = factions.get_faction_at(player:getpos())
            player:hud_remove("factionLand")
            player:hud_add({
                hud_elem_type = "text",
                name = "factionLand",
                number = 0xFFFFFF,
                position = {x=0.1, y = .98},
                text = (faction and faction.name) or "Wilderness",
                scale = {x=1, y=1},
                alignment = {x=0, y=0},
            })
        end
        hudUpdate = 0.
    end
    if factionUpdate > factions.tick_time then
        factions.faction_tick()
        factionUpdate = 0.
    end
end
)
--]]

hud_ids = {}

createHudFactionName = function(player,factionname)
	local name = player:get_player_name()
	local id_name = name .. "1"
	if not hud_ids[id_name] then
		hud_ids[id_name] = player:hud_add({
			hud_elem_type = "text",
			name = "factionName",
			number = 0xFFFFFF,
			position = {x=1, y = 0},
			text = "Faction "..factionname,
			scale = {x=1, y=1},
			alignment = {x=-1, y=0},
			offset = {x = -20, y = 20}
		})
	end
end

createHudPower = function(player,faction)
	local name = player:get_player_name()
	local id_name = name .. "2"
	if not hud_ids[id_name] then
		hud_ids[id_name] = player:hud_add({
			hud_elem_type = "text",
			name = "powerWatch",
			number = 0xFFFFFF,
			position = {x=0.9, y = .98},
			text = "Power "..faction.power.."/"..faction.maxpower - faction.usedpower.."/"..faction.maxpower,
			scale = {x=1, y=1},
			alignment = {x=-1, y=0},
			offset = {x = 0, y = 0}
		})
	end
end

updateHudPower = function(player,faction)
	local name = player:get_player_name()
	local id_name = name .. "2"
	if hud_ids[id_name] then
		player:hud_change(hud_ids[id_name],"text","Power "..faction.power.."/"..faction.maxpower - faction.usedpower.."/"..faction.maxpower)
	end
end

removeHud = function(player,numberString)
	local name = player:get_player_name()
	local id_name = name .. numberString
	if hud_ids[id_name] then
		player:hud_remove(hud_ids[id_name])
		hud_ids[id_name] = nil
	end
end

hudUpdate = function()
	minetest.after(.5, 
	function()
		local playerslist = minetest.get_connected_players()
		for i in pairs(playerslist) do
			local player = playerslist[i]
			local name = player:get_player_name()
			local faction = factions.get_faction_at(player:getpos())
			local id_name = name .. "0"
			if hud_ids[id_name] then
				player:hud_change(hud_ids[id_name],"text",(faction and faction.name) or "Wilderness")
			end
		end
		hudUpdate()
	end)
end

factionUpdate = function()
	minetest.after(factions.tick_time, 
	function()
		factions.faction_tick()
		factionUpdate()
	end)
end

minetest.register_on_joinplayer(
function(player)
	local name = player:get_player_name()
	hud_ids[name .. "0"] = player:hud_add({
		hud_elem_type = "text",
		name = "factionLand",
		number = 0xFFFFFF,
		position = {x=0.1, y = .98},
		text = "Wilderness",
		scale = {x=1, y=1},
		alignment = {x=0, y=0},
	})
    local faction = factions.get_player_faction(name)
    if faction then
        faction.last_logon = os.time()
		createHudFactionName(player,faction.name)
		createHudPower(player,faction)
    end
end
)

minetest.register_on_leaveplayer(
	function(player)
		local name = player:get_player_name()
		local id_name = name .. "0"
		if hud_ids[id_name] then
			player:hud_remove(hud_ids[id_name])
			hud_ids[id_name] = nil
		end
		removeHud(player,"1")
		removeHud(player,"2")
	end
)

minetest.register_on_respawnplayer(
    function(player)
        local faction = factions.get_player_faction(player:get_player_name())
        if not faction then
            return false
        else
            if not faction.spawn then
                return false
            else
                player:setpos(faction.spawn)
                return true
            end
        end
    end
)



local default_is_protected = minetest.is_protected
minetest.is_protected = function(pos, player)
    if pos.y < factions.protection_max_depth then
        return false
    end
    if factions.disallow_edit_nofac and not player_faction then
        return true
    end

    local parcelpos = factions.get_parcel_pos(pos)
    local parcel_faction = factions.get_parcel_faction(parcelpos)
    local player_faction = factions.get_player_faction(player)
    -- check if wielding death banner
    local player_info = minetest.get_player_by_name(player)
    if not player_info then
        if parcel_faction then
            return true
        else
            return false
        end
    end
    local player_wield = player_info:get_wielded_item()
    if player_wield:get_name() == "banners:death_banner" and player_faction then --todo: check for allies, maybe for permissions
        return not player_faction:has_permission(player, "claim") and player_faction.power > 0. and not parcel_faction.is_admin
    end
    -- no faction
    if not parcel_faction then
        return default_is_protected(pos, player)
    elseif player_faction then
        if parcel_faction.name == player_faction.name then
            return not parcel_faction:has_permission(player, "build")
        else
            return not parcel_faction:parcel_is_attacked_by(parcelpos, player_faction)
        end
    else
        return true
    end
end

hudUpdate()
factionUpdate()