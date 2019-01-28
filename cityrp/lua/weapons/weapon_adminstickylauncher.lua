AddCSLuaFile()

SWEP.PrintName = "Admin Stickybomb Launcher"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Launch a stickybomb.
Stickybombs will attach to surfaces upon contact.
<color=green>[SECONDARY FIRE]</color> Detonate all stickybombs.]]

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "stickybombs"

SWEP.Primary.Delay = 0.1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.IsStickyLauncher = true

local ShootSound = Sound("weapons/grenade_launcher1.wav")

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetHoldType("shotgun")
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:ShootEffects()
	self:EmitSound(ShootSound)

	if CLIENT then return end

	local nade = ents.Create("ent_stickybomb")

	if not IsValid(nade) then return end

	nade:SetOwner(self.Owner)
	nade:SetPos(self.Owner:EyePos())
	nade:SetAngles(self.Owner:EyeAngles())
	nade:Spawn()

	local phys = nade:GetPhysicsObject()
	if not IsValid(phys) then nade:Remove() return end

	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 1200
	phys:ApplyForceCenter(velocity)
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.01)
end

function SWEP:Reload() end
