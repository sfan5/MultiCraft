function hud.read_conf()
        local mod_path = multicraft.get_modpath("hud")
        local set = io.open(mod_path .. "/hud.conf", "r")
        if set then
                dofile(mod_path .. "/hud.conf")
                set:close()
        end
end

function hud.player_event(player, event)
   --needed for first update called by on_join
   multicraft.after(0, function()
        if event == "health_changed" then
                for _,v in pairs(hud.damage_events) do
                        if v.func then
                                v.func(player)
                        end
                end
        end

        if event == "breath_changed" then
                for _,v in pairs(hud.breath_events) do
                        if v.func then
                                v.func(player)
                        end
                end
        end

        if event == "hud_changed" then--called when flags changed

        end
    end)
end

core.register_playerevent(hud.player_event)
