AddCSLuaFile()

SWEP.PrintName = "Burgatron"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.Instructions = "Left click to be a burger, right click or switch guns to go back!"

SWEP.ViewModel = Model("models/weapons/v_hands.mdl")
SWEP.ViewModelFOV = 62
SWEP.WorldModel = ""

function SWEP:Initialize()
	self.Owner.IsBurger = false
end

function SWEP:PrimaryAttack()
	if self.Owner.IsBurger then return end

	self.Owner.IsBurger = true
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)

	if CLIENT then return end

	self.PreviousModel = self.Owner:GetModel()
	self.Owner:SetModel("models/food/burger.mdl")
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
