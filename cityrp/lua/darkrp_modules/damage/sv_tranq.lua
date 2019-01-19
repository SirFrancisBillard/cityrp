
-- #NoSimplerr#

hook.Add("EntityTakeDamage", "TranquilzerGun", function(ent, dmg)
	if IsValid(ent) and ent:IsPlayer() and dmg:IsDamageType(DMG_BULLET) then
		local atk = dmg:GetAttacker()
		local wep = atk:GetActiveWeapon()
		if IsValid(wep) and wep.IsTranq then
			DarkRP.toggleSleep(ent, "force") -- nighty night
		end
	end
end)
