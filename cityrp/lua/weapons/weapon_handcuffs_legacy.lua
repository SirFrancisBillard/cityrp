AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Handcuffs"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Restrain/release a criminal.
Only one person can be cuffed at once.]]

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = ""
SWEP.WorldModel = ""

if CLIENT then
	function SWEP:GetViewModelPosition (Pos, Ang)
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Pos = Pos + Ang:Forward() * 6
		Pos = Pos + Ang:Right() * 2

		return Pos, Ang
	end 
end

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if self.Owner.isCP and not self.Owner:isCP() then self:Remove() return end

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)

	self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")

	if CLIENT then return false end

	local trace = self.Owner:GetEyeTrace()
	if self.Owner:EyePos():Distance(trace.HitPos) > 75 then return false end
	if not trace.Entity or not trace.Entity:IsValid() or not trace.Entity:IsPlayer() then return false end
	if trace.Entity.isCP and trace.Entity.isCP() then self.Owner:ChatPrint("You cannot detain government employees.") return false end

	if trace.Entity.IsHandcuffed then
		trace.Entity.IsHandcuffed = false
		self.Owner:ChatPrint("You have released " .. trace.Entity:Nick() .. ".")
		trace.Entity:ChatPrint("You have been released.")

		return
	end

	trace.Entity.IsHandcuffed = true
	self.Owner:ChatPrint("You have restrained " .. trace.Entity:Nick() .. ".")
	trace.Entity:ChatPrint("You have been restrained. You can be broken out with boltcutters.")
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end