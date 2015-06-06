LIGHT_MAX = 15

multicraft.register_craftitem("farming:pumpkin_seed", {
    description = "Pumpkin Seed",
    stack_max = 64,
    inventory_image = "farming_pumpkin_seed.png",
    groups = {materials=1},
    on_place = function(itemstack, placer, pointed_thing)
        local above = multicraft.get_node(pointed_thing.above)
        if above.name == "air" then
            above.name = "farming:pumpkin_1"
            multicraft.set_node(pointed_thing.above, above)
            itemstack:take_item(1)
            return itemstack
        end
    end
})

multicraft.register_node("farming:pumpkin_1", {
    paramtype = "light",
    walkable = false,
    buildable_to = true,
    drawtype = "plantlike",
    sunlight_propagates = true,
    drop = "",
    tiles = {"farming_tige_1.png"},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.5+6/16, 0.5}
        },
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1 ,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})

multicraft.register_node("farming:pumpkin_2", {
    paramtype = "light",
    walkable = false,
    buildable_to = true,
    drawtype = "plantlike",
    sunlight_propagates = true,
    drop = "",
    tiles = {"farming_tige_2.png"},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.5+9/16, 0.5}
        },
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1 ,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})


multicraft.register_node("farming:pumpkin_face", {
    description = "Pumpkin Face",
    stack_max = 64,
    paramtype2 = "facedir",
    tiles = {"farming_pumpkin_top.png", "farming_pumpkin_top.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_face.png"},
    groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, building=1},
    after_dig_node = function(pos, oldnode, oldmetadata, user)
        local have_change = 0
        for x=-1,1 do
                local p = {x=pos.x+x, y=pos.y, z=pos.z}
                local n = multicraft.get_node(p)
            if string.find(n.name, "pumpkintige_linked_") and have_change == 0 then
                    have_change = 1
                    multicraft.add_node(p, {name="farming:pumpkintige_unconnect"})
            end
        end
        if have_change == 0 then
            for z=-1,1 do
                p = {x=pos.x, y=pos.y, z=pos.z+z}
                local n = multicraft.get_node(p)
                if string.find(n.name, "pumpkintige_linked_") and have_change == 0 then
                        have_change = 1
                        multicraft.add_node(p, {name="farming:pumpkintige_unconnect"})
                end
            end
        end
    end
})

multicraft.register_node("farming:pumpkintige_unconnect", {
    paramtype = "light",
    walkable = false,
    sunlight_propagates = true,
    drop = "",
    drawtype = "plantlike",
    tiles = {"farming_tige_end.png"},
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1 ,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})


multicraft.register_node("farming:pumpkintige_linked_r", {
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    drop = "",
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "wallmounted",
    legacy_wallmounted = true,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, 0, 0.5, 0.5, 0}, -- NodeBox1
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0.2, 0.2}
    },
    tiles = {
        "farming_tige_connnect.png", --top
        "farming_tige_connnect.png", -- bottom
        "farming_tige_connnect.png", -- right
        "farming_tige_connnect.png", -- left
        "farming_tige_connnect.png", -- back
        "farming_tige_connnect.png^[transformFX90" --front
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1 ,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})

multicraft.register_node("farming:pumpkintige_linked_l", {
    paramtype = "light",
    walkable = false,
    sunlight_propagates = true,
    drop = "",
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "wallmounted",
    legacy_wallmounted = true,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, 0, 0.5, 0.5, 0}, -- NodeBox1
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0.2, 0.2}
    },
    tiles = {
        "farming_tige_connnect.png", --top
        "farming_tige_connnect.png", -- bottom
        "farming_tige_connnect.png", -- right
        "farming_tige_connnect.png", -- left
        "farming_tige_connnect.png^[transformFX90", -- back
        "farming_tige_connnect.png" --front
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1 ,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})

multicraft.register_node("farming:pumpkintige_linked_t", {
    paramtype = "light",
    walkable = false,
    sunlight_propagates = true,
    drop = "",
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "wallmounted",
    legacy_wallmounted = true,
    node_box = {
        type = "fixed",
        fixed = {
            {0, -0.5, -0.5, 0, 0.5, 0.5}, -- NodeBox1
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0.2, 0.2}
    },
    tiles = {
        "farming_tige_connnect.png", --top
        "farming_tige_connnect.png", -- bottom
        "farming_tige_connnect.png^[transformFX90", -- right
        "farming_tige_connnect.png", -- left
        "farming_tige_connnect.png", -- back
        "farming_tige_connnect.png" --front
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1 ,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})

multicraft.register_node("farming:pumpkintige_linked_b", {
    paramtype = "light",
    walkable = false,
    sunlight_propagates = true,
    drop = "",
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "wallmounted",
    legacy_wallmounted = true,
    node_box = {
        type = "fixed",
        fixed = {
            {0, -0.5, -0.5, 0, 0.5, 0.5}, -- NodeBox1
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0.2, 0.2}
    },
    tiles = {
        "farming_tige_connnect.png", --top
        "farming_tige_connnect.png", -- bottom
        "farming_tige_connnect.png", -- right
        "farming_tige_connnect.png^[transformFX90", -- left
        "farming_tige_connnect.png", -- back
        "farming_tige_connnect.png" --front
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1 ,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})

farming:add_plant("farming:pumpkintige_unconnect", {"farming:pumpkin_1", "farming:pumpkin_2"}, 80, 20)


multicraft.register_abm({
    nodenames = {"farming:pumpkintige_unconnect"},
    neighbors = {"air"},
    interval = 30,
    chance = 15,
    action = function(pos)
    local have_change = 0
    local newpos = {x=pos.x, y=pos.y, z=pos.z}
    local light = multicraft.get_node_light(pos)
    if light or light > 10 then
        for x=-1,1 do
                local p = {x=pos.x+x, y=pos.y-1, z=pos.z}
                newpos = {x=pos.x+x, y=pos.y, z=pos.z}
                local n = multicraft.get_node(p)
                local nod = multicraft.get_node(newpos)
            if n.name=="default:dirt_with_grass" and nod.name=="air" and have_change == 0
            or n.name=="default:dirt" and nod.name=="air" and have_change == 0
            or string.find(n.name, "farming:soil") and nod.name=="air" and have_change == 0 then
                    have_change = 1
                    multicraft.add_node(newpos, {name="farming:pumpkin_face"})
                    if x == 1 then
                        multicraft.add_node(pos, {name="farming:pumpkintige_linked_r" })
                    else
                        multicraft.add_node(pos, {name="farming:pumpkintige_linked_l"})
                    end
            end
        end
        if have_change == 0 then
            for z=-1,1 do
                    p = {x=pos.x, y=pos.y-1, z=pos.z+z}
                    newpos = {x=pos.x, y=pos.y, z=pos.z+z}
                    n = multicraft.get_node(p)
                    local nod2 = multicraft.get_node(newpos)
                    if n.name=="default:dirt_with_grass" and nod2.name=="air" and have_change == 0
                    or n.name=="default:dirt" and nod2.name=="air" and have_change == 0
                    or string.find(n.name, "farming:soil") and nod2.name=="air" and have_change == 0 then
                        have_change = 1
                        multicraft.add_node(newpos, {name="farming:pumpkin_face"})
                    if z == 1 then
                        multicraft.add_node(pos, {name="farming:pumpkintige_linked_t" })
                    else
                        multicraft.add_node(pos, {name="farming:pumpkintige_linked_b" })
                    end
                    end
            end
        end
    end
    end,
})



multicraft.register_node("farming:pumpkin_face_light", {
    description = "Jack O' Lantern",
    stack_max = 64,
    paramtype2 = "facedir",
    light_source = LIGHT_MAX,
    tiles = {"farming_pumpkin_top.png", "farming_pumpkin_top.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_side.png", "farming_pumpkin_face_light.png"},
    groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, building=1},
})

multicraft.register_craft({
    type = "shapeless",
    output = "farming:pumpkin_face_light",
    recipe = {"farming:pumpkin_face", "default:torch"}
})

multicraft.register_craft({
    type = "shapeless",
    output = "farming:pumpkin_seed 4",
    recipe = {"farming:pumpkin_face"}
})


-- ========= FUEL =========
multicraft.register_craft({
    type = "fuel",
    recipe = "farming:pumpkin_seed",
    burntime = 1
})
