-- Register player copy

minetest.register_entity("hammer_of_power:playercopy", {
	initial_properties = {
		physical = false,
		collide_with_objects = false,
		pointable = false,
		selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		visual = "mesh",
		mesh = "character.b3d",
		textures = {"character.png"},
		is_visible = true,
		static_save = false,
	},
	on_step = function(self, dtime)
		if self.mimic and self.follow then
			local mimic = minetest.get_player_by_name(self.mimic)

			if not mimic or not self.follow:get_luaentity() then self.object:remove() return end

			local pos1 = self.object:get_pos()
			local pos2 = self.follow:get_pos()

			self.object:set_yaw(mimic:get_look_horizontal())
			self.object:set_velocity(vector.multiply(vector.direction(pos1, pos2), vector.distance(pos1, pos2)+10))
		end
	end
})

-- Register crafts

minetest.register_craft({
	output = "hammer_of_power:steel_hammer",
	recipe = {
		{"default:steelblock", "default:steelblock", "default:steelblock"},
		{"default:mese_crystal_fragment", "group:wood", "default:mese_crystal_fragment"},
		{"", "group:wood", ""},
	},
})

minetest.register_craft({
	output = "hammer_of_power:hammer",
	recipe = {
		{"default:mese", "default:diamondblock", "default:mese"},
		{"default:mese", "hammer_of_power:steel_hammer", "default:mese"},
		{"default:mese", "bucket:bucket_lava", "default:mese"},
	},
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})
