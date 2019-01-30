AddCSLuaFile()

SWEP.PrintName = "Jihad Bomb"
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Explode almost instantly.

Martyrdom, death in holy war, is glorious. Allah will secure you as a citizen of eternal paradise.

<color=red>Allahu akbar.</color>]]

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false

SWEP.Spawnable = true
SWEP.Category = "Explosives"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "slam"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	util.PrecacheModel("models/Humans/Charple01.mdl")
	util.PrecacheModel("models/Humans/Charple02.mdl")
	util.PrecacheModel("models/Humans/Charple03.mdl")
	util.PrecacheModel("models/Humans/Charple04.mdl")
end

function SWEP:CanPrimaryAttack() return true end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 2)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if SERVER then
		self.Owner:SuicideBombDelayed(1, 400 * 6, 300)
	end
end

function SWEP:CanSecondaryAttack() return false end
function SWEP:SecondaryAttack() end

if CLIENT then
	killicon.AddFont("weapon_jihad", "Trebuchet24", "JIHAD", Color(255, 80, 0, 255))
end
