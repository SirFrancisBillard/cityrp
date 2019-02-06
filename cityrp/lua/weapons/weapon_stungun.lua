AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Stungun"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Electrocute someone.]]

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
	
SWEP.HoldType = "knife"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["stungun"] = { type = "Model", model = "models/alyx_emptool_prop.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.476, 1.129, -2.632), angle = Angle(95.295, -69.621, -34.099), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["stungun"] = { type = "Model", model = "models/alyx_emptool_prop.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.868, 1.289, -2.639), angle = Angle(93.039, -102.579, -0.717), size = Vector(1.664, 1.664, 1.664), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WepSelectIcon = WeaponIconURL("stungun")

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
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay) -- not a typo

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

	if CLIENT and IsFirstTimePredicted() then
		PlaySoundURL("https://sirfrancisbillard.github.io/billard-radio/sound/misc/taser.mp3", self:GetPos())
	end

	--self.Owner:EmitSoundURL("https://sirfrancisbillard.github.io/billard-radio/sound/misc/taser.mp3")

	self.Owner:LagCompensation(true)
	local trace = self.Owner:GetEyeTrace()
	self.Owner:LagCompensation(false)

	local ent = trace.Entity

	if IsValid(ent) and ent:IsPlayer() and ent:GetPos():DistToSqr(self.Owner:GetPos()) < 10000 then
		if CLIENT and IsFirstTimePredicted() then
			ent:EmitSound("hostage/hpain/hpain" .. math.random(6) .. ".wav")
		elseif SERVER then
			ent:SetNWBool("IsPeppered", true)
			ent:SetNWInt("PepperAmount", 5)
			local dmg = DamageInfo()
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self)
			dmg:SetDamageType(DMG_SHOCK)
			dmg:SetDamage(5)
			ent:TakeDamageInfo(dmg)
		end
	end
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end
function SWEP:Think() end

if CLIENT then
	killicon.AddFont("weapon_stungun", "Trebuchet24", SWEP.PrintName, Color(255, 80, 0, 255))
end
