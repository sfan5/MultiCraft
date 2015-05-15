if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
-- dofile(multicraft.get_modpath("mesecons_extrawires").."/crossing.lua");
-- The crossing code is not active right now because it is hard to maintain
dofile(multicraft.get_modpath("mesecons_extrawires").."/mesewire.lua");
