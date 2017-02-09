AddCSLuaFile()

ENT.Type 		= "anim"
ENT.PrintName	= "C4"
ENT.Author		= ""
ENT.Spawnable 	= false

function ENT:Initialize()
	self:EmitSound("C4.Plant")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_c4_planted.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		self:PhysWake()

		local i = 0
		timer.Create(self:EntIndex() .. "explode", 1, 5, function()
			i = i + 1
			self:EmitSound("C4.PlantSound")
			if (i == 5) then
				self:Explosion()
			end
		end)
	end

	local badprops = {
		["models/props_interiors/vendingmachinesoda01a.mdl"] = true,
		["models/props_interiors/vendingmachinesoda01a_door.mdl"] = true,
	}

	local function findents(pos, radius)
		return table.Filter(ents.FindInSphere(pos, radius), function(v)
			return (v:IsProp() or v:IsDoor())
		end), table.Filter(ents.FindInSphere(pos, radius), function(v)
			return v:IsProp() and ((v.FadingDoor == true) or (v:GetCollisionGroup() == COLLISION_GROUP_WORLD))
		end)
	end

	function ENT:Explosion()
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetRadius(1000)
			effectdata:SetMagnitude(1000)
		util.Effect("HelicopterMegaBomb", effectdata)
		
		local exploeffect = EffectData()
			exploeffect:SetOrigin(self:GetPos())
			exploeffect:SetStart(self:GetPos())
		util.Effect("Explosion", exploeffect, true, true)
		
		local shake = ents.Create("env_shake")
			shake:SetOwner(self.ItemOwner)
			shake:SetPos(self:GetPos())
			shake:SetKeyValue("amplitude", "500")	// Power of the shake
			shake:SetKeyValue("radius", "500")		// Radius of the shake
			shake:SetKeyValue("duration", "2.5")	// Time of shake
			shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
			shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
			shake:Spawn()
			shake:Activate()
			shake:Fire("StartShake", "", 0)
			
		local push = ents.Create("env_physexplosion")
			push:SetOwner(self.ItemOwner)
			push:SetPos(self:GetPos())
			push:SetKeyValue("magnitude", 100)
			push:SetKeyValue("radius", 500)
			push:SetKeyValue("spawnflags", 2+16)
			push:Spawn()
			push:Activate()
			push:Fire("Explode", "", 0)
			push:Fire("Kill", "", .25)

		self:EmitSound(Sound("C4.Explode"))

		util.BlastDamage(self, self.ItemOwner, self:GetPos(), 250, 200)


		local max_rand = 6
		local props, doors = findents(self:GetPos(), 75)
		
		local prop_count, door_count = #props, #doors

		if (prop_count >= 8) or (door_count > 5) then
			props, door = findents(self:GetPos(), 100)
			prop_count, door_count = #props, #doors
			max_rand = 4
			if (prop_count >= 15) or (door_count > 7) then
				props, door = findents(self:GetPos(), 150)
				prop_count, door_count = #props, #doors
				max_rand = 2
				if (prop_count >= 25) or (door_count > 9) then
					props, door = findents(self:GetPos(), 250)
					prop_count, door_count = #props, #doors
				end
			end
		end

		for k, v in ipairs(props) do
			if IsValid(v) then
				local class = v:GetClass()
				if (class == "prop_physics") then
					local rand = math.random(1, max_rand)
					if (rand == 1) or (badprops[v:GetModel()]) then
						v:Remove()
					elseif (rand == 2) then
						if (not util.IsInWorld(v:GetPos())) then
							v:Remove()
						else
							constraint.RemoveAll(v)
							local phys = v:GetPhysicsObject()
							if IsValid(phys) then
								phys:EnableMotion(true)
							end
						end
					end
				elseif v:IsDoor() then
					v:DoorLock(false)
				end
			end
		end

		self:Remove()
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
