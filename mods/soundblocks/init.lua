minetest.register_node ("soundblocks:harp", {
    description = "Harp",
    tiles       = {
"soundblocks_harp1.png" , "soundblocks_harp2.png" , "soundblocks_harp3.png" ,
"soundblocks_harp4.png" , "soundblocks_harp5.png" , "soundblocks_harp6.png" ,
    } ,
    drawtype    = "nodebox" ,
    paramtype   = "light"   ,
    paramtype2  = "facedir" ,
    on_punch = function(pos, node, player, pointed_thing)
        minetest.sound_play ("soundblocks_harp", {
            pos               = pos ,
            max_hear_distance = 100  ,
            gain              =  1  ,
        })
    end,
    node_box = {
        type = "fixed" ,
        fixed = {
            {-0.3125, -0.5, -0.0625, 0.125, -0.375, 0.125}, -- NodeBox1
            {-0.1875, -0.375, -0.0625, 0.1875, -0.25, 0.125}, -- NodeBox2
            {-0.0625, -0.25, -0.0625, 0.25, -0.125, 0.125}, -- NodeBox3
            {0.0625, -0.125, -0.0625, 0.3125, 0, 0.125}, -- NodeBox4
            {0.1875, -0.0625, -0.0625, 0.375, 0.125, 0.125}, -- NodeBox5
            {0.3125, 0.0625, -0.0625, 0.4375, 0.25, 0.125}, -- NodeBox6
            {0.4375, 0.25, -0.0625, 0.5, 0.375, 0.125}, -- NodeBox7
            {0.375, 0.375, -0.0625, 0.4375, 0.4375, 0.125}, -- NodeBox8
            {-0.1875, 0.4375, -0.0625, 0.375, 0.5, 0.125}, -- NodeBox9
            {-0.375, -0.375, -0.0625, -0.3125, -0.3125, 0.125}, -- NodeBox10
            {-0.4375, -0.3125, -0.0625, -0.375, 0.25, 0.125}, -- NodeBox11
            {-0.375, 0.25, -0.0625, -0.3125, 0.3125, 0.125}, -- NodeBox12
            {-0.3125, 0.3125, -0.0625, -0.25, 0.375, 0.125}, -- NodeBox13
            {-0.25, 0.375, -0.0625, -0.1875, 0.4375, 0.125}, -- NodeBox14
            {-0.3125, -0.375, 0, -0.25, 0.3125, 0.0625}, -- NodeBox15
            {-0.1875, -0.25, 0, -0.125, 0.4375, 0.0625}, -- NodeBox16
            {-0.0625, -0.125, 0, 0, 0.4375, 0.0625}, -- NodeBox17
            {0.0625, 0, 0, 0.125, 0.4375, 0.0625}, -- NodeBox18
            {0.1875, 0.09375, 0, 0.25, 0.4375, 0.0625}, -- NodeBox19
            {0.3125, 0.25, 0, 0.375, 0.4375, 0.0625}, -- NodeBox20
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.125}, -- NodeBox1
        }
    },
    groups = {instrument=1, cracky=1}
})

minetest.register_craftitem ("soundblocks:harp_strings", {
    description     = "Harp Strings"      ,
    inventory_image = "soundblocks_harp_strings.png" ,
})

minetest.register_craft ({
    output = "soundblocks:harp_strings" ,
    recipe = {
{ "farming:string" , "default:gold_ingot" , "farming:string" } ,
{ "farming:string" , "default:gold_ingot" , "farming:string" } ,
{ "farming:string" , "default:gold_ingot" , "farming:string" } ,
    }
})

minetest.register_craft ({
    output = "soundblocks:harp",
    recipe = {
{ ""                   , "default:gold_ingot"           , ""                   } ,
{ "default:gold_ingot" , "soundblocks:harp_strings" , "default:gold_ingot" } ,
{ "default:gold_ingot" , "default:gold_ingot"           , ""                   } ,
    }
})

-- [Gold] Gong

minetest.register_node("soundblocks:gong", {
    description = "Gong",
    tiles = {"default_gold_block.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    on_punch = function(pos, node, player, pointed_thing)
        minetest.sound_play("soundblocks_gong", {
            pos= pos,
            max_hear_distance = 400,
            gain = 1,
        })
    end,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox1
            {0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
            {-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox3
            {-0.1875, -0.1875, -0.0625, 0.1875, 0.1875, 0}, -- NodeBox5
            {-0.375, -0.3125, 0, -0.1875, 0.3125, 0.0625}, -- NodeBox6
            {0.125, -0.3125, 0, 0.3125, 0.3125, 0.0625}, -- NodeBox7
            {-0.3125, 0.125, 0, 0.3125, 0.3125, 0.0625}, -- NodeBox8
            {-0.375, -0.3125, 0, 0.3125, -0.125, 0.0625}, -- NodeBox9
            {-0.3125, 0.25, 0, -0.25, 0.5, 0.0625}, -- NodeBox10
            {0.1875, 0.25, 0, 0.25, 0.5, 0.0625}, -- NodeBox11
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.125}, -- NodeBox1
        }
    },
    groups = {instrument=1, cracky=1}
})

minetest.register_craft ({
    output = "soundblocks:gong" ,
    recipe = {
{ "default:stick" , "default:stick"      , "default:stick" } ,
{ "default:stick" , "default:gold_ingot" , "default:stick" } ,
{ "default:stick" , ""                   , "default:stick" } ,
    }
})

-- Trumpet

minetest.register_craftitem ("soundblocks:trumpet", {
    description     = "Trumpet" ,
    inventory_image = "soundblocks_trumpet.png" ,
    on_use          = function (itemstack, user)
        minetest.sound_play ("soundblocks_trumpet", {
            pos = user:getpos()     ,
            max_hear_distance = 400 ,
            gain              =   1 ,
        })
    end ,
    groups = {instrument=1}
})


minetest.register_craft ({
    output = "soundblocks:trumpet" ,
    recipe = {
{ "default:gold_ingot" , ""                   , ""                   } ,
{ "default:gold_ingot" , "default:gold_ingot" , "default:gold_ingot" } ,
{ "default:gold_ingot" , ""					  , ""                   } ,
    }
})

-- Fanfare

minetest.register_craftitem ("soundblocks:fanfare", {
    description     = "Fanfare" ,
    inventory_image = "soundblocks_fanfare.png" ,
    on_use          = function (itemstack, user)
        minetest.sound_play ("soundblocks_fanfare", {
            pos = user:getpos()     ,
            max_hear_distance = 400 ,
            gain              =   1 ,
        })
    end ,
    groups = {instrument=1}
})

minetest.register_craft ({
    output = "soundblocks:fanfare" ,
    recipe = {
{ "default:gold_ingot" , ""                   , ""                   } ,
{ "default:gold_ingot" , "default:gold_ingot" , "default:gold_ingot" } ,
{ "default:gold_ingot" , "group:wool"         , ""                   } ,
    }
})

--Small Horn

minetest.register_craftitem ("soundblocks:smallhorn", {
    description     = "Small Horn"         ,
    inventory_image = "soundblocks_horn.png" ,
    on_use          = function (itemstack, user)
        minetest.sound_play ("HornSmall", {
            pos               = user:getpos() ,
            max_hear_distance = 400           ,
            gain              = 1             ,
        })
    end,
    groups = {instrument=1}
})

minetest.register_craft ({
    output = "soundblocks:smallhorn",
    recipe = {
{ "group:wood" , ""           , ""              } ,
{ ""           , "group:wood" , ""              } ,
{ ""           , ""           , "default:stick" } ,
    }
})

--Bell

minetest.register_node("soundblocks:bell_gold", {
    description = "Golden Bell",
    tiles = {"default_gold_block.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    on_punch = function(pos, node, player, pointed_thing)
        minetest.sound_play("BellGold", {
            pos= pos,
            max_hear_distance = 2400,
            gain = 1,
        })
    end,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox1
            {-0.0625, -0.4375, -0.0625, 0.0625, 0.5, 0.0625}, -- NodeBox2
            {-0.5, -0.5, 0.4375, 0.5, -0.375, 0.5}, -- NodeBox3
            {-0.5, -0.5, -0.5, 0.5, -0.375, -0.4375}, -- NodeBox4
            {0.4375, -0.5, -0.5, 0.5, -0.375, 0.5}, -- NodeBox5
            {-0.5, -0.5, -0.5, -0.4375, -0.375, 0.5}, -- NodeBox6
            {-0.4375, -0.4375, -0.4375, -0.375, -0.125, 0.4375}, -- NodeBox7
            {-0.4375, -0.4375, 0.375, 0.4375, -0.125, 0.4375}, -- NodeBox8
            {-0.4375, -0.4375, -0.4375, 0.4375, -0.125, -0.375}, -- NodeBox9
            {0.375, -0.4375, -0.4375, 0.4375, -0.125, 0.4375}, -- NodeBox10
            {-0.375, -0.1875, -0.375, -0.3125, 0.25, 0.375}, -- NodeBox11
            {-0.375, -0.1875, 0.3125, 0.375, 0.25, 0.375}, -- NodeBox12
            {-0.375, -0.1875, -0.375, 0.375, 0.25, -0.3125}, -- NodeBox13
            {0.3125, -0.1875, -0.375, 0.375, 0.25, 0.375}, -- NodeBox14
            {-0.3125, 0.1875, -0.3125, 0.3125, 0.375, 0.3125}, -- NodeBox15
            {-0.1875, 0.375, -0.1875, 0.1875, 0.4375, 0.1875}, -- NodeBox16
        }
    },
    groups = {instrument=1, cracky=1}
})

minetest.register_node("soundblocks:bell", {
    description = "Cast Iron Bell",
    tiles = {"default_stone.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    on_punch = function(pos, node, player, pointed_thing)
        minetest.sound_play("BellLarge", {
            pos= pos,
            max_hear_distance = 2400,
            gain = 1,
        })
    end,
    
    node_box = {
        type = "fixed",
        fixed = {
            {-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox1
            {-0.0625, -0.4375, -0.0625, 0.0625, 0.5, 0.0625}, -- NodeBox2
            {-0.5, -0.5, 0.4375, 0.5, -0.375, 0.5}, -- NodeBox3
            {-0.5, -0.5, -0.5, 0.5, -0.375, -0.4375}, -- NodeBox4
            {0.4375, -0.5, -0.5, 0.5, -0.375, 0.5}, -- NodeBox5
            {-0.5, -0.5, -0.5, -0.4375, -0.375, 0.5}, -- NodeBox6
            {-0.4375, -0.4375, -0.4375, -0.375, -0.125, 0.4375}, -- NodeBox7
            {-0.4375, -0.4375, 0.375, 0.4375, -0.125, 0.4375}, -- NodeBox8
            {-0.4375, -0.4375, -0.4375, 0.4375, -0.125, -0.375}, -- NodeBox9
            {0.375, -0.4375, -0.4375, 0.4375, -0.125, 0.4375}, -- NodeBox10
            {-0.375, -0.1875, -0.375, -0.3125, 0.25, 0.375}, -- NodeBox11
            {-0.375, -0.1875, 0.3125, 0.375, 0.25, 0.375}, -- NodeBox12
            {-0.375, -0.1875, -0.375, 0.375, 0.25, -0.3125}, -- NodeBox13
            {0.3125, -0.1875, -0.375, 0.375, 0.25, 0.375}, -- NodeBox14
            {-0.3125, 0.1875, -0.3125, 0.3125, 0.375, 0.3125}, -- NodeBox15
            {-0.1875, 0.375, -0.1875, 0.1875, 0.4375, 0.1875}, -- NodeBox16
        }
    },
    groups = {instrument=1, cracky=1}
})

minetest.register_craftitem("soundblocks:ironbellitem", {
    description = "Small Iron Bell",
    inventory_image = "soundblocks_ironbellitem.png",
    on_use = function (itemstack, user)
        minetest.sound_play ("BellSmall", {
            pos               = user:getpos() ,
            max_hear_distance = 100            ,
            gain              = 1             ,
        })
    end,
})

minetest.register_craftitem("soundblocks:goldbellitem", {
    description = "Small Golden Bell",
    inventory_image = "soundblocks_goldbellitem.png",
    on_use = function (itemstack, user)
        minetest.sound_play ("BellSmallGold", {
            pos               = user:getpos() ,
            max_hear_distance = 100            ,
            gain              = 1             ,
        })
    end,
})

minetest.register_craft({
    output = "soundblocks:goldbellitem",
    recipe = {
{"default:stick"},
{"default:gold_ingot"},
    }
})

minetest.register_craft({
    output = "soundblocks:ironbellitem",
    recipe = {
{"default:stick"},
{"default:steel_ingot"},
    }
})

minetest.register_craft({
    output = "soundblocks:bell",
    recipe = {
{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot" } ,
{"default:steel_ingot", "default:stick", "default:steel_ingot"} ,
    }
})

minetest.register_craft({
    output = "soundblocks:bell_gold",
    recipe = {
{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot" } ,
{"default:gold_ingot", "default:stick", "default:gold_ingot"} ,
    }
})

local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/meltdown.lua")