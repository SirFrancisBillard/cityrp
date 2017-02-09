AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "FN Five-seveN"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(-5.949, -2.096, 2.88)
	SWEP.AimAng = Vector(-0.401, 0, 0)
		
	SWEP.SprintPos = Vector(0, -17.514, -12.271)
	SWEP.SprintAng = Vector(63.637, 0, 0)
	
	SWEP.ZoomAmount = 5
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "smallshell"
	
	SWEP.IconLetter = "u"
	killicon.AddFont("swb_fiveseven", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_pistol_med"
end

SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.SpeedDec = 10
SWEP.BulletDiameter = 5.7
SWEP.CaseLength = 28

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

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"

SWEP.FireDelay = 0.145
SWEP.FireSound = Sound("Weapon_FiveSeven.Single")
SWEP.Recoil = 0.95

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.009
SWEP.VelocitySensitivity = 1.3
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.01
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 20
SWEP.DeployTime = 1
SWEP.DryFire = false