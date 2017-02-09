AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "IMI Galil ARM"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(-6.358, -2.747, 2.473)
	SWEP.AimAng = Vector(0, 0, 0)
	
	SWEP.SprintPos = Vector(1.786, -1, 2)
	SWEP.SprintAng = Vector(-10.778, 27.573, 0)
	
	SWEP.ViewModelMovementScale = 1.15
	
	SWEP.IconLetter = "v"
	killicon.AddFont("swb_galil", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_rifle_med"
end

SWEP.PlayBackRate = 3
SWEP.PlayBackRateSV = 3
SWEP.SpeedDec = 30
SWEP.BulletDiameter = 5.56
SWEP.CaseLength = 45

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "swb_base"
SWEP.Category = "SUP Weapons"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_galil.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 35
SWEP.Primary.DefaultClip	= 35
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Rifle"

SWEP.FireDelay = 0.08
SWEP.FireSound = Sound("Weapon_Galil.Single")
SWEP.Recoil = 1.1

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.0035
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.11
SWEP.Shots = 1
SWEP.Damage = 24
SWEP.DeployTime = 1