AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Guitar"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Pluck a note.
<color=green>[SECONDARY FIRE]</color> Play a chord.
<color=green>[RELOAD]</color> Strum.]]

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/props_phx/misc/fender.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, -46.406, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-31.952, -38.181, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.232, -45.262, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.254, -43.625, 0) },
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-2.169, 30.893, -28.747) },
	["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.856, -7.889, 11.763) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-9.08, 4.005, -23.31) },
	["ValveBiped.Grenade_body"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(-8.422, 1.779, -1.538), angle = Angle(-0.715, -0.616, 104.676) }
}

SWEP.VElements = {
	["guitar"] = { type = "Model", model = "models/props_phx/misc/fender.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, -2.217, 10.684), angle = Angle(90.869, -54.317, -85.959), size = Vector(0.675, 0.675, 0.675), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["guitar"] = { type = "Model", model = "models/props_phx/misc/fender.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.82, 12.43, -11.855), angle = Angle(66.623, 82.155, 111.039), size = Vector(0.771, 0.771, 0.771), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Primary.Delay = 0.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

local Pluck = Sound("guitar/pluck.wav")
local Chord = Sound("guitar/chord.wav")
local Strum = Sound("guitar/strum.wav")

if SERVER then
	resource.AddFile("sound/" .. Pluck)
	resource.AddFile("sound/" .. Chord)
	resource.AddFile("sound/" .. Strum)
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if (IsFirstTimePredicted() or game.SinglePlayer()) and IsValid(self.Owner) and self.Owner:IsPlayer() then
		self:EmitSound(Pluck, 75, 100 + (self.Owner:EyeAngles().p * -0.2))
	end
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	if (IsFirstTimePredicted() or game.SinglePlayer()) and IsValid(self.Owner) and self.Owner:IsPlayer() then
		self:EmitSound(Chord, 75, 100 + (self.Owner:EyeAngles().p * -0.2))
	end
end

function SWEP:Reload()
	if (IsFirstTimePredicted() or game.SinglePlayer()) and IsValid(self.Owner) and self.Owner:IsPlayer() and not self.ReloadWait then
		self.ReloadWait = true
		self:EmitSound(Strum, 75, 100 + (self.Owner:EyeAngles().p * -0.2))
	end
end

local GuitMinZ = 3
local GuitMaxZ = 10.5

function SWEP:Think()
	if not self.Owner:KeyDown(IN_RELOAD) then
		self.ReloadWait = false
	end

	local complicated = (17.8 - (self.Owner:EyeAngles().p * -0.2)) / 35.6
	self.VElements["guitar"].pos.z = Lerp(complicated, GuitMinZ, GuitMaxZ)
end
