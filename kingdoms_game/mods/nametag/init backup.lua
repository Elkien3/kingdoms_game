local hp_bar = {
	physical = false,
    collisionbox = {x=0, y=0, z=0},
	visual = "sprite",
	textures = {"20.png"},
	visual_size = {x=1, y=1/16, z=5},
	wielder = nil,
}

local furnace_bar = {
	physical = false,
    collisionbox = {x=0, y=0, z=0},
	visual = "sprite",
	textures = {"20.png"},
	visual_size = {x=14/16, y=1/20, z=5},
	wielder,
}

function hp_bar:on_step(dtime)
  local wielder = self.wielder
  if wielder == nil then 
     self.object:remove()
     return   
  elseif minetest.env:get_player_by_name(wielder:get_player_name()) == nil then 
     self.object:remove()
     return 
  end
  hp = wielder:get_hp()
  self.object:set_properties({
        textures = {tostring(hp) .. ".png",},
        }
  )   
end

function furnace_bar:on_step(dtime)
  local position = self.wielder
  if position == nil then 
     self.object:remove()
     return   
  end
  if minetest.env:get_node(position).name == "air" then 
     self.object:remove()
     return   
  end
  local meta = minetest.env:get_meta(position)
  local percent = meta:get_string("perc")
  self.object:set_properties({
        textures = {percent .. ".png",},
        }
  )   
end


minetest.register_entity("gauges:hp_bar", hp_bar)

minetest.register_entity("gauges:furnace_bar", furnace_bar)

function add_HP_gauge(pl)
    local pos = pl:getpos()
    local ent = minetest.env:add_entity(pos, "gauges:hp_bar")
    if ent~= nil then
       ent:set_attach(pl, "", {x=0,y=9,z=0}, {x=0,y=0,z=0})
       ent = ent:get_luaentity() 
       ent.wielder = pl       
    end
end

function add_furnace_gauge(pos, newnode, placer, oldnode, itemstack)
    if newnode.name ~= "default:furnace" then
       if  newnode.name ~= "default:furnace_active" then 
           return
       end
    end
    pos.y = pos.y+1
    local ent = minetest.env:add_entity(pos, "gauges:furnace_bar")
    pos.y = pos.y-1
    if ent~= nil then
       ent = ent:get_luaentity() 
       ent.wielder = pos             
    end
end

minetest.register_on_joinplayer(add_HP_gauge)
minetest.register_on_placenode(add_furnace_gauge)














