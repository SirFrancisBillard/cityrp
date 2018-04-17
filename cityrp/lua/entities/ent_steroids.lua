AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Steroids"
ENT.Category = "Medical"
ENT.Spawnable = true
ENT.Model = "models/Items/battery.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if caller:Armor() < 200 then
				caller:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1, 2)..".wav"))
				caller:SetArmor(math.min(caller:Armor() + 40, 200))
				SafeRemoveEntity(self)
			else
				caller:ChatPrint("You've taken enough steroids.")
			end
		end
	end
end