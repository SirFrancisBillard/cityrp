AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Protest Sign"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Not-so-peaceful protesting.
<color=green>[RELOAD]</color> Change sign text.]]

SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(13.947, -61.917, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-14.31, -99.358, 0) },
	["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 34.182, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 29.488, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.746, 0) },
	["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(21.524, -55.834, 0) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -31.257, 0) },
	["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(18.767, 10.421, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-12.945, 22.496, 74.3) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10.378, -9.263, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 21.622, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(2.493, -2.142, -2.395), angle = Angle(0, 0, -153.204) }
}

local TextColor = Color(255, 0, 255)

local function DrawFunc(wep)
	draw.SimpleText("Yay!\nProtesting!", "default", "0", "0", TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

SWEP.VElements = {
	["sign"] = { type = "Model", model = "models/props_lab/bewaredog.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.516, 1.215, 3.226), angle = Angle(0, 0, 180), size = Vector(0.365, 0.365, 0.365), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["label"] = { type = "Quad", bone = "ValveBiped.Bip01_R_Hand", rel = "sign", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = 10, draw_func = nil},
	["sign"] = { type = "Model", model = "models/props_lab/bewaredog.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.934, 2.755, 6.776), angle = Angle(0, 0, -167.144), size = Vector(0.864, 0.864, 0.864), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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

local Damage = 30
local SwingDist = 100

local SwingSound = Sound("Weapon_Crowbar.Single")
local HitSound = Sound("Wood.ImpactHard")
local StabSound = Sound("Wood.ImpactHard")

if CLIENT then
	function SWEP:Initialize()
		self.BaseClass.Initialize(self)

		self.CanSetText = true
	end
end

function SWEP:Reload()
	if (CLIENT or game.SinglePlayer()) and IsFirstTimePredicted() and self.CanSetText then
		self.CanSetText = false
		local frame = Derma_StringRequest("Protest Sign", "What cause are you going to support today?", "Burn a book, save a tree!", function(text)
			if IsValid(self) then
				SendProtestText(text)
				self.CanSetText = true
			end
		end,
		function()
			if IsValid(self) then
				self.CanSetText = true
			end
		end)
		frame:SetSkin("DarkRP")
	end
end

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

function SWEP:CanSecondaryAttack() return false end
function SWEP:SecondaryAttack() end
function SWEP:Think() end
