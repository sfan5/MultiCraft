if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
-- multicraft 0.4 mod: vessels
-- See README.txt for licensing and other information.

multicraft.register_node("vessels:glass_bottle", {
    description = "Glass Bottle (empty)",
    drawtype = "plantlike",
    tiles = {"vessels_glass_bottle.png"},
    inventory_image = "vessels_glass_bottle_inv.png",
    wield_image = "vessels_glass_bottle.png",
    paramtype = "light",
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
    },
    groups = {vessel=1,dig_immediate=3,attached_node=1,brewing = 1},
    sounds = default.node_sound_glass_defaults(),
})

multicraft.register_craft( {
    output = "vessels:glass_bottle 4",
    recipe = {
        { "default:glass", "", "default:glass" },
        { "", "default:glass", "" }
    }
})
