AddCSLuaFile()

game.AddAmmoType({name = "flamethrowergas"})
if CLIENT then
	language.Add("flamethrowergas_ammo", "Flamethrower Juice")
end

SWEP.PrintName = "Flamethrower"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Portably toast.]]

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "flamethrowergas"

SWEP.Primary.Delay = 0.1

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

local ShootLoop = Sound("ambient/fire/fire_med_loop1.wav")
local DeploySound = Sound("ambient/fire/gascan_ignite1.wav")

function SWEP:Deploy()
	self:EmitSound(DeploySound)
	if SERVER then
		self.FiringSound = CreateSound(self.Owner, ShootLoop)
	end
	return self.BaseClass.Deploy(self)
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetHoldType("ar2")
end

function SWEP:CanPrimaryAttack()
	return self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 and not self.reloading
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		local nade = ents.Create("ent_thrownflame")

		if not IsValid(nade) then return end

		nade:SetOwner(self.Owner)
		nade:SetPos(self.Owner:EyePos())
		nade:SetAngles(self.Owner:EyeAngles())
		nade:Spawn()

		local phys = nade:GetPhysicsObject()
		if not IsValid(phys) then nade:Remove() return end

		local velocity = self.Owner:GetAimVector()
		velocity = velocity * 1000
		phys:ApplyForceCenter(velocity)
	end

	if self.Owner:GetAmmoCount(self.Primary.Ammo) > self.Primary.DefaultClip then
		self.Owner:SetAmmo(self.Primary.DefaultClip, self.Primary.Ammo)
	end

	self.Owner:RemoveAmmo(1, self.Primary.Ammo)

	if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
		self.needs_reload = true
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	if not IsFirstTimePredicted() or self.Owner:GetAmmoCount(self.Primary.Ammo) >= self.Primary.DefaultClip or self.reloading then return end

	self:SendWeaponAnim(ACT_VM_RELOAD)
	self.Owner:SetAnimation(PLAYER_RELOAD)

	self.reload_timer = CurTime() + self:SequenceDuration()
	self.reloading = true
end

function SWEP:Think()
	if self.needs_reload then
		self.needs_reload = false
		self:Reload()
	end

	if self.reloading and self.reload_timer <= CurTime() then
		self.reloading = false
		self.reload_timer = 0

		self.Owner:SetAmmo(self.Primary.DefaultClip, self.Primary.Ammo)
	end

	if SERVER then
		if self.Owner:KeyDown(IN_ATTACK) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			if not self.FiringSound:IsPlaying() then
				self.FiringSound:Play()
			end
		else
			self.FiringSound:Stop()
		end
	end
end

function SWEP:Holster()
	if SERVER then
		self.FiringSound:Stop()
	end
	return true
end

function SWEP:OnRemove()
	if SERVER then
		self.FiringSound:Stop()
	end
end

