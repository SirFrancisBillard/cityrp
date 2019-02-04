AddCSLuaFile()

game.AddAmmoType({name = "molotov"})
if CLIENT then
	language.Add("molotov_ammo", "Molotov Cocktails")
end

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Molotov Cocktail"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Dispense Soviet hospitality.
<color=green>[SECONDARY FIRE]</color> Light without throwing.]]

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Spawnable = true	
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "molotov"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
}

SWEP.VElements = {
	["bottle"] = {type = "Model", model = "models/props_junk/GlassBottle01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.361, 2.709, -2.474), angle = Angle(-9.539, -84.175, 180), size = Vector(1.011, 1.011, 1.011), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["bottle"] = {type = "Model", model = "models/props_junk/GlassBottle01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.748, 1.988, -2.597), angle = Angle(-174.698, 67.234, -2.013), size = Vector(0.912, 1.029, 0.953), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WepSelectIcon = WeaponIconURL("molotov")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Lit")
	self:NetworkVar("Bool", 1, "ThrowWhenReady")
	self:NetworkVar("Int", 0, "ThrowTime")
end

function SWEP:ResetVars()
	self:SetLit(false)
	self:SetThrowWhenReady(false)
	self:SetThrowTime(0)

	self.EmitIgniteSound = 0
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetWeaponHoldType("grenade")

	self:ResetVars()
end

function SWEP:ThrowPrimed()
	return self:GetThrowTime() ~= 0 and CurTime() >= self:GetThrowTime()
end

function SWEP:Holster()
	local holst = self.BaseClass.Holster(self)
	if holst then
		self:ResetVars()
	end
	return holst 
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)

	if self:GetLit() and self:ThrowPrimed() then
		self:Throw()
	else
		self:Light()
		self:SetThrowWhenReady(true)
	end
end

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)

	if not self:GetLit() and not self:ThrowPrimed() then
		self:Light()
	end
end

function SWEP:Think()
	if self:GetThrowWhenReady() and self:ThrowPrimed() then
		self:Throw()
	end

	if self.EmitIgniteSound ~= 0 and self.EmitIgniteSound <= CurTime() then
		self:EmitSound("ambient/fire/mtov_flame2.wav")
		self.EmitIgniteSound = 0
	end

	self:NextThink(CurTime() + 0.1)
	return true
end

function SWEP:Light()
	if self:GetLit() then return end

	self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)

	self.EmitIgniteSound = CurTime() + 0.6

	self:SetLit(true)
	self:SetThrowTime(CurTime() + 2)
end

function SWEP:Throw()
	self:ResetVars()

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")

	if SERVER then
		local molly = ents.Create("ent_molotov")
		molly:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 20)
		molly:SetOwner(self.Owner)
		molly:Spawn()
		molly:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector() * 1500)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo)
		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self:SendWeaponAnim(ACT_VM_DRAW)
		else
			self.Owner:ConCommand("lastinv")
			self.Owner:StripWeapon(self.ClassName)
		end
	end
end
