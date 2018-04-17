AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Beer"
ENT.Category = "Beverages"
ENT.Spawnable = true
ENT.Model = "models/props_junk/garbage_glassbottle003a.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1, 2)..".wav"))
			if caller:Health() < caller:GetMaxHealth() then
				caller:SetHealth(math.min(caller:Health() + 2, caller:GetMaxHealth()))
			end
			caller:AddDrunkenness(1)
			SafeRemoveEntity(self)
		end
	end
end
