local dyes = dye.dyes

for i = 1, #dyes do
	local name, desc, desc2 = unpack(dyes[i])

	minetest.register_node("wool:" .. name, {
		description = desc2 .. " " .. Sl("Wool"),
		tiles = {"wool_" .. name .. ".png"},
		is_ground_content = false,
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
				flammable = 3, wool = 1},
		sounds = default.node_sound_wool_defaults()
	})

	minetest.register_craft({
		type = "shapeless",
		output = "wool:" .. name,
		recipe = {"group:dye,color_" .. name, "group:wool"}
	})
end
