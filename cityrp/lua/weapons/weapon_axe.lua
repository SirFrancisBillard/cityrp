AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Axe"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Brutally slaughter someone.

Hitting doors can open them.]]

SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(3.888, -1.297, -2.408), angle = Angle(0, 0, 0) },
	["Python"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.211, 32.226, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(9.965, 4.522, 3.088), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(40.321, -5.857, -80.337) }
}

SWEP.VElements = {
	["axe"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.493, 1.682, -5.781), angle = Angle(1.485, -16.361, 90), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["axe"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.302, 1.279, -3.52), angle = Angle(0, -1.17, 87.662), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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

local Damage = 30
local SwingDist = 100

local SwingSound = Sound("Weapon_Crowbar.Single")
local HitSound = Sound("Wood.ImpactHard")
local StabSound = Sound("Weapon_Crowbar.Melee_Hit")

local doors = {
	["prop_door"] = true,
	["prop_door_rotating"] = true,
	["func_door"] = true,
	["func_door_rotating"] = true,
	["func_rotating"] = true,
	["func_movelinear"] = true,
}

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
		-- self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		if not (CLIENT and (not IsFirstTimePredicted())) then
			local edata = EffectData()
			edata:SetStart(spos)
			edata:SetOrigin(tr_main.HitPos)
			edata:SetNormal(tr_main.Normal)
			edata:SetSurfaceProp(tr_main.SurfaceProps)
			edata:SetHitBox(tr_main.HitBox)
			edata:SetEntity(hitEnt)

			if SERVER and doors[hitEnt:GetClass()] and math.random(3) == 3 then
				hitEnt:Fire("unlock")
				hitEnt:Fire("open")
			end

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
		-- self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
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
	killicon.AddFont("weapon_axe", "Trebuchet24", SWEP.PrintName, Color(255, 80, 0, 255))
end
