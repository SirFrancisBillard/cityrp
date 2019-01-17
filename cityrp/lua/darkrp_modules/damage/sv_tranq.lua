
hook.Add("EntityTakeDamage", "TranquilzerGun", function(ent, dmg)
	if IsValid(ent) and ent:IsPlayer() then
		local wep = dmg:GetInflictor()
		if IsValid(wep) and wep.IsTranq then
			DarkRP.toggleSleep(ent, "force") -- nighty night
		end
	end
end)
