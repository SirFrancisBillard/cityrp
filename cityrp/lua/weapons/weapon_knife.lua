AddCSLuaFile()

SWEP.PrintName = "Knife"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Stab someone.
<color=green>[SECONDARY FIRE]</color> Throw a knife.
Thrown knives stick to surfaces.]]

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Primary.Delay = 0.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Secondary.Delay = 0.5

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

local Damage = 30
local SwingDist = 100

local SwingSound = Sound("Weapon_Knife.Slash")
local HitSound = Sound("Weapon_Knife.HitWall")
local StabSound = Sound("Weapon_Knife.Hit")

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetHoldType("knife")
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay) -- not a typo

	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if not IsValid(self.Owner) then return end

	if self.Owner.LagCompensation then -- for some reason not always true
		self.Owner:LagCompensation(true)
	end

	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * 70)

	local tr_main = util.TraceLine({start = spos, endpos = sdest, filter = self.Owner, mask = MASK_SHOT_HULL})
	local hitEnt = tr_main.Entity

	if IsValid(hitEnt) or tr_main.HitWorld then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		if not (CLIENT and (not IsFirstTimePredicted())) then
			local edata = EffectData()
			edata:SetStart(spos)
			edata:SetOrigin(tr_main.HitPos)
			edata:SetNormal(tr_main.Normal)
			edata:SetSurfaceProp(tr_main.SurfaceProps)
			edata:SetHitBox(tr_main.HitBox)
			edata:SetEntity(hitEnt)

			if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
				self:EmitSound(StabSound)
				util.Effect("BloodImpact", edata)
				self.Owner:LagCompensation(false)
				self.Owner:FireBullets({Num = 1, Src = spos, Dir = self.Owner:GetAimVector(), Spread = Vector(0, 0, 0), Tracer = 0, Force = 1, Damage = 0})
			else
				self:EmitSound(HitSound)
				util.Effect("Impact", edata)
			end
		end
	else
		-- miss
		self:EmitSound(SwingSound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end


	if SERVER then
		-- do another trace that sees nodraw stuff like func_button
		local tr_all = nil
		tr_all = util.TraceLine({start = spos, endpos = sdest, filter = self.Owner})

		if hitEnt and hitEnt:IsValid() then
			local dmg = DamageInfo()
			dmg:SetDamage(Damage)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self)
			dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
			dmg:SetDamagePosition(self.Owner:GetPos())
			dmg:SetDamageType(DMG_SLASH)

			hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
		end
	end

	if self.Owner.LagCompensation then
		self.Owner:LagCompensation(false)
	end
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay) -- not a typo
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	self:ShootEffects()
	self:EmitSound(SwingSound)

	if SERVER then
		local knife = ents.Create("ent_thrownknife")

		if not IsValid(knife) then return end

		knife:SetOwner(self.Owner)
		knife:SetPos(self.Owner:EyePos())
		knife:SetAngles(self.Owner:EyeAngles())
		knife:Spawn()

		local phys = knife:GetPhysicsObject()
		if not IsValid(phys) then knife:Remove() return end

		local velocity = self.Owner:GetAimVector()
		velocity = velocity * 1600
		phys:ApplyForceCenter(velocity)
	end
end

function SWEP:Reload() end

function SWEP:Think() end
