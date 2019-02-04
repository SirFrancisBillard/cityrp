AddCSLuaFile()

game.AddAmmoType({name = "glgrenades"})
if CLIENT then
	language.Add("glgrenades_ammo", "Pipebombs")
end

SWEP.PrintName = "Grenade Launcher"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Launch a grenade.
Grenades will explode shortly after impact with surfaces.
Grenades deal more damage on direct hits.]]

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "glgrenades"

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

SWEP.WepSelectIcon = WeaponIconURL("grenadelauncher")

local ShootSound = Sound("weapons/grenade_launcher1.wav")

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

	self:ShootEffects()
	self:EmitSound(ShootSound)

	if SERVER then
		local nade = ents.Create("ent_launchedgrenade")

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
end
