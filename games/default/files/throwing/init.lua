arrows = {
	{"throwing:arrow", "throwing:arrow_entity"},
}

local creative = minetest.settings:get_bool("creative_mode")
local wear

local throwing_shoot_arrow = function(itemstack, player)
	for _,arrow in ipairs(arrows) do
		if player:get_inventory():get_stack("main", player:get_wield_index()+1):get_name() == arrow[1] then
			if not creative or not minetest.is_singleplayer()then
				player:get_inventory():remove_item("main", arrow[1])
			end
			local playerpos = player:get_pos()
			local obj = minetest.add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, arrow[2])
			local dir = player:get_look_dir()
			obj:setvelocity({x=dir.x*19, y=dir.y*19, z=dir.z*19})
			obj:set_acceleration({x=dir.x*-3, y=-10, z=dir.z*-3})
			obj:setyaw(player:get_look_yaw()+math.pi)
			minetest.sound_play("throwing_sound", {pos=playerpos})
			if obj:get_luaentity().player == "" then
				obj:get_luaentity().player = player
			end
			obj:get_luaentity().node = player:get_inventory():get_stack("main", 1):get_name()
			return true
		end
	end
	return false
end

minetest.register_tool("throwing:bow", {
	description = "Bow",
	inventory_image = "throwing_bow.png",
	on_use = function(itemstack, user, pointed_thing)
		itemstack:replace("throwing:bow_arrow")
		return itemstack
	end,
})

minetest.register_tool("throwing:bow_arrow", {
	description = "Bow with arrow",
	inventory_image = "throwing_bow_arrow.png",
	groups = {not_in_creative_inventory=1},
	on_place = function(itemstack, user, pointed_thing)
		wear = itemstack:get_wear()
		itemstack:replace("throwing:bow")
		itemstack:add_wear(wear)
		if throwing_shoot_arrow(itemstack, user, pointed_thing) then
			if not creative then
				itemstack:add_wear(65535/385)
			end
		end
	return itemstack
	end,
	on_use = function(itemstack, user, pointed_thing)
		wear = itemstack:get_wear()
		itemstack:replace("throwing:bow")
		itemstack:add_wear(wear)
		if throwing_shoot_arrow(itemstack, user, pointed_thing) then
			if not creative then
				itemstack:add_wear(65535/385)
			end
		end
	return itemstack
	end,
})

minetest.register_craft({
	output = 'throwing:bow',
	recipe = {
		{'', 'default:wood', 'farming:string'},
		{'default:wood', '', 'farming:string'},
		{'', 'default:wood', 'farming:string'},
	}
})

minetest.register_alias("throwing:bow_0", "throwing:bow_arrow")
minetest.register_alias("throwing:bow_1", "throwing:bow_arrow")
minetest.register_alias("throwing:bow_2", "throwing:bow_arrow")

dofile(minetest.get_modpath("throwing").."/arrow.lua")
