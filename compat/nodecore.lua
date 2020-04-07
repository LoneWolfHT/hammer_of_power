-- Remove unsupported colored description
minetest.override_item("hammer_of_power:hammer", {description = "Hammer of Power"})

-- Register crafts
nodecore.register_craft({
	label = "assemble steel hammer",
	nodes = {
		{match = {name = "nc_lode:toolhead_mallet_annealed", count = 1}, replace = "air"},
		{y = -1, match = "nc_lode:rod_annealed", replace = "hammer_of_power:steel_hammer"},
	}
})

nodecore.register_soaking_abm({
	label = "steel hammer infusion",
	fieldname = "infuse",
	nodenames = {"hammer_of_power:steel_hammer"},
	neighbors = {"group:lux_fluid"},
	interval = 30,
	chance = 2,
	soakrate = nodecore.lux_soak_rate,
	soakcheck = function(data, pos)
		if data.total < 100 then return end

		return nodecore.set_loud(pos, {name = "hammer_of_power:hammer"})
	end
})
