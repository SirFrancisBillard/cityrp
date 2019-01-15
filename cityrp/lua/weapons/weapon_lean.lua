AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Lean"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Grip and sip that shit homie.]]

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = ""
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-13.275, -3.847, 32.747) }
}

SWEP.VElements = {
	["juice"] = { type = "Model", model = "models/props_phx/construct/plastic/plastic_angle_360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.888, 2.559, -3.166), angle = Angle(0, 0, 0), size = Vector(0.034, 0.034, 0.034), color = Color(130, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["cup"] = { type = "Model", model = "models/props_junk/terracotta01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.051, 2.542, 1.039), angle = Angle(0, 0, 180), size = Vector(0.2, 0.2, 0.344), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["juice"] = { type = "Model", model = "models/props_phx/construct/plastic/plastic_angle_360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.247, 2.033, -3.626), angle = Angle(-0.294, -4.694, 29.368), size = Vector(0.034, 0.034, 0.034), color = Color(130, 0, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["cup"] = { type = "Model", model = "models/props_junk/terracotta01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.505, 4.094, -0.105), angle = Angle(0, 0, -150.223), size = Vector(0.2, 0.2, 0.344), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

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

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

local HealAmt = 5
local SipDelay = 1
local SipSound = Sound("npc/barnacle/barnacle_gulp1.wav")

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + SipDelay)

	if (IsFirstTimePredicted() or game.SinglePlayer()) and IsValid(self.Owner) and self.Owner:IsPlayer() then
		self.Owner:SetHealth(math.Clamp(self.Owner:Health() + HealAmt, 1, self.Owner:GetMaxHealth()))
		self.Owner:ViewPunch(Angle(-40, 0, 0))
		self:EmitSound(SipSound)
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end
function SWEP:Think() end

if SERVER then return end

function SWEP:Think()
	self.VElements["juice"].color.r = 130 + (math.sin(CurTime() * 2) * 30)
end
