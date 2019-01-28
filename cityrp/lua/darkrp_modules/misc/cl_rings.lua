
do return end

local echoes = echoes or {}
local echo_thickness = 75.0
local color_mask = Color(0,0,0,0)

local function drawStencilSphere( pos, ref, compare_func, radius, color, detail )
	render.SetStencilReferenceValue( ref )
	render.SetStencilCompareFunction( compare_func )
	render.DrawSphere(pos, radius, detail, detail, color)
end

hook.Add( "PostDrawTranslucentRenderables", "PostDrawTranslucentRenderablesDrawEcho", function( )
	local localplayer_pos = LocalPlayer():EyePos()
	local detail = 25
	local realtime = RealTime()
	render.SetStencilEnable(true)
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	for i, echo in ipairs(echoes) do
		local dist = echo.pos:Distance(localplayer_pos)
		local opacity = ((echo.radius - (dist/2))/echo.radius) * 0.25
		local p = (realtime - echo.start) / (echo.lifetime)
		if p < 1.0 and opacity > 0 then
			local outer_r = Lerp(p, 0, echo.radius)
			local inner_r = math.max(outer_r-echo_thickness,0)
			local color = echo.color
			color.a = 255*opacity*math.pow(1-p, 2)
			render.ClearStencil()
			render.SetColorMaterial()
			render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
			drawStencilSphere(echo.pos, 2, STENCILCOMPARISONFUNCTION_ALWAYS, -outer_r, color_mask, detail ) -- big, inside-out
			render.SetStencilZFailOperation( STENCILOPERATION_INCR )
			drawStencilSphere(echo.pos, 2, STENCILCOMPARISONFUNCTION_ALWAYS, outer_r, color_mask, detail ) -- big
			render.SetStencilZFailOperation( STENCILOPERATION_INCR )
			drawStencilSphere(echo.pos, 2, STENCILCOMPARISONFUNCTION_ALWAYS, -inner_r, color_mask, detail ) -- small, inside-out
			render.SetStencilZFailOperation( STENCILOPERATION_DECR )
			drawStencilSphere(echo.pos, 2, STENCILCOMPARISONFUNCTION_ALWAYS, inner_r, color_mask, detail ) -- small
			render.SetColorMaterialIgnoreZ()
			drawStencilSphere(echo.pos, 2, STENCILCOMPARISONFUNCTION_EQUAL, -outer_r, color, detail ) -- big, inside-out
		end
	end
	render.SetStencilEnable(false)
end)
