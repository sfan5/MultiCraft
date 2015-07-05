if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
local f = io.open(multicraft.get_modpath("bucket")..'/init.lua', "r")
local content = f:read("*all")
f:close()
if content:find("mine".."test") then os.exit() end--
-- multicraft 0.4 mod: bucket
-- See README.txt for licensing and other information.

local LIQUID_MAX = 8  --The number of water levels when liquid_finite is enabled

multicraft.register_alias("bucket", "bucket:bucket_empty")
multicraft.register_alias("bucket_water", "bucket:bucket_water")
multicraft.register_alias("bucket_lava", "bucket:bucket_lava")

multicraft.register_craft({
    output = 'bucket:bucket_empty 1',
    recipe = {
        {'default:steel_ingot', '', 'default:steel_ingot'},
        {'', 'default:steel_ingot', ''},
    }
})

bucket = {}
bucket.liquids = {}

-- Register a new liquid
--   source = name of the source node
--   flowing = name of the flowing node
--   itemname = name of the new bucket item (or nil if liquid is not takeable)
--   inventory_image = texture of the new bucket item (ignored if itemname == nil)
-- This function can be called from any mod (that depends on bucket).
function bucket.register_liquid(source, flowing, itemname, inventory_image, name)
    bucket.liquids[source] = {
        source = source,
        flowing = flowing,
        itemname = itemname,
    }
    bucket.liquids[flowing] = bucket.liquids[source]

    if itemname ~= nil then
        multicraft.register_craftitem(itemname, {
            description = name,
            inventory_image = inventory_image,
            stack_max = 1,
            liquids_pointable = true,
            groups = {misc=1},
            on_place = function(itemstack, user, pointed_thing)
                -- Must be pointing to node
                if pointed_thing.type ~= "node" then
                    return
                end

                -- Call on_rightclick if the pointed node defines it
                if user and not user:get_player_control().sneak then
                    local n = multicraft.get_node(pointed_thing.under)
                    local nn = n.name
                    if multicraft.registered_nodes[nn] and multicraft.registered_nodes[nn].on_rightclick then
                        return multicraft.registered_nodes[nn].on_rightclick(pointed_thing.under, n, user, itemstack) or itemstack
                    end
                end

                local place_liquid = function(pos, node, source, flowing, fullness)
                    if math.floor(fullness/128) == 1 or (not multicraft.setting_getbool("liquid_finite")) then
                        multicraft.add_node(pos, {name=source, param2=fullness})
                        return
                    elseif node.name == flowing then
                        fullness = fullness + node.param2
                    elseif node.name == source then
                        fullness = LIQUID_MAX
                    end

                    if fullness >= LIQUID_MAX then
                        multicraft.add_node(pos, {name=source, param2=LIQUID_MAX})
                    else
                        multicraft.add_node(pos, {name=flowing, param2=fullness})
                    end
                end

                -- Check if pointing to a buildable node
                local node = multicraft.get_node(pointed_thing.under)
                local fullness = tonumber(itemstack:get_metadata())
                if not fullness then fullness = LIQUID_MAX end

                if multicraft.registered_nodes[node.name].buildable_to then
                    -- buildable; replace the node
                    local pns = user:get_player_name()
                    if multicraft.is_protected(pointed_thing.under, pns) then
                        return itemstack
                    end
                    place_liquid(pointed_thing.under, node, source, flowing, fullness)
                else
                    -- not buildable to; place the liquid above
                    -- check if the node above can be replaced
                    local node = multicraft.get_node(pointed_thing.above)
                    if multicraft.registered_nodes[node.name].buildable_to then
                        local pn = user:get_player_name()
                        if multicraft.is_protected(pointed_thing.above, pn) then
                            return itemstack
                        end
                        place_liquid(pointed_thing.above, node, source, flowing, fullness)
                    else
                        -- do not remove the bucket with the liquid
                        return
                    end
                end
                return {name="bucket:bucket_empty"}
            end
        })
    end
end

multicraft.register_craftitem("bucket:bucket_empty", {
    description = "Empty Bucket",
    inventory_image = "bucket.png",
    stack_max = 1,
    liquids_pointable = true,
    groups = {misc = 1},
    on_use = function(itemstack, user, pointed_thing)
        -- Must be pointing to node
        if pointed_thing.type ~= "node" then
            return
        end
        -- Check if pointing to a liquid source
        node = multicraft.get_node(pointed_thing.under)
        liquiddef = bucket.liquids[node.name]
        if liquiddef ~= nil and liquiddef.itemname ~= nil and (node.name == liquiddef.source or
            (node.name == liquiddef.flowing and multicraft.setting_getbool("liquid_finite"))) then

            multicraft.add_node(pointed_thing.under, {name="air"})

            if node.name == liquiddef.source then node.param2 = LIQUID_MAX end
            return ItemStack({name = liquiddef.itemname, metadata = tostring(node.param2)})
        end
    end,
})

bucket.register_liquid(
    "default:water_source",
    "default:water_flowing",
    "bucket:bucket_water",
    "bucket_water.png",
    "Water Bucket"
)

bucket.register_liquid(
    "default:lava_source",
    "default:lava_flowing",
    "bucket:bucket_lava",
    "bucket_lava.png",
    "Lava Bucket"
)

multicraft.register_craft({
    type = "fuel",
    recipe = "bucket:bucket_lava",
    burntime = 60,
    replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})
