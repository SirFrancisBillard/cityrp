AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Medical Kit"
ENT.Category = "Medical"
ENT.Spawnable = true
ENT.Model = "models/Items/HealthKit.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if caller:Health() >= caller:GetMaxHealth() then
				caller:ChatPrint("You already have " .. caller:Health() .. " health!")
			else
				caller:SetHealth(math.min(caller:Health() + 40, caller:GetMaxHealth()))
				self:EmitSound(Sound("items/medshot4.wav"))
				SafeRemoveEntity(self)
			end
		end
	end
end
