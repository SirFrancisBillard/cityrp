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

SWEP.HoldType = "normal"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = ""
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
}

SWEP.VElements = {
	["ties"] = {type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.844, 2.755, 0.797), angle = Angle(-97.581, -61.209, 56.716), size = Vector(0.912, 1.029, 0.953), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["ties"] = {type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.151, 1.075, -2.597), angle = Angle(106.364, 66.593, -1.293), size = Vector(0.912, 1.029, 0.953), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

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
