AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "FAMAS F1"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(-2.681, -3.332, 1.44)
	SWEP.AimAng = Vector(0, 0, 0)
	
	SWEP.SprintPos = Vector(0, 0, -0.7)
	SWEP.SprintAng = Vector(-7.739, 28.141, 0)
	
	SWEP.ZoomAmount = 15
	
	SWEP.IconLetter = "t"
	killicon.AddFont("swb_famas", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_rifle_med"
	SWEP.InvertShellEjectAngle = true
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

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_famas.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= 25
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Rifle"

SWEP.FireDelay = 0.06
SWEP.FireSound = Sound("Weapon_FAMAS.Single")
SWEP.Recoil = 1.15

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.003
SWEP.VelocitySensitivity = 2
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 24
SWEP.DeployTime = 1