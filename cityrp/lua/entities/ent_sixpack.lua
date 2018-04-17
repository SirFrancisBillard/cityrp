AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Alcohol Case"
ENT.Category = "Alcohol (Old)"
ENT.Spawnable = true
ENT.Model = "models/props/cs_militia/caseofbeer01.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	self:SetBottles(6)
end
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Bottles")
	self:NetworkVar("String", 0, "Alcohol")
end

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if (self:GetBottles() > 0) then
				self:SetBottles(math.Clamp(self:GetBottles() - 1, 0, 6))
				local logic = ents.Create("rp_bottle")
				logic:SetPos(self:GetPos() + Vector(0, 0, 30))
				logic:Spawn()
				logic:SetAlcohol(self:GetAlcohol())
				self:EmitSound("physics/glass/glass_bottle_impact_hard"..math.random(1, 3)..".wav")
			else
				SafeRemoveEntity(self)
			end
		end
	end
end
