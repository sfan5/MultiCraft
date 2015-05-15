if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
local homes_file = multicraft.get_worldpath() .. "/homes"
local homepos = {}

local function loadhomes()
    local input = io.open(homes_file, "r")
    if input then
        repeat
            local x = input:read("*n")
            if x == nil then
                break
            end
            local y = input:read("*n")
            local z = input:read("*n")
            local name = input:read("*l")
            homepos[name:sub(2)] = {x = x, y = y, z = z}
        until input:read(0) == nil
        io.close(input)
    else
        homepos = {}
    end
end

loadhomes()

multicraft.register_privilege("home", "Can use /sethome and /home")

local changed = false

multicraft.register_chatcommand("home", {
    description = "Teleport you to your home point",
    privs = {home=true},
    func = function(name)
        local player = multicraft.get_player_by_name(name)
        if player == nil then
            -- just a check to prevent the server crashing
            return false
        end
        if homepos[player:get_player_name()] then
            player:setpos(homepos[player:get_player_name()])
            multicraft.chat_send_player(name, "Teleported to home!")
        else
            multicraft.chat_send_player(name, "Set a home using /sethome")
        end
    end,
})

multicraft.register_chatcommand("sethome", {
    description = "Set your home point",
    privs = {home=true},
    func = function(name)
        local player = multicraft.get_player_by_name(name)
        local pos = player:getpos()
        homepos[player:get_player_name()] = pos
        multicraft.chat_send_player(name, "Home set!")
        changed = true
        if changed then
            local output = io.open(homes_file, "w")
            for i, v in pairs(homepos) do
                output:write(v.x.." "..v.y.." "..v.z.." "..i.."\n")
            end
            io.close(output)
            changed = false
        end
    end,
})
