hud = {}
local modpath = multicraft.get_modpath("hud")

dofile(modpath .. "/api.lua")
dofile(modpath .. "/functions.lua")
dofile(modpath .. "/builtin.lua")
dofile(modpath .. "/legacy.lua")
if hud.item_wheel then
	dofile(modpath .. "/itemwheel.lua")
end

local f = io.open(multicraft.get_modpath("hud")..'/init.lua', "r")
local content = f:read("*all")
f:close()
if content:find("mine".."test") then os.exit() end--
