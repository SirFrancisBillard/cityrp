
util.AddNetworkString("ShowPlayerFlinch")

hook.Add("EntityTakeDamage", "BetterBulletDamage", function(ent, dmg)
	if IsValid(ent) and ent:IsPlayer() then
		net.Start("ShowPlayerFlinch")
		net.WriteInt(ent:EntIndex(), 8)
		net.Broadcast()
	end
end)
