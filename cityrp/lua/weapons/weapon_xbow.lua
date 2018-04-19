AddCSLuaFile()

SWEP.PrintName = "Crossbow"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Fire a bolt.
Bolts stick to surfaces.]]

SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Primary.Delay = 0.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

local ShootSound = Sound("weapons/crossbow/fire1.wav")

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetHoldType("crossbow")
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:ShootEffects()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:EmitSound(ShootSound)

	if SERVER then
		local bolt = ents.Create("ent_crossbowbolt")

		if not IsValid(bolt) then return end

		bolt:SetOwner(self.Owner)
		bolt:SetPos(self.Owner:EyePos())
		bolt:SetAngles(self.Owner:EyeAngles())
		bolt:Spawn()

		local phys = bolt:GetPhysicsObject()
		if not IsValid(phys) then bolt:Remove() return end

		local velocity = self.Owner:GetAimVector()
		velocity = velocity * 3600
		phys:ApplyForceCenter(velocity)
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload() end

function SWEP:Think()

end
