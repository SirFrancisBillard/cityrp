AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M3 Super 90"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(-7.65, -8.207, 3.345)
	SWEP.AimAng = Vector(0.349, 0, 0)
		
	SWEP.SprintPos = Vector(3.957, -4.112, 1.013)
	SWEP.SprintAng = Vector(-8.613, 32.743, 0)
	
	SWEP.ZoomAmount = 5
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "shotshell"
	SWEP.ShellOnEvent = true
	
	SWEP.IconLetter = "k"
	killicon.AddFont("swb_m3super90", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_shotgun"
end

SWEP.PlayBackRate = 1
SWEP.PlayBackRateSV = 1
SWEP.SpeedDec = 30
SWEP.BulletDiameter = 5
SWEP.CaseLength = 10

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_box_buckshot_ttt"

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "shotgun"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"semi"}
SWEP.Base = "swb_base"
SWEP.Category = "SUP Weapons"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel		= "models/weapons/w_shot_m3super90.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Buckshot"

SWEP.FireDelay = 1
SWEP.FireSound = Sound("Weapon_M3.Single")
SWEP.Recoil = 2.5
SWEP.ShotgunReload = true
SWEP.ReloadStartWait = 0.6
SWEP.ReloadFinishWait = 1.1
SWEP.ReloadShellInsertWait = 0.6
SWEP.Chamberable = false

SWEP.HipSpread = 0.036
SWEP.AimSpread = 0.003
SWEP.ClumpSpread = 0.01
SWEP.VelocitySensitivity = 2.2
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.02
SWEP.SpreadCooldown = 1.03
SWEP.Shots = 12
SWEP.Damage = 10
SWEP.DeployTime = 1