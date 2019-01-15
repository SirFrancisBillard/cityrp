AddCSLuaFile()

-- TODO: Add axe model with SCK
SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Fire Axe"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.Spawnable = true

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Break down a door or prop.]]

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.UseHands = true

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)

	local trace = self.Owner:GetEyeTrace()

	if not IsValid(trace.Entity) then return end
	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 then return end

	self:SetHoldType("pistol")

	if CLIENT then return end

	if not trace.Entity:IsDoor() then return end

	trace.Entity:UnLock()

	self:EmitSound(self.Sound)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:Think()
end

function SWEP:DrawHUD()
end