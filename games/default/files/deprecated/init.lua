-- Media and code needed to upgrade to the new version.
-- Must be removed no earlier than 12 months after release.

local path = minetest.get_modpath("deprecated")

--== mesecons_pistons ==--
dofile(path .. "/mesecons_pistons.lua")

--== throwing ==--
minetest.register_entity(":throwing:arrow_entity", {
	is_visible = false,
	on_activate = function(self)
		self.object:remove()
	end
})
