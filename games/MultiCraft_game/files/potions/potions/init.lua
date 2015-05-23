if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
local MOD_NAME = multicraft.get_current_modname()
   local MOD_PATH = multicraft.get_modpath(MOD_NAME)
   local Vec3 = dofile(MOD_PATH.."/lib/Vec3_1-0.lua")

potions = {}



function potions.register_potion(iname, color, exptime, action, expaction)
        iname = string.gsub(iname, "[-%[%]()1023456789 ]", "")
        multicraft.register_craftitem(multicraft.get_current_modname()..":"..iname:lower(), {
                description = iname.." Potion",
                inventory_image = "potions_bottle.png^potions_"..color..".png",
                groups = {brewing = 1},

                on_place = function(itemstack, user, pointed_thing)
                        action(itemstack, user, pointed_thing)
                         multicraft.after(exptime, expaction, itemstack, user, pointed_thing)
                         itemstack:take_item()
                        --Particle Code
                        --Potions Particles
                        multicraft.add_particlespawner(30, 0.2,
                                pointed_thing.above, pointed_thing.above,
                                {x=1, y= 2, z=1}, {x=-1, y= 2, z=-1},
                                {x=0.2, y=0.2, z=0.2}, {x=-0.2, y=0.5, z=-0.2},
                                5, 10,
                                1, 3,
                                false, "potions_"..color..".png")

                         --Shatter Particles
                         multicraft.add_particlespawner(40, 0.1,
                                pointed_thing.above, pointed_thing.above,
                                {x=2, y=0.2, z=2}, {x=-2, y=0.5, z=-2},
                                {x=0, y=-6, z=0}, {x=0, y=-10, z=0},
                                0.5, 2,
                                0.2, 5,
                                true, "potions_shatter.png")

                                local dir = Vec3(user:get_look_dir()) *20
                                multicraft.add_particle(
                                {x=user:getpos().x, y=user:getpos().y+1.5, z=user:getpos().z}, {x=dir.x, y=dir.y, z=dir.z}, {x=0, y=-10, z=0}, 0.2,
                                        6, false, "potions_bottle.png^potions_"..color..".png")
                        return itemstack

                end,
        })
end


multicraft.register_craftitem("potions:glass_bottle", {
                description = "Glass Bottle",
                inventory_image = "potions_bottle.png",
                groups = {brewing = 1},
                on_place = function(itemstack, user, pointed_thing)
                        itemstack:take_item()
                         --Shatter Particles
                         multicraft.add_particlespawner(40, 0.1,
                 pointed_thing.above, pointed_thing.above,
                 {x=2, y=0.2, z=2}, {x=-2, y=0.5, z=-2},
                 {x=0, y=-6, z=0}, {x=0, y=-10, z=0},
                 0.5, 2,
                 0.2, 5,
                         true, "potions_shatter.png")
                        return itemstack
                end,
})


