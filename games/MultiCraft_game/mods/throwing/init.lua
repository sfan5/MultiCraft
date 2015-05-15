if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
dofile(multicraft.get_modpath("throwing").."/arrow.lua")

arrows = {
    {"throwing:arrow", "throwing:arrow_entity"},
}

local throwing_shoot_arrow = function(itemstack, player)
    for _,arrow in ipairs(arrows) do
        if player:get_inventory():get_stack("main", player:get_wield_index()+1):get_name() == arrow[1] then
                player:get_inventory():remove_item("main", arrow[1])
            local playerpos = player:getpos()
            local obj = multicraft.add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, arrow[2])
            local dir = player:get_look_dir()
            obj:setvelocity({x=dir.x*19, y=dir.y*19, z=dir.z*19})
            obj:setacceleration({x=dir.x*-3, y=-10, z=dir.z*-3})
            obj:setyaw(player:get_look_yaw()+math.pi)
            multicraft.sound_play("throwing_sound", {pos=playerpos})
            if obj:get_luaentity().player == "" then
                obj:get_luaentity().player = player
            end
            obj:get_luaentity().node = player:get_inventory():get_stack("main", 1):get_name()
            return true
        end
    end
    return false
end

multicraft.register_tool("throwing:bow", {
    description = "Bow",
    inventory_image = "throwing_bow.png",
    stack_max = 1,
    groups = {combat = 1},
    on_place = function(itemstack, placer, pointed_thing)
        wear = itemstack:get_wear()
        itemstack:replace("throwing:bow_0")
        itemstack:add_wear(wear)
        return itemstack
    end,
    on_use = function(itemstack, user, pointed_thing)
        wear = itemstack:get_wear()
        itemstack:add_wear(wear)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
            if not multicraft.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/385)
            end
        end
    return itemstack
    end,
})

multicraft.register_tool("throwing:bow_0", {
    description = "Bow",
    inventory_image = "throwing_bow_0.png",
    stack_max = 1,
    groups = {not_in_creative_inventory=1},
    on_place = function(itemstack, placer, pointed_thing)
        wear = itemstack:get_wear()
        itemstack:replace("throwing:bow_1")
        itemstack:add_wear(wear)
        return itemstack
    end,
        on_use = function(itemstack, user, pointed_thing)
        wear = itemstack:get_wear()
        itemstack:add_wear(wear)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
            if not multicraft.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/385)
            end
        end
    return itemstack
    end,
})

multicraft.register_tool("throwing:bow_1", {
    description = "Bow",
    inventory_image = "throwing_bow_1.png",
    stack_max = 1,
    groups = {not_in_creative_inventory=1},
    on_place = function(itemstack, placer, pointed_thing)
        wear = itemstack:get_wear()
        itemstack:replace("throwing:bow_2")
        itemstack:add_wear(wear)
        return itemstack
    end,
    on_use = function(itemstack, user, pointed_thing)
        wear = itemstack:get_wear()
        itemstack:add_wear(wear)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
            if not multicraft.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/385)
            end
        end
    return itemstack
    end,
})

multicraft.register_tool("throwing:bow_2", {
    description = "Bow",
    inventory_image = "throwing_bow_2.png",
    stack_max = 1,
    groups = {not_in_creative_inventory=1},
    on_use = function(itemstack, user, pointed_thing)
        wear = itemstack:get_wear()
        itemstack:replace("throwing:bow")
        itemstack:add_wear(wear)
        if throwing_shoot_arrow(itemstack, user, pointed_thing) then
            if not multicraft.setting_getbool("creative_mode") then
                itemstack:add_wear(65535/385)
            end
        end
        return itemstack
    end,
})

multicraft.register_craft({
    output = 'throwing:bow',
    recipe = {
        {'', 'default:wood', 'default:string'},
        {'default:wood', '', 'default:string'},
        {'', 'default:wood', 'default:string'},
    }
})

