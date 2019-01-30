AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Weed"
ENT.Category = "Weed Growing"
ENT.Spawnable = true
ENT.Model = "models/props/cs_office/trash_can_p5.mdl"

function ENT:SellPrice()
	return 2000
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
				if istable(v.SellItems) and v.SellItems["weed"] then
					caller:addMoney(self:SellPrice())
					caller:ChatPrint("You have sold "..string.lower(self.PrintName).." for $"..string.Comma(self:SellPrice()))
					SafeRemoveEntity(self)
				end
			end
		end
	end
else
	local GanjaGreen = Color(0, 255, 0)

	function ENT:Think()
		self:SetColor(GanjaGreen)
	end
end


