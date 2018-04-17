AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Milk"
ENT.Category = "Beverages"
ENT.Spawnable = true
ENT.Model = "models/props_junk/garbage_milkcarton001a.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1, 2)..".wav"))
			if caller:Health() < caller:GetMaxHealth() * 1.2 then
				caller:SetHealth(math.min(caller:Health() + 2, caller:GetMaxHealth() * 1.2))
			end
			SafeRemoveEntity(self)
		end
	end
end
