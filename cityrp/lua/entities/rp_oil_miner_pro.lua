AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Professional Oil Miner"
ENT.Category = "Oil"
ENT.Spawnable = true
ENT.Model = "models/props_industrial/winch_deck.mdl"

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
end
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Progress")
	self:NetworkVar("Int", 1, "Oil")
end

if SERVER then
	function ENT:Think()
		if (self:GetProgress() >= 60) then
			self:SetOil(self:GetOil() + 1)
			self:SetProgress(0)
		end
		self:SetProgress(math.Clamp(self:GetProgress() + 1, 0, 120))
		self:NextThink(CurTime() + 1)
		return true
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() and (self:GetOil() > 0) then
			self:SetOil(math.Clamp(self:GetOil() - 1, 0, self:GetOil()))
			local oil = ents.Create("rp_oil")
			oil:SetPos(self:GetPos() + Vector(0, 0, 32))
			oil:Spawn()
		end
	end
end
