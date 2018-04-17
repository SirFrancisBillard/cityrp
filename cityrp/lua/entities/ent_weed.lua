AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Weed"
ENT.Category = "Crime+"
ENT.Spawnable = true
ENT.Model = "models/props/cs_office/trash_can_p5.mdl"

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
	return 2000
end
function ENT:Think()
	self:SetColor(Color(0, 255, 0))
end
function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
			if (v:GetClass() == "ent_dealer") or (v:GetClass() == "rp_market") or (v:GetClass() == "rp_addict") then
				caller:addMoney(self:SellPrice())
				caller:ChatPrint("You have sold "..string.lower(self.PrintName).." for $"..string.Comma(self:SellPrice()))
				SafeRemoveEntity(self)
			end
		end
	end
end
