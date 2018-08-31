-- painting - in-game painting for minetest

-- THIS MOD CODE AND TEXTURES LICENSED
--                                              <3 TO YOU <3
--              UNDER TERMS OF WTFPL LICENSE

-- 2012, 2013, 2014 obneq aka jin xi

-- picture is drawn using a nodebox to draw the canvas
-- and an entity which has the painting as its texture.
-- this texture is created by minetests internal image
-- compositing engine (see tile.cpp).

-- Edited by Jasper den Ouden (a few commits now)

dofile(minetest.get_modpath("painting").."/crafts.lua")

local hexcols = {
        white = "ffffff", yellow = "fff000",
        orange = "ff6c00", red = "ff0000",
        violet = "8a00ff", blue = "000cff",
        green = "0cff00", magenta = "fc00ff",
        cyan = "00ffea", grey = "bebebe",
        dark_grey = "7b7b7b", black = "000000",
        dark_green = "006400", brown="964b00",
        pink = "ffc0cb"
}

local colors = {}

local revcolors = {
        "white", "dark_green", "grey", "red", "brown", "cyan", "orange", "violet",
        "dark_grey", "pink", "green", "magenta", "yellow", "black", "blue"
}

local thickness = 0.1

-- picture node
local picbox = {
        type = "fixed",
        fixed = { -0.499, -0.499, 0.499, 0.499, 0.499, 0.499 - thickness }
}
local picbox2 = {
        type="fixed",
        fixed={
            {-0.5, -0.5, -0.5, 0.5, -0.5+thickness, 0.5},
            {-0.5, -0.5, -0.5, -0.5, -0.39,  0.5},
            {-0.5, -0.5, -0.5,  0.5, -0.39, -0.5},
            { 0.5, -0.5,  0.5, -0.5, -0.39,  0.5},
            { 0.5, -0.5,  0.5,  0.5, -0.39, -0.5}
        }
}

local current_version = "0.1-juli"
local legacy = {}

-- puts the version before the data
local function get_metastring(data)
        return current_version.."(version)"..data
end

-- Initiate a white grid.
local function initgrid(res)
        local grid, a, x, y = {}, res-1
        for x = 0, a do
                grid[x] = {}
                for y = 0, a do
                        grid[x][y] = colors["white"]
                end
        end
        return grid
end

local function to_imagestring(data, res)
        if not data then
                minetest.log("error", "[painting] missing data")
                return
        end
        local cols = {}
        for y = 0, res - 1 do
                local xs = data[y]
                for x = 0, res - 1 do
                        local col = revcolors[xs[x]]
                        --if col ~= "white" then
                                cols[col] = cols[col] or {}
                                cols[col][#cols[col]+1] = {y, x}
                        --end
                end
        end
        local t,n = {},1
        local groupopen = "([combine:"..res.."x"..res
        for colour,ps in pairs(cols) do
                t[n] = groupopen
                n = n+1
                for _,p in pairs(ps) do
                        local y,x = unpack(p)
                        t[n] = ":"..p[1]..","..p[2].."=white.png"
                        n = n+1
                end
                t[n] = "^[colorize:#"..hexcols[colour]..")^"
                n = n+1
        end
        n = n-1
        if n == 0 then
                minetest.log("error", "[painting] no texels")
                return "white.png"
        end
        t[n] = t[n]:sub(1,-2)
        --print(table.concat(t))
        return table.concat(t)
end

local function dot(v, w)        -- Inproduct.
        return  v.x * w.x + v.y * w.y + v.z * w.z
end

local function intersect(pos, dir, origin, normal)
        local t = -(dot(vector.subtract(pos, origin), normal)) / dot(dir, normal)
        return vector.add(pos, vector.multiply(dir, t))
end

local function clamp(x, min,max)
        return math.max(math.min(x, max),min)
end

minetest.register_node("painting:pic", {
        description = "Picture",
        tiles = { "white.png" },
        inventory_image = "painted.png",
        drawtype = "nodebox",
        sunlight_propagates = true,
        paramtype = "light",
        paramtype2 = "facedir",
        node_box = picbox2,
        selection_box = { type="fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.39, 0.5} },
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2,
                not_in_creative_inventory=1},
        on_rotate = function(pos) return false end,
        --handle that right below, don't drop anything
        drop = "",

        after_dig_node = function(pos, _, oldmetadata, digger)
                --find and remove the entity
                for _,e in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
                        if e:get_luaentity().name == "painting:picent"
                           or e:get_luaentity().name == "painting:picent_notupright" then
                                e:remove()
                        end
                end
                if not oldmetadata.fields["painting:picturedata"] then return end
                local data = legacy.load_itemmeta(oldmetadata.fields["painting:picturedata"])
                --print("DATA OF DIGGED IMAGE");
                --print(dump(data))
                --put picture data back into inventory item
                digger:get_inventory():add_item("main", {
                        name = "painting:paintedcanvas",
                        count = 1,
                        metadata = get_metastring(data)
                })
        end,
        --copy pictures
        on_punch = function(pos, node, player, pointed_thing)
                local meta = minetest.get_meta(pos):to_table()
                if meta == nil then return end
                --print("metadata: painting:picturedata:")
                --print(dump(meta.fields["painting:picturedata"]))
                if not meta.fields["painting:picturedata"] then return end
                local data = legacy.load_itemmeta(meta.fields["painting:picturedata"])
                if not minetest.deserialize(data) then
                        data = minetest.decompress(data)
                        print("tryed to copy old data, convert it to new format")
                end

                --compare resulutions of picture and canvas the player wields
                --if it isn't the same don't copy
                local wname = player:get_wielded_item():get_name()
                local res = tonumber(string.sub(wname, #"painting:canvas_"+1))
                if res == nil then return end
                data_res = minetest.deserialize(data).res
                if data_res == nil then return end
                if res ~= data_res then
                        minetest.chat_send_player(player:get_player_name(),
                                "not same canvas type!")
                        return
                end
                --remove canvas, add picture
                player:get_inventory():remove_item("main", {
                        name = wname,
                        count = 1,
                })
                player:get_inventory():add_item("main", {
                        name = "painting:paintedcanvas",
                        count = 1,
                        metadata = get_metastring(data)
                })
        end
})

local on_activate = function(self, staticdata)
                local pos = self.object:getpos()
                local ldata = legacy.load_itemmeta(minetest.get_meta(pos):get_string("painting:picturedata"))
                local data = minetest.deserialize(ldata)
                -- for backwards compatiblity
                if not data then
                        data = minetest.deserialize(minetest.decompress(ldata))
                        if data then
                                print("loaded old data, converted to new uncompressed")
                        end
                end
                -- end backwards compatiblity
                if not data
                or not data.grid then
                        return
                end
                self.object:set_properties{textures = { to_imagestring(data.grid, data.res) }}
                if data.version ~= current_version then
                        minetest.log("legacy", "[painting] updating placed picture data")
                        if data.version == "nopairs" then
                            legacy.change_to_wallmounted(pos, self.object:getyaw())
                        end
                        data.version = current_version
                        data = minetest.serialize(data)
                        minetest.get_meta(pos):set_string("painting:picturedata", get_metastring(data))
                end
end

-- picture texture entity
minetest.register_entity("painting:picent", {
        collisionbox = { 0, 0, 0, 0, 0, 0 },
        visual = "upright_sprite",
        textures = { "white.png" },

        on_activate = on_activate
})

minetest.register_entity("painting:picent_notupright", {
        collisionbox = { 0, 0, 0, 0, 0, 0 },
        visual = "cube",
        visual_size = { x = 1, y = 0},
        textures = { "white.png" },

        on_activate = on_activate
})

-- Figure where it hits the canvas, in fraction given position and direction.
local function figure_paint_pos_raw(pos, d,od, ppos, l)
        --get player eye level, see player.h line 129
        local player_eye_h = 1.625
        ppos.y = ppos.y + player_eye_h

        local normal = { x = d.x, y = 0, z = d.z }
        local p = intersect(ppos, l, pos, normal)

        local off = -0.5
        pos = vector.add(pos, {x=off*od.x, y=off, z=off*od.z})
        p = vector.subtract(p, pos)
        return math.abs(p.x + p.z), 1 - p.y
end

local dirs = {  -- Directions the painting may be.
        [0] = { x = 0, z = 1 },
        [1] = { x = 1, z = 0 },
        [2] = { x = 0, z =-1 },
        [3] = { x =-1, z = 0 }
}
-- .. idem .. given self and puncher.
local function figure_paint_pos(self, puncher)
        local x,y = figure_paint_pos_raw(self.object:getpos(),
                dirs[self.fd], dirs[(self.fd + 1) % 4],
                puncher:getpos(), puncher:get_look_dir())
        return math.floor(self.res*clamp(x, 0, 1)), math.floor(self.res*clamp(y, 0, 1))
end

local function draw_input(self, name, x,y, as_line)
        local x0 = self.x0
        if as_line and x0 then -- Draw line if requested *and* have a previous position.
                local y0 = self.y0
                local line = vector.twoline(x0-x, y0-y) -- This figures how to do the line.
                for _,coord in pairs(line) do
                        if self.grid then
                                self.grid[x+coord[1]][y+coord[2]] = colors[name]
                        end
                end
        else    -- Draw just single point.
                if self.grid then
                        self.grid[x][y] = colors[name]
                end
        end
        self.x0, self.y0 = x, y -- Update previous position.
        -- Actually update the grid.
        self.object:set_properties{textures = { to_imagestring(self.grid, self.res) }}
end

local paintbox = {
        [0] = { -0.5,-0.5,0,0.5,0.5,0 },
        [1] = { 0,-0.5,-0.5,0,0.5,0.5 }
}

-- Painting as being painted.
minetest.register_entity("painting:paintent", {
        collisionbox = { 0, 0, 0, 0, 0, 0 },
        visual = "upright_sprite",
        textures = { "white.png" },

        on_punch = function(self, puncher)
                --check for brush.
                local name = string.sub(puncher:get_wielded_item():get_name(), #"painting:brush_"+1)
                if not colors[name] then        -- Not one of the brushes; can't paint.
--              minetest.chat_send_all(name)
                        return
                end

                assert(self.object)
                local x,y = figure_paint_pos(self, puncher)
                draw_input(self, name, x,y, puncher:get_player_control().sneak)

                local wielded = puncher:get_wielded_item()      -- Wear down the tool.
                wielded:add_wear(65535/256)
                puncher:set_wielded_item(wielded)
        end,

        on_activate = function(self, staticdata)
                local data = minetest.deserialize(staticdata)
                -- for backwards compatiblity
                if not data then
                        data = minetest.deserialize(minetest.decompress(staticdata))
                        if data then
                                print("loaded old data, converted to new uncompressed")
                        end
                end
                -- end backwards compatiblity
                if not data then
                        return
                end
                self.fd = data.fd
                self.x0, self.y0 = data.x0, data.y0
                self.res = data.res
                self.version = data.version
                self.grid = data.grid
                legacy.fix_grid(self.grid, self.version)
                self.object:set_properties{ textures = { to_imagestring(self.grid, self.res) }}
                if not self.fd then
                        return
                end
                self.object:set_properties{ collisionbox = paintbox[self.fd%2] }
                self.object:set_armor_groups{immortal=1}
        end,

        get_staticdata = function(self)
                return minetest.serialize{fd = self.fd, res = self.res,
                        grid = self.grid, x0 = self.x0, y0 = self.y0, version = self.version
                }
        end
})


--paintedcanvas picture inventory item
minetest.register_craftitem("painting:paintedcanvas", {
        description = "Painted Canvas",
        inventory_image = "painted.png",
        stack_max = 1,
        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory=1 },

        on_place = function(itemstack, placer, pointed_thing)
                --place node
                local pos = pointed_thing.above
                if minetest.is_protected(pos, placer:get_player_name()) then
                        return
                end

                minetest.rotate_node(ItemStack("painting:pic"), placer, pointed_thing)
                local dir = minetest.get_node(pointed_thing.above).param2/4

                -- just pure magic
                local walltoface = {0, 4, 5, 2, 3, 1}
                dir = minetest.wallmounted_to_dir(walltoface[math.floor(dir)+1])
                local wallmounted = minetest.dir_to_wallmounted(dir)
                local yaw = {nil,          --  y
                             nil,          -- -y
                             math.pi/2,    -- x
                             3/2*math.pi,          -- -x
                             0,  -- z
                             math.pi -- -z
                }
                yaw = yaw[wallmounted+1]

                --rotation =
                --save metadata
                local data = legacy.load_itemmeta(itemstack:get_metadata())
                -- for backwards compatiblity
                if not minetest.deserialize(data) then
                        status, data = pcall(minetest.decompress, data)
                        if (status and data) then
                                print("tryed to save old data"..
                                "converted to new uncompressed, save")
                        elseif not status then
                                print("error loading data")
                        end
                end
                -- end backwards compatiblity
                if data == nil then return ItemStack("") end
                minetest.get_meta(pos):set_string("painting:picturedata", get_metastring(data))

                --add entity
                local off = -(0.5 - thickness - 0.01)
                pos.x = pos.x + dir.x * off
                pos.y = pos.y + dir.y * off
                pos.z = pos.z + dir.z * off

                data = minetest.deserialize(data)
                if data == nil then return ItemStack("") end

                local img = to_imagestring(data.grid, data.res)
                print(wallmounted)
                if wallmounted == 0 then
                    local obj = minetest.add_entity(pos, "painting:picent_notupright")
                    obj:set_properties{ textures = { img}}
                elseif wallmounted == 1 then
                    local obj = minetest.add_entity(pos, "painting:picent_notupright")
                    obj:set_properties{ textures = { "white.png", img}}
                else
                    local obj = minetest.add_entity(pos, "painting:picent")
                    obj:set_properties{ textures = { img }}
                    obj:setyaw(yaw)
                end

                return ItemStack("")
        end
})

--canvas inventory items
for i = 4,6 do
        minetest.register_craftitem("painting:canvas_"..2^i, {
                description = "Canvas(" .. 2^i .. ")",
                inventory_image = "default_paper.png",
                stack_max = 99,
        })
end

--canvas for drawing
local canvasbox = {
        type = "fixed",
        fixed = { -0.5, -0.5, 0, 0.5, 0.5, thickness }
}

minetest.register_node("painting:canvasnode", {
        description = "Canvas",
        tiles = { "white.png" },
        inventory_image = "painted.png",
        drawtype = "nodebox",
        sunlight_propagates = true,
        paramtype = "light",
        paramtype2 = "facedir",
        node_box = canvasbox,
        selection_box = canvasbox,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2,
                not_in_creative_inventory=1},

        drop = "",

        after_dig_node = function(pos, oldnode, oldmetadata, digger)
                --get data and remove pixels
                local data = {}
                for _,e in pairs(minetest.get_objects_inside_radius(pos, 0.1)) do
                        e = e:get_luaentity()
                        if e.grid then
                                data.grid = e.grid
                                data.version = e.version
                                data.res = e.res
                                e.object:remove()
                                break
                        end
                end

                pos.y = pos.y-1
                minetest.get_meta(pos):set_int("has_canvas", 0)

                if not data.grid then
                        return
                end
                legacy.fix_grid(data.grid, data.version)
                digger:get_inventory():add_item("main", {
                        name = "painting:paintedcanvas",
                        count = 1,
                        metadata = get_metastring(minetest.serialize(data))
                })
        end
})

local easelbox = { -- Specifies 3d model.
        type = "fixed",
        fixed = {
                --feet
                {-0.4, -0.5, -0.5, -0.3, -0.4, 0.5 },
                { 0.3, -0.5, -0.5,      0.4, -0.4, 0.5 },
                --legs
                {-0.4, -0.4, 0.1, -0.3, 1.5, 0.2 },
                { 0.3, -0.4, 0.1,       0.4, 1.5, 0.2 },
                --shelf
                {-0.5, 0.35, -0.3, 0.5, 0.45, 0.1 }
        }
}

minetest.register_node("painting:easel", {
        description = "Easel",
        tiles = { "default_wood.png" },
        drawtype = "nodebox",
        sunlight_propagates = true,
        paramtype = "light",
        paramtype2 = "facedir",
        node_box = easelbox,
        selection_box = easelbox,

        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },

        on_punch = function(pos, node, player)
                local wield_name = player:get_wielded_item():get_name()
                local name, res = string.match(wield_name, "^([^_]+)_([^_]+)")
                if name ~= "painting:canvas" then       -- Can only put the canvas on there.
                        return
                end

                local meta = minetest.get_meta(pos)
                pos.y = pos.y+1
                if minetest.get_node(pos).name ~= "air" then
                        -- this is not likely going to happen
                        return
                end
                local fd = node.param2
                minetest.add_node(pos, { name = "painting:canvasnode", param2 = fd})

                local dir = dirs[fd]
                pos.x = pos.x - 0.01 * dir.x
                pos.z = pos.z - 0.01 * dir.z

                local obj = minetest.add_entity(pos, "painting:paintent")
                obj:set_properties{ collisionbox = paintbox[fd%2] }
                obj:set_armor_groups{immortal=1}
                obj:setyaw(math.pi * fd / -2)
                local res = tonumber(res) -- Was still string from matching.
                local ent = obj:get_luaentity()
                ent.grid = initgrid(res)
                ent.version = current_version
                ent.res = res
                ent.fd = fd

                meta:set_int("has_canvas", 1)
                player:get_inventory():remove_item("main", ItemStack(wield_name))
        end,

        can_dig = function(pos)
                return minetest.get_meta(pos):get_int("has_canvas") == 0
        end
})

--brushes
local function table_copy(t)
        local t2 = {}
        for k,v in pairs(t) do
                t2[k] = v
        end
        return t2
end

local brush = {
        wield_image = "",
        tool_capabilities = {
                full_punch_interval = 1.0,
                max_drop_level=0,
                groupcaps = {}
        }
}

local textures = {
        white = "white.png", yellow = "yellow.png",
        orange = "orange.png", red = "red.png",
        violet = "violet.png", blue = "blue.png",
        green = "green.png", magenta = "magenta.png",
        cyan = "cyan.png", grey = "grey.png",
        dark_grey = "darkgrey.png", black = "black.png",
        dark_green = "darkgreen.png", brown="brown.png",
        pink = "pink.png"
}

local vage_revcolours = {} -- colours in pairs order
for color, _ in pairs(textures) do
        vage_revcolours[#vage_revcolours+1] = color
        local brush_new = table_copy(brush)
        brush_new.description = color:gsub("^%l", string.upper).." brush"
        brush_new.inventory_image = "painting_brush_stem.png^(painting_brush_head.png^[colorize:#"..hexcols[color]..":255)^painting_brush_head.png"
        minetest.register_tool("painting:brush_"..color, brush_new)
        minetest.register_craft{
                output = "painting:brush_"..color,
                recipe = {
                        {"dye:"..color},
                        {"default:stick"},
                        {"default:stick"}
                }
        }
end

for i, color in ipairs(revcolors) do
        colors[color] = i
end


-- legacy

minetest.register_alias("easel", "painting:easel")
minetest.register_alias("canvas", "painting:canvas_16")

-- fixes the colours which were set by pairs
local function fix_eldest_grid(data)
        if data == nil then
                return
        end
        for y in pairs(data) do
                local xs = data[y]
                for x in pairs(xs) do
                        -- it was done in pairs order
                        xs[x] = colors[vage_revcolours[xs[x]]]
                end
        end
        return data
end

-- possibly updates grid
function legacy.fix_grid(grid, version)
        if version == current_version then
                return
        end

        --[[
        if version == "nopairs" then
                return
        end--]]

        minetest.log("action", "[painting] updating grid")

        fix_eldest_grid(grid)
end

-- gets the data from meta
function legacy.load_itemmeta(data)
        --if not data then
        --      data = current_version.."(version)"..
        local vend = data:find"(version)"
        if not vend then -- the oldest version
                local t = minetest.deserialize(data)
                if t.version then
                        minetest.log("error", "[painting] this musn't happen!")
                end
                minetest.log("action", "[painting] updating painting meta")
                legacy.fix_grid(t.grid)
                return minetest.serialize(t)
        end
        local version = data:sub(1, vend-2)
        data = data:sub(vend+8)
        --if version == current_version then
                return data
        --end
end


minetest.register_node("painting:pic_legacy_facedir", {
        description = "Picture",
        tiles = { "white.png" },
        inventory_image = "painted.png",
        drawtype = "nodebox",
        sunlight_propagates = true,
        paramtype = "light",
        paramtype2 = "facedir",
        node_box = picbox,
        selection_box = picbox,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2,
                not_in_creative_inventory=1},

        --handle that right below, don't drop anything
        drop = "",

        after_dig_node = function(pos, _, oldmetadata, digger)
                --find and remove the entity
                for _,e in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
                        if e:get_luaentity().name == "painting:picent" then
                                e:remove()
                        end
                end
                if not oldmetadata.fields["painting:picturedata"] then return end
                local data = legacy.load_itemmeta(oldmetadata.fields["painting:picturedata"])
                --print("DATA OF DIGGED IMAGE");
                --print(dump(data))
                --put picture data back into inventory item
                digger:get_inventory():add_item("main", {
                        name = "painting:paintedcanvas",
                        count = 1,
                        metadata = get_metastring(data)
                })
        end,
        --copy pictures
        on_punch = function(pos, node, player, pointed_thing)
                local meta = minetest.get_meta(pos):to_table()
                if meta == nil then return end
                --print("metadata: painting:picturedata:")
                --print(dump(meta.fields["painting:picturedata"]))
                if not meta.fields["painting:picturedata"] then return end
                local data = legacy.load_itemmeta(meta.fields["painting:picturedata"])
                if not minetest.deserialize(data) then
                        data = minetest.decompress(data)
                        print("tryed to copy old data, convert it to new format")
                end

                --compare resulutions of picture and canvas the player wields
                --if it isn't the same don't copy
                local wname = player:get_wielded_item():get_name()
                local res = tonumber(string.sub(wname, #"painting:canvas_"+1))
                if res == nil then return end
                data_res = minetest.deserialize(data).res
                if data_res == nil then return end
                if res ~= data_res then
                        minetest.chat_send_player(player:get_player_name(),
                                "not same canvas type!")
                        return
                end
                --remove canvas, add picture
                player:get_inventory():remove_item("main", {
                        name = wname,
                        count = 1,
                })
                player:get_inventory():add_item("main", {
                        name = "painting:paintedcanvas",
                        count = 1,
                        metadata = get_metastring(data)
                })
        end
})


function legacy.change_to_wallmounted(pos, yaw)
    local param2 = minetest.get_node(pos).param2
    minetest.set_node(pos, {name="painting:pic_legacy_facedir", param2=param2})
end

--[[ allows using many colours, doesn't work
function to_imagestring(data, res)
        if not data then
                return
        end
        local t,n = {},1
        local sbc = {}
        for y = 0, res - 1 do
                for x = 0, res - 1 do
                        local col = revcolors[data[x][y] ]
                        sbc[col] = sbc[col] or {}
                        sbc[col][#sbc[col] ] = {x,y}
                end
        end
        for col,ps in pairs(sbc) do
                t[n] = "([combine:"..res.."x"..res..":"
                n = n+1
                for _,p in pairs(ps) do
                        t[n] = p[1]..","..p[2].."=white.png:"
                        n = n+1
                end
                t[n-1] = string.sub(t[n-1], 1,-2)
                t[n] = "^[colorize:"..col..")^"
                n = n+1
        end
        t[n-1] = string.sub(t[n-1], 1,-2)
        return table.concat(t)
end--]]
