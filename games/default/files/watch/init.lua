local hour, inv

local images = {
	"blank.png",
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
	"watch_11.png"
}

for hour, img in ipairs(images) do
	if hour == 1 then
		inv = 0
	else
		inv = 1
	end

	minetest.register_tool("watch:" .. (hour - 1), {
		description = "Watch",
		inventory_image = "watch_watch.png^" .. img,
		groups = {not_in_creative_inventory = inv}
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

minetest.register_playerstep(function(dtime, playernames)
	local now = math.floor((minetest.get_timeofday() * 24) % 12)
	for hour, name in pairs(playernames) do
		local player = minetest.get_player_by_name(name)
		if player and player:is_player() then
			for hour, stack in pairs(player:get_inventory():get_list("main")) do
				if hour < 9 and string.sub(stack:get_name(), 0, 6) == "watch:" then
					player:get_inventory():remove_item("main", stack:get_name())
					player:get_inventory():add_item("main", "watch:" .. now)
				end
			end
		end
	end
end)
