
multicraft.register_chatcommand("night", {
    params = "",
    description = "Make the night",
    privs = {settime = true},
    func = function(name, param)
                local player = multicraft.get_player_by_name(name)
                if not player then
                        return
                end
       multicraft.set_timeofday(0.22)
    end
})

multicraft.register_chatcommand("day", {
    params = "",
    description = "Make the day wakeup",
    privs = {settime = true},
    func = function(name, param)
                local player = multicraft.get_player_by_name(name)
                if not player then
                        return
                end
                multicraft.set_timeofday(0.6)
    end
})


