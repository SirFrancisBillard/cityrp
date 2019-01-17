
util.AddNetworkString("ShowPlayerFlinch")

hook.Add("EntityTakeDamage", "PlayerFlinchOnHeadshot", function(ent, dmg)
	if IsValid(ent) and ent:IsPlayer() and ent:LastHitGroup() == HITGROUP_HEAD then
		ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_HEAD, true)
		net.Start("ShowPlayerFlinch")
		net.WriteEntity(ent)
		net.Broadcast()
	end
end)
