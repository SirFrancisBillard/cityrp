AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Monkey Milk"
SWEP.Instructions = [[
<color=green>Sounds... delicious?</color>]]

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/props_junk/garbage_milkcarton002a.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

local TextColor = Color(255, 0, 255)

local function DrawFunc(wep)
	draw.SimpleText("Monkey Milk", "default", "0", "0", TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

SWEP.VElements = {
	["milk"] = { type = "Model", model = "models/props_junk/garbage_milkcarton002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.28, 3.255, -0.369), angle = Angle(0, -67.805, -166.87), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["label"] = { type = "Quad", bone = "ValveBiped.Bip01_R_Hand", rel = "milk", pos = Vector(0.001, -1.428, -0.82), angle = Angle(180, 0, -90), size = 0.05, draw_func = DrawFunc}
}

SWEP.WElements = {
	["milk"] = { type = "Model", model = "models/props_junk/garbage_milkcarton002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.66, 3.621, -0.528), angle = Angle(-14.44, -79.377, -158.803), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["label"] = { type = "Quad", bone = "ValveBiped.Bip01_R_Hand", rel = "milk", pos = Vector(0.001, -1.428, -0.82), angle = Angle(180, 0, -90), size = 0.05, draw_func = DrawFunc}
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

local HealAmt = 10
local SipDelay = 1
local SipSound = Sound("npc/barnacle/barnacle_gulp1.wav")

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + SipDelay)

	if (IsFirstTimePredicted() or game.SinglePlayer()) and IsValid(self.Owner) and self.Owner:IsPlayer() then
		self.Owner:SetHealth(math.Clamp(self.Owner:Health() + HealAmt, 1, self.Owner:GetMaxHealth()))
		self.Owner:ViewPunch(Angle(-10, 0, 0))
		self:EmitSound(SipSound)
		if CLIENT then return end
		local ply = self.Owner
		self:Remove()
		if not ply.Vomit then return end
		timer.Simple(1, function()
			if IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply.Vomit then
				ply:Vomit()
			end
		end)
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end
function SWEP:Think() end
