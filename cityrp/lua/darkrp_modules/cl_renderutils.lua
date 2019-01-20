-- Call this to create a scissor circle.
-- Call it with no arguments to remove the current scissor circle.
function render.SetScissorCircle(x,y,radius)
	if x then
		render.ClearStencil()
		render.SetStencilTestMask(255)
		render.SetStencilWriteMask(255)
		render.SetStencilEnable(true)
		render.SetStencilReferenceValue(1)
		
		render.SetStencilCompareFunction(STENCIL_NEVER)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		render.SetStencilZFailOperation(STENCIL_REPLACE)
		
		draw.NoTexture()
		surface.SetDrawColor(color_white)
		local points = {}
		for degree=0,360,2 do
			local rad = math.rad(degree)
			local x1,y1 = math.cos(rad) * radius + x, math.sin(rad) * radius + y
			table.insert(points, {x=x1,y=y1})
		end
		surface.DrawPoly(points)
		
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
		
	else
		render.SetStencilEnable(false)
	end
end

--Usage:
--[[

hook.Add("HUDPaint","Circledraw1",function()
    render.SetScissorCircle(200,200,50)
	
		--Draw stuff here.
		surface.SetDrawColor(color_black)
		surface.DrawRect(0,0,ScrW(),ScrH())
		
    render.SetScissorCircle()
end)

]]