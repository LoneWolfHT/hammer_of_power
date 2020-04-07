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
