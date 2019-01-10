AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Bleach"
ENT.Category = "Chemicals"
ENT.Spawnable = true
ENT.Model = "models/props_junk/garbage_plasticbottle001a.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1, 2)..".wav"))
			timer.Simple(math.random(0.4, 0.6), function()
				if IsValid(caller) and caller:Alive() then
					caller:EmitSound(Sound("hostage/hpain/hpain" .. math.random(1, 6) .. ".wav"))
					caller:Kill()
				end
			end)
			SafeRemoveEntity(self)
		end
	end
end
