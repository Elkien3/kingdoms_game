local default_range = 4
local long_range = default_range + 1
local short_range = default_range - 2

local battleaxes = {"lottweapons:wood_battleaxe", "lottweapons:stone_battleaxe", "lottweapons:copper_battleaxe", "lottweapons:steel_battleaxe", "lottweapons:bronze_battleaxe", "lottweapons:gold_battleaxe"}
local warhammers = {"lottweapons:wood_warhammer", "lottweapons:stone_warhammer", "lottweapons:copper_warhammer", "lottweapons:steel_warhammer", "lottweapons:bronze_warhammer", "lottweapons:gold_warhammer"}
local spears = {"lottweapons:wood_spear", "lottweapons:stone_spear", "lottweapons:copper_spear", "lottweapons:steel_spear", "lottweapons:bronze_spear", "lottweapons:gold_spear"}
local daggers = {"lottweapons:wood_dagger", "lottweapons:stone_dagger", "lottweapons:copper_dagger", "lottweapons:steel_dagger", "lottweapons:bronze_dagger", "lottweapons:gold_dagger"}

minetest.override_item("", {range = default_range,})

for id, item in pairs(battleaxes) do
	minetest.override_item(item, {range = (short_range+default_range)/2,})
end
for id, item in pairs(warhammers) do
	minetest.override_item(item, {range = short_range,})
end
for id, item in pairs(daggers) do
	minetest.override_item(item, {range = short_range,})
end
for id, item in pairs(spears) do
	minetest.override_item(item, {range = long_range,})
end