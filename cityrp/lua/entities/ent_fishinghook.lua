AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Fish Hook"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Fish")
end

if SERVER then
	local Up = Vector(0, 0, 1)

	local FishList = {
		"models/props/cs_militia/fishriver01.mdl",
		"models/props/de_inferno/goldfish.mdl"
	}

	function ENT:Initialize()
		self:SetModel("models/props_junk/meathook001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		self.Phys = self:GetPhysicsObject()

		self.Phys:SetMaterial("ice")
		self.Phys:SetMass(10)
		self.Phys:SetDamping(1.5, 4)
	end

	function ENT:Think()
		local Ab = self:WaterLevel()
		if Ab < 1 then
			self:NextThink(CurTime() + 1)
			return true
		end

		if not self.HookedFish then
			if math.random(30) == 1 then
				self:SetFish(math.random(2))
				self:EmitSound("npc/antlion/attack_double" .. math.random(1, 3) .. ".wav")
				self.Phys:SetVelocity(Up * 2000)
				self.HookedFish = true

				self:NextThink(CurTime() + math.Rand(1, 2))
				return true
			end
		else
			self:EmitSound("npc/antlion/attack_double" .. math.random(1, 3).. ".wav")
			self.Phys:SetVelocity(VectorRand() * 1000)

			self:NextThink(CurTime() + math.Rand(1, 2))
			return true
		end
	end

	function ENT:Use(user) end
else
	function ENT:Think()
		if self:GetFish() and not self.FishModel then
			self.FishModel = ClientsideModel(FishList[self:GetFish()])

			if IsValid(self.FishModel) then
				self.FishModel:SetModelScale(1, 0)
				self.FishModel:SetNoDraw(true)
			end
		end
	end

	function ENT:Draw()
		self.Entity:DrawModel()
		
		if IsValid(self.FishModel) then
			self.FishModel:SetRenderOrigin(self:GetPos())
			self.FishModel:SetRenderAngles(self:GetAngles())
			self.FishModel:DrawModel()
		end
	end
end
