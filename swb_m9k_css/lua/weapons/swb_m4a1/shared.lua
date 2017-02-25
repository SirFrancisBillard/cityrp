AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M4A1"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(3.043, -1.38, 0.859)
	SWEP.AimAng = Vector(0.172, 0, 0)
	
	SWEP.SprintPos = Vector(-3.543, -2.126, -0.866)
	SWEP.SprintAng = Vector(-12.954, -58.151, 10.748)
	
	SWEP.ZoomAmount = 15
	
	SWEP.IconLetter = "w"
	killicon.AddFont("swb_m4a1", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_rifle_med"
	SWEP.MuzzleEffectSupp = "swb_silenced"
end

SWEP.FadeCrosshairOnAim = false

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.SpeedDec = 25
SWEP.BulletDiameter = 5.56
SWEP.CaseLength = 45

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "3burst", "semi"}
SWEP.Base = "swb_base"
SWEP.Category = "SUP Weapons"

SWEP.Author			= "aStonedPenguin"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= true
SWEP.ViewModel				= "models/weapons/2_rif_m4a1.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/3_rif_m4a1.mdl"	-- Weapon world model

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Rifle"

SWEP.FireDelay = 0.0666
SWEP.FireSound = Sound("Alt_Weapon_M4A1.1")
SWEP.FireSoundSuppressed = Sound("Alt_Weapon_M4A1.2")
SWEP.Recoil = 1

SWEP.Suppressable = true

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.004
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 35
SWEP.DeployTime = 1