AddCSLuaFile()

SWEP.PrintName = "Remote Mine"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Drop a mine.
Only one mine can be placed at a time.
<color=green>[SECONDARY FIRE]</color> Detonate mine.]]

SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Primary.Delay = 0.8

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

local ShootSound = Sound("WeaponFrag.Throw")

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetHoldType("slam")
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
	self:EmitSound(ShootSound)

	if CLIENT then return end

	if IsValid(self.Owner.DeployedMine) then
		self.Owner.DeployedMine:Fizzle()
	end

	local nade = ents.Create("ent_remotemine")

	if not IsValid(nade) then return end

	nade:SetOwner(self.Owner)
	nade:SetPos(self.Owner:EyePos())
	nade:SetAngles(self.Owner:EyeAngles())
	nade:Spawn()

	local phys = nade:GetPhysicsObject()
	if not IsValid(phys) then nade:Remove() return end

	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 800
	phys:ApplyForceCenter(velocity)

	self.Owner.DeployedMine = nade
end

function SWEP:CanSecondaryAttack()
	return IsValid(self.Owner.DeployedMine)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.01)

	if IsValid(self.Owner.DeployedMine) then
		self:SendWeaponAnim(ACT_SLAM_THROW_DETONATE)

		self.Owner.DeployedMine:Detonate()
		self.Owner.DeployedMine = nil
	end
end

function SWEP:Reload() end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_SLAM_THROW_ND_DRAW)

	return self.BaseClass.Deploy(self)
end

hook.Add("DoPlayerDeath", "RemoteMine.FizzleOnDeath", function(ply)
	if IsValid(ply.DeployedMine) then
		ply.DeployedMine:Fizzle()
	end
end)

hook.Add("PlayerDisconnected", "RemoteMine.FizzleOnDisconnect", function(ply)
	if IsValid(ply.DeployedMine) then
		ply.DeployedMine:Fizzle()
	end
end)
