AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Blunt"
SWEP.Instructions = [[
<color=green>Thank god for my reefer man... that shit GOOD.</color>]]

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["Detonator"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 0, 0), angle = Angle(0, 0, 0) },
	["Slam_base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(12.626, -8.179, -15.74) }
}

SWEP.DefaultPos = Vector(0, 0, 0)
SWEP.IronSightsPos = Vector(-3.32, -16.121, 1.399)

SWEP.VElements = {
	["blunt"] = { type = "Model", model = "models/props/cs_office/Snowman_nose.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.241, -1.323, 0.398), angle = Angle(5.921, 148.156, -15.768), size = Vector(1.139, 3.674, 1.139), color = Color(233, 233, 243, 255), surpresslightning = false, material = "models/props_c17/paper01", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["blunt"] = { type = "Model", model = "models/props/cs_office/Snowman_nose.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.998, 0.797, -0.373), angle = Angle(0, 127.7, 0), size = Vector(1.139, 3.674, 1.139), color = Color(233, 233, 243, 255), surpresslightning = false, material = "models/props_c17/paper01", skin = 0, bodygroup = {} }
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

SWEP.WepSelectIcon = WeaponIconURL("blunt")

local HealAmt = 5
local SipDelay = 1
local SipSound = Sound("npc/barnacle/barnacle_gulp1.wav")

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.2)
	if SERVER then
		self.Owner:SetHealth(math.min(self.Owner:Health() + 1, self.Owner:GetMaxHealth() * 1.2))
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end

SWEP.ViewModelPos = Vector(0, 0, 0)

function SWEP:PreDrawViewModel()
	local offset_pos = (self.Owner:KeyDown(IN_ATTACK) and self.IronSightsPos or self.DefaultPos)
	if not offset_pos then offset_pos = vector_origin end

	self.ViewModelPos = LerpVector(FrameTime() * 10, self.ViewModelPos, offset_pos)
end

function SWEP:GetViewModelPosition( pos, ang )
	pos = pos + self.ViewModelPos.x * ang:Right()
	pos = pos + self.ViewModelPos.y * ang:Forward()
	pos = pos + self.ViewModelPos.z * ang:Up()

	return pos, ang
end
