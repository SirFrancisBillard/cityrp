AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Log"
ENT.Category = "Wood Chopping"
ENT.Spawnable = true
ENT.Model = "models/props_docks/channelmarker_gib01.mdl"

function ENT:SellPrice()
	return 50
end

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetModelScale(0.5)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:PhysWake()
	end

	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
				if istable(v.SellItems) and v.SellItems["lumber"] then
					caller:addMoney(self:SellPrice())
					caller:ChatPrint("Sold lumber for " .. DarkRP.formatMoney(self:SellPrice()) .. ".")
					SafeRemoveEntity(self)
				end
			end
		end
	end
end
