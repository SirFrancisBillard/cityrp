
-- #NoSimplerr#

hook.Add("EntityTakeDamage", "TranquilzerGun", function(ent, dmg)
	if IsValid(ent) and ent:IsPlayer() and dmg:IsDamageType(DMG_BULLET) then
		local atk = dmg:GetAttacker()
		local wep = atk:GetActiveWeapon()
		if IsValid(wep) and wep.IsTranq then
			DarkRP.toggleSleep(ent, "force") -- nighty night
			timer.Simple(10, function()
				if not IsValid(ent) or not ent:IsPlayer() or not ent:Alive() or not ent.Sleeping then return end
				DarkRP.toggleSleep(ent, "force")
			end)
		end
	end
end)
