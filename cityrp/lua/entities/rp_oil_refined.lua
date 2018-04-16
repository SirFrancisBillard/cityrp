AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Refined Oil"
ENT.Category = "Oil"
ENT.Spawnable = true
ENT.Model = "models/props_junk/metalgascan.mdl"

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

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
				if (v:GetClass() == "rp_oil_dealer") then
					SafeRemoveEntity(self)
					caller:addMoney(2000)
					caller:ChatPrint("You have sold Refined Oil for $2000")
				end
			end
		end
	end
end
