AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Bleach"
ENT.Category = "RP"
ENT.Spawnable = true
ENT.Model = "models/props_junk/garbage_plasticbottle001a.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:Kill()
			SafeRemoveEntity(self)
		end
	end
end