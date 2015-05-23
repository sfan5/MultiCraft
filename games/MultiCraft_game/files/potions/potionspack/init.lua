if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
potions.register_potion("Anti Gravity", "purple", 60,
function(itemstack, user, pointed_thing)
	user:set_physics_override(nil, 1.5, 0.5)
	multicraft.chat_send_player(user:get_player_name(), "You have been blessed with Anti Gravity for 60 seconds!")
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(nil,1,1)
	multicraft.chat_send_player(user:get_player_name(), "Anti Gravity has worn off.")
end)

potions.register_potion("Anti Gravity II", "pink", 60,
function(itemstack, user, pointed_thing)
	user:set_physics_override(3, nil, 0.1)
	multicraft.chat_send_player(user:get_player_name(), "You have been blessed with Anti Gravity II for 60 seconds!")
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,nil,1)
	multicraft.chat_send_player(user:get_player_name(), "Anti Gravity II has worn off.")
end)

potions.register_potion("Speed", "lightgrey", 60,
function(itemstack, user, pointed_thing)
	user:set_physics_override(3, 1, 1)
	multicraft.chat_send_player(user:get_player_name(), "You have been blessed with Speed for 60 seconds!")
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,nil,nil)
	multicraft.chat_send_player(user:get_player_name(), "Speed has worn off.")
end)

potions.register_potion("Speed II", "cyan", 60,
function(itemstack, user, pointed_thing)
	user:set_physics_override(5, 1, 1)
	multicraft.chat_send_player(user:get_player_name(), "You have been blessed with Speed II for 60 seconds!")
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,nil,nil)
	multicraft.chat_send_player(user:get_player_name(), "Speed II has worn off.")
end)

potions.register_potion("Inversion", "dull", 60,
function(itemstack, user, pointed_thing)
	user:set_physics_override(1, -1, -0.2)
	multicraft.chat_send_player(user:get_player_name(), "You have been cursed with Inversion for 60 seconds!")
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,1,1)
	multicraft.chat_send_player(user:get_player_name(), "Inversion has worn off.")
end)

potions.register_potion("Confusion", "dull", 60,
function(itemstack, user, pointed_thing)
	user:set_physics_override(-1, nil, nil)
	multicraft.chat_send_player(user:get_player_name(), "You have been cursed with Confusion for 60 seconds!")
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,1,1)
	multicraft.chat_send_player(user:get_player_name(), "Confusion has worn off.")
end)

potions.register_potion("What will this do", "white", 60,
function(itemstack, user, pointed_thing)
	user:set_physics_override(math.random(1, 20), math.random(1, 20), math.random(-4, 2))
	multicraft.chat_send_player(user:get_player_name(), "You have been given unknown powers for good or evil! (60 seconds)")
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,1,1)
	multicraft.chat_send_player(user:get_player_name(), "Unknown powers lost.")
end)

potions.register_potion("Instant Health", "pink", 1,
function(itemstack, user, pointed_thing)
	local hp = user:get_hp()
	user:set_hp(hp + 6)
end,

function(itemstack, user, pointed_thing)
end)

potions.register_potion("Instant Health II", "pink", 1,
function(itemstack, user, pointed_thing)
	local hp = user:get_hp()
	local hp_raise = hp + 12
	user:set_hp(hp_raise)
end,

function(itemstack, user, pointed_thing)
end)

potions.register_potion("Regen", "purple", 35,
function(itemstack, user, pointed_thing)
	regen_I = true
	multicraft.chat_send_player(user:get_player_name(), "Regeneration I for 35 seconds")
	if regen_II == true then
		local regen
		regen = function ( )
			local hp = user:get_hp()
			if hp >= 20 then
				multicraft.after(1, regen)
			elseif hp < 20 then
				user:set_hp(hp + 1)
				multicraft.after(1, regen)
			end
		end
		multicraft.after(1, regen)
	end
end,

function(itemstack, user, pointed_thing)
	regen_I = false
end)

potions.register_potion("Regen II", "purple", 30,
function(itemstack, user, pointed_thing)
	regen_II = true
	multicraft.chat_send_player(user:get_player_name(), "Regeneration II for 30 seconds")
	if regen_II == true then
		local regen
		regen = function ( )
			local hp = user:get_hp()
			if hp >= 20 then
				multicraft.after(.5, regen)
			elseif hp < 20 then
				user:set_hp(hp + 1)
				multicraft.after(.5, regen)
			end
		end
		multicraft.after(.5, regen)
	end
end,

function(itemstack, user, pointed_thing)
	regen_II = false
end)

potions.register_potion("Harming", "red", 1,
function(itemstack, user, pointed_thing)
	local hp = user:get_hp()
	local lower = hp - 3
	user:set_hp(lower)
end,

function(itemstack, user, pointed_thing)
end)

potions.register_potion("Harming II", "red", 1,
function(itemstack, user, pointed_thing)
	local hp = user:get_hp()
	local lower = hp - 6
	user:set_hp(lower)
end,

function(itemstack, user, pointed_thing)
end)
