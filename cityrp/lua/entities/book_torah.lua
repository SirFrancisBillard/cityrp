AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Torah"
ENT.Category = "Holy Books"
ENT.Spawnable = true
ENT.Model = "models/props_lab/binderredlabel.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:SetNWInt("torah_amount", math.min(caller:GetNWInt("torah_amount", 0) + 1, 20))
			caller:ChatPrint("Your salary has increased.\nRead the Torah more times to increase it further.")
			SafeRemoveEntity(self)
		end
	end

	hook.Add("playerGetSalary", "TorahIncreaseSalary", function(ply, amt)
		if IsValid(ply) and ply:GetNWInt("torah_amount", 0) > 0 then
			local mult = ply:GetNWInt("torah_amount", 0)
			local extra_monies = 50 * mult
			ply:addMoney(extra_monies)
			DarkRP.notify(ply, 1, 4)
		end
	end)

	hook.Add("DoPlayerDeath", "LoseTorahOnDeath", function(ply)
		ply:SetNWInt("torah_amount", 0)
	end)
end
