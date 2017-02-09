AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "FN P90"
	SWEP.CSMuzzleFlashes = true

	SWEP.AimPos = Vector(-1.93, -5.928, 1.82)
	SWEP.AimAng = Vector(1.162, 0, 0)
	
	SWEP.SprintPos = Vector(0.736, -3.971, 1.802)
	SWEP.SprintAng = Vector(-13.205, 37.048, 0)
	
	SWEP.ZoomAmount = 15
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "smallshell"
	
	SWEP.IconLetter = "m"
	killicon.AddFont("swb_p90", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_rifle_med"
end

SWEP.FadeCrosshairOnAim = false

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.SpeedDec = 20
SWEP.BulletDiameter = 5.7
SWEP.CaseLength = 28

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.Slot = 2
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
SWEP.ViewModel		= "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel		= "models/weapons/w_smg_p90.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.FireDelay = 0.0666
SWEP.FireSound = Sound("Weapon_P90.Single")
SWEP.Recoil = 0.9

SWEP.HipSpread = 0.043
SWEP.AimSpread = 0.007
SWEP.VelocitySensitivity = 1.5
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 18
SWEP.DeployTime = 1
SWEP.BurstCooldownMul = 3.5