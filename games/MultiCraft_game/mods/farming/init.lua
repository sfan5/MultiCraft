if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
farming = {}
farming.seeds = {}
function farming:add_plant(full_grown, names, interval, chance)
    multicraft.register_abm({
        nodenames = names,
        interval = interval,
        chance = chance,
        action = function(pos, node)
            pos.y = pos.y-1
            if multicraft.get_node(pos).name ~= "farming:soil_wet" and math.random(0, 9) > 0 then
                return
            end
            pos.y = pos.y+1
            if not multicraft.get_node_light(pos) then
                return
            end
            if multicraft.get_node_light(pos) < 10 then
                return
            end
            local step = nil
            for i,name in ipairs(names) do
                if name == node.name then
                    step = i
                    break
                end
            end
            if step == nil then
                return
            end
            local new_node = {name=names[step+1]}
            if new_node.name == nil then
                new_node.name = full_grown
            end
            multicraft.set_node(pos, new_node)
        end
}   )
end


function farming:place_seed(itemstack, placer, pointed_thing, plantname)
    local pt = pointed_thing
    if not pt then
        return
    end
    if pt.type ~= "node" then
        return
    end

    local pos = {x=pt.above.x, y=pt.above.y-1, z=pt.above.z}
    local farmland = multicraft.get_node(pos)
    pos= {x=pt.above.x, y=pt.above.y, z=pt.above.z}
    local place_s = multicraft.get_node(pos)


    if string.find(farmland.name, "farming:soil") and string.find(place_s.name, "air")  then
        multicraft.add_node(pos, {name=plantname})
    else
        return
    end

    if not multicraft.setting_getbool("creative_mode") then
        itemstack:take_item()
    end
    return itemstack
end


multicraft.register_abm({
    nodenames = {"group:dig_by_water"},
    neighbors = {"group:water"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        for xp=-1,1 do
            for zp=-1,1 do
                p = {x=pos.x+xp, y=pos.y, z=pos.z+zp}
                n = multicraft.get_node(p)
                -- On verifie si il y a de l'eau
                if (n.name=="default:water_flowing") then
                        drop_attached_node(pos)
                        multicraft.dig_node(pos)
                        break
                end
            end
        end

    end,
})

-- ========= SOIL =========
dofile(multicraft.get_modpath("farming").."/soil.lua")

-- ========= HOES =========
dofile(multicraft.get_modpath("farming").."/hoes.lua")

-- ========= WHEAT =========
dofile(multicraft.get_modpath("farming").."/wheat.lua")

-- ========= PUMPKIN =========
dofile(multicraft.get_modpath("farming").."/pumpkin.lua")

-- ========= MELON =========
dofile(multicraft.get_modpath("farming").."/melon.lua")

-- ========= CARROT =========
dofile(multicraft.get_modpath("farming").."/carrots.lua")

-- ========= POTATOES =========
dofile(multicraft.get_modpath("farming").."/potatoes.lua")

-- ========= MUSHROOMS =========
dofile(multicraft.get_modpath("farming").."/mushrooms.lua")


