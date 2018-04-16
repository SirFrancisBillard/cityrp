AddCSLuaFile()

SWEP.Base = "lite_base_sniper"

SWEP.PrintName = "AWP"
SWEP.Category = "Lite Weapons"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "r"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model( "models/weapons/w_snip_awp.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_snip_awp.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound( "Weapon_AWP.Single" )
SWEP.Primary.Recoil = 6
SWEP.Primary.Damage = 90
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.05
SWEP.Primary.Delay = 1.7

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.25
SWEP.Spread.IronsightsMod = 0.001
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector( -7.5, -5, 2.3 )
SWEP.IronsightsAng = Angle( 0, 0, 0 )
SWEP.IronsightsFOV = 0.20
SWEP.IronsightsSensitivity = 0.10

SWEP.LoweredPos = Vector( 1.6397, -5.089, 2.4904 )
SWEP.LoweredAng = Angle( -17.2767, 28.3565, -0.4145 )

if CLIENT then
	killicon.AddFont( "lite_awp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end