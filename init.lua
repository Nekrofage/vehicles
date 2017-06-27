vehicles = {}

dofile(minetest.get_modpath("vehicles").."/api.lua")

local step = 1.1

minetest.register_entity("vehicles:assaultsuit", {
	visual = "mesh",
	mesh = "assaultsuit.b3d",
	textures = {"vehicles_assaultsuit.png"},
	velocity = 15,
	acceleration = -5,
	owner = "",
	stepheight = 1.5,
	hp_max = 200,
	physical = true,
	collisionbox = {-0.8, 0, -0.8, 0.8, 3, 0.8},
	on_rightclick = function(self, clicker)
		if self.driver and clicker == self.driver then
		object_detach(self, clicker, {x=1, y=0, z=1})
		elseif not self.driver then
		object_attach(self, clicker, {x=0, y=5, z=4}, false, {x=0, y=20, z=8})
		end
	end,
	on_punch = function(self, puncher)
		if not self.driver then
		local name = self.object:get_luaentity().name
		local pos = self.object:getpos()
		minetest.env:add_item(pos, name.."_spawner")
		self.object:remove()
		end
		if self.object:get_hp() == 0 then
		if self.driver then
		object_detach(self, self.driver, {x=1, y=0, z=1})
		end
		explode(self, 5)
		end
	end,
	on_step = function(self, dtime)
	if self.driver then
		object_drive(self, dtime, 6, 0.5, true, "vehicles:bullet", 0.2, {x=120, y=140}, {x=1, y=1}, "hover", {x=60, y=70}, {x=40, y=51}, 3.5)
		self.standing = false
		return false
	else
	if not standing then
		self.object:set_animation({x=1, y=1}, 20, 0)
		self.standing = true
	end
		end
		return true
	end,
})

register_vehicle_spawner("vehicles:assaultsuit", "Assault Suit", "vehicles_assaultsuit_inv.png")

