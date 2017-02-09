AddCSLuaFile()

SWEP.Base = "weapon_base"

if SERVER then
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
else
	SWEP.PrintName = "RP Weapon Base"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 68
	SWEP.Category = "RP"
	SWEP.Author = "code_gs"
end

SWEP.HoldType = "normal"

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.AdminOnly = true
SWEP.UseHands = true

SWEP.Primary = {
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = true,
	Ammo = "none",
	Delay = 0.5,
	Sound = Sound('ambient/voices/cough1.wav')
}

SWEP.Secondary = {
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = true,
	Ammo = "none",
	Delay = 0.5,
	Sound = Sound('ambient/voices/cough2.wav')
}

SWEP._Reload = {
	Delay = 2,
	Sound = Sound('npc/combine_soldier/vo/administer.wav')
}

SWEP.HitDistance = 100

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextReload")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:Reload()
	self:SetNextReload(CurTime() + self._Reload.Delay)
end

function SWEP:CanReload()
	return CurTime() > self:GetNextReload()
end

function SWEP:Holster()
	return true
end