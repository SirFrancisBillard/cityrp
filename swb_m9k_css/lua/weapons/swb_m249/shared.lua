AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M249 Para"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(-3.743, -1.346, 1.539)
	SWEP.AimAng = Vector(0, 0, 0)
	
	SWEP.SprintPos = Vector(3.779, -5.84, 0.165)
	SWEP.SprintAng = Vector(-8.655, 57.168, 0)
	
	SWEP.ZoomAmount = 15
	
	SWEP.IconLetter = "z"
	killicon.AddFont("swb_m249", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_rifle_med"
	SWEP.InvertShellEjectAngle = true
end

SWEP.PlayBackRate = 1
SWEP.PlayBackRateSV = 1
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
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "swb_base"
SWEP.Category = "SUP Weapons"

SWEP.Author			= "aStonedPenguin"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel				= "models/weapons/2_mach_m249para.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/3_mach_m249para.mdl"	-- Weapon world model

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Rifle"

SWEP.FireDelay = 0.075
SWEP.FireSound = Sound("Alt_Weapon_M249.1")	
SWEP.Recoil = 1.1
SWEP.Chamberable = false

SWEP.HipSpread = 0.055
SWEP.AimSpread = 0.004
SWEP.VelocitySensitivity = 2.5
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 24
SWEP.DeployTime = 1