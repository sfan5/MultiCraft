experience = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

dofile(modpath .. "/override.lua")

local MAX_HUD_XP = 32
local MAX_LEVEL = 40
local ORB_SOUND_INTERVAL = 0.01
local ORB_COLLECT_RADIUS = 3

local xp, hud = {}, {}

local get_objs_rad = minetest.get_objects_inside_radius
local get_players  = minetest.get_connected_players

local vec_new, vec_dist, vec_mul, vec_sub =
	vector.new, vector.distance, vector.multiply, vector.subtract

local function init_data(player, reset)
	local name = player:get_player_name()
	local _xp  = minetest.deserialize(player:get_attribute("xp"))

	if not _xp or reset then
		xp[name] = {
			xp_bar    = 0,
			xp_total  = 0,
			xp_number = 0,
			level     = 0,
		}
	else
		xp[name] = _xp
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	init_data(player)

	hud[name] = {
		-- background (empty bar)
		hud = player:hud_add({
			hud_elem_type = "statbar",
			position  = {x = 0.5, y = 0.97},
			offset    = {x = -191, y = -29},
			scale     = {x = 1,   y = 1},
			alignment = {x = -1,  y = -1},
			text      = "expbar_empty.png",
			number    = MAX_HUD_XP,
		}),

		-- foreground (filling bar)
		hud2 = player:hud_add({
			hud_elem_type = "statbar",
			position  = {x = 0.5,  y = 0.97},
			offset    = {x = -191, y = -29},
			scale     = {x = 1,    y = 1},
			alignment = {x = -1,   y = -1},
			text      = "expbar_full.png",
		}),

		-- level number
		hud3 = player:hud_add({
			hud_elem_type = "text",
			texture   = ("xp_blank"),
			position  = {x = 0.495, y = 0.976},
			offset    = {x = 6, y = -42},
			alignment = {x = -0.5, y = -1},
			number    = 0x3cff00,
			text      = "",
		})
	}
end)

function experience.add_orb(amount, pos)
	if amount == 0 then return end
	for _ = 1, amount do
		local area = vec_new(
			pos.x + math.random(0,5) / 5 - 0.5,
			pos.y,
			pos.z + math.random(0,5) / 5 - 0.5)

		minetest.add_entity(area, "experience:orb")
	end
end

function experience.get_level(name)
	return xp[name].level
end

minetest.register_on_dignode(function(pos, oldnode, digger)
	local name = oldnode.name
	local xp_min = minetest.get_item_group(name, "xp_min")
	local xp_max = minetest.get_item_group(name, "xp_max")

	if xp_min and xp_max and xp_max > 0 then
		experience.add_orb(math.random(xp_min, xp_max), pos)
	end
end)

minetest.register_on_newplayer(function(player)
	init_data(player)
end)

minetest.register_on_dieplayer(function(player)
	init_data(player, true)
end)

minetest.register_globalstep(function(dtime)
	local players = get_players()
	for i = 1, #players do
		local player = players[i]
		local name   = player:get_player_name()
		local pos    = player:get_pos()
		      pos.y  = pos.y + 0.5

		xp[name].timer = (xp[name].timer or 0) + dtime

		for _, obj in ipairs(get_objs_rad(pos, ORB_COLLECT_RADIUS)) do
			local ent = obj:get_luaentity()
			if not obj:is_player() and ent and ent.name == "experience:orb" then
				local orb_pos = obj:get_pos()

				if vec_dist(pos, orb_pos) <= 1 then
					if xp[name].timer >= ((xp[name].last_sound or 0) + ORB_SOUND_INTERVAL) then
						minetest.sound_play("orb", {to_player = name})
						xp[name].last_sound = xp[name].timer
					end

					local inc = 2 * xp[name].level + 7

					if xp[name].level >= 16 then
						inc = 5 * xp[name].level - 38
					elseif xp[name].level >= 31 then
						inc = 9 * xp[name].level - 158
					end

					xp[name].xp_bar = xp[name].xp_bar + (MAX_HUD_XP / inc)
					obj:remove()
				else
					pos.y = pos.y + 0.2
					local vec = vec_mul(vec_sub(pos, orb_pos), 3)
					obj:set_velocity(vec)
				end
			end
		end

		if xp[name].xp_bar >= MAX_HUD_XP then
			if xp[name].level < MAX_LEVEL then
				xp[name].level  = xp[name].level + 1
				xp[name].xp_bar = xp[name].xp_bar - MAX_HUD_XP
			else
				xp[name].xp_bar = MAX_HUD_XP
			end
		end

		player:hud_change(hud[name].hud2, "number", xp[name].xp_bar)
		player:hud_change(hud[name].hud3, "text",   xp[name].level)

		player:hud_change(hud[name].hud3, "offset",
			{x = (xp[name].level >= 10 and 13 or 6), y = -42})
	end
end)

minetest.register_entity("experience:orb", {
	timer        = 0,
	glow         = 12,
	physical     = true,
	textures     = {"orb.png"},
	visual_size  = {x = 0.1, y = 0.1},
	collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	collide_with_objects = false,
	
	on_activate = function(self, staticdata)
		local obj = self.object
		obj:set_armor_groups({immortal = 1})
		obj:set_velocity(vec_new(0, 1, 0))
		obj:set_acceleration(vec_new(0, -9.81, 0))
	end,

	on_step = function(self, dtime)
		local obj = self.object
		self.timer = self.timer + dtime
		self.last_color_change = self.last_color_change or 0
		self.color_ratio = self.color_ratio or 0

		if self.timer > 60 then
			obj:remove()
		elseif self.timer >= self.last_color_change + 0.001 then
			if self.color_ratio >= 120 then
				self.color_back = true
			elseif self.color_ratio <= 0 then
				self.color_back = nil
			end

			self.color_ratio = self.color_ratio + (self.color_back and -10 or 10)
			obj:set_texture_mod("^[colorize:#e5ff02:" .. self.color_ratio)
			self.last_color_change = self.timer
		end
	end,
})

minetest.register_on_shutdown(function()
	local players = get_players()
	for i = 1, #players do
		local player = players[i]
		local name   = player:get_player_name()

		player:set_attribute("xp", minetest.serialize(xp[name]))
	end
end)
