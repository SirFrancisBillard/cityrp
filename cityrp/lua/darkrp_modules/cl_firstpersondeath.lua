
hook.Add("CalcView", "FirstPersonDeath", function(ply, pos, ang, fov, nearz, farz)
	if ply:Alive() or not IsValid(ply:GetRagdollEntity())) then ply.FadingOutOfConsciousness = nil return end
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
	-- Reset everything to known good
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	-- Enable stencils
	render.SetStencilEnable(true)
	-- Set everything up everything draws to the stencil buffer instead of the screen
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_NEVER)
	render.SetStencilFailOperation(STENCIL_REPLACE)

	-- Draw black all over screen
	surface.SetDrawColor(0, 0, 0, math.min((CurTime() - ply.FadingOutOfConsciousness) * 125, 255))
	surface.DrawRect(0, 0, ScrW(), ScrH())

	-- Only draw things that are in the stencil buffer
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilFailOperation(STENCIL_KEEP)

	-- Fade in the area that we DONT draw
	draw.DrawText("YOU DIED", "YouDied", ScrW() / 2, ScrH() / 2, color_white, TEXT_ALIGN_CENTER)

	-- Let everything render normally again
	render.SetStencilEnable(false)
end)
