local radius = 8
local height = 4
local freq = 2
local kpos = {}

if PLATFORM == "Android" or PLATFORM == "iOS" then
	local radius = 4
	local height = 2
	local freq = 3
end

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()

	for i = 1, inv:get_size("main") do
		local stack = inv:get_stack("main", i)
		local itemname = stack:get_name()

		if not minetest.registered_items[itemname] then
			inv:set_stack("main", i, "")
		end
	end
end)

local function clean()
	local players = minetest.get_connected_players()
	for i = 1, #players do
		local player = players[i]
		local pos = player:get_pos()

		for x = -radius, radius do
		for y = -height, height do
		for z = -radius, radius do
			local pos_scan = vector.new(pos.x + x, pos.y + y, pos.z + z)
			if not minetest.is_valid_pos(pos_scan) then
				return
			end
			--local hash = minetest.hash_node_position(pos_scan)
			local nodename = minetest.get_node(pos_scan).name

			--[[if not kpos[hash] then
				local nodename = minetest.get_node(pos_scan).name

				if not minetest.registered_nodes[nodename] then
					minetest.remove_node(pos_scan)
				end

				kpos[hash] = true]]
			if not minetest.registered_nodes[nodename] then
				minetest.remove_node(pos_scan)
			end

			local objs = minetest.get_objects_inside_radius(pos_scan, 0.5)
			if #objs > 0 then
				for j = 1, #objs do
					local obj = objs[j]
					if not obj:is_player() then
						local entname = obj:get_entity_name()
						if not minetest.registered_entities[entname] then
							obj:remove()
						end
					end
				end
			end
		end
		end
		end
	end

	minetest.after(freq, clean)
end

minetest.after(freq, clean)
