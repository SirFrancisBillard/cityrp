g_SchoolShooterAnnounced = false

util.AddNetworkString("AnnounceSchoolShooting")
util.AddNetworkString("SchoolShooterDied")

local SchoolShootingWeps = {
	["swb_m249"] = true,
	["swb_ak47"] = true,
	["swb_m3super90"] = true
}

hook.Add("PlayerSwitchWeapon", "AnnounceSchoolShooting", function(ply, old, new)
	if IsValid(ply) and IsValid(new) and ply:IsPlayer() and new:IsWeapon() and ply:Team() == TEAM_SHOOTER and SchoolShootingWeps[new:GetClass()] and not g_SchoolShooterAnnounced then
		net.Start("AnnounceSchoolShooting")
		net.WriteString(ply:Nick())
		net.Broadcast()

		g_SchoolShooterAnnounced = true
	end
end)
