AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "USP .45"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(1.976, -0.042, 1.34)
	SWEP.AimAng = Vector(0.425, 0, 0)
	
	SWEP.SprintPos = Vector(-3.997, -6.459, -6.159)
	SWEP.SprintAng = Vector(61.365, 0, 0)
	
	SWEP.ZoomAmount = 5
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "smallshell"
	
	SWEP.IconLetter = "y"
	killicon.AddFont("swb_usp", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_pistol_med"
	SWEP.MuzzleEffectSupp = "swb_silenced_small"
end
SWEP.CanPenetrate = false
SWEP.FadeCrosshairOnAim = false

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.SpeedDec = 10
SWEP.BulletDiameter = 11.5
SWEP.CaseLength = 22.8

SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "Pistol"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "swb_base"
SWEP.Category = "SUP Weapons"

SWEP.Author			= "aStonedPenguin"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= true
SWEP.ViewModel				= "models/weapons/2_pist_usp.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/3_pist_usp.mdl"	-- Weapon world model

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"

SWEP.FireDelay = 0.14
SWEP.FireSound = Sound("Alt_Weapon_USP.1")
SWEP.FireSoundSuppressed = Sound("Alt_Weapon_USP.2")
SWEP.Recoil = 0.75
SWEP.DryFire = true

SWEP.Suppressable = true

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.2
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.16
SWEP.Shots = 1
SWEP.Damage = 20
SWEP.DeployTime = 1