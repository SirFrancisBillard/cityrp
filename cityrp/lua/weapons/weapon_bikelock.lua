AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Bike Lock"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Brutally slaughter someone.]]

SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["tube"] = { type = "Model", model = "models/props_wasteland/horizontalcoolingtank04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "arch", pos = Vector(0, 0, 0), angle = Angle(0, -91.488, -180), size = Vector(0.039, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalfloor_2-3", skin = 0, bodygroup = {} },
	["arch"] = { type = "Model", model = "models/props/de_train/tunnelarch.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.616, -0.142, -3.945), angle = Angle(7.267, -75.945, 32.497), size = Vector(0.032, 0.032, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/side", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["tube"] = { type = "Model", model = "models/props_wasteland/horizontalcoolingtank04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "arch", pos = Vector(0, 0, 0), angle = Angle(0, -91.488, -180), size = Vector(0.039, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/metalfloor_2-3", skin = 0, bodygroup = {} },
	["arch"] = { type = "Model", model = "models/props/de_train/tunnelarch.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.463, 0.214, -1.606), angle = Angle(0, -79.925, 65.258), size = Vector(0.032, 0.032, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/side", skin = 0, bodygroup = {} }
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

SWEP.Secondary.Delay = 0.5

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.WepSelectIcon = WeaponIconURL("bikelock")

local Damage = 30
local SwingDist = 100

local SwingSound = Sound("Weapon_Crowbar.Single")
local HitSound = Sound("MetalVent.ImpactHard")
local StabSound = Sound("Weapon_Crowbar.Melee_Hit")

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay) -- not a typo

	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if not IsValid(self.Owner) then return end

	if self.Owner.LagCompensation then -- for some reason not always true
		self.Owner:LagCompensation(true)
	end

	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * 70)

	local tr_main = util.TraceLine({start = spos, endpos = sdest, filter = self.Owner, mask = MASK_SHOT_HULL})
	local hitEnt = tr_main.Entity

	-- hit or miss
	-- i guess they nev- *dies*
	if IsValid(hitEnt) or tr_main.HitWorld then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		if not (CLIENT and (not IsFirstTimePredicted())) then
			local edata = EffectData()
			edata:SetStart(spos)
			edata:SetOrigin(tr_main.HitPos)
			edata:SetNormal(tr_main.Normal)
			edata:SetSurfaceProp(tr_main.SurfaceProps)
			edata:SetHitBox(tr_main.HitBox)
			edata:SetEntity(hitEnt)

			if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
				self:EmitSound(StabSound)
				util.Effect("BloodImpact", edata)
				self.Owner:LagCompensation(false)
				self.Owner:FireBullets({Num = 1, Src = spos, Dir = self.Owner:GetAimVector(), Spread = Vector(0, 0, 0), Tracer = 0, Force = 1, Damage = 0})
			else
				self:EmitSound(HitSound)
				util.Effect("Impact", edata)
			end
		end
	else
		-- miss
		self:EmitSound(SwingSound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end

	if SERVER then
		-- do another trace that sees nodraw stuff like func_button
		local tr_all = nil
		tr_all = util.TraceLine({start = spos, endpos = sdest, filter = self.Owner})

		if hitEnt and hitEnt:IsValid() then
			local dmg = DamageInfo()
			dmg:SetDamage(Damage)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self)
			dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
			dmg:SetDamagePosition(self.Owner:GetPos())
			dmg:SetDamageType(DMG_SLASH)

			hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
		end
	end

	if self.Owner.LagCompensation then
		self.Owner:LagCompensation(false)
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end
function SWEP:Think() end

if CLIENT then
	killicon.AddFont("weapon_bikelock", "Trebuchet24", SWEP.PrintName, Color(255, 80, 0, 255))
end
