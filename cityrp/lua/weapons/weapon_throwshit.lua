AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Throw Shit"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Throw shit.]]

SWEP.Slot = 5
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Spawnable = true	
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["shit"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.724, 2.887, -1.655), angle = Angle(0, 0, 0), size = Vector(0.837, 0.837, 0.837), color = Color(102, 57, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["shit"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.443, 1.988, -1.183), angle = Angle(-16.621, -87.29, 7.149), size = Vector(0.837, 0.837, 0.837), color = Color(102, 57, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WepSelectIcon = WeaponIconURL("shit")

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")

	if SERVER then
		local shit = ents.Create("ent_thrownshit")
		shit:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 20)
		shit:SetOwner(self.Owner)
		shit:Spawn()
		shit:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector() * 1500)

		self:SendWeaponAnim(ACT_VM_DRAW)
	end
end

function SWEP:SecondaryAttack() end
