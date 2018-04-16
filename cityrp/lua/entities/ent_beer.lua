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
			caller:SetHealth(math.min(caller:Health() + 2, caller:GetMaxHealth()))
			if math.random(1, 5) == 1 then
				caller:ConCommand("pp_motionblur 1")
				caller:ConCommand("pp_motionblur_delay 0.01")
				caller:ConCommand("pp_motionblur_addalpha 0.05")
				caller:ConCommand("pp_motionblur_drawalpha 1")
			end
			SafeRemoveEntity(self)
		end
	end
end
