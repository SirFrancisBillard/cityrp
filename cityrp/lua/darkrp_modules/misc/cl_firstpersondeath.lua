
hook.Add("CalcView", "FirstPersonDeath", function(ply, pos, ang, fov, nearz, farz)
	ply = LocalPlayer()
	if ply:Alive() or not IsValid(ply:GetRagdollEntity()) then ply.FadingOutOfConsciousness = nil return end
	if ply.FadingOutOfConsciousness == nil then
		ply.FadingOutOfConsciousness = CurTime() -- REALLY hacky
	end
	local rag = ply:GetRagdollEntity()
	local eyeattach = rag:LookupAttachment("eyes")
	if not eyeattach then return end
	local eyes = rag:GetAttachment(eyeattach)
	if not eyes then return end
	return {origin = eyes.Pos, angles = eyes.Ang, fov = fov}
end)

surface.CreateFont("YouDied", {
	font = "Arial",
	size = ScreenScale(80),
	weight = 5000,
	antialias = true,
})

hook.Add("HUDPaint", "FadeOutOfConsciousness", function()
	if LocalPlayer():Alive() then return end

	local fade_black = math.min((CurTime() - (LocalPlayer().FadingOutOfConsciousness or 0)) * 125, 255)
	local fade_white = math.min(((CurTime() - 1) - (LocalPlayer().FadingOutOfConsciousness or 0)) * 125, 255)
	surface.SetDrawColor(0, 0, 0, fade_black)
	surface.DrawRect(0, 0, ScrW(), ScrH())
	draw.DrawText("YOU DIED", "YouDied", ScrW() / 2, ScrH() / 3, Color(255, 255, 255, fade_white), TEXT_ALIGN_CENTER)
end)
