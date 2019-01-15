AddCSLuaFile()

SWEP.PrintName = "Burgatron"
SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.Instructions = [[<color=green>[PRIMARY FIRE]</color> Become a burger.
<color=green>[SECONDARY FIRE]</color> Turn back.]]

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.ViewModelFOV = 62
SWEP.WorldModel = ""

local BURGER = "models/food/burger.mdl"

function SWEP:Initialize()
	self.Owner.IsBurger = false
	util.PrecacheModel(BURGER)
end

function SWEP:PrimaryAttack()
	if self.Owner.IsBurger then return end

	self.Owner.IsBurger = true
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)

	if CLIENT then return end

	self.PreviousModel = self.Owner:GetModel()
	self.Owner:SetModel(BURGER)
end

function SWEP:SecondaryAttack()
	if not self.Owner.IsBurger then return end

	self.Owner.IsBurger = false
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)

	if CLIENT then return end

	if self.PreviousModel then
		self.Owner:SetModel(self.PreviousModel)
	end
end

function SWEP:Holster()
	if not self.Owner.IsBurger then return true end

	self.Owner.IsBurger = false

	if CLIENT then return true end

	self.Owner:SetModel(self.PreviousModel)

	return true
end
