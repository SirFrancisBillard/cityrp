
hook.Add("PlayerDeath", "Sanity.SubtractOnKill", function(victim, attacker, inflictor)
	if attacker:IsPlayer() then
		attacker:SubtractMentalState(6)
	end
end)

hook.Add("PlayerSpawn", "Sanity.Reset", function(ply)
	ply:SetMentalState(100)
end)
