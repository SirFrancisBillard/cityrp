AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.BounceWeaponIcon = false
	SWEP.DrawWeaponInfoBox = false
	SWEP.PrintName = "Knife"
	SWEP.BobScale = 0
	SWEP.SwayScale = 0
	SWEP.ViewbobIntensity = 1
	SWEP.ViewbobEnabled = true

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "knife_desc"
   };

   SWEP.Icon = "vgui/ttt/icon_knife"
end

SWEP.SpeedDec = 0
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.SWBWeapon = true
SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Category = "SUP Weapons"
SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel		= "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"

SWEP.HitSound = Sound("SWB_Knife_Hit")
SWEP.SwingSound = Sound("SWB_Knife_Swing")
SWEP.HitSoundElse = Sound("SWB_Knife_HitElse")

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_KNIFE

SWEP.IsSilent = true

function SWEP:IsEquipment() -- I have no idea what I'm doing, help
	return WEPS.IsEquipment(self)
end

function SWEP:Initialize()
	self:SetHoldType("knife")
end

local vm, CT

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)

	self:SetNextPrimaryFire(CurTime() + 0.7)
	return true
end

function SWEP:Reload()
end

function SWEP:Think()
	if self.DamageTime and CurTime() > self.DamageTime then
		if SERVER then
			self.Owner:LagCompensation(true)
		end

		self:Damage()

		if SERVER then
			self.Owner:LagCompensation(false)
		end

		self.DamageTime = nil
	end
end

function SWEP:PrimaryAttack()
	self.DamageMin = 10
	self.DamageMax = 10

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	CT = CurTime()

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	if IsFirstTimePredicted() then
		self:EmitSound(self.SwingSound, 70, 100)
		self.DamageTime = CT + 0.15
	end

	self.Owner:SetDTFloat(0, 0.5)
	self:SetNextPrimaryFire(CT + 0.55)
	self:SetNextSecondaryFire(CT + 0.55)
end

function SWEP:SecondaryAttack()
	self.DamageMin = 40
	self.DamageMax = 50

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	CT = CurTime()

	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

	if IsFirstTimePredicted() then
		self:EmitSound(self.SwingSound, 70, 100)
		self.DamageTime = CT + 0.15
	end

	self.Owner:SetDTFloat(0, 0.5)
	self:SetNextPrimaryFire(CT + 1)
	self:SetNextSecondaryFire(CT + 1)
end

local td = {}
local tr, ent

function SWEP:Damage()
	td.start = self.Owner:GetShootPos()
	td.endpos = td.start + self.Owner:EyeAngles():Forward() * 50
	td.filter = self.Owner
	td.mins = Vector(-6, -6, -6)
	td.maxs = Vector(6, 6, 6)

	tr = util.TraceHull(td)

	if tr.Hit then
		ent = tr.Entity

		if IsValid(ent) then
			if ent:IsPlayer() or ent:IsNPC() then
				if SERVER then
					ent:TakeDamage(math.random(self.DamageMin, self.DamageMax), self.Owner, self.Owner)
				end

				ParticleEffect("blood_impact_red_01", tr.HitPos, tr.HitNormal:Angle(), ent)
				self:EmitSound(self.HitSound, 80, 100)
			else
				if SERVER then
					ent:TakeDamage(math.random(self.DamageMin, self.DamageMax), self.Owner, self.Owner)

					if ent:GetClass() == "func_breakable_surf" then
						ent:Input("Shatter", NULL, NULL, "")
						self:EmitSound("physics/glass/glass_impact_bullet1.wav", 80, math.random(95, 105))
					end
				end

				self:EmitSound(self.HitSoundElse, 80, 100)
			end
		else
			self:EmitSound(self.HitSoundElse, 80, 100)
		end
	end
end

if CLIENT then
	local wm, pos, ang

	function SWEP:DrawWorldModel()
		self:DrawModel()
	end
end

function SWEP:Holster(wep)
	self:OnRemove()

	return true
end

if CLIENT then
	SWEP.BlendPos = Vector(0, 0, 0)
	SWEP.BlendAng = Vector(0, 0, 0)
	SWEP.OldDelta = Angle(0, 0, 0)
	SWEP.AngleDelta = Angle(0, 0, 0)

	local reg = debug.getregistry()
	local Right = reg.Angle.Right
	local Up = reg.Angle.Up
	local Forward = reg.Angle.Forward
	local RotateAroundAxis = reg.Angle.RotateAroundAxis
	local GetVelocity = reg.Entity.GetVelocity
	local Length = reg.Vector.Length

	local Ang0, curang, curviewbob = Angle(0, 0, 0), Angle(0, 0, 0), Angle(0, 0, 0)
	function SWEP:CalcView(ply, pos, ang, fov)
		FT, CT = FrameTime(), CurTime()

		if self.ViewbobEnabled then
			ws = self.Owner:GetWalkSpeed()
			vel = Length(GetVelocity(self.Owner))

			if self.Owner:OnGround() and vel > ws * 0.3 then
				if vel < ws * 1.2 then
					cos1 = math.cos(CT * 15)
					cos2 = math.cos(CT * 12)
					curviewbob.p = cos1 * 0.15
					curviewbob.y = cos2 * 0.1
				else
					cos1 = math.cos(CT * 20)
					cos2 = math.cos(CT * 15)
					curviewbob.p = cos1 * 0.25
					curviewbob.y = cos2 * 0.15
				end
			else
				curviewbob = LerpAngle(FT * 10, curviewbob, Ang0)
			end
		end

		return pos, ang + curviewbob * self.ViewbobIntensity, fov
	end

	local Vec0 = Vector(0, 0, 0)
	local TargetPos, TargetAng, cos1, sin1, tan, ws, rs, mod, vel, FT, sin2, delta

	local SP = game.SinglePlayer()
	local PosMod, AngMod = Vector(0, 0, 0), Vector(0, 0, 0)
	local CurPosMod, CurAngMod = Vector(0, 0, 0), Vector(0, 0, 0)

	function SWEP:PreDrawViewModel()
		CT = UnPredictedCurTime()
		vm = self.Owner:GetViewModel()

		EA = EyeAngles()
		FT = FrameTime()

		delta = Angle(EA.p, EA.y, 0) - self.OldDelta
		delta.p = math.Clamp(delta.p, -10, 10)

		self.OldDelta = Angle(EA.p, EA.y, 0)
		self.AngleDelta = LerpAngle(math.Clamp(FT * 10, 0, 1), self.AngleDelta, delta)
		self.AngleDelta.y = math.Clamp(self.AngleDelta.y, -10, 10)

		vel = Length(GetVelocity(self.Owner))
		ws = self.Owner:GetWalkSpeed()

		PosMod, AngMod = Vec0 * 1, Vec0 * 1

		if vel < 10 or not self.Owner:OnGround() then
			cos1, sin1 = math.cos(CT), math.sin(CT)
			tan = math.atan(cos1 * sin1, cos1 * sin1)

			AngMod.x = AngMod.x + tan * 1.15
			AngMod.y = AngMod.y + cos1 * 0.4
			AngMod.z = AngMod.z + tan

			PosMod.y = PosMod.y + tan * 0.2
		elseif vel > 10 and vel < ws * 1.2 then
			mod = 6 + ws / 130
			mul = math.Clamp(vel / ws, 0, 1)
			sin1 = math.sin(CT * mod) * mul
			cos1 = math.cos(CT * mod) * mul
			tan1 = math.tan(sin1 * cos1) * mul

			AngMod.x = AngMod.x + tan1
			AngMod.y = AngMod.y - cos1
			AngMod.z = AngMod.z + cos1
			PosMod.x = PosMod.x - sin1 * 0.4
			PosMod.y = PosMod.y + tan1 * 1
			PosMod.z = PosMod.z + tan1 * 0.5
		elseif (vel > ws * 1.2 and self.Owner:KeyDown(IN_SPEED)) or vel > ws * 3 then
			rs = self.Owner:GetRunSpeed()
			mod = 7 + math.Clamp(rs / 100, 0, 6)
			mul = math.Clamp(vel / rs, 0, 1)
			sin1 = math.sin(CT * mod) * mul
			cos1 = math.cos(CT * mod) * mul
			tan1 = math.tan(sin1 * cos1) * mul

			AngMod.x = AngMod.x + tan1 * 0.2
			AngMod.y = AngMod.y - cos1 * 1.5
			AngMod.z = AngMod.z + cos1 * 3
			PosMod.x = PosMod.x - sin1 * 1.2
			PosMod.y = PosMod.y + tan1 * 1.5
			PosMod.z = PosMod.z + tan1
		end

		FT = FrameTime()

		CurPosMod = LerpVector(FT * 10, CurPosMod, PosMod)
		CurAngMod = LerpVector(FT * 10, CurAngMod, AngMod)
	end

	function SWEP:GetViewModelPosition(pos, ang)
		RotateAroundAxis(ang, Right(ang), CurAngMod.x + self.AngleDelta.p)
		RotateAroundAxis(ang, Up(ang), CurAngMod.y + self.AngleDelta.y * 0.3)
		RotateAroundAxis(ang, Forward(ang), CurAngMod.z + self.AngleDelta.y * 0.3)

		pos = pos + (CurPosMod.x + self.AngleDelta.y * 0.1) * Right(ang)
		pos = pos + (CurPosMod.y + self.BlendPos.y) * Forward(ang)
		pos = pos + (CurPosMod.z + self.BlendPos.z - self.AngleDelta.p * 0.1) * Up(ang)

		return pos, ang
	end
end
