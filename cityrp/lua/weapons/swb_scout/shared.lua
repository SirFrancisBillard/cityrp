AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Steyr Scout"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(-6.68, -18.331, 3.359)
	SWEP.AimAng = Vector(0, 0, 0)
		
	SWEP.SprintPos = Vector(0, 0, 1.5)
	SWEP.SprintAng = Vector(-7.739, 28.141, 0)
	
	SWEP.ViewModelMovementScale = 1.15
	
	SWEP.DrawBlackBarsOnAim = true
	SWEP.AimOverlay = surface.GetTextureID("swb/scope_rifle")
	SWEP.FadeDuringAiming = true
	SWEP.MoveWepAwayWhenAiming = true
	SWEP.ZoomAmount = 70
	SWEP.DelayedZoom = true
	SWEP.SnapZoom = true
	SWEP.SimulateCenterMuzzle = true
	
	SWEP.AdjustableZoom = true
	SWEP.MinZoom = 40
	SWEP.MaxZoom = 80
	
	SWEP.IconLetter = "n"
	killicon.AddFont("swb_scout", "SWB_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "swb_rifle_large"
end

SWEP.PlayBackRate = 1
SWEP.PlayBackRateSV = 1
SWEP.FadeCrosshairOnAim = true
SWEP.PreventQuickScoping = true

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true

SWEP.SpeedDec = 25
SWEP.BulletDiameter = 7.62
SWEP.CaseLength = 51

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"bolt"}
SWEP.Base = "swb_base"
SWEP.Category = "SUP Weapons"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel		= "models/weapons/w_snip_scout.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Rifle"

SWEP.FireDelay = 1.3
SWEP.FireSound = Sound("Weapon_Scout.Single")
SWEP.Recoil = 2

SWEP.HipSpread = 0.055
SWEP.AimSpread = 0.00015
SWEP.VelocitySensitivity = 2
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.05
SWEP.SpreadCooldown = 1.25
SWEP.Shots = 1
SWEP.Damage = 48
SWEP.DeployTime = 1