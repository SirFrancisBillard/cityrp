AddCSLuaFile()

SWEP.PrintName = "Handcuffed"
SWEP.Instructions = [[<color=red>You are handcuffed. You can be broken out with boltcutters.</color>]]
SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Spawnable = false	
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ziptied"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.UseHands = true

SWEP.OwnerIsCaptive = true

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Holster()
	if CLIENT and IsFirstTimePredicted() then
		chat.AddText(Color(255, 0, 0), "You are handcuffed!")
	end
	return false
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end
