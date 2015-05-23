if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
--[[
uniskins = {
	skin = {},
	armor = {},
	wielditem = {},
	default_skin = "character.png",
	default_texture = "uniskins_trans.png",
}

uniskins.update_player_visuals = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	player:set_properties({
		visual = "mesh",
		mesh = "uniskins_character.x",
		textures = {
			self.skin[name],
			self.armor[name],
			self.wielditem[name]
		},
		visual_size = {x=1, y=1},
	})
end

multicraft.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	uniskins.skin[name] = uniskins.default_skin
	uniskins.armor[name] = uniskins.default_texture
	uniskins.wielditem[name] = uniskins.default_texture
	if multicraft.get_modpath("player_textures") then
		local filename = multicraft.get_modpath("player_textures").."/textures/player_"..name
		local f = io.open(filename..".png")
		if f then
			f:close()
			uniskins.skin[name] = "player_"..name..".png"
		end
	end
	if multicraft.get_modpath("skins") then
		local skin = skins.skins[name]
		if skin and skins.get_type(skin) == skins.type.MODEL then
			uniskins.skin[name] = skin..".png"
		end
	end
end)
]]
