local arrows = {
	{"throwing:arrow", "throwing:arrow_entity"},
}
local creative = minetest.settings:get_bool("creative_mode")

local function arrow_impact(thrower, pos, dir, hit_object)
	if hit_object then
		local punch_damage = {
			full_punch_interval = 1.0,
			damage_groups = {fleshy=5},
		}
		hit_object:punch(thrower, 1.0, punch_damage, dir)
	end
	minetest.add_item(pos, "throwing:arrow")
end

local throwing_shoot_arrow = function(itemstack, player)
	for _,arrow in ipairs(arrows) do
		if player:get_inventory():get_stack("main",
				player:get_wield_index() + 1):get_name() == arrow[1] then
			if not creative or not minetest.is_singleplayer()then
				player:get_inventory():remove_item("main", arrow[1])
			end
			local playerpos = player:get_pos()
			if not minetest.is_valid_pos(playerpos) then
				return
			end
			local obj = minetest.item_throw("throwing:arrow_box", player,
				19, -3, arrow_impact)
			if obj then
				local ent = obj:get_luaentity()
				if ent then
					minetest.sound_play("throwing_sound", {
						pos = playerpos,
						gain = 0.7,
						max_hear_distance = 10,
					})
					obj:set_yaw(player:get_look_yaw() + math.pi)
					return true
				else
					obj:remove()
				end
			end
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
		local wear = itemstack:get_wear()
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
		local wear = itemstack:get_wear()
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

minetest.register_node("throwing:arrow_box", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- Shaft
			{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
			--Spitze
			{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
			{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
			--Federn
			{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
			{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
			{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
			{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},

			{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
			{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
			{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
			{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
		}
	},
	tiles = {
		"throwing_arrow.png", "throwing_arrow.png", "throwing_arrow_back.png",
		"throwing_arrow_front.png", "throwing_arrow_2.png", "throwing_arrow.png"
	},
	groups = {not_in_creative_inventory=1},
})

minetest.register_craft({
	output = 'throwing:bow',
	recipe = {
		{'', 'default:wood', 'farming:string'},
		{'default:wood', '', 'farming:string'},
		{'', 'default:wood', 'farming:string'},
	}
})

minetest.register_craftitem("throwing:arrow", {
	description = "Arrow",
	inventory_image = "throwing_arrow_inv.png",
})

minetest.register_craft({
	output = 'throwing:arrow 4',
	recipe = {
		{'fire:flint_and_steel'},
		{'default:stick'},
		{'default:paper'}
	}
})

-- Legacy support

minetest.register_entity("throwing:arrow_entity", {
	is_visible = false,
	on_activate = function(self)
		self.object:remove()
	end
})

minetest.register_alias("throwing:bow_0", "throwing:bow_arrow")
minetest.register_alias("throwing:bow_1", "throwing:bow_arrow")
minetest.register_alias("throwing:bow_2", "throwing:bow_arrow")
