AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Bible"
ENT.Category = "Holy Books"
ENT.Spawnable = true
ENT.Model = "models/props_lab/binderblue.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:SetMaxHealth(math.Clamp(caller:GetMaxHealth() + 10, 0, 200))
			caller:ChatPrint("+10% damage to gays and minorities.\nRead the Bible more times to increase it further.")
			SafeRemoveEntity(self)
		end
	end
end