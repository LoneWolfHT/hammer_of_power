local cant_start_fling = {}
local cant_fling = {}
local immune_to_fall_dmg = {}

local function spawn_particle_trail(obj)
	minetest.add_particlespawner({
		amount = 100,
		time = 1,
		minpos = vector.new(),
		maxpos = vector.new(),
		minvel = {x=1, y=1, z=1},
		maxvel = {x=-1, y=-1, z=-1},
		minacc = {x=0, y=-9.8, z=0},
		maxacc = {x=0, y=-9.8, z=0},
		minexptime = 2,
		maxexptime = 2,
		minsize = 2,
		maxsize = 4,
		collisiondetection = true,
		collision_removal = false,
		object_collision = true,
		attached = obj,
		vertical = false,
		texture = "hammer_of_power_swirl.png",
		glow = 2,
	})
end

minetest.register_node("hammer_of_power:hammer", {
	description = minetest.colorize("orange", "Hammer of Power"),
	mesh = "hammer_of_power_hammer.obj",
	tiles = {"hammer_of_power_hammer.png^[colorize:yellow:25"},
	groups = {oddly_breakable_by_hand = 3, snappy = 1},
	tool_capabilities = {
		full_punch_interval = 5,
		damage_groups = {fleshy = 3},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.125, -0.1875, 0.375, 0.5, 0.1875}, -- head
			{-0.125, -0.5, -0.0625, 0.125, 0.125, 0.0625}, -- handle
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.125, -0.1875, 0.375, 0.5, 0.1875}, -- head
			{-0.125, -0.5, -0.0625, 0.125, 0.125, 0.0625}, -- handle
		},
	},
	node_placement_prediction = "",
	sunlight_propogates = true,
	paramtype2 = "facedir",
	visual_scale = 0.66,
	paramtype = "light",
	drawtype = "mesh",
	light_source = 2,
	stack_max = 1,
	range = 3,
	on_place = function(_, placer, pointed_thing)
		local name = placer:get_player_name()

		if placer:get_player_velocity().y <= -10 then
			local pos = pointed_thing.above
			local objs = minetest.get_objects_inside_radius(pos, 3)
			local yvel = placer:get_player_velocity().y

			for _, object in pairs(objs) do
				local vel = vector.multiply(vector.direction(pos, object:get_pos()), math.abs(yvel/2))
				vel.y = math.abs(yvel/2)

				immune_to_fall_dmg[name] = true
				minetest.after(1, function() immune_to_fall_dmg[name] = nil end)

				if object:is_player() then
					if object:get_player_name() ~= name then
						object:add_player_velocity(vel)
						spawn_particle_trail(object)
					end
				else
					object:add_velocity(vel)
					spawn_particle_trail(object)
				end
			end

			local def = minetest.registered_nodes[minetest.get_node(pointed_thing.under).name]

			minetest.add_particlespawner({
				amount = 100,
				time = 0.5,
				minpos = pos,
				maxpos = pos,
				minvel = {x=5, y=5, z=5},
				maxvel = {x=-5, y=5, z=-5},
				minacc = {x=0, y=-9.8, z=0},
				maxacc = {x=0, y=-9.8, z=0},
				minexptime = 2,
				maxexptime = 2,
				minsize = 1,
				maxsize = 4,
				collisiondetection = true,
				collision_removal = false,
				object_collision = true,
				vertical = false,
				texture = def.tiles[1],
			})

			if def.sounds and def.sounds.footstep and def.sounds.footstep.name then
				minetest.sound_play({name = def.sounds.footstep.name}, {
					pos = pos,
					gain = def.sounds.footstep.gain*2 or 2,
					pitch = 0.5
				}, true)
			end
		end
	end,
	on_secondary_use = function(_, user, _)
		local name = user:get_player_name()

		if not cant_start_fling[name] then
			cant_start_fling[name] = true
			minetest.after(5, function() cant_start_fling[name] = nil end)

			local pos = user:get_pos()
			pos.y = pos.y + 1.5

			local obj = minetest.add_entity(
				vector.add(pos, vector.multiply(user:get_look_dir(), 2.5)),
				"hammer_of_power:flingent"
			)

			if obj then
				obj:get_luaentity().player = name
			end
		end
	end,
})

minetest.register_node("hammer_of_power:steel_hammer", {
	description = "Steel Hammer",
	mesh = "hammer_of_power_hammer.obj",
	tiles = {"hammer_of_power_hammer.png"},
	groups = {oddly_breakable_by_hand = 3, snappy = 1},
	tool_capabilities = {
		full_punch_interval = 3,
		damage_groups = {fleshy = 4},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.125, -0.1875, 0.375, 0.5, 0.1875}, -- head
			{-0.125, -0.5, -0.0625, 0.125, 0.125, 0.0625}, -- handle
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.125, -0.1875, 0.375, 0.5, 0.1875}, -- head
			{-0.125, -0.5, -0.0625, 0.125, 0.125, 0.0625}, -- handle
		},
	},
	sunlight_propogates = true,
	paramtype2 = "facedir",
	visual_scale = 0.66,
	paramtype = "light",
	drawtype = "mesh",
	stack_max = 1,
	range = 3,
})

minetest.register_on_player_hpchange(function(player, hp_change, reason)
	local name = player:get_player_name()

	if reason.type == "fall" and (immune_to_fall_dmg[name] or not cant_fling[name]) then
		return 0, true
	else
		return hp_change
	end
end, true)

minetest.register_entity("hammer_of_power:flingent", {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		selectionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
		pointable = true,
		visual = "cube",
		visual_size = {x = 0.5, y = 0.5, z = 0.5},
		textures = {
			"hammer_of_power_swirl.png","hammer_of_power_swirl.png","hammer_of_power_swirl.png",
			"hammer_of_power_swirl.png","hammer_of_power_swirl.png","hammer_of_power_swirl.png"
		},
		is_visible = true,
		automatic_rotate = 20,
		glow = 4,
		static_save = false,
	},
	on_punch = function(self, puncher, _, _, dir)
		local name = puncher:get_player_name()
		if not cant_fling[name] then
			if puncher:is_player() and (not self.player or name == self.player) then
				spawn_particle_trail(puncher)

				if not cant_fling then
					cant_fling[name] = true
					minetest.after(5, function() cant_fling[name] = nil end)
				end

				minetest.sound_play({name = "hammer_of_power_woosh"}, {
					object = puncher,
					max_hear_distance = 16,
				}, true)

				puncher:add_player_velocity(vector.multiply(dir, 50))
			end

			self.object:remove()
		end
	end,
	on_step = function(self, dtime)
		if not self.timer then self.timer = 0 end

		self.timer = self.timer + dtime

		if self.timer > 5 then self.object:remove() end
	end,
})

if minetest.get_modpath("default") then
	minetest.log("action", "[HAMMER_OF_POWER] Loading compat for mtg")
	dofile(minetest.get_modpath("hammer_of_power").."/compat/mtg.lua")
elseif minetest.get_modpath("nc_api_all") then
	minetest.log("action", "[HAMMER_OF_POWER] Loading compat for nodecore")
	dofile(minetest.get_modpath("hammer_of_power").."/compat/nodecore.lua")
end
