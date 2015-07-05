if not multicraft.get_modpath("check") then os.exit() end
-- multicraft 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

WATER_ALPHA = 160
WATER_VISC = 1
LAVA_VISC = 7
LIGHT_MAX = 20

-- Definitions made by this mod that other mods can use too
default = {}
default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project = true
exit = os.exit
default.exit = exit
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
local f = io.open(multicraft.get_modpath("default")..'/init.lua', "r")
local content = f:read("*all")
f:close()
if content:find("mine".."test") then os.exit() end--

-- Load files
dofile(multicraft.get_modpath("default").."/functions.lua")
dofile(multicraft.get_modpath("default").."/nodes.lua")
dofile(multicraft.get_modpath("default").."/tools.lua")
dofile(multicraft.get_modpath("default").."/craftitems.lua")
dofile(multicraft.get_modpath("default").."/crafting.lua")
dofile(multicraft.get_modpath("default").."/mapgen.lua")
dofile(multicraft.get_modpath("default").."/player.lua")

-- Aliases
multicraft.register_alias("default:desert_sand", "default:sand")
multicraft.register_alias("default:desert_stone", "default:sandstone")
multicraft.register_alias("default:iron_lump", "default:stone_with_iron")
multicraft.register_alias("default:gold_lump", "default:stone_with_gold")
