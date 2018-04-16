AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Oil Refinery"
ENT.Category = "Oil"
ENT.Spawnable = true
ENT.Model = "models/props_c17/FurnitureFireplace001a.mdl"

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
		phys:SetMass(60)
	end
	self:SetProgress(0)
	self:SetOil(0)
	self:SetRefinedOil(0)
end
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Progress")
	self:NetworkVar("Int", 1, "Oil")
	self:NetworkVar("Int", 2, "RefinedOil")
end

if SERVER then
	function ENT:StartTouch(ent)
		if IsValid(ent) and (ent:GetClass() == "rp_oil") then
			SafeRemoveEntity(ent)
			self:SetOil(self:GetOil() + 1)
		end
	end
	function ENT:Think()
		if (self:GetOil() > 0) then
			if (self:GetProgress() >= 80) then
				self:SetOil(math.Clamp(self:GetOil() - 1, 0, self:GetOil()))
				self:SetRefinedOil(self:GetRefinedOil() + 1)
				self:SetProgress(0)
			end
			self:SetProgress(math.Clamp(self:Progress() + 1, 0, 80))
		end
		self:NextThink(CurTime() + 1)
		return true
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() and (self:GetRefinedOil() > 0) then
			self:SetRefinedOil(math.Clamp(self:GetRefinedOil() - 1, 0, self:GetRefinedOil()))
			local oil = ents.Create("rp_oil_refined")
			oil:SetPos(self:GetPos() + Vector(0, 0, 32))
			oil:Spawn()
		end
	end
end
