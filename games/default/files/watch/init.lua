function round(num)
	return math.floor(num + 0.5)
end

minetest.register_playerstep(function(dtime, playernames)
	local now = round((minetest.get_timeofday() * 24) % 12)
	if now == 12 then now = 0 end
	for i, name in ipairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			local item = player:get_wielded_item()
			if item and string.sub(item:get_name(), 0, 6) == "watch:" then
				player:set_wielded_item("watch:"..now)
			end
			for i,stack in ipairs(player:get_inventory():get_list("main")) do
				if i<9 and string.sub(stack:get_name(), 0, 6) == "watch:" then
					player:get_inventory():remove_item("main", stack:get_name())
					player:get_inventory():add_item("main", "watch:"..now)
				end
			end
		end
	end
end, minetest.is_singleplayer()) -- Force step in singlplayer mode only

local images = {
	"watch_0.png",
	"watch_1.png",
	"watch_2.png",
	"watch_3.png",
	"watch_4.png",
	"watch_5.png",
	"watch_6.png",
	"watch_7.png",
	"watch_8.png",
	"watch_9.png",
	"watch_10.png",
	"watch_11.png",
}

local i
for i, img in ipairs(images) do
	local inv = 1
	if i == 1 then
		inv = 0
	end
	minetest.register_tool("watch:"..(i-1), {
		description = "Watch",
		inventory_image = img,
		groups = {not_in_creative_inventory=inv}
	})
end

minetest.register_craft({
	output = "watch:0",
	recipe = {
		{"", "default:gold_ingot", ""},
		{"default:gold_ingot", "mesecons:wire_00000000_off", "default:gold_ingot"},
		{"", "default:gold_ingot", ""}
	}
})
