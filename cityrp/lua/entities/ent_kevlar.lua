AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Kevlar"
ENT.Category = "RP"
ENT.Spawnable = true
ENT.Model = "models/props_c17/SuitCase_Passenger_Physics.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if caller:Armor() >= 100 then
				caller:ChatPrint("You are already wearing kevlar.")
			else
				caller:ChatPrint("You have equipped kevlar.")
				caller:SetArmor(100)
				self:EmitSound(Sound("items/itempickup.wav"))
				SafeRemoveEntity(self)
			end
		end
	end
end
