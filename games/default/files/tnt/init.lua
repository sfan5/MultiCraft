local enable_tnt = minetest.settings:get_bool("enable_tnt")
if enable_tnt == nil then
	enable_tnt = minetest.is_singleplayer()
end
local TNT_RANGE = 3

local function spawn_tnt(pos, entname)
	minetest.sound_play("tnt_ignite", {
		pos = pos,
		gain = 1.0,
		max_hear_distance = 16
	})
	return minetest.add_entity(pos, entname)
end

local function activate_tnt(pos)
	minetest.remove_node(pos)
	spawn_tnt(pos, "tnt:tnt")
	minetest.check_for_falling(pos)
end

local function do_tnt_physics(pos, tntr)
	local objs = minetest.get_objects_inside_radius(pos, tntr)
	for k, obj in pairs(objs) do
		local oname = obj:get_luaentity()
		local v = obj:get_velocity()
		local p = obj:get_pos()
		if oname == "tnt:tnt" then
			obj:set_velocity({
				x = (p.x - pos.x) + (tntr / 2) + v.x,
				y = (p.y - pos.y) + tntr + v.y,
				z = (p.z - pos.z) + (tntr / 2) + v.z
			})
		else
			if v ~= nil then
				obj:set_velocity({
					x = (p.x - pos.x) + (tntr / 4) + v.x,
					y = (p.y - pos.y) + (tntr / 2) + v.y,
					z = (p.z - pos.z) + (tntr / 4) + v.z
				})
			else
				if obj:is_player() then
					obj:set_hp(obj:get_hp() - 4)
				end
			end
		end
	end
end

minetest.register_node("tnt:tnt", {
	description = "TNT",
	tiles = {"default_tnt_top.png", "default_tnt_bottom.png", "default_tnt_side.png"},
	groups = {choppy = 1, mese = 1},

	mesecons = {effector = {
		action_on = (function(pos, node)
			activate_tnt(pos)
		end)
	}},

	on_ignite = function(pos, igniter)
		if not minetest.is_protected(pos, igniter) then
			activate_tnt(pos)
		end
	end
})

minetest.register_abm({
	label = "TNT ignition",
	nodenames = {"tnt:tnt"},
	neighbors = {"fire:basic_flame", "default:lava_source", "default:lava_flowing"},
	interval = 3,
	chance = 1,
	action = function(pos, node)
		minetest.remove_node(pos)
		spawn_tnt(pos, "tnt:tnt")
		minetest.check_for_falling(pos)
	end
})

local TNT = {
	physical = true,
	visual = "cube",
	textures = {
		"default_tnt_top.png", "default_tnt_bottom.png",
		"default_tnt_side.png", "default_tnt_side.png",
		"default_tnt_side.png", "default_tnt_side.png"
	},
	-- Initial value for our timer
	timer = 0,
	blinktimer = 0,
	blinkstatus = true
}

function TNT:on_activate(staticdata)
	self.object:set_velocity({x = 0, y = 4, z = 0})
	self.object:set_acceleration({x = 0, y = -10, z = 0})
	self.object:set_texture_mod("^[brighten")
end

function TNT:on_step(dtime)
	local pos = self.object:get_pos()
	minetest.add_particlespawner({
		amount = 1,
		time = 0.1,
		minpos = {x = pos.x, y = pos.y + 0.5, z = pos.z},
		maxpos = {x = pos.x, y = pos.y + 0.5, z = pos.z},
		minvel = {x = -0.1, y = 1, z = 0.1},
		maxvel = {x = 0.1, y = 2, z = 0.1},
		minacc = {x = 0, y = -0.1, z = 0},
		maxacc = {x = 0, y = -0.1, z = 0},
		minexptime = 1,
		maxexptime = 3,
		minsize = 1,
		maxsize = 3,
		texture = "item_smoke.png"
	})
	
	self.timer = self.timer + dtime
	self.blinktimer = self.blinktimer + dtime

	if self.timer > 3 then
		self.blinktimer = self.blinktimer + dtime
		if self.timer > 5 then
			self.blinktimer = self.blinktimer + dtime
		end
	end

	if self.blinktimer > 0.5 then
		self.blinktimer = self.blinktimer - 0.5
		if self.blinkstatus then
			self.object:set_texture_mod("")
		else
			self.object:set_texture_mod("^[brighten")
		end
		self.blinkstatus = not self.blinkstatus
	end

	if self.timer > 5 then
		local pos = self.object:get_pos()
		pos.x = math.floor(pos.x + 0.5)
		pos.y = math.floor(pos.y + 0.5)
		pos.z = math.floor(pos.z + 0.5)
		do_tnt_physics(pos, TNT_RANGE)
		local meta = minetest.get_meta(pos)
		minetest.sound_play("tnt_explode", {
			pos = pos,
			gain = 1.5,
			max_hear_distance = 16
		})
		local nn = core.get_node(pos).name
		if nn == "default:water_source" or nn == "default:water_flowing" or
				nn == "default:bedrock" or nn == "protector:display" or
				nn == "ignore" or not enable_tnt then
			-- Cancel the Explosion
			self.object:remove()
			return
		end

		for x = -TNT_RANGE, TNT_RANGE do
		for y = -TNT_RANGE, TNT_RANGE do
		for z = -TNT_RANGE, TNT_RANGE do
			if x * x + y * y + z * z <= TNT_RANGE * TNT_RANGE + TNT_RANGE then
				local np = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
				local n = core.get_node_or_nil(np)
				if n and n.name ~= "air" and n.name ~= "default:obsidian" and
						n.name ~= "default:bedrock" and n.name ~= "protector:protect" then
					if n.name == "tnt:tnt" then
						spawn_tnt(np, n.name):set_velocity({
							x = (np.x - pos.x) * 5 + 0.75,
							y = (np.y - pos.y) * 5 + 1,
							z = (np.z - pos.z) * 5 + 0.75
						})
					end
					minetest.remove_node(np)
					minetest.check_for_falling(np)
					if math.random(1, 5) == 1 then
						local node_drops = minetest.get_node_drops(n.name, "")
						for _, item in pairs(node_drops) do
							local obj = minetest.add_item(np, item)
						end
					end
				end
			end
		end
		end
		end
		self.object:remove()
	end
end

function TNT:on_punch(puncher, pos)
	if not puncher or self.removed then
		return
	end
	local pos = self.object:get_pos()
	minetest.set_node(pos, {name = "tnt:tnt"})
	self.object:remove()
end

minetest.register_entity("tnt:tnt", TNT)

minetest.register_craft({
	output = "tnt:tnt",
	recipe = {
		{"default:gunpowder", "group:sand", "default:gunpowder"},
		{"group:sand", "default:gunpowder", "group:sand"},
		{"default:gunpowder", "group:sand", "default:gunpowder"}
	}
})
