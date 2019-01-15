AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "STD Medication"
ENT.Category = "Medical"
ENT.Spawnable = true
ENT.Model = "models/props_lab/jar01a.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() and caller:CureSTD() then
			caller:EmitSound(Sound("npc/barnacle/barnacle_gulp" .. math.random(1, 2) .. ".wav"))
			SafeRemoveEntity(self)
		end
	end
end
