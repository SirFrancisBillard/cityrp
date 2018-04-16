AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Water"
ENT.Category = "Beverages"
ENT.Spawnable = true
ENT.Model = "models/props/cs_office/Water_bottle.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1, 2)..".wav"))
			caller:SetHealth(math.min(caller:Health() + 1, caller:GetMaxHealth()))
			caller:ConCommand("pp_motionblur 0")
			caller:ConCommand("pp_sharpen 0")
			caller:ConCommand("pp_texturize \"\"")
			SafeRemoveEntity(self)
		end
	end
end
