
-- what the actual fuck

hook.Add("EntityEmitSound", "HellenKellerCantHearHaHaSoFunnyAmirite", function()
	if LocalPlayer():GetTeam() == TEAM_HELLENKELLER then
		return false
	end
end)

hook.Add("HUDPaint", "HellenKellerCantSeeHaHaSoFunnyAmirite", function()
	if LocalPlayer():GetTeam() == TEAM_HELLENKELLER then
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
end)
