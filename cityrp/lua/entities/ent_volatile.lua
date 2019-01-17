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
			if caller:GetVolatile() < 8 then
				if caller:GetVolatile() < 1 then
					caller:ChatPrint("You will explode violently on death.\nThe more you drink, the bigger the explosion!")
				end
				caller:AddVolatile()
				caller:EmitSound(Sound("npc/barnacle/barnacle_gulp" .. math.random(1, 2) .. ".wav"))
				SafeRemoveEntity(self)
			else
				caller:ChatPrint("You've drank enough waste, now go blow someone up!")
			end
		end
	end
end
