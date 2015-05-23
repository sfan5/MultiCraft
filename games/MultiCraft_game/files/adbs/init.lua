if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
-------------------------
-- adbs mod by 4aiman  --
-------------------------
--  (Multicraft port)  --
-------------------------
--                     --
--    Licence:GPLv3    --
--                     --
-------------------------



math.randomseed(os.time())
math.random(1,100)

local adbs = {}
adbs.ids = {[0] = 'dummy'}
adbs.spawning_mobs = {}
adbs.registered_mobs = {}
adbs.max_count = {}
adbs.max_count.cow=20
adbs.max_count.cattle=20
adbs.max_count.sheep=20
adbs.max_count.lamb=20
adbs.max_count.pig=20
adbs.max_count.pigglet=20
adbs.max_count.chicken=20
adbs.max_count.chick=20
adbs.max_count.skeleton=20
adbs.max_count.zombie=20
adbs.spawn_control = true

local isghost = isghost or {}

function adbs.can_spawn(name)
    if not adbs.spawn_control then return true end
    if adbs.spawn_locked then return false end
    local nm =name:sub(name:find(':')+1)
    if adbs.max_count[nm] == -1 then return true end
    local cnt = 0
    for i=1,#adbs.ids do
        if adbs.ids[i] and adbs.ids[i]:get_luaentity() and adbs.ids[i]:get_luaentity().name == name then
           cnt = cnt + 1
        end
    end
    return cnt < (adbs.max_count[nm] or 0)
end


adbs.children={sheep='lamb',cow='cattle',chicken='chick',pig='piglet',test='test2'}
adbs.parents={lamb='sheep',cattle='cow',chick='chicken',piglet='pig',test2='test'}

adbs.colors = { [0] = 'black',
                [1] = 'blue',
                [2] = 'brown',
                [3] = 'cyan',
                [4] = 'dark_green',
                [5] = 'dark_grey',
                [6] = 'green',
                [7] = 'grey',
                [8] = 'magenta',
                [9] = 'orange',
               [10] = 'pink',
               [11] = 'red',
               [12] = 'violet',
               [13] = 'white',
               [14] = 'yellow',
               [15] = 'light_blue',
}

function adbs.color_by_name(color)
   for i,col in ipairs(adbs.colors) do
       if col == color then return i end
   end
   return 13
end

adbs.dd = {
         id = 0,
         hp = 10,
         mp = 0,
         st = 20,
         xp = 3,
         alive = true,
         armor = {fleshy=100},
         attack_power = 2,
         attack_power_percent = nil,
         cloth = {},
         weapon = nil,
         target = nil,
         visual = "cube",
         visual_size = {x=1,y=1,z=1},
         mesh = nil,
         collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
         physical = true,
         textures = {'default_dirt.png','default_dirt.png','default_dirt.png','default_dirt.png','default_dirt.png','default_dirt.png'},
         makes_footstep_sound = nil,
         view_range = 16,
         walk_velocity = 0.8,
         run_velocity = 1.5,
         light_damage = 0,
         water_damage = 0,
         lava_damage = 0,
         natural_damage_timer = 0,
         disable_fall_damage = false,
         fall_tolerance = 5,
         drops = {},
         mob_type = 2,
         arrow = nil,
         arrow_dist = 0,
         shoot_interval = 0,
         shoot_timer = 0,
         sounds = {},
         animation = {},
         follow = nil,
         destination = nil,
         attractor = nil,
         horny = false,
         hornytimer = 0,
         colouring = nil,
         color = nil,
         oldcolor = nil,
         timer = 0,
         damage_timer = 0,
         hostile_timer = 0,
         state = 1,
         old_pos = nil,
         lifetimer = -1,
         tamed = false,
         path = nil,
         mother = nil,
         child = 0,
         busy = false,
         walk_time = 0,
         lover_dist_max = 6,
         attractor_dist_max = 5,
         horny_timer_max = 85,
         statuses = {},
         produce = nil,
         produce_num = 0,
         produce_item = nil,
         can_produce = nil,
         produce_cooldown = 85,
         produce_textures = nil,
         produce_mesh = nil,
         auto_produce = nil,
         auto_produce_chance = 0,
         food = 8,
         food_max = 8,
         can_mount = nil,
         mounted = nil,
         status = { speed = 0,
                    add_damage = 0,
                    heal = 0,
                    jump = 0,
                    wobble = false,
                    regen = 0,
                    proof = 0,
                    diggin = 0,
                    lava_damage = 0,
                    aqualung = 0,
                    nv = 0,
                    hunger = 0,
                    poison = 0,
                    wither = 0,
                    health_boost = 0,
                    attack = false},

         jump = function (self, height)
                if self.state == 4 then return end
                local pos = self.object:getpos()
                pos.y=pos.y-1.5
                if multicraft.get_node(pos).name == 'air' then
                   return
                end
                local v = self.object:getvelocity()
                if not height then height = 5 end
                local vy = v.y
                v.y = height
                self.object:setvelocity(v)
                local prev_state = self.state
                self.state = 4
                self:set_animation(4)
                self.busy = true
                multicraft.after(1,function()
                   v.y = vy
                   self.object:setvelocity(v)
                   self.busy = false
                   self.state = prev_state
                   self:set_animation(prev_state)
                end)
         end,

         set_velocity = function(self, v)
            local yaw = self.object:getyaw()
            local x = math.sin(yaw) * -v
            local z = math.cos(yaw) * v
            self.object:setvelocity({x=x, y=self.object:getvelocity().y, z=z})
         end,

         hit = function(self, obj)
             if self and obj then
                local y
                if not obj.is_player or not obj:is_player() then
                   if self.id == obj.id then
                      y = self.object:getyaw()
                   else
                      y = obj:getyaw()
                   end
                else
                   y = obj:get_look_yaw()
                end
                local x = math.cos(y) * 3
                local z = math.sin(y) * 3
                local vel = self.object:getvelocity()
                self.busy = true
                self.object:setvelocity({x=x, y=3, z=z})
                multicraft.after(0.3,function()
                   self.object:setvelocity(vel)
                   self.busy = false
                end)
            end
         end,

         get_velocity = function(self)
             local v = self.object:getvelocity()
             return (v.x^2 + v.z^2)^(0.5)
         end,

         set_animation = function(self, at)
            if not self.animation then
               return
            end
            self.busy = true
            multicraft.after(0.3,function()
               self.busy = false
            end)
            if not self.animation.current then
               self.animation.current = self.state
            end
            local ac = self.animation.current
            if at == 0 and ac ~= 0 then
               if  self.animation.stand_start
               and self.animation.stand_end
               and self.animation.speed_normal
               then
                  self.object:set_animation({x=self.animation.stand_start,y=self.animation.stand_end},self.animation.speed_normal, 0)
                  self.animation.current = 0
               end
            elseif at == 1 and ac ~= 1  then
               if  self.animation.walk_start
                   and self.animation.walk_end
               and self.animation.speed_normal
               then
                  self.object:set_animation({x=self.animation.walk_start,y=self.animation.walk_end},self.animation.speed_normal, 0)
                  self.animation.current = 1
               end
            elseif at == 2 and ac ~= 2  then
               if   self.animation.run_start
               and self.animation.run_end
               and self.animation.speed_run
               then
                  self.object:set_animation({x=self.animation.run_start,y=self.animation.run_end},self.animation.speed_run, 0)
                  self.animation.current = 2
               end
            elseif at == 3 and ac ~= 3  then
               if   self.animation.punch_start
               and self.animation.punch_end
               and self.animation.speed_normal
               then
                  self.object:set_animation({x=self.animation.punch_start,y=self.animation.punch_end},self.animation.speed_normal, 0)
                  self.animation.current = 3
               end
            elseif at == 4 and ac ~= 4  then
                   if  self.animation.jump_start
                   and self.animation.jump_end
                   and self.animation.speed_normal
                   then
                       self.object:set_animation({x=self.animation.jump_start,y=self.animation.jump_end},self.animation.speed_normal, 0)
                       self.animation.current = 4
                   end
            elseif at == 5 and ac ~= 5  then
               if   self.animation.mine_start
               and self.animation.mine_end
               and self.animation.speed_normal
               then
                  self.object:set_animation({x=self.animation.mine_start,y=self.animation.mine_end},self.animation.speed_normal, 0)
                  self.animation.current = 5
               end
            elseif at == 6 and ac ~= 6  then
               if   self.animation.mine_walk_start
               and self.animation.mine_walk_end
               and self.animation.speed_normal
               then
                  self.object:set_animation({x=self.animation.mine_walk_start,y=self.animation.mine_walk_end},self.animation.speed_normal, 0)
                  self.animation.current = 5
               end
            elseif at == 7 and ac ~= 7  then
               if   self.animation.sit_start
               and self.animation.sit_end
               and self.animation.speed_normal
               then
                  self.object:set_animation({x=self.animation.sit_start,y=self.animation.sit_end},self.animation.speed_normal, 0)
                  self.animation.current = 7
               end
            end
           end,

         get_staticdata = function(self)
            local tmp = {}
            for _,stat in pairs(self) do
               local t = type(stat)
               if  t ~= 'function'
               and t ~= 'nil'
               and t ~= 'userdata'
               then
                   tmp[_] = self[_]
               end
            end
            return multicraft.serialize(tmp)
         end,

         on_activate = function(self, staticdata, dtime_s)
            self.object:set_armor_groups(self.armour)
            if self.object.after_spawn then
               self.object:after_spawn()
            end
            self.walk_time_max = self.walk_velocity *2
            if self.mob_type == 3 and multicraft.setting_getbool("only_peaceful_mobs") then
                self.alive = false
                self.object:remove()
                return
            end

            if staticdata then
                local tmp = multicraft.deserialize(staticdata)
                if tmp then
                   for _,stat in pairs(tmp) do
                       self[_] = stat
                   end
                end
            end
            if self.lifetimer > -1 and self.lifetimer <= 1 and not self.tamed then
               self.object:remove()
            end
         end,

         on_punch = function(self, hitter)
            if not self or not hitter then
               return
            end
            self:hit(hitter)
            if self.mob_type > 2 then
               self.destination = nil
               if not hitter:is_player() then
                  if hitter.is_arrow then
                     self.target = hitter.master
                  else
                     self.target = hitter
                  end
               else
                  self.target = hitter
               end
               self.mob_type = 3
            elseif self.mob_type <3 then
               self.state = 2
               self.aggressor = hitter
            end
            if self.object:get_hp() <= 0 then
                  if self.alive then
                     local pos =  self.object:getpos()
                     for _,drop in ipairs(self.drops) do
                    if math.random(1, drop.chance) == 1 then
                            local itm = multicraft.add_item(pos, ItemStack(drop.name.." "..math.random(drop.min, drop.max)))
                            if itm then
                               itm:setvelocity({x=math.random()*math.random(-1,1),y=math.random()*math.random(0,2),z=math.random()*math.random(-1,1)})
                            end
                     end
                     end
                 if self.sounds and self.sounds.die then
                   multicraft.sound_play(self.sounds.die, {object = self.object})
                 end
                     self.alive = false
                     self.object:remove()
                  end
            else
               if self.sounds and self.sounds.damage then
                  multicraft.sound_play(self.sounds.damage, {object = self.object})
               end
            end

            local digger = hitter
            if digger and digger:is_player() then
               local wstack = digger:get_wielded_item()
               local wear = wstack:get_wear()
               local uses = multicraft.registered_items[wstack:get_name()].uses or 1562
               if wear + 65535/uses >= 65535 then
                  wstack:clear()
                  multicraft.sound_play("default_break_tool",{pos = digger:getpos(),gain = 0.5, max_hear_distance = 10,})
               else
                   wstack:set_wear(wear + 65535/uses)
               end
               digger:set_wielded_item(wstack)
            end
         end,

         natural_damage = function(self)
            local pos = self.object:getpos()
            local node = multicraft.get_node(pos)
            local light = multicraft.get_node_light(pos)
            local nodedef = multicraft.registered_nodes[node.name]

            if  self.light_damage>0
            and light == 15 then
                self:hit(self)
                self.object:set_hp(self.object:get_hp()-self.light_damage)
            end

            if  self.water_damage
            and self.water_damage > 0
            and nodedef.groups.water then
                self.object:set_hp(self.object:get_hp()-self.water_damage)
                self:hit(self)
            end

            if  self.lava_damage
            and self.lava_damage > 0
            and nodedef.groups.lava then
                self.object:set_hp(self.object:get_hp()-self.lava_damage)
                self:hit(self)
            end
         end,

         on_step = function(self, dtime)

            if not self.alive then return end

            self.timer=self.timer+dtime
            self.shoot_timer = self.shoot_timer + dtime
            self.walk_time = (self.walk_time or 0 )+dtime

            if self.produce_timer then
               self.produce_timer = self.produce_timer - dtime
               if self.produce_timer <=0
               and math.random()>0.9
               then
                  self.produce_timer = nil
                  self.can_produce = true
               end
            end

            if self.busy then
               if self.timer<0.5 then
                  return
               end
            end

            if self.object:get_hp() <= 0 then
               self.alive = nil
               self.object:remove()
               return
            end

            local pos = self.object:getpos()


            local posb = {x=pos.x, y=pos.y-1.5, z=pos.z}
            local posf = {x=pos.x, y=pos.y-1.0, z=pos.z}

            if not self.follow and self.timer>0.5 then
               if self.state == 0 then
                  if math.random(1, 200) == 1 then
                     self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
                  end
                  self.object:setvelocity({x=0,y=0,z=0})
                  if math.random() <= 0.05 then
                     self:set_velocity(self.walk_velocity)
                     self.state = 1
                  end
               elseif self.state == 1 then
                  if math.random(1, 500) <= 30 then
                     self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
                  end
                  self.set_velocity(self, self.walk_velocity)
                  if math.random(1, 500) <= 10 then
                     self.object:setvelocity({x=0,y=0,z=0})
                     self.object:setacceleration({x=0,y=0,z=0})
                     self.state = 0
                  end
               elseif self.state == 2 then
                   if math.random(1, 500) <= 60 then
                      self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
                   end
               end

               local yaw = self.object:getyaw()
               local x = -math.sin(yaw)
               local z = math.cos(yaw)
               local nm = multicraft.get_node(posf).name
               if  multicraft.registered_nodes[nm]
               and multicraft.registered_nodes[nm].walkable
               then
                   self:jump()
               end

            end

            if self.timer>0.5 then
               if self.mob_type > 2 then
                  if multicraft.setting_getbool("only_peaceful_mobs") then
                    self.alive = nil
                    self.object:remove()
                  end

                  if self.hostile_timer > 0 then
                    self.hostile_timer = self.hostile_timer - dtime
                    if self.hostile_timer <= 0 then
                      self.hostile_timer = 0
                      self.mob_type = 2
                      self.state = 1
                    end
                  end

                  if self.walk_time > self.walk_time_max then
                     self.walk_time = 0
                     self.destination = nil
                     self.target = nil
                     self.follow = nil
                  end

                  if multicraft.get_node(pos).name:find('water')
                  then self.in_water = true
                  else self.in_water = nil
                  end

                  if self.follow then
                    if not self.in_water then
                       if not self.destination then
                          if self.target then
                             local pos1 = posf
                             local pos2
                             local tname
                             if  self.target.is_player
                             and self.target:is_player()
                             then
                                 if not isghost[self.target:get_player_name()] then
                                    pos2 = self.target:getpos()
                                 end
                                 tname = self.target:get_player_name()
                             elseif self.target.object then
                                 pos2 = self.target.object:getpos()
                                 pos2.y = pos2.y-1
                                 tname = self.target.object:getluaentity().name
                             end

                             if pos2 then
                                local path = multicraft.find_path(pos1,pos2,self.view_range*2,1 ,2,"A*")
                                if path and #path>1 then
                                   local ppp
                                   ppp = path[3] or path[2]
                                   self.destination = ppp
                                   local dir = {x=ppp.x-pos1.x, y=ppp.y-pos1.y, z=ppp.z-pos1.z}
                                   local yaw = math.atan(dir.z/dir.x)+math.pi/2
                                      if ppp.x > pos1.x then
                                        yaw = yaw+math.pi
                                      end
                                   self.object:setyaw(yaw)
                                   self:set_velocity(self.run_velocity)
                                   self.state = 2
                                   if ppp.y>pos1.y then
                                   end
                                else
                                   self.follow = nil
                                   self.target = nil
                                   self.state = 1
                                   self:set_velocity(self.walk_velocity)
                                end
                             end
                          else
                             self.follow = nil
                             self.state = 1
                             self:set_velocity(self.walk_velocity)
                          end

                       else
                           local ppp = self.destination
                           local nm = multicraft.get_node(ppp).name
                           local spos = {x=ppp.x, y=posf.y, z=ppp.z}
                           local nm2 = multicraft.get_node(spos).name
                           if  ppp.y > posf.y
                           and multicraft.registered_nodes[nm]
                           and multicraft.registered_nodes[nm].walkable
                           then
                              self:jump()
                           end

                           if
                           multicraft.registered_nodes[nm2]
                           and multicraft.registered_nodes[nm2].walkable
                           then
                              self:jump()
                           end

                           local distance = ((pos.x-self.destination.x)^2 + (pos.y-self.destination.y)^2 + (pos.z-self.destination.z)^2)^0.5
                           if distance<=0.15 or distance>=1.5 then
                              self.destination = nil
                           else
                               local pos1 = pos
                               local pos2 = self.destination
                               local dir = {x=pos2.x-pos1.x, y=pos2.y-pos1.y, z=pos2.z-pos1.z}
                               local yaw = math.atan(dir.z/dir.x)+math.pi/2
                               if pos2.x > pos1.x then
                                  yaw = yaw+math.pi
                               end
                               self.object:setyaw(yaw)
                               if self.target then
                                  self:set_velocity(self.run_velocity)
                                  self.state = 2
                               else
                                  self:set_velocity(self.walk_velocity)
                                  self.state = 1
                               end
                           end
                       end

                    else
                        if self.target then
                           local s = pos
                           local p
                           if     self.target.is_player
                           and    self.target:is_player() then
                                  p=self.target:getpos()
                           elseif self.target.object then
                                  p=self.target.object:getpos()
                           end

                           if p then
                              local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                              local yaw = math.atan(vec.z/vec.x)+math.pi/2
                              if p.x > s.x then
                                 yaw = yaw+math.pi
                              end
                              self.object:setyaw(yaw)
                              self.set_velocity(self, self.walk_velocity/1.5)
                              self.state = 2
                          end

                        else
                            self.state = 1
                            for _,player in pairs(multicraft.get_connected_players()) do
                               local s = self.object:getpos()
                               local p = player:getpos()
                               local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                               if self.view_range and dist < self.view_range then
                                  self.target = player
                                  self.set_velocity(self, self.walk_velocity/1.5)
                                  self.state = 2
                                  break
                               end
                           end
                           if not self.target then
                              self.state = 0
                           end
                        end
                    end


                  else

                   if not multicraft.setting_getbool("enable_damage")
                      then
                         self.state = 1
                         self.target = nil
                   else
                      local players = multicraft.get_connected_players()
                      for _,player in pairs(players) do
                         local op = pos
                         local pp = player:getpos()
                         local distance = ((op.x-pp.x)^2 + (op.y-pp.y)^2 + (op.z-pp.z)^2)^0.5
                         if distance < self.view_range then
                              self.follow = true
                              self.target = player
                              self.destination = nil
                              self.state = 2
                              self.set_velocity(self, self.run_velocity)
                              if (self.arrow_dist>0 and distance<self.arrow_dist) then
                                 if not isghost[player:get_player_name()]
                                 or self.ghost_hater
                                 then
                                    self.target = player
                                    self.state = 3
                                    self.follow = nil
                                 break
                                 end
                              elseif distance<2.5 and not self.arrow then
                                 if not isghost[player:get_player_name()]
                                 or self.ghost_hater
                                 then
                                    self.target = player
                                    self.state = 3
                                    self.follow = nil
                                    break
                                 end
                              end
                         end
                      end

                      if self.state == 3 then
                         if self.arrow then
                            self.destination = nil
                            if not self.target then
                               self.follow = nil
                               self.state = 2
                            else
                                 local s = pos
                                 local s1 = {x=pos.x, y=pos.y+1, z=pos.z}
                                 local p
                                 if     self.target.is_player
                                 and    self.target:is_player() then
                                        p=self.target:getpos()
                                 elseif self.target.object then
                                        p=self.target.object:getpos()
                                 else
                                     p= {x=pos.x, y=pos.y-100, z=pos.z}
                                 end
                                 local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                                 local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                                 local yaw = math.atan(vec.z/vec.x)+math.pi/2
                                 if p.x > s.x then
                                    yaw = yaw+math.pi
                                 end
                                 self.object:setyaw(yaw)
                                 p.y = p.y +0.5
                                 if multicraft.line_of_sight(s1, p, 0.9) then
                                    self.set_velocity(self, 0)
                                    if self.shoot_timer > self.shoot_interval and math.random(1, 100) <= 30 then
                                       self.shoot_timer = 0
                                       if self.sounds and self.sounds.attack then
                                          multicraft.sound_play(self.sounds.attack, {object = self.object})
                                       end
                                       local obj = multicraft.add_entity(s, self.arrow)
                                       obj:get_luaentity().master = self.object
                                       obj:get_luaentity().target = self.target
                                       if obj:get_luaentity().path then
                                          obj:get_luaentity():path(pos, p)
                                       else
                                           local vec = {x=(p.x-s.x)/dist, y=(p.y-s.y)/dist, z=(p.z-s.z)/dist}
                                           local v = 19
                                           vec.y = vec.y+0.25
                                           vec.x = vec.x*v
                                           vec.y = vec.y*v
                                           vec.z = vec.z*v
                                           obj:setvelocity(vec)
                                           obj:get_luaentity().object:setacceleration({x=-2, y=-9.8, z = -2})
                                           if math.random()<0.05 then
                                              obj:get_luaentity().collected = nil
                                           else
                                              obj:get_luaentity().collected = true
                                           end
                                       end
                                    end
                                 else
                                    self.follow = true
                                    self.destination = nil
                                    self.state = 2
                                 local pos1 = {x=pos.x,y=pos.y,z=pos.z}
                                 local dots = 10000000
                                 local to_go = {x=pos.x,y=pos.y,z=pos.z}
                                 local stop = false
                                 local tttype = ''
                                 for ii=-self.view_range,self.view_range do
                                     for jj=-4,4 do
                                         for kk=-self.view_range,self.view_range do
                                             local new_pos = {x=pos1.x+ii, y=pos1.y+jj, z=pos1.z+kk}
                                             if multicraft.line_of_sight(new_pos, p, 0.5) then
                                                local dist = ((pos1.x-new_pos.x)^2 + (pos1.y-new_pos.y)^2 + (pos1.z-new_pos.z)^2)^0.5
                                                if dist < self.arrow_dist then
                                                   to_go = new_pos
                                                   stop = true
                                                   break
                                                end
                                                if dist<dots then
                                                   to_go = new_pos
                                                end
                                             end
                                         end
                                         if stop then break end
                                     end
                                     if stop then break end
                                 end
                                 local post = to_go
                                    if post then
                                       pos1.y = pos1.y-1
                                       local path = multicraft.find_path(posf,post,self.view_range*2,3 ,3,"A*")
                                       if not path then
                                          path = multicraft.find_path(posf,post,self.view_range*2,3 ,3,"A*")
                                       end
                                       if path and #path>1 then
                                          local ppp
                                          ppp = path[2]
                                          self.destination = ppp
                                          local dir = {x=ppp.x-pos1.x, y=ppp.y-pos1.y, z=ppp.z-pos1.z}
                                          local yaw = math.atan(dir.z/dir.x)+math.pi/2
                                             if ppp.x > pos1.x then
                                               yaw = yaw+math.pi
                                             end
                                          self.object:setyaw(yaw)
                                          self:set_velocity(self.run_velocity)
                                          self.state = 2
                                       else
                                          self.follow = nil
                                          self.target = nil
                                          self.state = 1
                                          self:set_velocity(self.walk_velocity)
                                       end
                                    else
                                       self.follow = nil
                                       self.target = nil
                                       self.state = 1
                                       self:set_velocity(self.walk_velocity)
                                    end
                                 end
                            end

                         else
                             if self.target then
                                if self.shoot_timer > self.shoot_interval and math.random(1, 100) <= 10 then
                                   local s = pos
                                   local p
                                   local obj
                                   if     self.target.is_player
                                   and    self.target:is_player() then
                                          obj=self.target
                                          p=obj:getpos()
                                          -- p.y=p.y+0.5


                                   elseif self.target.object then
                                          obj=self.target.object
                                          p=obj:getpos()
                                          p.y=p.y-1
                                   end
                                   if obj then
                                      if self.attack_proc then
                                         self:attack_proc(p)
                                      else
                                          local tool_capabilities = { full_punch_interval=1,
                                                                      max_drop_level=1,
                                                                      uses = 0,
                                                                      groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                                                                      damage_groups = {fleshy=self.attack_power or 1},
                                                                    }
                                          obj:punch(self.object, 1.1, tool_capabilities)
                                      end
                                   else
                                       self.follow = nil
                                       self.target = nil
                                       self.destination = nil
                                       self.state = 1
                                       self:set_velocity(self.walk_velocity)
                                   end
                                end
                             else
                                 self.follow = nil
                                 self.target = nil
                                 self.destination = nil
                                 self.state = 1
                                 self:set_velocity(self.walk_velocity)
                             end
                         end
                      end
                   end
                  end
               end
            end

            if self.lifetimer then
               self.lifetimer = self.lifetimer - dtime
               if self.lifetimer >= -1 and self.lifetimer <= 0 and not self.tamed then
                  local player_count = 0
                  for _,obj in ipairs(multicraft.get_objects_inside_radius(pos, 20)) do
                      if obj:is_player() then
                          player_count = player_count+1
                      end
                  end
                  if player_count == 0 and self.state ~= 3 then
                      self.alive = false
                      self.object:remove()
                      return
                  end
               end
            end

            if self.object:getvelocity().y > 0.1 then
                local yaw = self.object:getyaw()
                local x = math.sin(yaw) * -2
                local z = math.cos(yaw) * 2
                if not self.flying then
                   self.object:setacceleration({x=x, y=-10, z=z})
                else
                   local basepos = pos
                   basepos.y = basepos.y - 10
                   local y = multicraft.get_surface(basepos,10,false)
                   if y then
                      self.object:setacceleration({x=x, y=math.random(), z=z})
                   else
                      self.object:setacceleration({x=x, y=-1, z=z})
                   end
                end
            else
                if not self.flying then
                   self.object:setacceleration({x=0, y=-10, z=0})
                else
                   local basepos = pos
                   basepos.y = basepos.y - 10
                   local y = multicraft.get_surface(basepos,10,false)
                   if y then
                      self.object:setacceleration({x=0, y=math.random(), z=0})
                   else
                      self.object:setacceleration({x=0, y=-1, z=0})
                   end
                end
            end


            local n = multicraft.get_node(pos)
            local p1 = {x=pos.x,y=pos.y-1,z=pos.z}
            local p2 = {x=pos.x,y=pos.y-2,z=pos.z}

            local n2 = multicraft.get_node(p2)

            if multicraft.get_item_group(n.name, "water") ~= 0 then
               local n1 = multicraft.get_node(p1)
               if  multicraft.get_item_group(n1.name, "water") == 0
               and self.jump then
                   self:jump()
               else
                   local v = self.object:getvelocity()
                   v.y = 2
                   self.object:setvelocity(v)
               end
             end

            if not self.flying then
                if not self.disable_fall_damage
                and self.object:getvelocity().y == 0 then
                    if not self.old_pos then
                        self.old_pos = pos
                    else
                        local d = self.old_pos.y - pos.y
                        if d > self.fall_tolerance then
                            local damage = d-self.fall_tolerance
                            self.object:set_hp(self.object:get_hp()-damage)
                        end
                        self.old_pos = pos
                    end
                end
            end

            if self.natural_damage_timer>-1 then
               self.natural_damage_timer = self.natural_damage_timer + dtime
               if self.natural_damage_timer > 1 then
                  self.natural_damage_timer = 0
                  self:natural_damage()
               end
            end

            if self.child > 0 then
               if self.mother then
                  self.target=self.mother
                  self.child=self.child-dtime
                  if self.child and self.child<0 then
                     local nm =self.name:sub(self.name:find(':')+1)
                     local name = adbs.parents[nm]
                     local mob
                     if name then
                        if adbs.can_spawn(name) then
                           mob = adbs.spawn_mob(pos, 'adbs:'..name)
                           if mob then
                               local ent=mob:get_luaentity()
                               ent.id=self.id
                               ent.object:setyaw(self.object:getyaw())
                               ent.color=self.color
                               self.alive = nil
                               self.object:remove()
                           end
                        end
                     end
                  end
               end
            end

            if self.timer > 1 then
               if self.mob_type<=2 then
                  if not self.follow then
                     if self.attractor ~= "" then
                         for _,object in pairs(multicraft.get_objects_inside_radius(pos, self.attractor_dist_max)) do
                            if object:get_wielded_item():get_name() == self.attractor then
                               self.target = object
                               self.follow = true
                               break
                            end
                         end
                     end
                  elseif self.target then
                     local object
                     local s = pos
                     local p
                     if     self.target.is_player
                     and    self.target:is_player() then
                            p=self.target:getpos()
                            object = self.target
                     elseif self.target.object then
                            p=self.target.object:getpos()
                            object = self.target.object
                     end
                     if object:get_wielded_item():get_name() ~= self.attractor then
                        self.target = nil
                        self.follow = nil
                     elseif p then
                        local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                        local distance = ((p.x-s.x)^2 + (p.z-s.z)^2 )^0.5
                        local yaw = math.atan(vec.z/vec.x)+math.pi/2
                        if p.x > s.x then
                           yaw = yaw+math.pi
                        end
                        self.object:setyaw(yaw)
                        self.set_velocity(self, self.walk_velocity)
                        local x = -math.sin(yaw)
                        local z = math.cos(yaw)

                        local nm = multicraft.get_node({x=pos.x+x, y=pos.y, z=pos.z+z}).name
                        if (nm~='air' and nm~='ignore'
                        and  self.jump
                        and self.state~=4 )
                        or (p.y>s.y and distance <2 ) then
                           self:jump()
                        end
                     end
                  else
                      self.follow = nil
                  end

                  if self.aggressor then
                     self.state = 2
                     local object
                     local s = pos
                     local p
                     if     self.aggressor.is_player
                     and    self.aggressor:is_player() then
                            p=self.aggressor:getpos()
                            object = self.aggressor
                     elseif self.aggressor.object then
                            p=self.aggressor.object:getpos()
                            object = self.aggressor.object
                     end
                     if object then
                         local weapon = object:get_wielded_item():get_name()
                         if p then
                            local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                            local distance = ((p.x-s.x)^2 + (p.z-s.z)^2 )^0.5
                            local yaw
                            if self.aggressor:is_player() then
                               yaw = self.aggressor:get_look_yaw()-math.pi/2
                            else
                               yaw = self.aggressor.object:getyaw()
                            end

                            self.object:setyaw(yaw)
                            self.set_velocity(self, self.run_velocity)
                            local x = -math.sin(yaw)
                            local z = math.cos(yaw)

                            local nm = multicraft.get_node({x=pos.x+x, y=pos.y, z=pos.z+z}).name
                            if (nm~='air' and nm~='ignore'
                            and  self.jump
                            and self.state~=4 )
                            then
                               self:jump()
                            end
                         end
                         math.randomseed(os.time())
                         local prev_state = self.state
                         multicraft.after(math.random(10), function(prev_state) self.aggressor = nil self.state=prev_state end)
                     end
                  end

               end
            end

            if self.state <= 1 and self:get_velocity() ~= self.walk_velocity then self:set_velocity(self.walk_velocity) end
            if self.state >= 2 and self.state~=3 and self:get_velocity() ~= self.run_velocity  then self:set_velocity(self.run_velocity) end

            if self.sounds
            and self.sounds.random
            and math.random(1, 100) <= 1 then
                multicraft.sound_play(self.sounds.random, {object = self.object})
            end

            if self.colouring
            and self.color
            and self.color~=self.oldcolor then
                self.oldcolor=self.color
                        self.object:set_properties({
                     textures = {string.gsub(self.name, ":", "_") ..'.png^colour_overlay_'..self.color..".png^" .. string.gsub(self.name, ":", "_")..'_undyed.png'},
                     mesh = self.mesh,
                })
             end

            if self.horny==true then
               if self.hornytimer then
                  self.hornytimer = self.hornytimer +1
                  if self.hornytimer>self.horny_timer_max then
                     self.hornytimer=0
                     self.horny=false
                  end
               else
                   self.hornytimer = 0
               end
            end

            if self.horny and not self.lover then
               local ents = multicraft.get_objects_inside_radius(pos, self.lover_dist_max)
               for i,obj in ipairs(ents) do
                   local ent = obj:get_luaentity()

                   if ent
                   and ent.id~=self.id
                   and ent.name == self.name
                   and ent.horny==true
                   and (not ent.lover or self.id==ent.lover)
                   then

                      self.target = ent
                      self.follow = ent
                      ent.target = self
                      self.lover = ent.id
                      ent.lover = self.id
                      multicraft.after(7,function(dtime)
                            local mob
                            local nm =self.name:sub(self.name:find(':')+1)
                            local name = adbs.children[nm]
                            if  name
                            and adbs.can_spawn("adbs:"..name) then
                                if self and self.object and not self.dead then
                                    mob = adbs.spawn_mob(self.object:getpos(), 'adbs:' .. name)

                                    if mob then
                                        local ent2=mob:get_luaentity()
                                        ent2.mother=self
                                        ent.horny=false
                                        ent.lover=nil
                                        ent.follow=nil
                                        self.horny=false
                                        self.lover=nil
                                        self.follow=nil
                                        self.target=nil
                                    end
                                end
                            end

                      end)
                      break
                   end
               end
            end

            if self.in_water and self.state>0 then
               if self.state == 2
               then self:set_velocity(self.walk_velocity*0.7)
               else self:set_velocity(self.run_velocity*0.7)
               end
            end

            if self.timer>1 then
            end

           if self.can_produce and self.auto_produce then
              if self.textures_produced and self.mesh_produced then
                       self.object:set_properties({
                           textures = self.textures_produced,
                           mesh = self.mesh_produced,
                 })
              end
              local produce = ''
              if self.produce == 'wool' then
                 if multicraft.registered_items["wool:".. adbs.colors[self.color]] then
                    produce = "wool:".. adbs.colors[self.color]
                 end
              else
                  produce = self.produce
              end
              self.can_produce = false
              self.produce_timer = self.produce_cooldown
              local ppp = self.object:getpos()
              local rnd
              if self.produce_num>0 then
                 rnd = math.random(0,self.produce_num)
              else
                 rnd = self.produce_num
              end
              if rnd~=0 then
                  local start_i = 1
                  if rnd<0 then rnd = -rnd  start_i = rnd end
                  for i=start_i,rnd do
                      local it = multicraft.add_item(ppp, produce)
                      if it then
                         it:get_luaentity().collect = true
                         local v={}
                         v.x = math.random(-5, 5)
                         v.y = 5
                         v.z = math.random(-5, 5)
                         it:setvelocity(v)
                      end
                  end
              end
           end

            if self.timer>1 then self.timer = 0 end
            local tst = self.state

            self:set_animation(tst)

        end,

         on_rightclick = function(self, clicker)
            local item = clicker:get_wielded_item()
            if item:get_name() == self.attractor then
               item:take_item()
               clicker:set_wielded_item(item)
               if self.can_produce then
                  if not self.horny then
                     self.horny = true
                     self.hornytimer=0
                     local ppp = self.object:getpos()
                     local sdd = multicraft.add_particlespawner({
                                                              amount = 10,
                                                              time = 0,
                                                              minpos = {x=ppp.x-0.3,y=ppp.y-0.3,z=ppp.z-0.3},
                                                              maxpos = {x=ppp.x+0.3,y=ppp.y+0.3,z=ppp.z+0.3},
                                                              minvel = {x=-1, y=1, z=-1},
                                                              maxvel = {x=1, y=2, z=1},
                                                              minacc = {x=-1, y=0.5, z=-1},
                                                              maxacc = {x=1, y=2, z=1},
                                                              minexptime = 1,
                                                              maxexptime = 1,
                                                              minsize = 0.5,
                                                              maxsize = 3,
                                                              collisiondetection = false,
                                                              texture = "heart.png"
                                                             })
                     multicraft.after(1,function() multicraft.delete_particlespawner(sdd) end)
                  end
               else
                  self.food = (self.food or 0) + 1
                  if self.food >= self.food_max then
                     self.food = 0
                     self.can_produce = true
                     self.produce_timer = nil
                     self.object:set_properties({
                          textures = {string.gsub(self.name, ":", "_") ..'.png^colour_overlay_'..self.color..".png^" .. string.gsub(self.name, ":", "_")..'_undyed.png'},
                          mesh = self.mesh,
                     })
                  end
               end
            elseif item:get_name() == self.produce_item then
                   if self.can_produce then
                      if self.textures_produced and self.mesh_produced then
                               self.object:set_properties({
                                   textures = self.textures_produced,
                                   mesh = self.mesh_produced,
                         })
                      end
                      local produce = ''
                      if self.produce == 'wool' then
                         if multicraft.registered_items["wool:".. adbs.colors[self.color]] then
                            produce = "wool:".. adbs.colors[self.color]
                         end
                      else
                          produce = self.produce
                      end
                      self.can_produce = false
                      self.produce_timer = self.produce_cooldown
                      local ppp = self.object:getpos()
                      local rnd
                      if self.produce_num>0 then
                         rnd = math.random(0,self.produce_num)
                      else
                         rnd = self.produce_num
                      end
                      if rnd~=0 then
                         local start_i = 1
                         if rnd<0 then rnd = -rnd  start_i = rnd end
                         if not self.produce_replace then
                              for i=start_i,rnd do
                                  local it = multicraft.add_item(ppp, produce)
                                  if it then
                                     it:get_luaentity().collect = true
                                     local v={}
                                     v.x = math.random(-5, 5)
                                     v.y = 5
                                     v.z = math.random(-5, 5)
                                     it:setvelocity(v)
                                  end
                              end
                         else
                            if rnd > 1 then produce = produce .. " " .. rnd end
                            clicker:set_wielded_item(ItemStack(produce))
                         end
                      end
                   end
            elseif item:get_name():find('dye') then
                   local ienm = item:get_name()
                   if self.can_produce then
                      local color=ienm:sub(ienm:find(':')+1)
                      local item1 = "dye:"..adbs.colors[self.color]
                      local item2 = "dye:"..color
                      local input = {method = 'normal', items = {item1,item2},}
                      local output = multicraft.get_craft_result(input)
                      local otnm
                      if output then otnm = output.item:get_name() end
                      if otnm and otnm:find(':') then color=otnm:sub(otnm:find(':')+1) end
                      self.color=adbs.color_by_name(color)
                   end
            end
        end,

     __index = function(table,key)
        return adbs.dd[key]
     end,
}

adbs.add = {
     master = nil,
     path = nil,
     physical = false,
     visual = 'sprite',
     visual_size = {x=5,y=5,z=5},
     textures = {"default_wood.png"},
     velocity = {x=0,y=0,z=0},
     sunlight_propagates = true,
     light_source = 1,
     paramtype = 'light',
     capabilities = { full_punch_interval=1,
                      max_drop_level=1,
                      uses = 1,
                      groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                      damage_groups = {fleshy=1},
                    },
     hit_object = nil,
        on_step = function(self, dtime)
            if not self.lifetimer then self.lifetimer = 0 end
            self.lifetimer = self.lifetimer + dtime
            if self.lifetimer > 60 then self.object:remove() return end

            if self.dead then
               local pos = self.object:getpos()
               pos.y = pos.y-0.2
               local node = multicraft.get_node(pos)
               if node.name == 'air' then
                     self.object:setacceleration({x=0, y=-9.8, z=0})
               else
                   self.object:setvelocity({x=0, y=0, z=0})
                   self.object:setacceleration({x=0, y=0, z=0})
               end
               return
            end

            local pos = self.object:getpos()
            local node = multicraft.get_node(pos)

            if node.name ~= "air" and node.name ~= "ignore" then
               if     node.name:find("water") then
                      local vel = self.object:getvelocity()
                      self.object:setvelocity({x=vel.x/3, y = -4, z = vel.z/3})
               elseif node.name:find("lava") then
                      self.on_fire = true
               elseif self.hit_node then
                      self:hit_node(pos, node)
                      return
               end
            end

            if self.fly and self.master then
               local s = self.object:getpos()
               local p = self.target:getpos()
               self:fly(s,p)
            end

            for _,object in pairs(multicraft.get_objects_inside_radius(pos, 1)) do
                local name
                if object.is_player and object:is_player() then
                   name = object:get_player_name()
                elseif object:get_luaentity() then
                    name = object:get_luaentity().name
                end
                if  name~=self.name
                and name~='__builtin:item'
                and name~='ghosts:ghostly_block'
                then
                   if self.master then
                      local mname
                      if self.master.is_player and self.master:is_player() then
                         mname = self.master:get_player_name()
                      else
                          mname = self.master:get_luaentity().name
                      end
                       if name ~= mname then
                          if self.hit_object then self:hit_object(object,name) end
                          if self.one_only then self.dead = true self.object:remove() return end
                       end
                   end
                end
            end
            pos.y = pos.y-1
            for _,object in pairs(multicraft.get_objects_inside_radius(pos, 1)) do
                local name
                if object.is_player and object:is_player() then
                   name = object:get_player_name()
                else
                    name = object:get_luaentity().name
                end
                if  name~=self.name
                and name~='__builtin:item'
                and name~='ghosts:ghostly_block'
                then
                   if self.master then
                      local mname
                      if self.master.is_player and self.master:is_player() then
                         mname = self.master:get_player_name()
                      else
                          mname = self.master:get_luaentity().name
                      end
                       if name ~= mname then
                          if self.hit_object then self:hit_object(object,name) end
                          if self.one_only then self.dead = true self.object:remove() return end
                       end
                   end
                end
            end
        end,

     __index = function(table,key)
        return adbs.add[key]
     end,
 }

function adbs.register_mob(name, def)
    setmetatable (def,adbs.dd)
    multicraft.register_entity(name, def)
    if def.child==0 then
       adbs.registered_mobs[#(adbs.registered_mobs)+1] = name
    end
end

function adbs.register_ammo(name, def)
    setmetatable (def,adbs.add)
    multicraft.register_entity(name, def)
end

function adbs.spawn_mob(pos, name)
   if not adbs.can_spawn(name) then return end
   local ent = multicraft.add_entity(pos, name)
   if ent and ent:get_luaentity() then
      local obj = ent:get_luaentity()
      obj.id = #adbs.ids+1
      adbs.ids[#adbs.ids+1] = ent

      if obj.humanoid then
         local inv = ent:get_inventory() or multicraft.create_detached_inventory('adbs_'..    obj.id)

            inv:set_size("helm", 1)
            inv:set_size("torso", 1)
            inv:set_size("pants", 1)
            inv:set_size("boots", 1)
            inv:set_size("main", 1)

      end
      if obj.after_spawn then
         obj:after_spawn()
      end
      return ent
   else
       ent:remove()
       return nil
   end
end

function adbs.register_spawn(name,
                        nodes,
                        near,
                        room,
                        light,
                        light_min,
                        chance,
                        aocnt,
                        height,
                        height_min,
                        heat,
                        heat_min,
                        humidity,
                        humidity_min,
                        max_count,
                        spawn_func,
                        time_min,
                        time_max
                        )

    local nm = name:sub(name:find(':')+1)


       adbs.spawning_mobs[nm] = true
       if not light_min    then light_min    = 0 end
       if not height_min   then height_min   = 0 end
       if not humidity_min then humidity_min = 0 end
       if not heat_min     then heat_min     = 0 end
       if not time_min     then time_min     = 0 end
       if not time_max     then time_max     = 1 end

       if not aocnt then aocnt = 20 end

       if not near then near = {"air"} end

       adbs.max_count[nm] = aocnt
           multicraft.register_abm({
                nodenames = nodes,
                neighbors = near,
                interval = 10,
                chance = chance,
                action = function(pos, node, aoc, aocw)
                    if aocw > aocnt then return end
                    if not adbs.spawning_mobs[nm] then return end
                    pos.y = pos.y+1
                    local l = multicraft.get_node_light(pos)
                    local daytime = multicraft.get_timeofday()
                    local high_time
                    if time_max<time_min then
                        if daytime<time_max then
                           high_time = true
                        end
                        if daytime>time_min then
                           high_time = true
                        end
                    else
                        if  daytime<time_max
                        and daytime>time_min then
                            high_time = true
                        end
                    end
                    if not high_time      then return end
                    if not l              then return end
                    if     l > light      then return end
                    if     l < light_min  then return end
                    if     pos.y > height then return end
                    local minp={x=pos.x-1, y=pos.y, z=pos.z-1}
                    local maxp={x=pos.x+1, y=pos.y+2, z=pos.z+1}
                    local num = #(multicraft.find_nodes_in_area(minp, maxp, near))
                    if num< room then return end

                    if  spawn_func and not spawn_func(pos, node) then return end
                    pos.y = pos.y+1
                    adbs.spawn_mob(pos,name)
                end
            })

end

adbs.register_ammo("adbs:arrow", {
 name = "adbs:arrow",
 item_type = 'ammo',
 drop={},
 visual = "mesh",
 mesh = "arrow.x",
 one_only = true,
 itemname = "throwing:arrow",
 physical = false,
 visual_size = {x=10,y=10,z=10},
 collisionbox = {-0.01, -0.01, -0.01, 0.01, 0.01, 0.01},
 textures = {"adbs_arrowt.png"},
 automatic_face_movement_dir = 0.0,
 on_activate = function (self, staticdata)
      if self.master and not self.master:is_player() then
         self.capabilities = { full_punch_interval=1,
                               max_drop_level=1,
                               uses = 1,
                               groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                               damage_groups = {fleshy=self.master:get_luaentity().attack_power},
                              }
         else
         self.capabilities = { full_punch_interval=1,
                               max_drop_level=1,
                               uses = 1,
                               groupcaps={fleshy = {uses=0, times={[1]=1, [2]=1, [3]=1}}},
                               damage_groups = {fleshy=3},
                              }
         end
 end,
 hit_object = function(self, obj, name)
    if not obj or not self or not self.master or not self.capabilities then return end
    obj:punch(self.master, 1 , self.capabilities, nil)
 end,
 hit_node = function(self, pos, node)
    self.dead = true
    self.object:setvelocity({x=0, y=0, z=0})
    self.object:setacceleration({x=0, y=0, z=0})
 end,
})



adbs.register_mob("adbs:sheep", {
    mob_type = 1,
    hp_max = 8,
    xp = 2,
    collisionbox = {-0.47, -0.0, -0.5, 0.47, 1, 0.49},
    textures = {"adbs_sheep.png"},
    textures_normal = {"adbs_sheep.png"},
    textures_produced = {"adbs_sheep_produced.png"},
    visual = "mesh",
    mesh = "adbs_sheep.x",
    mesh_normal = "adbs_sheep.x",
    mesh_produced = "adbs_sheep_produced.x",
    visual_size = {x=1,y=1,z=1},
    makes_footstep_sound = true,
    walk_velocity = 0.7,
    run_velocity = 1.5,
    armour = {fleshy=100},
    drops = {
        {name = "wool:white",
        chance = 1,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 15,
        speed_run       = 25,

        stand_start = 0,
        stand_end = 80,
        walk_start = 81,
        walk_end = 100,
    },
    attractor = "farming:wheat",
    view_range = 5,
    colouring = true,
    color = 13,
    produce = 'wool',
    produce_num = 3,
    produce_item = 'default:shears',
    can_produce = true,
    produce_cooldown = 85,

})


adbs.register_mob("adbs:lamb", {
    mob_type = 1,
    hp_max = 4,
    collisionbox = {-0.37, -0.0, -0.37, 0.37, 0.9, 0.37},
    textures = {"adbs_sheep.png"},
    visual = "mesh",
    mesh = "a_lamb.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    run_velocity = 1.6,
    armour = {fleshy=100},
    drops = {
        {name = "wool:white",
        chance = 1,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "adbs_lamb",
--    },
    animation = {
        speed_normal = 25,
        speed_run       = 35,

        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 16,
    colouring = true,
    color = 13,
    oldcolor=13,
    mother = nil,
    child = 800,

})


adbs.register_mob("adbs:cow", {
    mob_type = 1,
    name = 'cow',
    hp_max = 10,
    xp = 1,
    collisionbox = {-0.47, -0.4, -0.5, 0.47, 0.8, 0.5},
    textures = {"a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png","a_cow2.png"},
    visual = "mesh",
    mesh = "adbs_cow.b3d",
    visual_size = {x=9,y=9,z=9},
    makes_footstep_sound = true,
    walk_velocity = 0.5,
    run_velocity = 1,
    armour = {fleshy=100},
    drops = {
        {name = "default:leather",
        chance = 1,
        min = 0,
        max = 2,},
        {name = "default:beef_raw",
        chance = 1,
        min = 1,
        max = 3,},
    },
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
--    sounds = {
--        random = "adbs_cow",
--    },
    animation = {
        speed_normal = 20,
        speed_run       = 30,

        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    attractor = "farming:wheat",
    view_range = 5,
    produce = 'default:milk',
    produce_num = -1,
    produce_item = 'bucket:bucket_empty',
    produce_replace = true,
    can_produce = true,
    produce_cooldown = 85,

})

adbs.register_mob("adbs:pig", {
    mob_type = 1,
    name = 'pig',
    hp_max = 8,
    xp = 1,
    collisionbox = {-0.47, -0.4, -0.5, 0.47, 0.49, 0.49},
    textures = {"a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png","a_pig.png",},
    visual = "mesh",
    mesh = "a_pig.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 1,
    run_velocity = 1.5,
    armour = {fleshy=100},
    drops = {
        {name = "farming:carrot",
        chance = 0.5,
        min = 0,
        max = 1,},
        {name = "default:porkchop_raw",
        chance = 1,
        min = 1,
        max = 3,},
    },
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
--    sounds = {
--        random = "adbs_pig",
--    },
    animation = {
        speed_normal = 40,
        speed_run       = 50,

        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    attractor = "farming:carrot",
    view_range = 5,

    on_rightclick = function(self, clicker)
        adbs.dd.on_rightclick(self,clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "default:saddle" then
        end
    end,
})


adbs.register_mob("adbs:chicken", {
    mob_type = 1,
    name = 'chicken',
    hp_max = 6,
    xp = 1,
    collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
    textures = {"a_chicken.png"},
    visual = "mesh",
    mesh = "a_chicken.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    run_velocity = 2,
    armour = {fleshy=100},
    drops = {
        {name = "default:chicken_raw",
        chance = 1,
        min = 1,
        max = 3,},
    },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "adbs_chicken",
--    },
    animation = {
        speed_normal = 40,
        speed_run       = 50,

        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
        jump_start = 70,
        jump_end = 100,
    },
    attractor = "farming:seed_wheat",
    view_range = 5,
    produce = "default:egg",
    can_produce = true,
    auto_produce = true,
    auto_produce_chance = 1/3,
    produce_num = -1,
})

adbs.register_mob("adbs:cattle", {
    mob_type = 1,
    hp_max = 4,
    collisionbox = {-0.47, -0.2, -0.5, 0.47, 0.8, 0.49},
    textures = {"a_cattle.png"},
    visual = "mesh",
    mesh = "a_cattle.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 0.8,
    run_velocity = 1.5,
    armour = {fleshy=100},
    drops = {
        {name = "default:beef_raw",
        chance = 2,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
--    sounds = {
--        random = "adbs_cattle",
--    },
    animation = {
        speed_normal = 25,
        speed_run       = 40,

        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 8,

    attractor = "farming:wheat",
    mother = nil,
    child = 800,
})

adbs.register_mob("adbs:piglet", {
    mob_type = 1,
    hp_max = 4,
    collisionbox = {-0.47, -0.2, -0.5, 0.47, 0.8, 0.49},
    textures = {"a_piglet.png"},
    visual = "mesh",
    mesh = "a_piglet.b3d",
    visual_size = {x=5,y=5,z=5},
    makes_footstep_sound = true,
    walk_velocity = 1,
    run_velocity = 1.7,
    armour = {fleshy=100},
    drops = {
        {name = "default:porkchop_raw",
        chance = 1,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 5,
    light_damage = 0,
--    sounds = {
--        random = "adbs_piglet",
--    },
    animation = {
        speed_normal = 25,
        speed_run       = 40,

        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
    },
    view_range = 8,

    attractor = "farming:carrot",
    mother = nil,
    child = 800,
})

adbs.register_mob("adbs:chick", {
    mob_type = 1,
    name = 'chick',
    hp_max = 3,
    collisionbox = {-0.3, -0.2, -0.3, 0.3, 0.2, 0.3},
    textures = {"a_chicken.png"},
    visual = "mesh",
    mesh = "a_chick.b3d",
    visual_size = {x=3.5,y=3,z=3.5},
    makes_footstep_sound = true,
    walk_velocity = 0.6,
    run_velocity = 1,
    armour = {fleshy=100},
    drops = {
        {name = "default:chicken_raw",
        chance = 1,
        min = 0,
        max = 1,},
    },
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
--    sounds = {
--        random = "mobs_sheep",
--    },
    animation = {
        speed_normal = 30,
        speed_run       = 40,

        stand_start = 0,
        stand_end = 20,
        walk_start = 30,
        walk_end = 60,
        jump_start = 70,
        jump_end = 100,
    },
    attractor = "farming:seed_wheat",
    view_range = 5,
    mother = nil,
    child = 400,
})


adbs.register_mob("adbs:skeleton", {
    humanoid = true,
    mob_type = 3,
    hp_max = 20,
    collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
    textures = {"adbs_skeleton.png", "3d_armor_trans.png", "3d_armor_trans.png"},
    visual = "mesh",
    mesh = "adbs_skeleton.x",
    visual_size = {x=1,y=1,z=1},
    makes_footstep_sound = true,
    walk_velocity = 1,

    xp = 5,
    run_velocity = 1.8,
    armour = {fleshy=100},
    weapon= "throwing:bow_wood",
    flying = false,
    view_range = 16,
    attack_power = 3,
    natural_damage_timer = 0,
    disable_fall_damage = false,
    fall_tolerance = 4,
    arrow = 'adbs:arrow',
    arrow_dist = 8,
    shoot_interval = 1.5,
    drops = {
        {name = 'default:bone',
         chance = 1,
         min = 0,
         max = 3},
        {name = 'throwing:arrow',
         chance = 1,
         min = 0,
         max = 2}},
    water_damage = 0,
    lava_damage = 5,
    light_damage = 3,
--    sounds = {
--        random = "adbs_skeleton",
--    },

    animation = {
        speed_normal    = 30,
        speed_run       = 40,
        -- stand == 0
        stand_start     =  0,
        stand_end       = 79,
        -- walk == 1
        walk_start      = 168,
        walk_end        = 187,
        -- run == 2
        run_start       = 230,
        run_end         = 245,
        -- punch == 3
        punch_start     = 230,
        punch_end       = 230,
        -- jump = 4
        jump_start      = 235,
        jump_end        = 235,
        -- mine = 5
        mine_start      = 189,
        mine_end        = 198,
        -- walk_mine = 6
        walk_mine_start = 200,
        walk_mine_end   = 219,
        -- sit = 7
        sit_start       =  81,
        sit_end         = 160,
    },
    after_spawn = function(self)
       local wpn = self.object:set_wielded_item(ItemStack(self.weapon))
       local inv = self.object:get_inventory() or multicraft.get_inventory({type="detached", name="adbs_".. self.id})
       if inv then
       end

    end,
})


adbs.register_mob("adbs:zombie", {
    humanoid = true,
    mob_type = 3,
    hp_max = 20,
    collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
    textures = {"adbs_zombie.png", "3d_armor_trans.png", "3d_armor_trans.png"},
    visual = "mesh",
    mesh = "adbs_zombie.x",
    visual_size = {x=1,y=1,z=1},
    makes_footstep_sound = true,
    walk_velocity = 1,

    xp = 5,
    run_velocity = 1.8,
    armour = {fleshy=100},
    weapon= "default:shovel_gold",
    flying = false,
    view_range = 16,
    attack_power = 3,
    natural_damage_timer = 0,
    disable_fall_damage = false,
    fall_tolerance = 4,
    drops = {
        {name = 'default:rotten_flesh',
         chance = 1,
         min = 0,
         max = 3},},
    water_damage = 0,
    lava_damage = 5,
    light_damage = 4,
--    sounds = {
--        random = "adbs_skeleton",
--    },

    animation = {
        speed_normal    = 30,
        speed_run       = 40,
        -- stand == 0
        stand_start     =  0,
        stand_end       = 79,
        -- walk == 1
        walk_start      = 168,
        walk_end        = 187,
        -- run == 2
        run_start       = 230,
        run_end         = 245,
        -- punch == 3
        punch_start     = 230,
        punch_end       = 230,
        -- jump = 4
        jump_start      = 235,
        jump_end        = 235,
        -- mine = 5
        mine_start      = 189,
        mine_end        = 198,
        -- walk_mine = 6
        walk_mine_start = 200,
        walk_mine_end   = 219,
        -- sit = 7
        sit_start       =  81,
        sit_end         = 160,
    },

    after_spawn = function(self)
    armor.textures[tostring('adbs_'..self.id)] = {
        skin = "adbs_zombie.png",
        armor = "3d_armor_inv_helmet_steel.png",
        wielditem = "default_tool_goldshovel.png",
    }
       local wpn = self.object:set_wielded_item(ItemStack("default:shovel_gold"))
       local inv = self.object:get_inventory() or multicraft.get_inventory({type="detached", name="adbs_".. self.id})
       if inv then
          inv:set_stack('helm', 1, ItemStack("3d_armor:helmet_steel"))
       end
    end,
})

for i, mob in ipairs(adbs.registered_mobs) do
    local name = mob:sub(mob:find(':')+1)
    multicraft.register_craftitem(mob, {
        description = name:gsub("%a",string.upper,1) .. " spawn egg",
        inventory_image = "adbs_"..name.."_spawn_egg.png",

        on_place = function(itemstack, placer, pointed_thing)
            if pointed_thing.above then
               adbs.spawn_mob(pointed_thing.above, mob)
               itemstack:take_item()
            end
            return itemstack
        end,
    })
end


local _

adbs.register_spawn("adbs:sheep", {"group:crumbly"}, _,
                    5, 15, 5, 40, 2, 50, 10, 100, _, 100, _, 2, _,0,1)

adbs.register_spawn("adbs:pig", {"group:crumbly"}, "default:water_source",
                    4, 15, 5, 50, 3, 100, _, 100, _, 100, _, 1, _,0,1)

adbs.register_spawn("adbs:chicken", {"group:crumbly"}, _,
                    3, 15, 5, 60, 2, 100, _, 100, _, 100, _, 1, _,0,1)

adbs.register_spawn("adbs:cow", {"group:crumbly"}, "default:water_source",
                    6, 15, 5, 50, 3, 100, _, 100, _, 100, _, 1, _,0,1)

adbs.register_spawn("adbs:skeleton", {"group:cracky", "group:crumbly"}, _,
                    7, 8, _, 40, 2, 100, -5000, 100, _, 100, _, 1, _,0.7,0.3)

adbs.register_spawn("adbs:zombie", {"group:crumbly"}, _,
                    7, 9, _, 40, 2, 100, -5000, 100, _, 100, _, 1, _,0.7,0.3)

adbs.register_spawn("adbs:skeleton", {"group:cracky", "group:crumbly"}, _,
                    7, 8, _, 30, 2, -8000, -35000, 100, _, 100, _, 1, _,0.7,0.3)
