if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
--if multicraft.setting_get("keepInventory") == false then
    multicraft.register_on_dieplayer(function(player)
        local inv = player:get_inventory()
        local pos = player:getpos()
        for i,stack in ipairs(inv:get_list("main")) do
            local x = math.random(0, 9)/3
            local z = math.random(0, 9)/3
            pos.x = pos.x + x
            pos.z = pos.z + z
            multicraft.add_item(pos, stack)
            stack:clear()
            inv:set_stack("main", i, stack)
            pos.x = pos.x - x
            pos.z = pos.z - z
        end
    end)
--end