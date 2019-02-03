
-- what the actual fuck

hook.Add("EntityEmitSound", "HellenKeller.Deaf", function()
	if LocalPlayer():Team() == TEAM_HELLENKELLER then
		return false
	end
end)

hook.Add("HUDPaint", "HellenKeller.Blind", function()
	if LocalPlayer():Team() == TEAM_HELLENKELLER then
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
end)
