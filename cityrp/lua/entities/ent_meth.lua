AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Meth"
ENT.Category = "Meth Cooking"
ENT.Spawnable = true
ENT.Model = "models/props_junk/rock001a.mdl"

local Aqua = Color(0, 255, 255)

function ENT:SellPrice()
	return 10000
end

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:PhysWake()
	end

	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
				if istable(v.SellItems) and v.SellItems["meth"] then
					caller:addMoney(self:SellPrice())
					caller:ChatPrint("You have sold "..string.lower(self.PrintName).." for $"..string.Comma(self:SellPrice()))
					SafeRemoveEntity(self)
				end
			end
		end
	end
else
	function ENT:Think()
		self:SetColor(Aqua)
		self:SetMaterial("models/debug/debugwhite")
	end
end
