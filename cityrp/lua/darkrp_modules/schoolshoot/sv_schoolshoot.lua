g_SchoolShooterAnnounced = false

util.AddNetworkString("AnnounceSchoolShooting")
util.AddNetworkString("SchoolShooterDied")

hook.Add("FireBullets", "SchoolShootingAlert", function(ply, data)
	if IsValid(ply) and ply:IsPlayer() and ply:Team() == TEAM_SHOOTER and not g_SchoolShooterAnnounced then
		net.Start("AnnounceSchoolShooting")
		net.WriteString(ply:Nick())
		net.Broadcast()

		g_SchoolShooterAnnounced = true
	end
end)
