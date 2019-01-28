AddCSLuaFile()

if SERVER then
	resource.AddFile("sound/handcuff.wav")
end

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Handcuffs"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Detain a criminal.]]

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.Spawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

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

SWEP.HandcuffSWEP = "weapon_handcuffed"

local function CanCuff(us, them, wep)
	if not IsValid(them) or not them:IsPlayer() or them:GetPos():DistToSqr(us:GetPos()) > 10000 or them:HasWeapon(wep) then
		return false
	end
	if (isfunction(us.isCP) and not us:isCP()) or (isfunction(them.isCP) and them:isCP()) then
		return false
	end
	return true
end

function SWEP:CanPrimaryAttack()
	return true
end

local CuffSound = Sound("handcuff.wav")

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.5)

	self:GetOwner():LagCompensation(true)
	local trace = self:GetOwner():GetEyeTrace()
	self:GetOwner():LagCompensation(false)

	local ent = trace.Entity
	if not CanCuff(self.Owner, ent, self.HandcuffSWEP) then return end

	if SERVER then
		ent:Give(self.HandcuffSWEP)
		ent:SelectWeapon(self.HandcuffSWEP)
		self.Owner:EmitSound(CuffSound)
	end
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack() end
function SWEP:Think() end

if SERVER then
	hook.Add("PlayerUse", "UnhandcuffPlayer", function( ply, ent )
		if not IsValid( ent ) or not ent:IsVehicle() then return end

		if ( ply:GetEyeTrace().HitGroup == 5 ) then
			return false
		end
	end)
	return
end

local blue = Color(0, 0, 255)

function SWEP:DrawHUD()
	local tr = self.Owner:GetEyeTrace()
	if CanCuff(self.Owner, tr.Entity, self.HandcuffSWEP) then
		local x = ScrW() / 2
		local y = ScrH() / 2

		surface.SetDrawColor(blue)

		local outer = 20
		local inner = 10
		surface.DrawLine(x - outer, y - outer, x - inner, y - inner)
		surface.DrawLine(x + outer, y + outer, x + inner, y + inner)

		surface.DrawLine(x - outer, y + outer, x - inner, y + inner)
		surface.DrawLine(x + outer, y - outer, x + inner, y - inner)

		draw.SimpleText("CUFF", "TabLarge", x, y - 30, blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
end
