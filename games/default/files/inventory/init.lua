if minetest.settings:get_bool("creative_mode") then
	return
end

local function set_inventory(player)
	local form = default.gui ..
	"background[-0.2,-0.26;9.41,9.49;formspec_inventory_inventory.png]" ..
	"list[current_player;craft;4,1;2,1;1]" ..
	"list[current_player;craft;4,2;2,1;4]" ..
	"list[current_player;craftpreview;7.05,1.53;1,1;]" ..
	"image[1.5,0;2,4;default_player2d.png]" ..
	"image_button[7,3.14;1,1;blank.png;craftguide;;true;false;workbench_button_back.png]" ..
	"image[7,3.14;1,1;craftguide_book.png]" ..
	"tooltip[craftguide;" .. Sl("Crafting Guide") .. ";#000;#FFF]" ..
	"image_button_exit[9.21,2.5;1,1;creative_home_set.png;sethome_set;;true;false]" ..
	"tooltip[sethome_set;" .. Sl("Set Home") .. ";#000;#FFF]" ..
	"image_button_exit[9.21,3.5;1,1;creative_home_go.png;sethome_go;;true;false]" ..
	"tooltip[sethome_go;" .. Sl("Go Home") .. ";#000;#FFF]"
	-- Armor
	if minetest.get_modpath("3d_armor") then
		local player_name = player:get_player_name()
		form = form ..
		"list[detached:" .. player_name .. "_armor;armor;0,0;1,1;]" ..
		"list[detached:" .. player_name .. "_armor;armor;0,1;1,1;1]" ..
		"list[detached:" .. player_name .. "_armor;armor;0,2;1,1;2]" ..
		"list[detached:" .. player_name .. "_armor;armor;0,3;1,1;3]"
	end
	player:set_inventory_formspec(form)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if not player or not player:is_player() then
		return
	end
	-- Drop craft items on closing
	if fields.quit then
		local inv = player:get_inventory()
		for i, stack in pairs(inv:get_list("craft")) do
			minetest.item_drop(stack, player, player:get_pos())
			stack:clear()
			inv:set_stack("craft", i, stack)
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	if inv then
		inv:set_size("main", 9*4)
	end
	set_inventory(player)
end)
