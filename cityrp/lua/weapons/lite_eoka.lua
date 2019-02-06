AddCSLuaFile()

SWEP.Base = "lite_base_sck"

SWEP.PrintName = "Eoka Pistol"
SWEP.Category = "Lite Weapons"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "B"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_XM1014.Single")
SWEP.Primary.PitchOverride = 75
SWEP.Primary.Recoil = 50
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 35
SWEP.Primary.Cone = 0.4
SWEP.Primary.Delay = 0.5

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.5
SWEP.Spread.IronsightsMod = 0.8
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.05
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = true

SWEP.LoweredPos = Vector( 1.6397, -5.089, 4 )
SWEP.LoweredAng = Angle( -17.2767, 28.3565, -0.4145 )

SWEP.Blowback = 1200
SWEP.FireChance = 4

SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/props_canal/mattpipe.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["v_weapon.xm1014_Parent"] = { scale = Vector(0.01, 0.01, 0.01), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["pipe"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(-0.24, -4.941, -13.122), angle = Angle(-4, -90, 180), size = Vector(0.813, 0.813, 0.813), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["pipe"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.513, 0.718, -5.298), angle = Angle(103.386, -175.993, 0), size = Vector(0.813, 0.813, 0.813), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.IronsightsPos = Vector(-6.52, 0, 3.68)
SWEP.IronsightsAng = Angle(-2.1, -0.201, 3.2)

if CLIENT then
	killicon.AddFont( "lite_eoka", "Trebuchet24", "Eoka", Color( 255, 80, 0, 255 ) )
end