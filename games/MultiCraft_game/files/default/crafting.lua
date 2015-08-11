-- mods/default/crafting.lua

--
-- Crafting definition
--

multicraft.register_craft({
    output = 'default:wood 4',
    recipe = {
        {'default:tree'},
    }
})

multicraft.register_craft({
    output = 'default:junglewood 4',
    recipe = {
        {'default:jungletree'},
    }
})

multicraft.register_craft({
    output = 'default:acaciawood 4',
    recipe = {
        {'default:acaciatree'},
    }
})

multicraft.register_craft({
    output = 'default:sprucewood 4',
    recipe = {
        {'default:sprucetree'},
    }
})



multicraft.register_craft({
    output = 'default:mossycobble',
    recipe = {
        {'default:cobble', 'default:vine'},
    }
})

multicraft.register_craft({
    output = 'default:stonebrickmossy',
    recipe = {
        {'default:stonebrick', 'default:vine'},
    }
})


multicraft.register_craft({
    output = 'default:stick 4',
    recipe = {
        {'group:wood'},
        {'group:wood'},
    }
})

multicraft.register_craft({
    output = 'fences:fence_wood 2',
    recipe = {
        {'default:stick', 'default:stick', 'default:stick'},
        {'default:stick', 'default:stick', 'default:stick'},
    }
})

multicraft.register_craft({
    output = 'signs:sign_wall',
    recipe = {
        {'group:wood', 'group:wood', 'group:wood'},
        {'group:wood', 'group:wood', 'group:wood'},
        {'', 'default:stick', ''},
    }
})

multicraft.register_craft({
    output = 'default:torch 4',
    recipe = {
        {'default:coal_lump'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:torch 4',
    recipe = {
        {'default:charcoal_lump'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:pick_wood',
    recipe = {
        {'group:wood', 'group:wood', 'group:wood'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

multicraft.register_craft({
    output = 'default:pick_stone',
    recipe = {
        {'group:stone', 'group:stone', 'group:stone'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

multicraft.register_craft({
    output = 'default:pick_steel',
    recipe = {
        {'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

multicraft.register_craft({
    output = 'default:pick_gold',
    recipe = {
        {'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

multicraft.register_craft({
    output = 'default:diamondblock',
    recipe = {
        {'default:diamond', 'default:diamond', 'default:diamond'},
        {'default:diamond', 'default:diamond', 'default:diamond'},
        {'default:diamond', 'default:diamond', 'default:diamond'},
    }
})

multicraft.register_craft({
    output = 'default:pick_diamond',
    recipe = {
        {'default:diamond', 'default:diamond', 'default:diamond'},
        {'', 'default:stick', ''},
        {'', 'default:stick', ''},
    }
})

multicraft.register_craft({
    output = 'default:shovel_wood',
    recipe = {
        {'group:wood'},
        {'default:stick'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:shovel_stone',
    recipe = {
        {'group:stone'},
        {'default:stick'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:shovel_steel',
    recipe = {
        {'default:steel_ingot'},
        {'default:stick'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:shovel_gold',
    recipe = {
        {'default:gold_ingot'},
        {'default:stick'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:shovel_diamond',
    recipe = {
        {'default:diamond'},
        {'default:stick'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:axe_wood',
    recipe = {
        {'group:wood', 'group:wood'},
        {'group:wood', 'default:stick'},
        {'', 'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:axe_stone',
    recipe = {
        {'group:stone', 'group:stone'},
        {'group:stone', 'default:stick'},
        {'', 'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:axe_steel',
    recipe = {
        {'default:steel_ingot', 'default:steel_ingot'},
        {'default:steel_ingot', 'default:stick'},
        {'', 'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:axe_gold',
    recipe = {
        {'default:gold_ingot', 'default:gold_ingot'},
        {'default:gold_ingot', 'default:stick'},
        {'', 'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:axe_diamond',
    recipe = {
        {'default:diamond', 'default:diamond'},
        {'default:diamond', 'default:stick'},
        {'', 'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:sword_wood',
    recipe = {
        {'group:wood'},
        {'group:wood'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:sword_stone',
    recipe = {
        {'group:stone'},
        {'group:stone'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:sword_steel',
    recipe = {
        {'default:steel_ingot'},
        {'default:steel_ingot'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:sword_gold',
    recipe = {
        {'default:gold_ingot'},
        {'default:gold_ingot'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:sword_diamond',
    recipe = {
        {'default:diamond'},
        {'default:diamond'},
        {'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:flint_and_steel',
    recipe = {
        {'default:steel_ingot', ''},
        {'', 'default:flint'},
    }
})

multicraft.register_craft({
    output = "default:pole",
    recipe = {
        {'','','default:stick'},
        {'','default:stick','farming:string'},
        {'default:stick','','farming:string'},
    }
})

multicraft.register_craft({
    output = "default:pole",
    recipe = {
        {'', '', 'default:stick'},
        {'', 'default:stick', 'default:string'},
        {'default:stick', '', 'default:string'},
    }
})

multicraft.register_craft({
    output = 'default:rail 15',
    recipe = {
        {'default:steel_ingot', '', 'default:steel_ingot'},
        {'default:steel_ingot', 'default:stick', 'default:steel_ingot'},
        {'default:steel_ingot', '', 'default:steel_ingot'},
    }
})

multicraft.register_craft({
    output = 'default:chest',
    recipe = {
        {'group:wood', 'group:wood', 'group:wood'},
        {'group:wood', '', 'group:wood'},
        {'group:wood', 'group:wood', 'group:wood'},
    }
})

multicraft.register_craft({
    output = 'default:furnace',
    recipe = {
        {'group:stone', 'group:stone', 'group:stone'},
        {'group:stone', '', 'group:stone'},
        {'group:stone', 'group:stone', 'group:stone'},
    }
})

multicraft.register_craft({
    output = 'default:haybale',
    recipe = {
        {'farming:wheat_harvested', 'farming:wheat_harvested', 'farming:wheat_harvested'},
        {'farming:wheat_harvested', 'farming:wheat_harvested', 'farming:wheat_harvested'},
        {'farming:wheat_harvested', 'farming:wheat_harvested', 'farming:wheat_harvested'},
    }
})

multicraft.register_craft({
    output = 'farming:wheat_harvested 9',
    recipe = {
        {'default:haybale'},
    }
})


multicraft.register_craft({
    output = 'default:steelblock',
    recipe = {
        {'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
        {'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
        {'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
    }
})

multicraft.register_craft({
    output = 'default:steel_ingot 9',
    recipe = {
        {'default:steelblock'},
    }
})

multicraft.register_craft({
    output = 'default:goldblock',
    recipe = {
        {'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
        {'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
        {'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
    }
})

multicraft.register_craft({
    output = 'default:gold_ingot 9',
    recipe = {
        {'default:goldblock'},
    }
})

multicraft.register_craft({
    output = "default:gold_nugget 9",
    recipe = {{"default:gold_ingot"}},
})

multicraft.register_craft({
    output = 'default:sandstone',
    recipe = {
        {'group:sand', 'group:sand'},
        {'group:sand', 'group:sand'},
    }
})

multicraft.register_craft({
    output = 'default:clay',
    recipe = {
        {'default:clay_lump', 'default:clay_lump'},
        {'default:clay_lump', 'default:clay_lump'},
    }
})

multicraft.register_craft({
    output = 'default:brick',
    recipe = {
        {'default:clay_brick', 'default:clay_brick'},
        {'default:clay_brick', 'default:clay_brick'},
    }
})

multicraft.register_craft({
    output = 'default:clay_brick 4',
    recipe = {
        {'default:brick'},
    }
})

multicraft.register_craft({
    output = 'default:paper',
    recipe = {
        {'default:reeds', 'default:reeds', 'default:reeds'},
    }
})

multicraft.register_craft({
    output = 'default:book',
    recipe = {
        {'default:paper'},
        {'default:paper'},
        {'default:paper'},
    }
})

multicraft.register_craft({
    output = 'default:bookshelf',
    recipe = {
        {'group:wood', 'group:wood', 'group:wood'},
        {'default:book', 'default:book', 'default:book'},
        {'group:wood', 'group:wood', 'group:wood'},
    }
})

multicraft.register_craft({
    output = 'default:ladder',
    recipe = {
        {'default:stick', '', 'default:stick'},
        {'default:stick', 'default:stick', 'default:stick'},
        {'default:stick', '', 'default:stick'},
    }
})

multicraft.register_craft({
    output = 'default:stonebrick',
    recipe = {
        {'default:stone', 'default:stone'},
        {'default:stone', 'default:stone'},
    }
})

multicraft.register_craft({
    type = "shapeless",
    output = "default:gunpowder",
    recipe = {
        'default:sand',
        'default:gravel',
    }
})

multicraft.register_craft({
    output = 'dye:white 3',
    recipe = {
        {'default:bone'},
    }
})

multicraft.register_craft({
    output = 'default:lapisblock',
    recipe = {
        {'dye:blue', 'dye:blue', 'dye:blue'},
        {'dye:blue', 'dye:blue', 'dye:blue'},
        {'dye:blue', 'dye:blue', 'dye:blue'},
    }
})

multicraft.register_craft({
    output = 'dye:blue 9',
    recipe = {
        {'default:lapisblock'},
    }
})

multicraft.register_craft({
    output = "default:emeraldblock",
    recipe = {
        {'default:emerald', 'default:emerald', 'default:emerald'},
        {'default:emerald', 'default:emerald', 'default:emerald'},
        {'default:emerald', 'default:emerald', 'default:emerald'},
    }
})

multicraft.register_craft({
    output = 'default:emerald 9',
    recipe = {
        {'default:emeraldblock'},
    }
})

multicraft.register_craft({
    output = "default:glowstone",
    recipe = {
        {'default:glowstone_dust', 'default:glowstone_dust'},
        {'default:glowstone_dust', 'default:glowstone_dust'},
    }
})

multicraft.register_craft({
    output = 'default:glowstone_dust 4',
    recipe = {
        {'default:glowstone'},
    }
})


multicraft.register_craft({
    output = 'default:redstone_dust',
    recipe = {{"mesecons:wire_00000000_off"}},
})


multicraft.register_craft({
    output = "default:apple_gold",
    recipe = {
        {"default:gold_nugget", "default:gold_nugget", "default:gold_nugget"},
        {"default:gold_nugget", 'default:apple', "default:gold_nugget"},
        {"default:gold_nugget", "default:gold_nugget", "default:gold_nugget"},
    }
})

multicraft.register_craft({
    output = "default:sugar",
    recipe = {
        {"default:reeds"},
    }
})

multicraft.register_craft({
    output = 'default:snowblock',
    recipe = {
        {'default:snow', 'default:snow', 'default:snow'},
        {'default:snow', 'default:snow', 'default:snow'},
        {'default:snow', 'default:snow', 'default:snow'},
    }
})

multicraft.register_craft({
    output = 'default:snow 9',
    recipe = {
        {'default:snowblock'},
    }
})

multicraft.register_craft({
    output = 'default:quartz_block',
    recipe = {
        {'default:quartz_crystal', 'default:quartz_crystal'},
        {'default:quartz_crystal', 'default:quartz_crystal'},
    }
})

multicraft.register_craft({
    output = 'default:quartz_chiseled 2',
    recipe = {
        {'stairs:slab_quartzblock'},
        {'stairs:slab_quartzblock'},
    }
})

multicraft.register_craft({
    output = 'default:quartz_pillar 2',
    recipe = {
        {'default:quartz_block'},
        {'default:quartz_block'},
    }
})


--
-- Cooking recipes
--

multicraft.register_craft({
    type = "cooking",
    output = "default:glass",
    recipe = "group:sand",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:stone",
    recipe = "default:cobble",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:steel_ingot",
    recipe = "default:stone_with_iron",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:gold_ingot",
    recipe = "default:stone_with_gold",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:clay_brick",
    recipe = "default:clay_lump",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:fish",
    recipe = "default:fish_raw",
--  cooktime = 2,
})

multicraft.register_craft({
    type = "cooking",
    output = "default:charcoal_lump",
    recipe = "group:tree",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:sponge",
    recipe = "default:sponge_wet",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:steak",
    recipe = "default:beef_raw",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:chicken_cooked",
    recipe = "default:chicken_raw",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:coal_lump",
    recipe = "default:stone_with_coal",
})

multicraft.register_craft({
    type = "cooking",
    output = "mesecons:wire_00000000_off 5",
    recipe = "default:stone_with_redstone",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:diamond",
    recipe = "default:stone_with_diamond",
})

multicraft.register_craft({
    type = "cooking",
    output = "default:stonebrickcracked",
    recipe = "default:stonebrick",
})



--
-- Fuels
--

multicraft.register_craft({
    type = "fuel",
    recipe = "group:tree",
    burntime = 15,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:bookshelf",
    burntime = 15,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:fence_wood",
    burntime = 15,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "group:wood",
    burntime = 15,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "bucket:bucket_lava",
    burntime = 1000,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:chest",
    burntime = 15,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:sapling",
    burntime = 5,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:coal_block",
    burntime = 800,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:coal_lump",
    burntime = 80,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:charcoal_lump",
    burntime = 80,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:junglesapling",
    burntime = 5,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:stick",
    burntime = 5,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "crafting:workbench",
    burntime = 15,
})

multicraft.register_craft({
    type = "fuel",
    recipe = "default:chest",
    burntime = 15,
})


--
--Temporary
--
multicraft.register_craft({
    output = "default:string",
    recipe = {{"default:paper", "default:paper"}},
})

multicraft.register_craft({
    output = "default:cobweb",
    recipe = {
        {"farming:string", "farming:string", "farming:string"},
        {"farming:string", "farming:string", "farming:string"},
        {"farming:string", "farming:string", "farming:string"},
    }
})