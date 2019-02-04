AddCSLuaFile()

-- fucking yikes

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Self Harm"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Cut yourself.]]

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

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.HoldType = "passive"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.974, -16.903, -5.329) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(-3.451, 2.802, 2.588), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(-5.742, -4.631, -1.297), angle = Angle(17.184, 26.486, -145.096) }
}

SWEP.VElements = {
	["blood"] = { type = "Model", model = "models/props_c17/FurnitureDrawer001a_Shard01.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(10.333, -0.528, -0.681), angle = Angle(35.247, -26.342, -61.002), size = Vector(0.123, 0.123, 0.123), color = Color(147, 0, 0, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["knife"] = { type = "Model", model = "models/weapons/w_knife_t.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.662, -0.353, 1.792), angle = Angle(44.234, -24.695, -180), size = Vector(0.924, 0.924, 0.924), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WepSelectIcon = WeaponIconURL("cutter")

local Damage = 10
local CutSound = Sound("Weapon_Knife.Hit")
local PainSounds = {
	Sound("vo/npc/female01/pain01.wav"),
	Sound("vo/npc/female01/pain02.wav"),
	Sound("vo/npc/female01/pain03.wav"),
	Sound("vo/npc/female01/pain04.wav"),
	Sound("vo/npc/female01/pain05.wav"),
	Sound("vo/npc/female01/pain06.wav"),
	Sound("vo/npc/female01/pain07.wav"),
	Sound("vo/npc/female01/pain08.wav"),
	Sound("vo/npc/female01/pain09.wav"),
	Sound("vo/npc/female01/myarm01.wav"),
	Sound("vo/npc/female01/myarm02.wav"),
}
local MoanSounds = {
	Sound("vo/npc/female01/moan01.wav"),
	Sound("vo/npc/female01/moan02.wav"),
	Sound("vo/npc/female01/moan03.wav"),
	Sound("vo/npc/female01/moan04.wav"),
	Sound("vo/npc/female01/moan05.wav"),
}
local MinPitch = 115
local MaxPitch = 120

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetHoldType(self.HoldType)

	if CLIENT then
		self.NextMoan = 0
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	if SERVER then
		self.Owner:EmitSound(CutSound)
		self.Owner:EmitSound(PainSounds[math.random(#PainSounds)], 75, math.random(MinPitch, MaxPitch))

		local newhealth = self.Owner:Health() - Damage
		if newhealth > 0 then
			self.Owner:SetHealth(newhealth)
			self.Owner:ViewPunch(Angle(math.random(-40, 40), math.random(-40, 40), 0))
		else
			self.Owner:Kill()
		end
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end

if CLIENT then
	killicon.AddFont("weapon_cutter", "Trebuchet24", "Self Harm", Color(255, 80, 0, 255))

	function SWEP:Think()
		if not LocalPlayer() == self.Owner or CurTime() < self.NextMoan then return end
		self.Owner:EmitSound(MoanSounds[math.random(#MoanSounds)], 100, math.random(MinPitch, MaxPitch))
		self.NextMoan = CurTime() + math.random(3, 6)
		return true
	end
end
