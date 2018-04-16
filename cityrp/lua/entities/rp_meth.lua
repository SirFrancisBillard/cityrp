AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Meth"
ENT.Category = "Crime+"
ENT.Spawnable = true
ENT.Model = "models/props_junk/rock001a.mdl"

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
end
function ENT:SellPrice()
	return 10000
end
function ENT:Think()
	self:SetColor(Color(0, 255, 255))
	self:SetMaterial("models/debug/debugwhite")
end
function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
			if (v:GetClass() == "rp_dealer") or (v:GetClass() == "rp_market") or (v:GetClass() == "rp_addict") then
				caller:addMoney(self:SellPrice())
				caller:ChatPrint("You have sold "..string.lower(self.PrintName).." for $"..string.Comma(self:SellPrice()))
				SafeRemoveEntity(self)
			end
		end
	end
end
