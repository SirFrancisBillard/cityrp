
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
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_REPLACE)
	render.SetStencilZFailOperation(STENCIL_REPLACE)

	-- Fade in the area that we DONT draw
	--draw.DrawText("YOU DIED", "YouDied", ScrW() / 2, ScrH() / 2, color_white, TEXT_ALIGN_CENTER)
	surface.SetFont( "Default" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( 128, 128 )
	surface.DrawText( "Hello World" )

	-- Only draw things that are in the stencil buffer
	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
	render.SetStencilZFailOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)

	-- Draw black all over screen
	surface.SetDrawColor(0, 0, 0, math.min((CurTime() - (LocalPlayer().FadingOutOfConsciousness or 0)) * 125, 255))
	surface.DrawRect(0, 0, ScrW(), ScrH())

	-- Let everything render normally again
	render.SetStencilEnable(false)
end)
