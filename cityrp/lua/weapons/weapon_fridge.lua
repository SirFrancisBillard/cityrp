AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Refridgerator"
SWEP.Instructions = [[
You're just carrying a fridge...]]

SWEP.HoldType = "duel"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/props_c17/FurnitureFridge001a.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["v_weapon.elite_right"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-0.03, 0.029, -8.039), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 6.763), angle = Angle(0, 0, 0) },
	["v_weapon.elite_left"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["fridge"] = { type = "Model", model = "models/props_c17/FurnitureFridge001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-2.083, -14.818, -0.073), angle = Angle(0.72, 66.535, 90), size = Vector(0.625, 0.625, 0.625), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["fridge"] = { type = "Model", model = "models/props_c17/FurnitureFridge001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.124, 11.338, 0), angle = Angle(0, -6.191, -174.086), size = Vector(0.779, 0.779, 0.779), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end
function SWEP:Think() end
