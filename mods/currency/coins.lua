local function makecoin(name, itemstring, texture, ingot)
	minetest.register_craftitem(itemstring, {
    description = name,
    inventory_image = texture,
		groups = {coin = 1}
	})

	minetest.register_craft({
		type = "shapeless",
		output = itemstring.." 9",
		recipe = {ingot},
	})
	minetest.register_craft({
		type = "shapeless",
		output = ingot,
		recipe = {itemstring, itemstring, itemstring, itemstring, itemstring, itemstring, itemstring, itemstring, itemstring},
	})
end

makecoin("Tin Coin", "currency:coin_tin", "coin_tin.png", "default:tin_ingot")
makecoin("Copper Coin", "currency:coin_copper", "coin_copper.png", "default:copper_ingot")
makecoin("Steel Coin", "currency:coin_steel", "coin_steel.png", "default:steel_ingot")
makecoin("Bronze Coin", "currency:coin_bronze", "coin_bronze.png", "default:bronze_ingot")
makecoin("Gold Coin", "currency:coin_gold", "coin_gold.png", "default:gold_ingot")