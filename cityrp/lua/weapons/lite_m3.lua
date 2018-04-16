AddCSLuaFile()

SWEP.Base = "lite_base_shotgun"

SWEP.PrintName = "M3 Super 90"
SWEP.Category = "Lite Weapons"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "k"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model( "models/weapons/w_shot_m3super90.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_shot_m3super90.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound( "Weapon_M3.Single" )
SWEP.Primary.Recoil = 2.5
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 8
SWEP.Primary.Cone = 0.06
SWEP.Primary.Delay = 0.9

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.25
SWEP.Spread.IronsightsMod = 0.75
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector( -7.65, -5, 2.8 )
SWEP.IronsightsAng = Angle( 1, 0, 0 )
SWEP.IronsightsFOV = 0.8

SWEP.LoweredPos = Vector( 1.6397, -5.089, 4 )
SWEP.LoweredAng = Angle( -17.2767, 28.3565, -0.4145 )

if CLIENT then
	killicon.AddFont( "lite_m3", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end