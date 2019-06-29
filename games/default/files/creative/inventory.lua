local has_armor = minetest.get_modpath("3d_armor")
local player_inventory = {}
local inventory_cache = {}

local ofs_tab = {}
local ofs_img = {}
local bg = {}
local rot = {}

rot["blocks"] = ""
rot["stairs"] = ""
rot["bluestone"] = ""
rot["rail"] = ""
rot["misc"] = ""
rot["food"] = ""
rot["tools"] = ""
rot["matr"] = ""
rot["brew"] = ""
rot["all"] = "^[transformR270"
rot["inv"] = "^[transformR270"

ofs_tab["blocks"] = "-0.28,-0.35"
ofs_tab["stairs"] = "0.88,-0.35"
ofs_tab["bluestone"] = "2.05,-0.35"
ofs_tab["rail"] = "3.22,-0.35"
ofs_tab["misc"] = "4.4,-0.35"
ofs_tab["food"] = "5.57,-0.35"
ofs_tab["tools"] = "6.74,-0.35"
ofs_tab["matr"] = "7.91,-0.35"
ofs_tab["brew"] = "9.07,-0.35"
ofs_tab["all"] = "10.15,0.83"
ofs_tab["inv"] = "10.15,6.94"

ofs_img["blocks"] = "-0.13,-0.15"
ofs_img["stairs"] = "1.03,-0.15"
ofs_img["bluestone"] = "2.2,-0.15"
ofs_img["rail"] = "3.39,-0.15"
ofs_img["misc"] = "4.54,-0.15"
ofs_img["food"] = "5.72,-0.15"
ofs_img["tools"] = "6.87,-0.15"
ofs_img["matr"] = "8.05,-0.15"
ofs_img["brew"] = "9.22,-0.15"
ofs_img["all"] = "10.26,0.98"
ofs_img["inv"] = "10.26,7.1"

bg["blocks"] = "default:dirt_with_grass"
bg["stairs"] = "stairs:stair_default_mossycobble"
bg["bluestone"] = "mesecons_lightstone:lightstone_on"
bg["rail"] = "boats:boat"
bg["misc"] = "bucket:bucket_lava"
bg["food"] = "default:apple"
bg["tools"] = "default:pick_diamond"
bg["matr"] = "default:emerald"
bg["brew"] = "vessels:glass_bottle"
bg["all"] = "default:paper"
bg["inv"] = "default:chest"

local function found_in_list(name, list)
	for _, v in pairs(list) do
		if name:find(v) then
			return true
		end
	end
end

local filters = {
	["all"] = function(name, def, groups)
		return true and not def.groups.stairs
	end,
	["blocks"] = function(name, def, groups)
	return minetest.registered_nodes[name] and
		not def.mesecons and not def.groups.stairs and
		(def.drawtype == "normal" or def.drawtype:sub(1,5) == "glass" or def.drawtype:sub(1,8) == "allfaces") or
		found_in_list(name, {"cactus", "slimeblock"})
	end,
	["stairs"] = function(name, def, groups)
		return def.groups.stairs
	end,
	["bluestone"] = function(name)
		return name:find("mese") or found_in_list(name, {"^tnt:", "^doors:"})
	end,
	["rail"] = function(name, _, groups)
		return found_in_list(name, {"^boats:", "^carts:"}) or groups.rail
	end,
	["food"] = function(name, def, groups)
		return def.on_use
		--[[return found_in_list(name, {
				"fish", "apple", "bread", "chicken_", "meat", "sugar",
				"mushroom", "pork", "rabbit", "cheese", "milk",
			})]]
	end,
	["tools"] = function(name)
		return minetest.registered_tools[name] or
		found_in_list(name, {"arrow",})
	end,
	["matr"] = function(name, def, groups)
		return minetest.registered_craftitems[name] and
		not found_in_list(name, {"^boats:", "^carts:", "^boats:", "^vessels:", "^pep:", "^bucket:", "^doors:"}) and
		not def.on_use
	end,
	["brew"] = function(name)
		return found_in_list(name, {"^vessels:", "^pep:"})
	end,
}

-- Not found in any other category except all
filters["misc"] = function(name, def, groups)
	for filter, func in pairs(filters) do
		if filter ~= "misc" and filter ~= "all" and func(name, def, groups) then
			return
		end
	end
	return true
end

local function init_creative_cache(tab_name, category)
	inventory_cache[tab_name] = {}
	local i_cache = inventory_cache[tab_name]
	local filter = filters[category] or function() return end
	for name, def in pairs(minetest.registered_items) do
		local groups = def.groups or {}
		if def.description and def.description ~= "" and
				groups.not_in_creative_inventory ~= 1 and
				filter(name, def, groups) then
			i_cache[name] = def.description
		end
	end
	table.sort(i_cache)
end

local function init_creative_inventory(player_name)
	player_inventory[player_name] = {
		size = 0,
		filter = "",
		start_i = 0,
		list = {},
	}
	return player_inventory[player_name]
end

local function update_creative_inventory(player_name, tab_name)
	local player = minetest.get_player_by_name(player_name)
	if not player or not player:is_player() then
		return
	end
	local inv = player_inventory[player_name] or
			init_creative_inventory(player_name)
	local creative_list = inv.list
	for k in pairs (creative_list) do
		creative_list[k] = nil
	end
	local items = inventory_cache[tab_name] or {}
	local filter = tab_name == "all" and inv.filter or ""
	for name, description in pairs(items) do
		if name:find(inv.filter, 1, true) or
				description:lower():find(filter, 1, true) then
			creative_list[#creative_list + 1] = name
		end
	end
	table.sort(creative_list)
	inv.size = #creative_list
	inv.filter = filter
end

local function get_button_formspec(player_name, start_i)
	local buttons = ""
	local inv = player_inventory[player_name] or
			init_creative_inventory(player_name)
	local creative_list = inv.list or {}
	local i = start_i + 1
	for y = 0, 4 do
		for x = 0, 8 do
			local item = creative_list[i]
			if not item then
				return buttons
			end
			local def = minetest.registered_items[item]
			local tooltip = def and def.description or ""
			buttons = buttons.."item_image["..
				(x + 0.02)..","..(y + 1.68)..";1,1;"..item.."]image_button["..
				(x + 0.02)..","..(y + 1.68)..";1,1;blank.png;"..item..
				";;;false;button_pressed.png]"..
				"tooltip["..item..";"..tooltip..";#000;#FFF]"

			i = i + 1
		end
	end
	return buttons
end

local function get_creative_formspec(player_name, start_i, pagenum, page, pagemax)
	page = page or "all"
	pagenum = pagenum or 1
	pagemax = (pagemax and pagemax ~= 0) and pagemax or 1
	local slider_height = 4.52 / pagemax
	local slider_pos = 4 / pagemax * (pagenum - 1) + 2.14
	if pagenum > 1 then
		slider_pos = slider_pos - 0.05
	end
	local main_list = get_button_formspec(player_name, start_i)
	if page == "inv" then
		main_list = "image[-0.2,1.6;11.35,2.33;creative_bg.png]"..
			"list[current_player;main;0.02,3.68;9,3;9]"
		if has_armor then
			main_list = main_list.."image[-0.3,0.15;3,4.3;inventory_armor.png]"..
			"list[detached:"..player_name.."_armor;armor;0.03,1.69;1,1;]"..
			"list[detached:"..player_name.."_armor;armor;0.03,2.69;1,1;1]"..
			"list[detached:"..player_name.."_armor;armor;0.99,1.69;1,1;2]"..
			"list[detached:"..player_name.."_armor;armor;0.99,2.69;1,1;3]"
		end
	end
	local formspec = "image_button_exit[10.4,-0.1;0.75,0.75;close.png;exit;;true;false;close_pressed.png]"..
		"background[-0.2,-0.26;11.55,8.49;inventory_creative.png]"..
		sfinv.gui_bg..
		sfinv.listcolors..
		"label[-5,-5;"..page.."]"..

		"image_button["..ofs_tab["blocks"]..";1.3,1.3;creative_tab.png;build;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["blocks"]..";1,1;"..bg["blocks"].."]"..
		
		"image_button["..ofs_tab["stairs"]..";1.3,1.3;creative_tab.png;stairs;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["stairs"]..";1,1;"..bg["stairs"].."]"..
		
		"image_button["..ofs_tab["bluestone"]..";1.3,1.3;creative_tab.png;bluestone;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["bluestone"]..";1,1;"..bg["bluestone"].."]"..

		"image_button["..ofs_tab["rail"]..";1.3,1.3;creative_tab.png;rail;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["rail"]..";1,1;"..bg["rail"].."]"..

		"image_button["..ofs_tab["misc"]..";1.3,1.3;creative_tab.png;misc;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["misc"]..";1,1;"..bg["misc"].."]"..
		
		"image_button["..ofs_tab["food"]..";1.3,1.3;creative_tab.png;food;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["food"]..";1,1;"..bg["food"].."]"..

		"image_button["..ofs_tab["tools"]..";1.3,1.3;creative_tab.png;tools;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["tools"]..";1,1;"..bg["tools"].."]"..

		"image_button["..ofs_tab["matr"]..";1.3,1.3;creative_tab.png;matr;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["matr"]..";1,1;"..bg["matr"].."]"..

		"image_button["..ofs_tab["brew"]..";1.3,1.3;creative_tab.png;brew;;;false;creative_tab_pressed.png]"..
		"item_image["..ofs_img["brew"]..";1,1;"..bg["brew"].."]"..

		"image_button["..ofs_tab["all"]..";1.3,1.3;blank.png;default;;;false]"..
		"item_image["..ofs_img["all"]..";1,1;"..bg["all"].."]"..

		"image_button["..ofs_tab["inv"]..";1.3,1.3;blank.png;inv;;;false]"..
		"item_image["..ofs_img["inv"]..";1,1;"..bg["inv"].."]"..

		"image_button_exit[10.3,2.5;1,1;creative_home_set.png;sethome_set;;true;false]"..
		"tooltip[sethome_set;Set Home;#000;#FFF]"..
		"image_button_exit[10.3,3.5;1,1;creative_home_go.png;sethome_go;;true;false]"..
		"tooltip[sethome_go;Go Home;#000;#FFF]"..
		"image[0,0.95;5,0.75;fnt_"..page..".png]"..
		"image_button[9.145,1.65;0.81,0.6;blank.png;creative_prev;;;false]" ..
		"image_button[9.145,6.08;0.81,0.6;blank.png;creative_next;;;false]" ..
		"list[current_player;main;0.02,6.93;9,1;]"..main_list..
		"list[detached:creative_trash;main;9.03,6.94;1,1;]"..
		"image["..ofs_tab[page]..";1.4,1.4;creative_tab_active.png"..rot[page].."]"..
		"item_image["..ofs_img[page]..";1,1;"..bg[page].."]"..
		"image[9.165," .. tostring(slider_pos) .. ";0.7,"..tostring(slider_height) .. ";creative_slider.png]"
	if page == "all" then
		local inv = player_inventory[player_name] or {}
		local filter = inv.filter or ""
		formspec = formspec .. "field_close_on_enter[search;false]"..
			"field[5.31,1.27;4.0,0.75;search;;"..filter.."]"..
			"image_button[9.14,0.93;0.81,0.82;creative_search.png;creative_search;;;false]"
	end
	if pagenum ~= nil then
		formspec = formspec .. "p"..tostring(pagenum)
	end
	return formspec
end

local function add_to_player_inventory(player, item)
	if not player or not player:is_player() or not item then
		return
	end
	local inv = player:get_inventory()
	if not inv then
		return
	end
	local def = minetest.registered_items[item]
	if not def or (def.groups and def.groups.not_in_creative_inventory == 1) then
		return
	end
	local empty_slot = nil
	local list = inv:get_list("main")
	if list and #list > 8 then
		for i = 1, 9 do
			local stack = list[i]
			if stack then
				if not empty_slot and stack:get_count() == 0 then
					empty_slot = i
				elseif stack:get_name() == item and
						stack:get_free_space() > 0 then
					stack:add_item(item)
					inv:set_stack("main", i, stack)
					return
				end
			end
		end
		if empty_slot then
			local stack = list[empty_slot]
			stack:add_item(item)
			inv:set_stack("main", empty_slot, stack)
		end
	end
end

local function register_tab(name, title, group)
	init_creative_cache(name, group)
	sfinv.register_page("creative:" .. name, {
		title = title,
		is_in_nav = function(self, player, context)
			return creative.is_enabled_for(player:get_player_name())
		end,
		get = function(self, player, context)
			local player_name = player:get_player_name()
			update_creative_inventory(player_name, name)
			local inv = player_inventory[player_name]
			local start_i = inv.start_i or 0
			local pagenum = math.floor(start_i / (5*9) + 1)
			local pagemax = math.ceil(inv.size / (5*9))
			local formspec = get_creative_formspec(player_name, start_i,
					pagenum, name, pagemax)
			return sfinv.make_formspec(player, context, formspec, false, "size[11,7.7]")
		end,
		on_enter = function(self, player, context)
			local player_name = player:get_player_name()
			local inv = player_inventory[player_name]
			if inv then
				inv.start_i = 0
			end
		end,
		on_player_receive_fields = function(self, player, context, fields)
			local player_name = player:get_player_name()
			local inv = player_inventory[player_name]
			if not inv then
				return
			end
			if creative.is_enabled_for(player_name) then
				for field, _ in pairs(fields) do
					if field:find(":") then
						add_to_player_inventory(player, field)
						return
					end
				end
			end
			inv.filter = fields.search and fields.search:lower() or ""
			if fields.build then
				sfinv.set_page(player, "creative:blocks")
			elseif fields.stairs then
				sfinv.set_page(player, "creative:stairs")
			elseif fields.bluestone then
				sfinv.set_page(player, "creative:bluestone")
			elseif fields.rail then
				sfinv.set_page(player, "creative:rail")
			elseif fields.misc then
				sfinv.set_page(player, "creative:misc")
			elseif fields.default then
				sfinv.set_page(player, "creative:all")
			elseif fields.food then
				sfinv.set_page(player, "creative:food")
			elseif fields.tools then
				sfinv.set_page(player, "creative:tools")
			elseif fields.combat then
				sfinv.set_page(player, "creative:combat")
			elseif fields.matr then
				sfinv.set_page(player, "creative:matr")
			elseif fields.inv then
				sfinv.set_page(player, "creative:inv")
			elseif fields.brew then
				sfinv.set_page(player, "creative:brew")
			elseif fields.search and
					(fields.creative_search or
					fields.key_enter_field == "search") then
				inv.start_i = 0
				--inv.filter = fields.search:lower()
				update_creative_inventory(player_name, name)
				sfinv.set_player_inventory_formspec(player, context)
			elseif not fields.quit then
				local start_i = inv.start_i or 0
				if fields.creative_prev then
					start_i = start_i - 5*9
					if start_i < 0 then
						start_i = inv.size - (inv.size % (5*9))
						if inv.size == start_i then
							start_i = math.max(0, inv.size - (5*9))
						end
					end
				elseif fields.creative_next then
					start_i = start_i + 5*9
					if start_i >= inv.size then
						start_i = 0
					end
				end
				inv.start_i = start_i
				sfinv.set_player_inventory_formspec(player, context)
			end
		end
	})
end

register_tab("inv", "Inv")
minetest.after(0, function()
	register_tab("all", "All", "all")
	register_tab("blocks", "1", "blocks")
	register_tab("stairs", "2", "stairs")
	register_tab("bluestone", "3", "bluestone")
	register_tab("rail", "4", "rail")
	register_tab("misc", "5", "misc")
	register_tab("food", "6", "food")
	register_tab("tools", "7", "tools")
	register_tab("matr", "8", "matr")
	register_tab("brew", "9", "brew")
end)

local old_homepage_name = sfinv.get_homepage_name
function sfinv.get_homepage_name(player)
	if creative.is_enabled_for(player:get_player_name()) then
		return "creative:all"
	else
		return old_homepage_name(player)
	end
end

-- Create the trash field
local trash = minetest.create_detached_inventory("creative_trash", {
	-- Allow the stack to be placed and remove it in on_put()
	-- This allows the creative inventory to restore the stack
	allow_put = function(inv, listname, index, stack, player)
		return stack:get_count()
	end,
	on_put = function(inv, listname)
		inv:set_list(listname, {})
	end,
})
trash:set_size("main", 1)
