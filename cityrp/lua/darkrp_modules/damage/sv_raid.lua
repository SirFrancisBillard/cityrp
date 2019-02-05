
-- #NoSimplerr#

local badprops = {
	["models/props_interiors/vendingmachinesoda01a.mdl"] = true,
	["models/props_interiors/vendingmachinesoda01a_door.mdl"] = true,
}

local IsDoor = {
	["prop_door_rotating"] = true,
	["func_door"] = true,
	["func_door_rotating"] = true,
}

local IsProp = {
	["prop_physics"] = true,
	["prop_ragdoll"] = true,
}

local function findents(pos, radius)
	local props = {}
	local doors = {}
	for k, v in pairs(ents.FindInSphere(pos, radius)) do
		if IsValid(v) and IsDoor[v:GetClass()] then
			table.insert(doors, v)
		elseif IsValid(v) and IsProp[v:GetClass()] then
			table.insert(props, v)
		end
	end
	return props, doors
end

function RaidExplosion(pos, radius, chance)
	if not chance then
		chance = 1
	end
	local props, doors = findents(pos, radius)
	for k, v in ipairs(props) do
		if IsValid(v) and IsProp[v:GetClass()] and math.random(chance) == chance then
			constraint.RemoveAll(v)
			local phys = v:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion(true)
			end
		end
	end

	for k, v in ipairs(doors) do
		if IsValid(v) and IsDoor[v:GetClass()] and math.random(chance) == chance then
			v:Fire("Unlock")
			v:Fire("Open")
		end
	end
end
