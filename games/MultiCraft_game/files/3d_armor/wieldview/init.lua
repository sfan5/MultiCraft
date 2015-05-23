if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
local time = 0
local update_time = tonumber(multicraft.setting_get("wieldview_update_time"))
if not update_time then
	update_time = 2
	multicraft.setting_set("wieldview_update_time", tostring(update_time))
end
local node_tiles = multicraft.setting_getbool("wieldview_node_tiles")
if not node_tiles then
	node_tiles = false
	multicraft.setting_set("wieldview_node_tiles", "false")
end

wieldview = {
	wielded_item = {},
	transform = {},
}

dofile(multicraft.get_modpath(multicraft.get_current_modname()).."/transform.lua")

wieldview.get_item_texture = function(self, item)
	local texture = "3d_armor_trans.png"
	if item ~= "" then
		if multicraft.registered_items[item] then
			local inventory_image = multicraft.registered_items[item].inventory_image
			if inventory_image and inventory_image ~= "" then
				texture = inventory_image
			elseif node_tiles == true and multicraft.registered_items[item].tiles then
				texture = multicraft.registered_items[item].tiles[1]
			end
		end
		if wieldview.transform[item] then
			texture = texture.."^[transform"..wieldview.transform[item]
		end
	end
	return texture
end

wieldview.update_wielded_item = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local stack = player:get_wielded_item()
	local item = stack:get_name()
	if not item then
		return
	end
	if self.wielded_item[name] then
		if self.wielded_item[name] == item then
			return
		end
		armor.textures[name].wielditem = self:get_item_texture(item)
		armor:update_player_visuals(player)
	end
	self.wielded_item[name] = item
end

multicraft.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	wieldview.wielded_item[name] = ""
	multicraft.after(0, function(player)
		wieldview:update_wielded_item(player)
	end, player)
end)

multicraft.register_globalstep(function(dtime)
	time = time + dtime
	if time > update_time then
		for _,player in ipairs(multicraft.get_connected_players()) do
			wieldview:update_wielded_item(player)
		end
		time = 0
	end
end)