AddCSLuaFile()

SWEP.Base = "lite_base"

SWEP.PrintName = "Lite Weapon Base Sniper"
SWEP.Category = "Lite Weapons"
SWEP.DrawWeaponInfoBox = false

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model( "models/weapons/w_snip_awp.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_snip_awp.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound( "Weapon_AWP.Single" )
SWEP.Primary.Recoil = 4
SWEP.Primary.Damage = 60
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Delay = 1.7

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.5
SWEP.Spread.IronsightsMod = 0.001
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.025
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector( -7.5, -5, 2.3 )
SWEP.IronsightsAng = Angle( 0, 0, 0 )
SWEP.IronsightsFOV = 0.25
SWEP.IronsightsSensitivity = 0.05
SWEP.UseIronsightsRecoil = false

SWEP.LoweredPos = Vector( 1.6397, -5.089, 2.4904 )
SWEP.LoweredAng = Angle( -17.2767, 28.3565, -0.4145 )

SWEP.Scope = Material( "gmod/scope" )
SWEP.ScopeRefract = Material( "gmod/scope-refract" )

function SWEP:DrawScope()
	local h = ScrH()
	local w = h * 1.25

	local x, y = ScrW() / 2 - w / 2, ScrH() / 2 - h / 2
	
	render.UpdateRefractTexture()

	surface.SetDrawColor( color_black )
	surface.DrawRect( 0, 0, x, ScrH() )
	surface.DrawRect( x + w, 0, ScrW() - ( x + w ), ScrH() )

	surface.SetMaterial( self.ScopeRefract )
	surface.DrawTexturedRect( x, y, w, h )

	surface.SetMaterial( self.Scope )
	surface.DrawTexturedRect( x, y, w, h )

	surface.DrawLine( 0, ScrH() / 2, ScrW(), ScrH() / 2 )
	surface.DrawLine( ScrW() / 2, 0, ScrW() / 2, ScrH() )
end

function SWEP:DrawHUDBackground()
	if self:GetIronsights() then self:DrawScope() end
end

function SWEP:PreDrawViewModel()
	self:OffsetThink()
	if self:GetIronsights() then return true end
end