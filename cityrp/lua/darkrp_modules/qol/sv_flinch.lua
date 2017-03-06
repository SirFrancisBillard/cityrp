
util.AddNetworkString("ShowPlayerFlinch")

hook.Add("EntityTakeDamage", "PlayerFlinchOnHeadshot", function(ent, dmg)
	if IsValid(ent) and ent:IsPlayer() and ent:LastHitgroup() == HITGROUP_HEAD then
		ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_HEAD, true)
		net.Start("ShowPlayerFlinch")
		net.WriteInt(ent:EntIndex(), 8)
		net.Broadcast()
	end
end)
