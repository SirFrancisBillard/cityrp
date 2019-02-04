AddCSLuaFile()

game.AddAmmoType({name = "bandages"})
if CLIENT then
	language.Add("bandages_ammo", "Bandages")
end

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Bandages"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Use on yourself.
<color=green>[SECONDARY FIRE]</color> Use on someone else.

Bandages stop bleeding and restore health.]]

SWEP.Spawnable = true
SWEP.Slot = 3
SWEP.SlotPos = 100

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "bandages"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = {scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
}

SWEP.VElements = {
	["bandage"] = {type = "Model", model = "models/props/cs_office/Paper_towels.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.43, 4.143, 0), angle = Angle(-95.865, 7.394, -18.122), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["bandage"] = {type = "Model", model = "models/props/cs_office/Paper_towels.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.012, 2.647, -2.123), angle = Angle(-69.766, 5.291, 9.59), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WepSelectIcon = WeaponIconURL("bandages")

local function IsGood(ent)
	return IsValid(ent) and IsValid(ent.Owner) and ent.Owner:IsPlayer() and ent.Owner:Alive() and IsValid(ent.Owner:GetActiveWeapon()) and ent.Owner:GetActiveWeapon():GetClass() == ent.ClassName
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetHoldType(self.HoldType)
	return self.BaseClass.Deploy(self)
end

function SWEP:CanPrimaryAttack()
	return IsGood(self) and self.Owner:Health() < self.Owner:GetMaxHealth()
end

function SWEP:PrimaryAttack()
	if CLIENT or not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + 0.8)
	self:SetNextSecondaryFire(CurTime() + 0.8)
	self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
	timer.Simple(0.3, function()
		if not IsGood(self) then return end
		self.Owner:SetHealth(math.min(self.Owner:Health() + 5, self.Owner:GetMaxHealth()))

		self.Owner:RemoveAmmo(1, self.Primary.Ammo)
		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self:SendWeaponAnim(ACT_VM_DRAW)
		else
			self.Owner:ConCommand("lastinv")
			self.Owner:StripWeapon(self.ClassName)
		end
	end)
end

function SWEP:CanSecondaryAttack()
	self.Owner:LagCompensation(true)
	local tr = self.Owner:GetEyeTrace()
	self.Owner:LagCompensation(false)
	if IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:Health() < tr.Entity:GetMaxHealth() and tr.Entity:GetShootPos():DistToSqr(self.Owner:GetShootPos()) < 62500 then
		return true, tr.Entity
	end
	return false, NULL
end

function SWEP:SecondaryAttack()
	local can, ply = self:CanSecondaryAttack()
	if CLIENT or not can then return end
	self:SetNextPrimaryFire(CurTime() + 0.8)
	self:SetNextSecondaryFire(CurTime() + 0.8)
	self:SendWeaponAnim(ACT_VM_THROW)
	timer.Simple(0.3, function()
		if not IsGood(self) or not IsValid(ply) or not ply:IsPlayer() or not (self.Owner:GetShootPos():DistToSqr(ply:GetShootPos()) < 62500) then return end
		ply:SetHealth(math.min(ply:Health() + 5, ply:GetMaxHealth()))

		self.Owner:RemoveAmmo(1, self.Primary.Ammo)
		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self:SendWeaponAnim(ACT_VM_DRAW)
		else
			self.Owner:ConCommand("lastinv")
			self.Owner:StripWeapon(self.ClassName)
		end
	end)
end
