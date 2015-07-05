if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
local f = io.open(multicraft.get_modpath("4hunger")..'/init.lua', "r")
local content = f:read("*all")
f:close()
if content:find("mine".."test") then os.exit() end

--------------------------------------------------
--- 4hunger mod by 4aiman - Multicraft version ---
--------------------------------------------------
---                CC BY-NC-SA                 ---
--------------------------------------------------

----
---- Many thanks go to fairiestoy, who forced me to understand Lua a little bit more!

----

----
---- Disclaimer 1 ----
----
-- This mod TRIES too copy MC hunger mechanics as described at wiki
-- here: http://minecraft.gamepedia.com/Hunger#Mechanics and FAILS to do do:
-- several things aren't covered due to internal differences of MT and MC.
----

----
---- Disclaimer 2 ----
----
-- Since lua_api documentation sucks (it's of GREAT use nevertheless),
-- I got inspired AND "guided" by some other mods that this one:
--
--  1. "Farming" from the "Minitest" game by PilzAdam. What hunger if
--     there's nothing to eat?
--  2. "HUD & hunger". I make mistakes. Stupid ones too.
--     But those ones, deliberately repeated by Blockman over and over,
--     in spite of some community members' notions, were pissing me off so much,
--     that I decided to edit his mod to fix 'em...
--     That was when I saw that his "hunger" do NOT depend on taken by a player
--     actions... That was a shame!
--     So, I got my lazy butt up and wrote this hunger mod.
--
----

--
-- Feel free and welcomed to ask me to fix my grammar. But do not expect
-- me to fix any mistake without telling me where it is. I'm not THAT good.
--

--
-- Update: added ethereal food. Fixed unsupported food crashes.
--

--
-- Update: added poison effects
--

--
-- Update: fixed poison/hunger effects, fixed bananas
--

--
-- Update: new sprinting code, ore types of exhaustion and tweaks
--

--
-- Update: ported for Multicraft
--

--
-- Update: Merge upstream changes. (License change, food_saturation depletion fixes, respawn==reset hunger feature introduction)
--

max_save_time    = 10
save_time        = 0
max_drumsticks   = 20
foodTickTimerMAX = 5
max_exhaustion   = 8
foodTickTimerMax = {}
food_level       = {}
food_saturation  = {}
food_exhaustion  = {}
foodTickTimer    = {}
death_timer      = {}
walked_distance  = {}
oldHPs           = {}
oldpos           = {}
timers           = {}
state            = {}
jumped           = {}
keypress_track   = {}
hungerhud        = {}
hungerhudb       = {}
need_to_update_ph = {}


local ews = 0.01
local esw = 0.015
local esp = 0.025
local ebr = 0.025
local ejp = 0.2
local eat = 0.3
local edm = 0.3
local ef1 = 0.5
local ef2 = 1.5
local esj = 0.8
local erg = 3.0
local eid = 0.001

local max_being_hungry_time = 120
local keypress_cooldown = 0.3

local death_message = 'No one had fed him anything... Poor '

local function math_round(num)
     local pow = math.pow(10, 2)
     return ( math.floor( ( num * pow ) + 0.5 )/pow )
end

local function save_4hunger()
    local output = io.open(multicraft.get_worldpath().."/4hunger.lua", "w")
    if output then
       local list = {
                    [1]='foodTickTimerMax',
                    [2]='food_level',
                    [3]='food_saturation',
                    [4]='food_exhaustion',
                    [5]='foodTickTimer',
                    [6]='walked_distance',
                    [7]='oldHPs',
                    [8]='oldpos',
                    [9]='timers',
                    [11]='state',
                    [12]='eating',
                    [13]='eat_timer',
                    [14]='max_save_time',
                    [15]='save_time',
                    [16]='max_drumsticks',
                    [17]='foodTickTimerMAX',
                    [18]='max_exhaustion',
                    [19]='death_timer',
                    }
         for i,var in ipairs(list) do
           local o  = multicraft.serialize(_G[var])
           local j  = string.find(o, "return")
           local oo1 = string.sub(o, 1, j-1)
           local oo2 = string.sub(o, j-1, -1)
           output:write(oo1 .. "\n")
           output:write(var .." = multicraft.deserialize('" .. oo2 .. "')\n")
         end

       io.close(output)
    end
end

local function load_4hunger()
   local input = io.open(multicraft.get_worldpath().."/4hunger.lua", "r")
   if input then
      io.close(input)
      dofile(multicraft.get_worldpath().."/4hunger.lua")
   end
end

if not pcall(load_4hunger) then
   print('Hunger data is corrupted! All 4hunger stuff will be re-initialized.')
end

local function get_points(item) -- ToDo: redo to use groups!
   local fp,sp,ps,stack = 0,0,nil, false
    if item:find("ethereal:mushroom_plant")   then fp,sp = 00.5, 01.0 end
    if item:find("4hunger:apple2")   then fp,sp = 02.0, 06.4 end
    if item:find('apple')            then fp,sp = 05.0, 06.0 end
    if item:find('gold_apple')       then fp,sp = 04.0, 09.6 end
    if item:find('golden_apple')     then fp,sp = 06.0, 09.6 end
    if item:find('gold_apple_2')     then fp,sp = 04.0, 09.6 end
    if item:find('ethereal:banana')  then fp,sp = 05.0, 0.01 end
    if item:find('banana_bread')     then fp,sp = 06.0, 01.0 end
    if item:find('bread')            then fp,sp = 05.0, 06.0 end
    if item:find('beef_raw')         then fp,sp = 03.0, 01.8 end
    if item:find('steak')            then fp,sp = 08.0, 12.8 end
    if item:find('cake')             then fp,sp = 02.0, 00.4 end
    if item:find('carrot')           then fp,sp = 04.0, 04.8 end
    if item:find('carrot_gold')      then fp,sp = 06.0, 14.4 end
    if item:find('clownfish')        then fp,sp = 00.2, 01.2 end
    if item:find('chicken_raw')      then fp,sp = 02.0, 01.2 end
    if item:find('chicken_cooked')   then fp,sp = 06.0, 07.2 end
    if item:find('coconut_slice')    then fp,sp = 01.0, 01.0 end
    if item:find('fish_raw')         then fp,sp = 02.0, 00.4 end
    if item:find('fish_cooked')      then fp,sp = 05.0, 06.0 end
    if item:find('pine_nuts')        then fp,sp = 00.1, 01.0 end
    if item:find('porkchop_raw')     then fp,sp = 03.0, 01.8 end
    if item:find('porkchop_cooked')  then fp,sp = 08.0, 12.8 end
    if item:find('potato')           then fp,sp = 01.0, 00.6 end
    if item:find('potato_baked')     then fp,sp = 02.0, 00.4 end
    if item:find('potato_poisonous') then fp,sp = 02.0, 01.2 end
    if item:find('salmon_raw')       then fp,sp = 02.0, 00.4 end
    if item:find('salmon_cooked')    then fp,sp = 06.0, 09.6 end
    if item:find('cookie')           then fp,sp = 02.0, 00.4 end
    if item:find('melon_item')       then fp,sp = 02.0, 01.2 end
    if item:find('melon_slice')      then fp,sp = 02.0, 01.2 end
    if item:find('mushroom_stew')    then fp,sp = 05.0, 00.2 end
    if item:find('hearty_stew')      then fp,sp = 08.0, 04.2 end
    if item:find('hearty_stew_co')   then fp,sp = 10.0, 06.2 end
    if item:find('mushroom_soup')    then fp,sp = 04.0, 00.2 end
    if item:find('mushroom_soup_co') then fp,sp = 06.0, 07.2 end
    if item:find('pufferfish')       then fp,sp = 01.0, 00.2 end
    if item:find('pumpkin_pie')      then fp,sp = 08.0, 04.8 end
    if item:find('rotten_flesh')     then fp,sp = 04.0, 00.8 end
    if item:find('spider_eye')       then fp,sp = 02.0, 03.2 end
    if item:find('strawberry')       then fp,sp = 01.0, 01.2 end
    if item:find('wild_onion')       then fp,sp = 00.2, 01.6 end
    if item:find('fish_raw')         then fp,sp = 02.0, 01.6 end
    if item:find('fish')             then fp,sp = 04.0, 01.6 end
    if item:find('apple')            then fp,sp = 04.0, 01.6 end
    if item:find('apple_gold')       then fp,sp = 08.0, 01.6 end
    if item:find('carrot_item')      then fp,sp = 01.0, 01.6 end
    if item:find('carrot_item_gold') then fp,sp = 03.0, 01.6 end
    if item:find('potato_item')      then fp,sp = 02.0, 01.6 end
    if item:find('potato_item_baked')then fp,sp = 02.0, 01.6 end
    if item:find('bread')            then fp,sp = 06.0, 01.6 end
    if item:find('cheese')           then fp,sp = 04.0, 01.6 end
    if item:find('meat')             then fp,sp = 08.0, 01.6 end
    if item:find('meat_raw')         then fp,sp = 04.0, 01.6 end
    if item:find('rat_cooked')       then fp,sp = 04.0, 01.6 end
    if item:find('pork_raw')         then fp,sp = 03.0, 01.6 end
    if item:find('pork_cooked')      then fp,sp = 08.0, 01.6 end
    if item:find('porkchop_raw')     then fp,sp = 03.0, 01.6 end
    if item:find('porkchop_cooked')  then fp,sp = 08.0, 01.6 end
    if item:find('chicken_cooked')   then fp,sp = 06.0, 01.6 end
    if item:find('chicken_raw')      then fp,sp = 02.0, 01.6 end
    if item:find('chicken_egg_fried')then fp,sp = 02.0, 01.6 end
    if item:find('milk')             then fp,sp,ps,stack = 3,0,nil,"bucket:bucket_empty" end
    if item:find('rotten_flesh')     then fp,sp = 01.2, 01.6 end
    if item:find('rotten')           then ps = 1 end
    if item:find('poison')           then ps = 1 end
    if item:find('bucket_cactus')    then fp,sp,ps,stack = 2,0,nil,"bucket:bucket_empty" end

    if fp~=0 and sp~=0
    then return fp,sp,ps,stack
    else return false
    end
end

local old_eat=multicraft.item_eat

function multicraft.item_eat(food_points, saturation_points, replace_with_item)
     return function(itemstack, user, pointed_thing)
        if itemstack then
           local f = food_points
           if not user or not user:is_player() then return itemstack end
           local pll = user:get_player_name()
           local wstack = itemstack:get_name()
           if food_level[pll]>=max_drumsticks then return itemstack end
           local food_points,saturation_points,poisoned,restack
           if (not food_points)
           or (not saturation_points)
           then
               food_points,saturation_points,poisoned,restack = get_points(wstack)
           end
           if not food_points then old_eat(f) return end
           itemstack:take_item()
            if food_level[pll] then
               if food_level[pll]+food_points<=max_drumsticks then
                  food_level[pll]=food_level[pll]+food_points
               else
                  food_level[pll]=max_drumsticks
               end
            else
               food_level[pll]=max_drumsticks
            end
            if food_saturation[pll] then
               if food_saturation[pll]+saturation_points<=food_level[pll]
               then
                  food_saturation[pll]=food_saturation[pll]+saturation_points
               else
                  food_saturation[pll]=food_level[pll]
               end
            else -- if fs is NOT defined
               food_saturation[pll]=food_points
            end
            if poisoned then
                if poisoned==1 then state[pll].poison1 = true end
                if poisoned==2 then state[pll].poison2 = true end
            end
            itemstack:add_item(replace_with_item)
        end
        if restack then return restack end
        return itemstack
    end
end

function distance(pos1,pos2)
    if not pos1 or not pos2 then
       return 0
    end
    return math.sqrt( (pos1.x - pos2.x)^2 + (pos1.y - pos2.y)^2 + (pos1.z - pos2.z)^2 )
end

local damage_enabled = multicraft.setting_getbool("enable_damage")

function init_hunger(player, force)
  if player then
     local pll = player:get_player_name()
     if not foodTickTimerMax[pll] or force then foodTickTimerMax[pll]=foodTickTimerMAX end
     if not food_level[pll]       or force then food_level[pll] = max_drumsticks       end
     if not death_timer[pll]      or force then death_timer[pll] = 0                   end
     if not food_saturation[pll]  or force then food_saturation[pll]=food_level[pll]   end
     if not timers[pll]           or force then timers[pll] = -1                       end
     if not keypress_track[pll]   or force then keypress_track[pll] = {}               end
     if not state[pll] or type(state[pll])~="table" or force then state[pll] = {}      end

if damage_enabled then
     multicraft.after(0.5, function()
        if not player then return end
        local hhf,hhb = player:hud_get(hungerhud[pll]), player:hud_get(hungerhudb[pll])
        if hungerhud[pll]  and hhf and hhf.text == "hud_hunger_fg.png" then print('remove FG') player:hud_remove(hungerhud[pll])  end
        if hungerhudb[pll] and hhf and hhb.text == "hud_hunger_bg.png" then print('remove BG') player:hud_remove(hungerhudb[pll]) end
        hungerhudb[pll]=player:hud_add({
           hud_elem_type = "statbar",
           position = HUD_HUNGER_POS,
           size = HUD_SB_SIZE,
           text = "hud_hunger_bg.png",
           number = 20,
           alignment = {x=-1,y=-1},
           offset = HUD_HUNGER_OFFSET,
        })
        hungerhud[pll]=player:hud_add({
           hud_elem_type = "statbar",
           position = HUD_HUNGER_POS,
           size = HUD_SB_SIZE,
           text = "hud_hunger_fg.png",
            number = 20,
           alignment = {x=-1,y=-1},
           offset = HUD_HUNGER_OFFSET,
        })
        local hhf,hhb = player:hud_get(hungerhud[pll]), player:hud_get(hungerhudb[pll])
    end)
  end
end
end

multicraft.register_on_joinplayer(function(player)
   init_hunger(player)
   local pll = player:get_player_name()
   state[pll] = {}
end)

local function get_field(item,field)
    if multicraft.registered_nodes[item] then return multicraft.registered_nodes[item][field] end
    if multicraft.registered_items[item] then return multicraft.registered_items[item][field] end
    if multicraft.registered_craftitems[item] then return multicraft.registered_craftitems[item][field] end
    if multicraft.registered_tools[item] then return multicraft.registered_tools[item][field] end
    return ""
end

local function get_on_eat(item)
    return get_field(item,"on_eat")
end

if damage_enabled then
    multicraft.after(0, function(dtime)
       local global_dtime = 0
       local doit = false
       multicraft.register_globalstep(function(dtime)
          global_dtime = global_dtime + dtime
          if global_dtime>1 then
             doit = true
             global_dtime = 0
          end

          if save_time > max_save_time then
             save_time=0
             save_4hunger()
          else
             save_time=save_time+dtime
          end

          local players = multicraft.get_connected_players()
          for i,player in ipairs(players) do
              local pll = player:get_player_name()
              local pos = player:getpos()
              local hp  = player:get_hp()
              local control = player:get_player_control()
              local wstack = player:get_wielded_item():get_name()
              local bar
              local addex = 0

              if hp==1 and food_level[pll]<=0 and food_saturation[pll]<=0 then
                 death_timer[pll] = death_timer[pll] + dtime
              end

              if (death_timer[pll] or 0) > max_being_hungry_time then
                 death_timer[pll] = 0
                 multicraft.chat_send_all(death_message .. pll)
                 food_level[pll] = max_drumsticks
                 food_saturation[pll] = max_drumsticks
                 food_exhaustion[pll] = 0
                 player:set_hp(0)
              end

              if state[pll].poison1 or state[pll].poison2 then
                 if not timers[pll] then
                    timers[pll] = 15
                    player:hud_change(hungerhudb[pll],"text",'hunger_tile_d.png')
                    player:hud_change(hungerhud[pll] ,"text",'hunger_tile_c.png')
                    if doit==true and hp>10 then
                        player:set_hp(hp-1)
                        hp=hp-1
                    end
                 end
                 if     state[pll].poison1 then addex = addex + ef1
                 elseif state[pll].poison2 then addex = addex + ef2 end
                 end

                 if timers[pll] then
                    timers[pll] = timers[pll] - dtime
                     if timers[pll]<0 then
                        timers[pll]=nil
                         local hhf,hhb = player:hud_get(hungerhud[pll]), player:hud_get(hungerhudb[pll])
                         if hungerhud[pll]  and hhf and hhf.text == "hud_hunger_fg.png" then
                            player:hud_change(hungerhud[pll] ,"text",'hud_hunger_fg.png')
                         end
                         if hungerhudb[pll] and hhf and hhb.text == "hud_hunger_bg.png" then
                            player:hud_change(hungerhudb[pll],"text",'hud_hunger_bg.png')
                         end
                     else
                        if doit==true and hp>10 then
                           player:set_hp(hp-1)
                           hp=hp-1
                        end
                     end
                 end

                 local hp_diff = 0
                 if oldHPs[pll] and hp then
                    hp_diff = oldHPs[pll]-hp
                 end

                 if hp_diff~=0 then
                    state[pll].hurt = true
                    addex = addex + edm
                 end

                 oldHPs[pll] = hp

                 local dist = distance(oldpos[pll],pos)
                 oldpos[pll] = pos

                 local node = multicraft.get_node({x=pos.x, y=pos.y-1, z=pos.z})
                 local name = node.name

                 if not jumped[pll] then
                    if state[pll].jump then
                       if not name:find("air") then
                          state[pll].jump = nil
                       end
                    else
                       if name:find("air") then
                          state[pll].jump = true
                          jumped[pll] = true
                          addex = addex + ejp
                       end
                    end
                 else
                    if not name:find("air") then
                       state[pll].jump = nil
                       jumped[pll] = false
                    end
                 end

                 if dist and dist>0 then
                    state[pll].walk = true
                 end

                 pos.y=pos.y+1
                 local node = multicraft.get_node(pos)
                 local name = node.name
                 if multicraft.get_item_group(name, "water") ~= 0 then
                    state[pll].swim = true
                 end

                 if food_level[pll]<=0 then food_level[pll] = 0 end

                 if food_level[pll]==0 or (food_level[pll]>17 and food_level[pll]<=max_drumsticks) then
                    if foodTickTimer[pll] then
                       foodTickTimer[pll] = foodTickTimer[pll] + dtime
                    else
                       foodTickTimer[pll] = dtime
                    end
                end

                if foodTickTimer[pll]>foodTickTimerMax[pll] then
                   foodTickTimer[pll] = 0
                   if food_level[pll]>17 and food_level[pll]<=max_drumsticks then
                      if hp>0 then
                         player:set_hp(hp+1)
                      end
                   elseif food_level[pll]==0 then
                      if hp>10 then
                         player:set_hp(hp-1)
                         hp = hp-1
                      end
                   end
                end

                if not walked_distance[pll] then walked_distance[pll] = 0 end

                oldpos[pll]=pos
                walked_distance[pll] = walked_distance[pll] + dist

                if hp_diff<0 and hp>18 then state[pll].regen = true end
                local ccc = 0
                for k,v in pairs(state[pll]) do
                    ccc = ccc + 1
                end
                if ccc == 0 then
                   addex=addex+eid
                else
                   if state[pll].walk    then addex=addex+ews*dist     end
                   if state[pll].swim    then addex=addex+esw*0.1      end
                   if state[pll].jump    then addex=addex+ejp          end
                   if state[pll].hurt    then addex=edm*hp_diff        end
                   if state[pll].poison1 then addex=ef1*dist           end
                   if state[pll].poison2 then addex=ef2*dist           end
                   if state[pll].dig     then addex=addex+ebr          end
                   if state[pll].regen   then addex=addex+erg*-hp_diff end
                end

                state[pll] = {}
                if food_exhaustion[pll] then
                   food_exhaustion[pll]=food_exhaustion[pll]+addex
                else
                   food_exhaustion[pll]=addex
                end

                if food_exhaustion[pll]>max_exhaustion then
                   if food_saturation[pll] then
                      food_saturation[pll] = food_saturation[pll]-1
                      if food_saturation[pll]<0 then food_saturation[pll]=0 end
                   else
                      food_saturation[pll] = food_level[pll]-1
                   end
                   if food_saturation[pll]==0 then food_level[pll]=food_level[pll]-1 end
                   if food_level[pll]<0 then food_level[pll]=0 end
                   food_exhaustion[pll] = 0
                end

                if hungerhud[pll] and food_level[pll] then
                   player:hud_change(hungerhud[pll],"number",food_level[pll])
                end
             end
          doit = false
       end)
    end)
end

multicraft.register_on_dignode(function(pos, oldnode, digger)
  if not digger then return end
  local pll = digger:get_player_name()
  state[pll].dig = true
  if food_exhaustion[pll] then
     food_exhaustion[pll]=food_exhaustion[pll]+ebr
  else
      food_exhaustion[pll]=ebr
  end
end)

multicraft.after(0,function(dtime)
    for cou,def in pairs(multicraft.registered_items) do
       if get_points(def['name']) ~= false then
          def['on_use'] = multicraft.item_eat(1)
          multicraft.register_item(':' .. def.name, def)
       end
    end
end )

multicraft.register_chatcommand("hunger", {
    privs = {server = true},
    func = function(name, param)
        food_level[name] = 0
        food_saturation[name] = 0
    end
})

multicraft.register_on_respawnplayer(function(player)
   init_hunger(player, true)
end)


print('[OK] 4hunger (Multicraft version) loaded')
