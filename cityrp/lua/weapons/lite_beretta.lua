AddCSLuaFile()

SWEP.Base = "lite_base_sck"

SWEP.PrintName = "Beretta"
SWEP.Category = "Lite Weapons"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "u"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = true

SWEP.Primary.Sound = Sound( "Weapon_Elite.Single" )
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Damage = 25
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = 0.12

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 15
SWEP.Primary.DefaultClip = 20

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.25
SWEP.Spread.IronsightsMod = 0.2
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector( -5.9613, -3.3101, 2.706 )
SWEP.IronsightsAng = Angle( 0, 0, 0 )
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false

SWEP.LoweredPos = Vector( 0, -20, -10 )
SWEP.LoweredAng = Angle( 70, 0, 0 )

if CLIENT then
	killicon.AddFont( "lite_beretta", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite_single.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["v_weapon.elite_right"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.IronsightsPos = Vector(6.5, 0, 2.92)
SWEP.IronsightsAng = Angle(-0.201, 0.2, 0)

SWEP.VElements = {}
