AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Bolt Cutters"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Free someone from captivity.]]

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.Spawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

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
	["Slam_panel"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10.994, 42.076, -20.774) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -5.64, 0) },
	["Slam_base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["boltcutters2"] = { type = "Model", model = "models/props_c17/tools_wrench01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5.013, 1.202, 3.486), angle = Angle(-0.03, -87.663, 63.866), size = Vector(1.021, 1.021, 1.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["boltcutters"] = { type = "Model", model = "models/props_c17/tools_wrench01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.858, 2.174, -3.698), angle = Angle(10.222, -96.566, -84.36), size = Vector(1.021, 1.021, 1.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["boltcutters2"] = { type = "Model", model = "models/props_c17/tools_wrench01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "boltcutters", pos = Vector(6.15, -1.721, 0), angle = Angle(180, 37.84, -2.369), size = Vector(1.021, 1.021, 1.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["boltcutters"] = { type = "Model", model = "models/props_c17/tools_wrench01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.085, 2.036, -3.639), angle = Angle(1.225, -92.381, -51.926), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WepSelectIcon = WeaponIconURL("boltcutters")

local function CanFree(us, them, weps)
	if not IsValid(them) or not them:IsPlayer() or them:GetPos():DistToSqr(us:GetPos()) > 10000 then
		return false
	end
	local wep = them:GetActiveWeapon()
	if not IsValid(wep) or not wep.OwnerIsCaptive then
		return false
	end
	return true
end

function SWEP:CanPrimaryAttack()
	return true
end

local BreakFreeSound = Sound("physics/metal/chain_impact_hard1.wav")

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.5)

	self:GetOwner():LagCompensation(true)
	local trace = self:GetOwner():GetEyeTrace()
	self:GetOwner():LagCompensation(false)

	local ent = trace.Entity
	if not CanFree(self.Owner, ent) then return end

	if SERVER then
		local wep = ent:GetActiveWeapon()
		if IsValid(wep) then
			ent:StripWeapon(wep:GetClass())
			self.Owner:EmitSound(BreakFreeSound)
		end
	end
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack() end
function SWEP:Think() end

local red = Color(255, 0, 0)

function SWEP:DrawHUD()
	local tr = self.Owner:GetEyeTrace()
	if CanFree(self.Owner, tr.Entity) then
		local x = ScrW() / 2
		local y = ScrH() / 2

		surface.SetDrawColor(red)

		local outer = 20
		local inner = 10
		surface.DrawLine(x - outer, y - outer, x - inner, y - inner)
		surface.DrawLine(x + outer, y + outer, x + inner, y + inner)

		surface.DrawLine(x - outer, y + outer, x - inner, y + inner)
		surface.DrawLine(x + outer, y - outer, x + inner, y - inner)

		draw.SimpleText("FREE", "TabLarge", x, y - 30, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
end
