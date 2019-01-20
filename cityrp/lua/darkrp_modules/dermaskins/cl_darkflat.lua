local SKIN = {}

surface.CreateFont("darkHead", {
	font = "coolvetica",
	size = 50, 
	weight = 500
})

surface.CreateFont("darkHeadSmall", {
	font = "coolvetica",
	size = 25, 
	weight = 500
})

surface.CreateFont("darkPaint", {
	font = "coolvetica",
	size = 20, 
	outlined = true,
	weight = 500
})

surface.CreateFont("darkButton", {
	font = "coolvetica",
	size = 25, 
	weight = 500
})

surface.CreateFont("darkTitle", {
	font = "Default",
	size = 30, 
	weight = 500
})

SKIN.PrintName          				= "DarkFlat"
SKIN.Author           					= "Grey Hellios"
SKIN.DermaVersion       				= 1

SKIN.colOutline 						= Color( 0, 0, 0, 20 )

SKIN.BigTitleFont 						= "darkHead"
SKIN.SmallTitleFont 					= "darkHeadSmall"
SKIN.fontButton							= "darkButton"
SKIN.menuTitle							= "Erebus"

SKIN.bg_color							= Color(0, 0, 0, 255)
SKIN.head_color							= Color(50, 50, 50, 255)

SKIN.Highlight							= Color( 80, 80, 80 )
SKIN.InnerPanel 						= Color( 49, 49, 49 )
SKIN.ButtonColor 						= Color( 65, 65, 65 )

SKIN.colButtonHover						= Color(40, 40, 40)
SKIN.colButtonNormal					= Color(50, 50, 50)
SKIN.colButtonText						= Color(255, 255, 255)
SKIN.colButtonTextDisabled				= Color(0, 0, 0, 255)

/*---------------------------------------------------------
        Frame
---------------------------------------------------------*/
function SKIN:DrawSquaredBox( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawRect( x, y, w, h )
			
	surface.SetDrawColor( self.colOutline )
	surface.DrawOutlinedRect( x, y, w, h )
end

function SKIN:PaintFrame( panel )
	self:DrawSquaredBox( 0, 0, panel:GetWide(), panel:GetTall(), self.bg_color )
	panel.lblTitle:SetFont(self.SmallTitleFont)
	
	draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), self.bg_color) -- BG
	draw.RoundedBox(0, 0, 0, panel:GetWide(), 25, SKIN.head_color) -- Header Top
end

/*---------------------------------------------------------
        Button
---------------------------------------------------------*/
function SKIN:PaintButton(panel, w, h)
	if ( panel.Hovered ) then
		panel:SetTextColor(Color(255, 255, 255))
		surface.SetDrawColor(self.colButtonHover)
		surface.DrawRect(0, 0, w, h)
	else
		panel:SetTextColor(Color(200, 200, 200))
		surface.SetFont(self.fontButton)
		surface.SetDrawColor(self.colButtonNormal)
		surface.DrawRect(0, 0, w, h)
	end
	panel:SetFont(self.fontButton)
end

/*---------------------------------------------------------
        Scrollbar
---------------------------------------------------------*/
function SKIN:PaintScrollBarGrip( panel, w, h )
	if panel.Depressed then
		surface.SetDrawColor( self.Highlight )
	else
		surface.SetDrawColor( self.ButtonColor )
	end
	surface.DrawRect( 0, 0, w, h )
end

function SKIN:PaintVScrollBar( panel, w, h )
	surface.SetDrawColor( self.InnerPanel )
	surface.DrawRect( 0, 0, w, h )
end

function SKIN:PaintButtonDown( panel, w, h )
	self:PaintButton( panel, w, h )
	if not panel.m_Image then
		panel:SetImage( "getyourowndamnbuttonimage" )
		panel.m_Image:SetSize( 12, 12 )
	end
end

function SKIN:PaintButtonUp( panel, w, h )
	self:PaintButton( panel, w, h )
	if not panel.m_Image then
		panel:SetImage( "getyourowndamnbuttonimage" )
		panel.m_Image:SetSize( 12, 12 )
	end
end

/*---------------------------------------------------------
        List View
---------------------------------------------------------*/
function SKIN:PaintListView(panel, w, h)
	surface.SetDrawColor(80, 80, 80)
	surface.DrawRect(0, 0, w, h)
end

--[[---------------------------------------------------------
	CheckBox
-----------------------------------------------------------]]
function SKIN:PaintCheckBox( panel, w, h )
	if ( panel:GetChecked() ) then
		if ( panel:GetDisabled() ) then
			draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(255, 0, 0, 255))
		else
			// Checked \\
			draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(108, 122, 137, 255))
		end
	else
		if ( panel:GetDisabled() ) then
			draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(255, 0, 0, 255))
		else
			// Not Checked \\
			draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(75, 75, 75, 255))
		end
	end	
end

derma.DefineSkin( "DarkFlat", "mitsuma's_blue_skin", SKIN )
