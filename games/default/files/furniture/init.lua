ts_furniture = {}

minetest.register_playerstep(function(dtime, playernames)
	for _, name in pairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			if player_api.player_attached[name] and not player:get_attach() and
					(player:get_player_control().up == true    or
					 player:get_player_control().down == true  or
					 player:get_player_control().left == true  or
					 player:get_player_control().right == true or
					 player:get_player_control().jump == true) then
				player:set_eye_offset({ x = 0, y = 0, z = 0 }, { x = 0, y = 0, z = 0 })
				player:set_physics_override(1, 1, 1)
				player_api.player_attached[player] = false
				player_api.set_animation(player, "stand", 30)
			end
		end
	end
end)

ts_furniture.sit = function(name, pos)
	local player = minetest.get_player_by_name(name)
	if player_api.player_attached[name] then
		player:set_eye_offset({ x = 0, y = 0, z = 0 }, { x = 0, y = 0, z = 0 })
		player:set_physics_override(1, 1, 1)
		player_api.player_attached[name] = false
		player_api.set_animation(player, "stand", 30)
	else
		player:moveto(pos)
		player:set_eye_offset({ x = 0, y = -7, z = 2 }, { x = 0, y = 0, z = 0 })
		player:set_physics_override(0, 0, 0)
		player_api.player_attached[name] = true
		player_api.set_animation(player, "sit", 30)
	end
end

local furnitures = {
	["chair"] = {
		description = "Chair",
		sitting = true,
		nodebox = {
			{ -0.3, -0.5,  0.2, -0.2,  0.5,  0.3 }, -- foot 1
			{  0.2, -0.5,  0.2,  0.3,  0.5,  0.3 }, -- foot 2
			{  0.2, -0.5, -0.3,  0.3, -0.1, -0.2 }, -- foot 3
			{ -0.3, -0.5, -0.3, -0.2, -0.1, -0.2 }, -- foot 4
			{ -0.3, -0.1, -0.3,  0.3,  0,    0.2 }, -- seating
			{ -0.2,  0.1,  0.25, 0.2,  0.4,  0.26 } -- conector 1-2
		},
		craft = function(recipe)
			return {
				{ "", "group:stick" },
				{ recipe, recipe },
				{ "group:stick", "group:stick" }
			}
		end
	},
	["table"] = {
		description = "Table",
		nodebox = {
			{ -0.4, -0.5, -0.4, -0.3, 0.4, -0.3 }, -- foot 1
			{  0.3, -0.5, -0.4,  0.4, 0.4, -0.3 }, -- foot 2
			{ -0.4, -0.5,  0.3, -0.3, 0.4,  0.4 }, -- foot 3
			{  0.3, -0.5,  0.3,  0.4, 0.4,  0.4 }, -- foot 4
			{ -0.5,  0.4, -0.5,  0.5, 0.5,  0.5 }, -- table top
		},
		craft = function(recipe)
			return {
				{ recipe, recipe, recipe },
				{ "group:stick", "", "group:stick" },
				{ "group:stick", "", "group:stick" }
			}
		end
	},
	["small_table"] = {
		description = "Small Table",
		nodebox = {
			{ -0.4, -0.5, -0.4, -0.3, 0.1, -0.3 }, -- foot 1
			{  0.3, -0.5, -0.4,  0.4, 0.1, -0.3 }, -- foot 2
			{ -0.4, -0.5,  0.3, -0.3, 0.1,  0.4 }, -- foot 3
			{  0.3, -0.5,  0.3,  0.4, 0.1,  0.4 }, -- foot 4
			{ -0.5,  0.1, -0.5,  0.5, 0.2,  0.5 }, -- table top
		},
		craft = function(recipe)
			return {
				{ recipe, recipe, recipe },
				{ "group:stick", "", "group:stick" }
			}
		end
	},
	["tiny_table"] = {
		description = "Tiny Table",
		nodebox = {
			{ -0.5, -0.1, -0.5,  0.5,  0,   0.5 }, -- table top
			{ -0.4, -0.5, -0.5, -0.3, -0.1, 0.5 }, -- foot 1
			{  0.3, -0.5, -0.5,  0.4, -0.1, 0.5 }, -- foot 2
		},
		craft = function(recipe)
			local bench_name = "ts_furniture:" .. recipe:gsub(":", "_") .. "_bench"
			return {
				{ bench_name, bench_name }
			}
		end
	},
	["bench"] = {
		description = "Bench",
		sitting = true,
		nodebox = {
			{ -0.5, -0.1, 0,  0.5,  0,   0.5 }, -- seating
			{ -0.4, -0.5, 0, -0.3, -0.1, 0.5 }, -- foot 1
			{  0.3, -0.5, 0,  0.4, -0.1, 0.5 }, -- foot 2
		},
		craft = function(recipe)
			return {
				{ recipe, recipe },
				{ "group:stick", "group:stick" }
			}
		end
	},
}

local ignore_groups = {
	["wood"] = true,
	["stone"] = true,
}

function ts_furniture.register_furniture(recipe, description, texture)
	local recipe_def = minetest.registered_items[recipe]
	if not recipe_def then
		return
	end

	local groups = {falling_node = 1}

	for k, v in pairs(recipe_def.groups) do
		if not ignore_groups[k] then
			groups[k] = v
		end
	end

	for furniture, def in pairs(furnitures) do
		local node_name = "ts_furniture:" .. recipe:gsub(":", "_") .. "_" .. furniture

		def.on_rightclick = nil

		if def.sitting then
			def.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				ts_furniture.sit(player:get_player_name(), pos)
			end
		end

		minetest.register_node(":" .. node_name, {
			description = description .. " " .. def.description,
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			sunlight_propagates = true,
			tiles = { texture },
			groups = groups,
			node_box = {
				type = "fixed",
				fixed = def.nodebox
			},
			on_rightclick = def.on_rightclick
		})

		minetest.register_craft({
			output = node_name,
			recipe = def.craft(recipe)
		})
	end
end

ts_furniture.register_furniture("default:birch_wood", "Birch", "default_birch_wood.png")
ts_furniture.register_furniture("default:pine_wood", "Pine", "default_pine_wood.png")
ts_furniture.register_furniture("default:acacia_wood", "Acacia", "default_acacia_wood.png")
ts_furniture.register_furniture("default:wood", "Wooden", "default_wood.png")
ts_furniture.register_furniture("default:junglewood", "Jungle Wood", "default_junglewood.png")
