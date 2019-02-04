AddCSLuaFile()

game.AddAmmoType({
	name = "bbgun",
	dmgtype = DMG_BULLET
})

if CLIENT then
	language.Add("bbgun_ammo", "BBs")
end

SWEP.Base = "lite_base_sniper"

SWEP.PrintName = "Red Ryder BB Gun"
SWEP.Category = "Lite Weapons"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "n"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model( "models/weapons/w_snip_scout.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_snip_scout.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound("garrysmod/balloon_pop_cute.wav")
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 2
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 1.5

SWEP.Primary.Ammo = "bbgun"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 00
SWEP.Spread.IronsightsMod = 0.001
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector( -7.5, -5, 2.3 )
SWEP.IronsightsAng = Angle( 0, 0, 0 )
SWEP.IronsightsFOV = 0.25
SWEP.IronsightsSensitivity = 0.125

SWEP.LoweredPos = Vector( 1.6397, -5.089, 2.4904 )
SWEP.LoweredAng = Angle( -17.2767, 28.3565, -0.4145 )

SWEP.WepSelectIcon = WeaponIconURL("bbgun")

if CLIENT then
	killicon.AddFont( "weapon_bbgun", "Default", "BB GUN", Color( 255, 80, 0, 255 ) )
end
