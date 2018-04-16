AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Volatile Waste"
ENT.Category = "Chemicals"
ENT.Spawnable = true
ENT.Model = "models/props/CS_militia/paintbucket01.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if not caller:IsVolatile() then
				caller:SetVolatile(true)
				caller:ChatPrint("You will explode on death! Allahu akbar!")
			end
			caller:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1, 2)..".wav"))
			SafeRemoveEntity(self)
		end
	end
end