AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

if CLIENT then
	SWEP.PrintName = "Camera"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.HoldType = "rpg"
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}

SWEP.WElements = {
	["camera"] = { type = "Model", model = "models/dav0r/camera.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.491, 1.508, -8.811), angle = Angle(0, 0, 180), size = Vector(0.832, 0.832, 0.832), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Zoom out.
<color=green>[SECONDARY FIRE]</color> Zoom in.]]
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.BobScale			= 2
SWEP.SwayScale			= 2

SWEP.Volume = 7
SWEP.Influence = 0

SWEP.LastSoundRelease = 0
SWEP.RestartDelay = 1
SWEP.RandomEffectsDelay = 0.2

SWEP.ViewModelDefPos = Vector (12.7306, 17.1875, -6.495)
SWEP.ViewModelDefAng = Vector (6.0177, 11.7713, -0.8871)

SWEP.MoveToPos = Vector (12.7306, 17.1875, -6.495)
SWEP.MoveToAng = Vector (6.0177, 11.7713, -0.8871)

SWEP.WepSelectIcon = WeaponIconURL("camera")

function SWEP:Initialize()
	self.zoomLevel = 70
	self.MaxZoomLevel = 70
	self.MinZoomLevel = 20
	self.BaseClass.Initialize(self)
end

function SWEP:Deploy()
	self.zoomLeve = 70
	self:layoutFOV()
end

function SWEP:CanPrimaryAttack() return true end
function SWEP:CanSecondaryAttack() return true end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	self.zoomLevel = math.Clamp(self.zoomLevel + FrameTime() * 100, self.MinZoomLevel, self.MaxZoomLevel)
	self:layoutFOV()
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	self.zoomLevel = math.Clamp(self.zoomLevel - FrameTime() * 100, self.MinZoomLevel, self.MaxZoomLevel)
	self:layoutFOV()
end

function SWEP:layoutFOV()
	self.Owner:SetFOV(self.zoomLevel, 0)
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_FORWARD) then
		self.Owner:ViewPunch( Angle( math.Rand(0,0.1), math.Rand(-0.2,0.2), 0 ) )
		if self.Owner:KeyDown(IN_SPEED) then
			self.Owner:ViewPunch( Angle( math.Rand(0,0.3), math.Rand(-0.2,0.2), math.Rand(-0.2,0.2) ) )
		end
	end

	if self.Owner:KeyDown(IN_MOVELEFT) then
		self.Owner:ViewPunch( Angle( math.Rand(0,0.1), math.Rand(-0.2,0.2), 0 ) )
		if self.Owner:KeyDown(IN_SPEED) then
			self.Owner:ViewPunch( Angle( math.Rand(0,0.3), math.Rand(-0.2,0.2), math.Rand(-0.2,0.2) ) )
		end
	end

	if self.Owner:KeyDown(IN_MOVERIGHT) then
		self.Owner:ViewPunch( Angle( math.Rand(0,0.1), math.Rand(-0.2,0.2), 0 ) )
		if self.Owner:KeyDown(IN_SPEED) then
			self.Owner:ViewPunch( Angle( math.Rand(0,0.3), math.Rand(-0.2,0.2), math.Rand(-0.2,0.2) ) )
		end
	end

	if self.Owner:KeyDown(IN_MOVELEFT) then
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,0.2), math.Rand(-0.2,0.2), 0 ) )
		if self.Owner:KeyDown(IN_SPEED) then
			self.Owner:ViewPunch( Angle( math.Rand(-0.5,0.5), math.Rand(-0.2,0.2), math.Rand(-0.2,0.2) ) )
		end
	end

	local cmd = self.Owner:GetCurrentCommand()
	
	self.LastThink = self.LastThink or 0
	local fDelta = (CurTime() - self.LastThink)
	self.LastThink = CurTime()
end

if SERVER then return end

local function DrawCircle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local color_red = Color(255, 0, 0)

surface.CreateFont("VideoCameraREC", {
	font = "Verdana", 
	size = ScreenScale(128),
	weight = 500,
	antialias = true,
})

function SWEP:DrawHUD()
	local DistFromEdge = ScrW() / 12
	if math.Round(CurTime()) % 2 == 0 then
		surface.SetDrawColor(color_red)
		draw.NoTexture()
		local CircleRadius = (DistFromEdge / 2)
		DrawCircle(DistFromEdge * 0.6, DistFromEdge * 0.6, CircleRadius, 36)
	end
	draw.SimpleText("REC", "VideoCameraREC", DistFromEdge + (ScrW() / (1920/35)), DistFromEdge - (ScrH() / (1080/66)), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end
