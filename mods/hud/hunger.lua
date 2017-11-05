-- Keep these for backwards compatibility
function hud.save_hunger(player)
	hud.set_hunger(player)
end
function hud.load_hunger(player)
	hud.get_hunger(player)
end

-- Poison player
local function poisenp(tick, time, time_left, player)
	time_left = time_left + tick
	if time_left < time then
		minetest.after(tick, poisenp, tick, time, time_left, player)
	else
		--reset hud image
	end
	if player:get_hp()-1 > 0 then
		player:set_hp(player:get_hp()-1)
	end
	
end

function hud.item_eat(hunger_change, replace_with_item, poisen, heal)
	return function(itemstack, user, pointed_thing)
		if itemstack:take_item() ~= nil and user ~= nil then
			local name = user:get_player_name()
			local h = tonumber(hud.hunger[name])
			local hp = user:get_hp()

			-- Saturation
			if h < 30 and hunger_change then
				h = h + hunger_change
				if h > 30 then h = 30 end
				hud.hunger[name] = h
				hud.set_hunger(user)
			end
			-- Healing
			if hp < 20 and heal then
				hp = hp + heal
				if hp > 20 then hp = 20 end
				user:set_hp(hp)
			end
			-- Poison
			if poisen then
				--set hud-img
				poisenp(1.0, poisen, 0, user)
			end

			--sound:eat
			itemstack:add_item(replace_with_item)
		end
		return itemstack
	end
end

function overwritefood(name, hunger_change, replace_with_item, poisen, heal)
	local tab = minetest.registered_items[name]
	if tab == nil then return end
	tab.on_use = hud.item_eat(hunger_change, replace_with_item, poisen, heal)
	minetest.registered_items[name] = tab
end

overwritefood("default:apple", 2)
overwritefood("flowers:mushroom_brown", 2)
if minetest.get_modpath("farming") ~= nil then
	overwritefood("farming:bread", 4)
end

if minetest.get_modpath("mobs") ~= nil then
	overwritefood("mobs:meat", 6)
	overwritefood("mobs:meat_raw", 3)
	overwritefood("mobs:rat_cooked", 5)
end

if minetest.get_modpath("moretrees") ~= nil then
	overwritefood("moretrees:coconut_milk", 1)
	overwritefood("moretrees:raw_coconut", 2)
	overwritefood("moretrees:acorn_muffin", 3)
	overwritefood("moretrees:spruce_nuts", 1)
	overwritefood("moretrees:pine_nuts", 1)
	overwritefood("moretrees:fir_nuts", 1)
end

if minetest.get_modpath("dwarves") ~= nil then
	overwritefood("dwarves:beer", 2)
	overwritefood("dwarves:apple_cider", 1)
	overwritefood("dwarves:midus", 2)
	overwritefood("dwarves:tequila", 2)
	overwritefood("dwarves:tequila_with_lime", 2)
	overwritefood("dwarves:sake", 2)
end

if minetest.get_modpath("animalmaterials") ~= nil then
	overwritefood("animalmaterials:milk", 2)
	overwritefood("animalmaterials:meat_raw", 3)
	overwritefood("animalmaterials:meat_pork", 3)
	overwritefood("animalmaterials:meat_beef", 3)
	overwritefood("animalmaterials:meat_chicken", 3)
	overwritefood("animalmaterials:meat_lamb", 3)
	overwritefood("animalmaterials:meat_venison", 3)
	overwritefood("animalmaterials:meat_undead", 3, "", 3)
	overwritefood("animalmaterials:meat_toxic", 3, "", 5)
	overwritefood("animalmaterials:meat_ostrich", 3)
	overwritefood("animalmaterials:fish_bluewhite", 2)
	overwritefood("animalmaterials:fish_clownfish", 2)
end

if minetest.get_modpath("fishing") ~= nil then
	overwritefood("fishing:fish_raw", 2)
	overwritefood("fishing:fish_cooked", 5)
	overwritefood("fishing:sushi", 6)
	overwritefood("fishing:shark", 4)
	overwritefood("fishing:shark_cooked", 8)
	overwritefood("fishing:pike", 4)
	overwritefood("fishing:pike_cooked", 8)
end

if minetest.get_modpath("glooptest") ~= nil then
	overwritefood("glooptest:kalite_lump", 1)
end

if minetest.get_modpath("bushes") ~= nil then
	overwritefood("bushes:sugar", 1)
	overwritefood("bushes:strawberry", 2)
	overwritefood("bushes:berry_pie_raw", 3)
	overwritefood("bushes:berry_pie_cooked", 4)
	overwritefood("bushes:basket_pies", 15)
end

if minetest.get_modpath("bushes_classic") then
	-- bushes_classic mod, as found in the plantlife modpack
	local berries = {
	    "strawberry",
		"blackberry",
		"blueberry",
		"raspberry",
		"gooseberry",
		"mixed_berry"}
	for _, berry in ipairs(berries) do
		if berry ~= "mixed_berry" then
			overwritefood("bushes:"..berry, 1)
		end
		overwritefood("bushes:"..berry.."_pie_raw", 2)
		overwritefood("bushes:"..berry.."_pie_cooked", 5)
		overwritefood("bushes:basket_"..berry, 15)
	end
end

if minetest.get_modpath("mushroom") ~= nil then
	overwritefood("mushroom:brown", 1)
	overwritefood("mushroom:red", 1, "", 3)
end

if minetest.get_modpath("docfarming") ~= nil then
	overwritefood("docfarming:carrot", 3)
	overwritefood("docfarming:cucumber", 2)
	overwritefood("docfarming:corn", 3)
	overwritefood("docfarming:potato", 4)
	overwritefood("docfarming:bakedpotato", 5)
	overwritefood("docfarming:raspberry", 3)
end

if minetest.get_modpath("farming_plus") ~= nil then
	overwritefood("farming_plus:carrot_item", 3)
	overwritefood("farming_plus:banana", 2)
	overwritefood("farming_plus:orange_item", 2)
	overwritefood("farming:pumpkin_bread", 4)
	overwritefood("farming_plus:strawberry_item", 2)
	overwritefood("farming_plus:tomato_item", 2)
	overwritefood("farming_plus:potato_item", 4)
	overwritefood("farming_plus:rhubarb_item", 2)
end

if minetest.get_modpath("mtfoods") ~= nil then
	overwritefood("mtfoods:dandelion_milk", 1)
	overwritefood("mtfoods:sugar", 1)
	overwritefood("mtfoods:short_bread", 4)
	overwritefood("mtfoods:cream", 1)
	overwritefood("mtfoods:chocolate", 2)
	overwritefood("mtfoods:cupcake", 2)
	overwritefood("mtfoods:strawberry_shortcake", 2)
	overwritefood("mtfoods:cake", 3)
	overwritefood("mtfoods:chocolate_cake", 3)
	overwritefood("mtfoods:carrot_cake", 3)
	overwritefood("mtfoods:pie_crust", 3)
	overwritefood("mtfoods:apple_pie", 3)
	overwritefood("mtfoods:rhubarb_pie", 2)
	overwritefood("mtfoods:banana_pie", 3)
	overwritefood("mtfoods:pumpkin_pie", 3)
	overwritefood("mtfoods:cookies", 2)
	overwritefood("mtfoods:mlt_burger", 5)
	overwritefood("mtfoods:potato_slices", 2)
	overwritefood("mtfoods:potato_chips", 3)
	--mtfoods:medicine
	overwritefood("mtfoods:casserole", 3)
	overwritefood("mtfoods:glass_flute", 2)
	overwritefood("mtfoods:orange_juice", 2)
	overwritefood("mtfoods:apple_juice", 2)
	overwritefood("mtfoods:apple_cider", 2)
	overwritefood("mtfoods:cider_rack", 2)
end

if minetest.get_modpath("fruit") ~= nil then
	overwritefood("fruit:apple", 2)
	overwritefood("fruit:pear", 2)
	overwritefood("fruit:bananna", 3)
	overwritefood("fruit:orange", 2)
end

if minetest.get_modpath("mush45") ~= nil then
	overwritefood("mush45:meal", 4)
end

if minetest.get_modpath("seaplants") ~= nil then
	overwritefood("seaplants:kelpgreen", 1)
	overwritefood("seaplants:kelpbrown", 1)
	overwritefood("seaplants:seagrassgreen", 1)
	overwritefood("seaplants:seagrassred", 1)
	overwritefood("seaplants:seasaladmix", 6)
	overwritefood("seaplants:kelpgreensalad", 1)
	overwritefood("seaplants:kelpbrownsalad", 1)
	overwritefood("seaplants:seagrassgreensalad", 1)
	overwritefood("seaplants:seagrassgreensalad", 1)
end

if minetest.get_modpath("mobfcooking") ~= nil then
	overwritefood("mobfcooking:cooked_pork", 6)
	overwritefood("mobfcooking:cooked_ostrich", 6)
	overwritefood("mobfcooking:cooked_beef", 6)
	overwritefood("mobfcooking:cooked_chicken", 6)
	overwritefood("mobfcooking:cooked_lamb", 6)
	overwritefood("mobfcooking:cooked_venison", 6)
	overwritefood("mobfcooking:cooked_fish", 6)
end

if minetest.get_modpath("creatures") ~= nil then
	overwritefood("creatures:meat", 6)
	overwritefood("creatures:flesh", 3)
        overwritefood("creatures:chicken_meat", 5)
	overwritefood("creatures:chicken_flesh", 2)
	overwritefood("creatures:rotten_flesh", 3, "", 3)
end

if minetest.get_modpath("ethereal") then
   overwritefood("ethereal:strawberry", 1)
   overwritefood("ethereal:banana", 4)
   overwritefood("ethereal:pine_nuts", 1)
   overwritefood("ethereal:bamboo_sprout", 0, "", 3)
   overwritefood("ethereal:fern_tubers", 1)
   overwritefood("ethereal:banana_bread", 7)
   overwritefood("ethereal:mushroom_plant", 2)
   overwritefood("ethereal:coconut_slice", 2)
   overwritefood("ethereal:golden_apple", 4, "", nil, 10)
   overwritefood("ethereal:wild_onion_plant", 2)
   overwritefood("ethereal:mushroom_soup", 4, "ethereal:bowl")
   overwritefood("ethereal:mushroom_soup_cooked", 6, "ethereal:bowl")
   overwritefood("ethereal:hearty_stew", 6, "ethereal:bowl", 3)
   overwritefood("ethereal:hearty_stew_cooked", 10, "ethereal:bowl")
   if minetest.get_modpath("bucket") then
  	overwritefood("ethereal:bucket_cactus", 2, "bucket:bucket_empty")
   end
   overwritefood("ethereal:fish_raw", 2)
   overwritefood("ethereal:fish_cooked", 5)
   overwritefood("ethereal:seaweed", 1)
   overwritefood("ethereal:yellowleaves", 1, "", nil, 1)
   overwritefood("ethereal:sashimi", 4)
end

if minetest.get_modpath("farming") and farming.mod == "redo" then
   overwritefood("farming:bread", 6)
   overwritefood("farming:potato", 1)
   overwritefood("farming:baked_potato", 6)
   overwritefood("farming:cucumber", 4)
   overwritefood("farming:tomato", 4)
   overwritefood("farming:carrot", 3)
   overwritefood("farming:carrot_gold", 6, "", nil, 8)
   overwritefood("farming:corn", 3)
   overwritefood("farming:corn_cob", 5)
   overwritefood("farming:melon_slice", 2)
   overwritefood("farming:pumpkin_slice", 1)
   overwritefood("farming:pumpkin_bread", 9)
   overwritefood("farming:coffee_cup", 2, "farming:drinking_cup")
   overwritefood("farming:coffee_cup_hot", 3, "farming:drinking_cup", nil, 2)
   overwritefood("farming:cookie", 2)
   overwritefood("farming:chocolate_dark", 3)
   overwritefood("farming:donut", 4)
   overwritefood("farming:donut_chocolate", 6)
   overwritefood("farming:donut_apple", 6)
   overwritefood("farming:raspberries", 1)
   if minetest.get_modpath("vessels") then
	overwritefood("farming:smoothie_raspberry", 2, "vessels:drinking_glass")
   end
   overwritefood("farming:rhubarb", 1)
   overwritefood("farming:rhubarb_pie", 6)
end

if minetest.get_modpath("kpgmobs") ~= nil then
	overwritefood("kpgmobs:uley", 3)
	overwritefood("kpgmobs:meat", 6)
	overwritefood("kpgmobs:rat_cooked", 5)
	overwritefood("kpgmobs:med_cooked", 4)
  	if minetest.get_modpath("bucket") then
	   overwritefood("kpgmobs:bucket_milk", 4, "bucket:bucket_empty")
	end
end

if minetest.get_modpath("jkfarming") ~= nil then
	overwritefood("jkfarming:carrot", 3)
	overwritefood("jkfarming:corn", 3)
	overwritefood("jkfarming:melon_part", 2)
	overwritefood("jkfarming:cake", 3)
end

if minetest.get_modpath("jkanimals") ~= nil then
	overwritefood("jkanimals:meat", 6)
end

if minetest.get_modpath("jkwine") ~= nil then
	overwritefood("jkwine:grapes", 2)
	overwritefood("jkwine:winebottle", 1)
end

-- player-action based hunger changes
function hud.handle_node_actions(pos, oldnode, player, ext)
	if not player or not player:is_player() then
		return
	end
	local name = player:get_player_name()
	local exhaus = hud.exhaustion[name]
	local new = HUD_HUNGER_EXHAUST_PLACE
	-- placenode event
	if not ext then
		new = HUD_HUNGER_EXHAUST_DIG
	end
	-- assume its send by main timer when movement detected
	if not pos and not oldnode then
		new = HUD_HUNGER_EXHAUST_MOVE
	end
	exhaus = exhaus + new
	if exhaus > HUD_HUNGER_EXHAUST_LVL then
		exhaus = 0
		local h = tonumber(hud.hunger[name])
		h = h - 1
		if h < 0 then h = 0 end
		hud.hunger[name] = h
		hud.set_hunger(player)
	end
	hud.exhaustion[name] = exhaus
end

minetest.register_on_placenode(hud.handle_node_actions)
minetest.register_on_dignode(hud.handle_node_actions)
