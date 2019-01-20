
uber = uber or {}

surface.CreateFont("uberFont", {
	font = "Comic Sans MS", 
	size = 60, 
	weight = 1000,
	antialias = true
})

surface.CreateFont("uberFontTitle", {
	font = "Comic Sans MS", 
	size = 25, 
	weight = 400,
	antialias = true
})

-- Corner Borders
local function drawAreaBounds( x, y, w, h, color )
	-- left top
	draw.RoundedBox( 0, x, y, 15, 1, color )
	draw.RoundedBox( 0, x, y, 1, 15, color )
	-- left bottom
	draw.RoundedBox( 0, x, y + h - 1, 15, 1, color )
	draw.RoundedBox( 0, x, y + h - 15, 1, 15, color )
	-- right top
	draw.RoundedBox( 0, x + w - 15, y, 15, 1, color )
	draw.RoundedBox( 0, x + w - 1, y, 1, 15, color )
	-- right bottom
	draw.RoundedBox( 0, x + w - 15, y + h - 1, 15, 1, color )
	draw.RoundedBox( 0, x + w - 1, y + h - 15, 1, 15, color )
end

-- Blur
local blur = Material("pp/blurscreen")
local function drawBlur(panel, amount) 
        local x, y = panel:LocalToScreen(0, 0)
        local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)
        for i = 1, 6 do
                blur:SetFloat("$blur", (i / 3) * (amount or 6))
                blur:Recompute()
                render.UpdateScreenEffectTexture()
                surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
        end
end

-- All this code for a circled avatar......
-- Circle Avatar Code!
local function MakeCirclePoly( _x, _y, _r, _points )
	local _u = ( _x + _r * 320 ) - _x;
    	local _v = ( _y + _r * 320 ) - _y;
 
    	local _slices = ( 2 * math.pi ) / _points;
    	local _poly = { };
    	for i = 0, _points - 1 do
        	local _angle = ( _slices * i ) % _points;
        	local x = _x + _r * math.cos( _angle );
        	local y = _y + _r * math.sin( _angle );
        	table.insert( _poly, { x = x, y = y, u = _u, v = _v } )
    	end
 
    	return _poly;
end
 
local PANEL = {}
 
function PANEL:Init()
    	self.Avatar = vgui.Create("AvatarImage", self)
    	self.Avatar:SetPaintedManually(true)
    	self.material = Material( "effects/flashlight001" )
    	self:OnSizeChanged(self:GetWide(), self:GetTall())
end
 
function PANEL:PerformLayout()
    	self:OnSizeChanged(self:GetWide(), self:GetTall())
end
 
function PANEL:SetSteamID(...)
    	self.Avatar:SetSteamID(...)
end
 
function PANEL:SetPlayer(...)
    	self.Avatar:SetPlayer(...)
end
 
function PANEL:OnSizeChanged(w, h)
    	self.Avatar:SetSize(self:GetWide(), self:GetTall())
    	self.points = math.Max((self:GetWide()/4), 32)
    	self.poly = MakeCirclePoly(self:GetWide()/2, self:GetTall()/2, self:GetWide()/2, self.points)
end
 
function PANEL:DrawMask(w, h)
    	--draw.RoundedBox(w/4, 0, 0, w, h, color_white)
    	draw.NoTexture();
    	surface.SetMaterial(self.material); 
    	surface.SetDrawColor(color_white);
    	surface.DrawPoly(self.poly);
end
 
function PANEL:Paint(w, h)
    	render.ClearStencil()
    	render.SetStencilEnable(true)
 
    	render.SetStencilWriteMask(1)
    	render.SetStencilTestMask(1)
 
    	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
    	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
    	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    	render.SetStencilReferenceValue( 1 )
 
    	self:DrawMask(w, h)
 
    	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    	render.SetStencilReferenceValue(1)
 
    	self.Avatar:SetPaintedManually(false)
    	self.Avatar:PaintManual()
    	self.Avatar:SetPaintedManually(true)
 
    	render.SetStencilEnable(false)
    	render.ClearStencil()
end

vgui.Register("AvatarMask", PANEL)
-- End of Circle Avatar Code

local uberContextCall = false

-- Colors
local greywhite = Color(255, 255, 255, 100)
local blue = Color(2, 152, 219, 255)

-- Gradients
local gradient = surface.GetTextureID("gui/gradient_down.vtf")
local gradient2 = surface.GetTextureID("gui/gradient_up.vtf")

local function uberMenu()
	uberFrame = vgui.Create("DFrame")
	uberFrame:SetSize(ScrW()*0.3, ScrH()*0.7)
	uberFrame:Center()
	uberFrame:SetTitle("")
	uberFrame:MakePopup()
	uberFrame:ShowCloseButton(false)
	function uberFrame:Paint( w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(26, 26, 26, 255) )
		draw.RoundedBox(0, 0, 0, w, 30, Color(0, 0, 0, 255) )

		surface.SetDrawColor(100, 100, 100, 50)
		surface.SetTexture(gradient)
	    	surface.DrawTexturedRect(0, 0, w, 30)

	    	surface.SetDrawColor(100, 100, 100, 50)
	    	surface.SetTexture(gradient)
	    	surface.DrawTexturedRect(0, 0, w, h)

	    	surface.SetDrawColor(blue)
        	surface.DrawRect(0, 0, 3, 30 - 0.1 * 2)

	    	draw.SimpleTextOutlined("Uber","uberFontTitle", w/2, 0, color_white, TEXT_ALIGN_CENTER, 0, 1, color_black)
	end

	local uberClose = vgui.Create("DButton", uberFrame)
	uberClose:SetSize(25,25)
	uberClose:SetPos(uberFrame:GetWide() - 35, 2)
	uberClose:SetText("")
	function uberClose:Paint(w, h)
		if uberClose:IsHovered() then
			surface.SetDrawColor(color_white)
			surface.DrawLine(12, 7, 23, 17) 
			surface.DrawLine(12, 17, 23, 7) 
		else
			surface.SetDrawColor(greywhite)
			surface.DrawLine(12, 7, 23, 17) 
			surface.DrawLine(12, 17, 23, 7) 
		end
	end

	function uberClose:DoClick()
		uberFrame:Remove()
		surface.PlaySound("UI/buttonclick.wav")
	end

	local uberScrollPNL = vgui.Create("DScrollPanel", uberFrame)
	uberScrollPNL:Dock(FILL)
	function uberScrollPNL:Paint(w, h) 
	end

	local uberDriverPanel = vgui.Create("DPanel", uberScrollPNL)
	uberDriverPanel:SetSize(ScrW(), 100)
	uberDriverPanel:Dock(TOP)
	uberDriverPanel:DockMargin(0, 5, 0, 0)
	function uberDriverPanel:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(16, 16, 16, 255) )

		surface.SetDrawColor(75, 75, 75, 100)
	    	surface.SetTexture(gradient)
	    	surface.DrawTexturedRect(0, 0, w, h)

	    	draw.SimpleTextOutlined("Driver: "..LocalPlayer():Nick(),"uberFontTitle", w*0.3, h*0.2, color_white, TEXT_ALIGN_LEFT, 0, 1, color_black)
	    	draw.SimpleTextOutlined("Price: $1337","uberFontTitle", w*0.3, h*0.5, color_white, TEXT_ALIGN_LEFT, 0, 1, color_black)
	end

	local uberAvatar = vgui.Create("AvatarMask", uberDriverPanel)
    	uberAvatar:SetSize(84, 84)
    	uberAvatar:SetPos(0, 5)
    	uberAvatar:SetPlayer(LocalPlayer(), 128)
end

local function uberContext()
	buttonContext = vgui.Create("DButton")
	buttonContext:SetSize(ScrW()*0.06, ScrH()*0.1)
	buttonContext:SetPos(ScrW()/2 - 50, ScrH()-100)
	buttonContext:MakePopup()
	buttonContext:SetText("Ü")
	buttonContext:SetFont("uberFont")
	buttonContext:SetTextColor(greywhite)
	function buttonContext:Paint(w, h)
		drawBlur(buttonContext, 1)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 220))

		if buttonContext:IsHovered() then
			drawAreaBounds(0, 0, w, h, color_white)
			buttonContext:SetPos(ScrW()/2 - 55, ScrH()-105)
			buttonContext:SetTextColor(color_white)
		else
			drawAreaBounds(0, 0, w, h, greywhite)
			buttonContext:SetPos(ScrW()/2 - 55, ScrH()-100)
			buttonContext:SetTextColor(greywhite)
		end
	end

	function buttonContext:OnCursorEntered()
    	surface.PlaySound("UI/buttonrollover.wav")                            
    end

    function buttonContext:DoClick()
    	uberMenu()
    	surface.PlaySound("UI/buttonclick.wav")
    end
end

hook.Add("OnContextMenuOpen", "contextMenuOpen", function()	
	gui.EnableScreenClicker(true)
	uberContext()
	uberContextCall = true
end)

hook.Add("OnContextMenuClose", "contextMenuClose", function()
	buttonContext:Remove()
	gui.EnableScreenClicker(false)
	uberContextCall = false
end)
