AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Stabilization Pills"
ENT.Category = "Medical"
ENT.Spawnable = true
ENT.Model = "models/props_lab/jar01b.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if caller:Health() <= caller:GetMaxHealth() and caller:Armor() <= 100 and not caller:GetNWBool("tripping_balls", false) and caller:GetDrunkenness() <= 0 then
				caller:ChatPrint("Your vital signs are already stable!")
			else
				caller:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1, 2)..".wav"))
				caller:SetHealth(math.Clamp(caller:Health(), 0, caller:GetMaxHealth()))
				caller:SetArmor(math.Clamp(caller:Armor(), 0, 100))
				caller:SetNWBool("tripping_balls", false)
				caller:SoberUp()
				SafeRemoveEntity(self)
			end
		end
	end
end