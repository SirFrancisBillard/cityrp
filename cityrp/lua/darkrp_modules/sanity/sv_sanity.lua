
hook.Add("PlayerDeath", "MentalState", function(victim, attacker, inflictor)
	if attacker:IsPlayer() then
		attacker:SubtractMentalState(1)
	end
end)
