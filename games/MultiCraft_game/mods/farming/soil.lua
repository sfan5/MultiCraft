multicraft.register_node("farming:soil", {
    tiles = {"farming_soil.png", "default_dirt.png", "default_dirt.png", "default_dirt.png", "default_dirt.png", "default_dirt.png"},
    drop = "default:dirt",
    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.375, 0.5},
        }
    },
    groups = {crumbly=3, not_in_creative_inventory=1,soil=2},
})

multicraft.register_node("farming:soil_wet", {
    tiles = {"farming_soil_wet.png", "default_dirt.png", "default_dirt.png", "default_dirt.png", "default_dirt.png", "default_dirt.png"},
    drop = "default:dirt",
    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.375, 0.5},
        }
    },
    groups = {crumbly=3, not_in_creative_inventory=1,soil=3},
})

multicraft.register_abm({
    nodenames = {"farming:soil"},
    interval = 15,
    chance = 3,
    action = function(pos, node)
        if multicraft.find_node_near(pos, 3, {"default:water_source", "default:water_flowing"}) then
            node.name = "farming:soil_wet"
            multicraft.set_node(pos, node)
        end
    end,
})

