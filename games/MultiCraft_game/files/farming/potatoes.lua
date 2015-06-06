multicraft.register_node("farming:potato_1", {
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    buildable_to = true,
    drop = "farming:potato_item",
    tiles = {"farming_potato_1.png"},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.125, 0.5}
        },
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})

multicraft.register_node("farming:potato_2", {
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    drop = "farming:potato_item",
    buildable_to = true,
    tiles = {"farming_potato_2.png"},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.125, 0.5}
        },
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})

multicraft.register_node("farming:potato", {
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    buildable_to = true,
    tiles = {"farming_potato_3.png"},
    drop = {
        max_items = 1,
        items = {
            { items = {'farming:potato_item 2'} },
            { items = {'farming:potato_item 3'}, rarity = 2 },
            { items = {'farming:potato_item 4'}, rarity = 5 }
        }
    },
    groups = {snappy=3, flammable=2, not_in_creative_inventory=1,dig_by_water=1},
    sounds = default.node_sound_leaves_defaults(),
})

multicraft.register_craftitem("farming:potato_item", {
    description = "Potato",
    inventory_image = "farming_potato.png",
    on_use = multicraft.item_eat(1),
    stack_max = 64,
    groups = {foodstuffs=1},
    on_place = function(itemstack, placer, pointed_thing)
        return farming:place_seed(itemstack, placer, pointed_thing, "farming:potato_1")
    end,
})

multicraft.register_craftitem("farming:potato_item_baked", {
    description = "Baked Potato",
    stack_max = 64,
    inventory_image = "farming_potato_baked.png",
    on_use = multicraft.item_eat(6),
    groups = {foodstuffs=1},
})

multicraft.register_craftitem("farming:potato_item_poison", {
    description = "Poisonous Potato",
    stack_max = 64,
    inventory_image = "farming_potato_poison.png",
    on_use = multicraft.item_eat(2),
    groups = {foodstuffs=1},
})

multicraft.register_craft({
    type = "cooking",
    output = "farming:potato_item_baked",
    recipe = "farming:potato_item",
})

farming:add_plant("farming:potato", {"farming:potato_1", "farming:potato_2"}, 50, 20)
