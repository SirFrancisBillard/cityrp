
hook.Add("PlayerDeath", "MentalState", function(victim, attacker, inflictor)
	if attacker:IsPlayer() then
		attacker:SubtractMentalState(6)
	end
end)
