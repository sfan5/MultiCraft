-- mods/default/craftitems.lua

--
-- Crafting items
--

multicraft.register_craftitem("default:stick", {
    description = "Stick",
    inventory_image = "default_stick.png",
    stack_max = 64,
    groups = {materials = 1},

})

multicraft.register_craftitem("default:paper", {
    description = "Paper",
    inventory_image = "default_paper.png",
    stack_max = 64,
    groups = {misc = 1},
})

multicraft.register_craftitem("default:book", {
    description = "Book",
    inventory_image = "default_book.png",
    stack_max = 64,
    groups = {misc = 1},
})

multicraft.register_craftitem("default:coal_lump", {
    description = "Coal Lump",
    inventory_image = "default_coal_lump.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:charcoal_lump", {
    description = "Charcoal Lump",
    inventory_image = "default_charcoal_lump.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:gold_nugget", {
    description = "Gold Nugget",
    inventory_image = "default_gold_nugget.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:diamond", {
    description = "Diamond",
    inventory_image = "default_diamond.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:clay_lump", {
    description = "Clay Lump",
    inventory_image = "default_clay_lump.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:steel_ingot", {
    description = "Steel Ingot",
    inventory_image = "default_steel_ingot.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:gold_ingot", {
    description = "Gold Ingot",
    inventory_image = "default_gold_ingot.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:emerald", {
    description = "Emerald",
    inventory_image = "default_emerald.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:clay_brick", {
    description = "Clay Brick",
    inventory_image = "default_clay_brick.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:flint", {
    description = "Flint",
    inventory_image = "default_flint.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:gunpowder", {
    description = "Gunpowder",
    inventory_image = "default_gunpowder.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:bone", {
    description = "Bone",
    inventory_image = "default_bone.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:glowstone_dust", {
    description = "Glowstone Dust",
    inventory_image = "default_glowstone_dust.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:fish_raw", {
    description = "Raw Fish",
    groups = {},
    inventory_image = "default_fish.png",
    on_use = multicraft.item_eat(2),
    stack_max = 64,
    groups = {foodstuffs = 1},
})

multicraft.register_craftitem("default:fish", {
    description = "Cooked Fish",
    groups = {},
    inventory_image = "default_fish_cooked.png",
    on_use = multicraft.item_eat(4),
    stack_max = 64,
    groups = {foodstuffs = 1},
})

multicraft.register_craftitem("default:sugar", {
    description = "Sugar",
    inventory_image = "default_sugar.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:string",{
    description = "String",
    inventory_image = "default_string.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:prismarine_cry", {
    description = "Prismarine Crystals",
    inventory_image = "default_prismarine_crystals.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:prismarine_shard", {
    description = "Prismarine Shard",
    inventory_image = "default_prismarine_shard.png",
    stack_max = 64,
    groups = {materials = 1},
})

multicraft.register_craftitem("default:quartz_crystal", {
    description = "Quartz Crystal",
    inventory_image = "default_quartz_crystal.png",
    stack_max = 64,
    groups = {materials = 1},
})


multicraft.register_craftitem('default:rotten_flesh', {
    description = "Rotten flesh",
    inventory_image = "zombie_flesh.png",
    on_use = multicraft.item_eat(1),
})


multicraft.register_craftitem('default:milk', {
    description = "A bucket of milk",
    inventory_image = "default_milk.png",
    on_use = multicraft.item_eat(1),
})

multicraft.register_craftitem('default:beef_raw', {
    description = "Beef",
    inventory_image = "mobs_meat_raw.png",
    on_use = multicraft.item_eat(1),
})

multicraft.register_craftitem('default:steak', {
    description = "Steak",
    inventory_image = "mobs_meat.png",
    on_use = multicraft.item_eat(1),
})

multicraft.register_craftitem('default:chicken_raw', {
    description = "Chicken",
    inventory_image = "mobs_chicken_raw.png",
    on_use = multicraft.item_eat(1),
})

multicraft.register_craftitem('default:chicken_cooked', {
    description = "Cooked chicken",
    inventory_image = "mobs_chicken_cooked.png",
    on_use = multicraft.item_eat(1),
})

multicraft.register_craftitem('default:porkchop_raw', {
    description = "Porkchop",
    inventory_image = "mobs_meat_raw.png",
    on_use = multicraft.item_eat(1),
})

multicraft.register_craftitem('default:porkchop_cooked', {
    description = "Cooked porkchop",
    inventory_image = "mobs_meat.png",
    on_use = multicraft.item_eat(1),
})

multicraft.register_craftitem('default:leather', {
    description = "Leather",
    inventory_image = "default_leather.png",
--    on_use = multicraft.item_eat(1),
})

multicraft.register_craftitem('default:egg', {
    description = "Egg",
    inventory_image = "adbs_chicken_spawn_egg.png",
--    on_use = multicraft.item_eat(1),
})

