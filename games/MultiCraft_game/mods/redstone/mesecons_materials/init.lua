if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
--GLUE
multicraft.register_craftitem("mesecons_materials:glue", {
    image = "jeija_glue.png",
    on_place_on_ground = multicraft.craftitem_place_item,
    description="Glue",
    groups = {misc = 1},
})

multicraft.register_craft({
    output = '"mesecons_materials:glue" 2',
    type = "cooking",
    recipe = "default:sapling",
    cooktime = 2
})

