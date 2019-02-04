AddCSLuaFile()

SWEP.PrintName = "Tennis Racket"
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Instructions = "<color=green>[PRIMARY FIRE]</color> Hit forehand.\n<color=green>[SECONDARY FIRE]</color> Hit backhand."

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false

SWEP.Spawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local HitSound = "https://sirfrancisbillard.github.io/billard-radio/sound/tennis/hit.mp3"
local MissSound = Sound("Weapon_Crowbar.Single")

SWEP.Delay = 0.5
SWEP.HitForce = 6000

SWEP.WepSelectIcon = WeaponIconURL("tennis")

function SWEP:Initialize()
	self:SetHoldType("slam")
end

function SWEP:Miss()
	self.Owner:EmitSound(MissSound)
end

function SWEP:Hit(ball)
	local phys = ball:GetPhysicsObject()
	if not IsValid(phys) then return end
	local velocity = self.Owner:GetAimVector()
	velocity.z = 0.5
	velocity = velocity * self.HitForce
	phys:ApplyForceCenter(velocity)
	self.Owner:EmitSoundURL(HitSound)
end

function SWEP:Swing(primary)
	self:SetNextPrimaryFire(CurTime() + self.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Delay)
	local anim = "tennis_forehand"
	if not primary then
		anim = "tennis_backhand"
	end
	self.Owner:SetLuaAnimation(anim)

	local found = ents.FindInSphere(self.Owner:GetShootPos(), 150)
	if #found < 1 then
		self:Miss()
		return
	end
	local ball = false
	for k, v in pairs(found) do
		if v.IsTennisBall then
			ball = v
			break
		end
	end
	if not ball then
		self:Miss()
		return
	end

	return self:Hit(ball)
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	self:Swing(true)
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	self:Swing(false)
end
