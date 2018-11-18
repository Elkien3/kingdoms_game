-------------------------------------------------------------------------------
-- factions Mod by Sapier
--
-- License WTFPL
--
--! @file config.lua
--! @brief settings file
--! @copyright Coder12a
--! @author Coder12a
--! @date 2018-03-13
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

config = {}
config.protection_max_depth = tonumber(minetest.setting_get("protection_max_depth")) or -20
config.power_per_parcel = tonumber(minetest.setting_get("power_per_parcel")) or 1
config.power_per_death = tonumber(minetest.setting_get("power_per_death")) or 0.25
config.power_per_tick = tonumber(minetest.setting_get("power_per_tick")) or 0.125
config.tick_time = tonumber(minetest.setting_get("tick_time")) or 60
config.power_per_attack = tonumber(minetest.setting_get("power_per_attack")) or 4
config.faction_name_max_length = tonumber(minetest.setting_get("faction_name_max_length")) or 50
config.rank_name_max_length = tonumber(minetest.setting_get("rank_name_max_length")) or 25
config.maximum_faction_inactivity = tonumber(minetest.setting_get("maximum_faction_inactivity")) or 604800
config.power = tonumber(minetest.setting_get("power")) or 1
config.maxpower = tonumber(minetest.setting_get("maxpower")) or 4
config.power_per_banner = minetest.settings:get("power_per_banner") or 1
config.attack_parcel = minetest.settings:get_bool("attack_parcel") or false
config.siege_banner_interval = minetest.settings:get_bool("siege_banner_interval") or 300 