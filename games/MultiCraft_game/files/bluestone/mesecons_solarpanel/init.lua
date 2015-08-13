if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
local boxes = { -8/16, -8/16, -8/16,  8/16, -2/16, 8/16 } -- Solar Pannel

-- Solar Panel
multicraft.register_node("mesecons_solarpanel:solar_panel_on", {
    drawtype = "nodebox",
    tiles = { "jeija_solar_panel.png","jeija_solar_panel.png","jeija_solar_panel_side.png",
    "jeija_solar_panel_side.png","jeija_solar_panel_side.png","jeija_solar_panel_side.png", },
    wield_image = "jeija_solar_panel.png",
    paramtype = "light",
    walkable = false,
    is_ground_content = true,
    selection_box = {
        type = "fixed",
        fixed = boxes
    },
    node_box = {
        type = "fixed",
        fixed = boxes
    },
    drop = "mesecons_solarpanel:solar_panel_off",
    groups = {dig_immediate=3, not_in_creative_inventory = 1},
    sounds = default.node_sound_glass_defaults(),
    mesecons = {receptor = {
        state = mesecon.state.on
    }}
})

-- Solar Panel
multicraft.register_node("mesecons_solarpanel:solar_panel_off", {
    drawtype = "nodebox",
    tiles = { "jeija_solar_panel.png","jeija_solar_panel.png","jeija_solar_panel_side.png",
    "jeija_solar_panel_side.png","jeija_solar_panel_side.png","jeija_solar_panel_side.png", },
    wield_image = "jeija_solar_panel.png",
    paramtype = "light",
    walkable = false,
    is_ground_content = true,
        selection_box = {
        type = "fixed",
        fixed = boxes
    },
    node_box = {
        type = "fixed",
        fixed = boxes
    },
    groups = {dig_immediate=3, mese = 1},
        description="Solar Panel",
    sounds = default.node_sound_glass_defaults(),
    mesecons = {receptor = {
        state = mesecon.state.off
    }}
})

multicraft.register_craft({
    output = '"mesecons_solarpanel:solar_panel_off" 1',
    recipe = {
        {'default:glass', 'default:glass', 'default:glass'},
        {'default:glass', 'default:glass', 'default:glass'},
        {'default:restone_dust', 'default:restone_dust', 'default:restone_dust'},
    }
})

multicraft.register_abm(
    {nodenames = {"mesecons_solarpanel:solar_panel_off"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local light = multicraft.get_node_light(pos, nil)

        if light >= 12 and multicraft.get_timeofday() > 0.2 and multicraft.get_timeofday() < 0.8 then
            multicraft.set_node(pos, {name="mesecons_solarpanel:solar_panel_on", param2=node.param2})
            mesecon:receptor_on(pos)
        end
    end,
})

multicraft.register_abm(
    {nodenames = {"mesecons_solarpanel:solar_panel_on"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local light = multicraft.get_node_light(pos, nil)

        if light < 12 then
            multicraft.set_node(pos, {name="mesecons_solarpanel:solar_panel_off", param2=node.param2})
            mesecon:receptor_off(pos)
        end
    end,
})

--- Solar panel inversed

-- Solar Panel
multicraft.register_node("mesecons_solarpanel:solar_panel_inverted_on", {
    drawtype = "nodebox",
    tiles = { "jeija_solar_panel_inverted.png","jeija_solar_panel_inverted.png","jeija_solar_panel_side.png",
    "jeija_solar_panel_side.png","jeija_solar_panel_side.png","jeija_solar_panel_side.png", },
    wield_image = "jeija_solar_panel_inverted.png",
    paramtype = "light",
    walkable = false,
    is_ground_content = true,
    selection_box = {
        type = "fixed",
        fixed = boxes
    },
    node_box = {
        type = "fixed",
        fixed = boxes
    },
    drop = "mesecons_solarpanel:solar_panel_inverted_off",
    groups = {dig_immediate=3, not_in_creative_inventory = 1},
    sounds = default.node_sound_glass_defaults(),
    mesecons = {receptor = {
        state = mesecon.state.on
    }}
})

-- Solar Panel
multicraft.register_node("mesecons_solarpanel:solar_panel_inverted_off", {
    drawtype = "nodebox",
    tiles = { "jeija_solar_panel_inverted.png","jeija_solar_panel_inverted.png","jeija_solar_panel_side.png",
    "jeija_solar_panel_side.png","jeija_solar_panel_side.png","jeija_solar_panel_side.png", },
    wield_image = "jeija_solar_panel_inverted.png",
    paramtype = "light",
    walkable = false,
    is_ground_content = true,
        selection_box = {
        type = "fixed",
        fixed = boxes
    },
    node_box = {
        type = "fixed",
        fixed = boxes
    },
    groups = {dig_immediate=3, mese =1},
        description="Solar Panel Inverted",
    sounds = default.node_sound_glass_defaults(),
    mesecons = {receptor = {
        state = mesecon.state.off
    }}
})

multicraft.register_craft({
    output = '"mesecons_solarpanel:solar_panel_inverted_off" 1',
    recipe = {
        {'default:restone_dust', 'default:restone_dust', 'default:restone_dust'},
        {'default:glass', 'default:glass', 'default:glass'},
        {'default:glass', 'default:glass', 'default:glass'},
    }
})

multicraft.register_abm(
    {nodenames = {"mesecons_solarpanel:solar_panel_inverted_off"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local light = multicraft.get_node_light(pos, nil)

        if light < 12 then
            multicraft.set_node(pos, {name="mesecons_solarpanel:solar_panel_inverted_on", param2=node.param2})
            mesecon:receptor_on(pos)
        end
    end,
})

multicraft.register_abm(
    {nodenames = {"mesecons_solarpanel:solar_panel_inverted_on"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local light = multicraft.get_node_light(pos, nil)

        if light >= 12 and multicraft.get_timeofday() > 0.8 and multicraft.get_timeofday() < 0.2 then
            multicraft.set_node(pos, {name="mesecons_solarpanel:solar_panel_inverted_off", param2=node.param2})
            mesecon:receptor_off(pos)
        end
    end,
})

