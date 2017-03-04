AddCSLuaFile()

SWEP.PrintName = "Molotov Cocktail"
SWEP.Instructions = "Primary fire to dispense Soviet hospitality."
SWEP.Purpose = "Revolution"
SWEP.Author = "Vyacheslav Mikhailovich Molotov"

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Spawnable = true	
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

-- TODO: Better VM, maybe SCK?
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Lit")
	self:NetworkVar("Bool", 1, "ThrowWhenReady")
	self:NetworkVar("Bool", 2, "Supress")
	self:NetworkVar("Int", 0, "ThrowTime")
end

function SWEP:Initialize()
	self:SetWeaponHoldType("grenade")

	self:SetLit(false)
	self:SetThrowWhenReady(false)
	self:SetThrowTime(0)
end

function SWEP:ThrowPrimed()
	return self:GetThrowTime() ~= 0 and CurTime() >= self:GetThrowTime()
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DEPLOY)
end

function SWEP:Holster()
	return not self:GetThrowWhenReady()
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
end

function SWEP:Think()
	if self:GetThrowWhenReady() and self:ThrowPrimed() then
		self:Throw()
	elseif self:ThrowPrimed() and not self.DontEmitPrimedSound then
		-- self:EmitSound("molotov prime sound")
		self.DontEmitPrimedSound = true
	end

	self:NextThink(CurTime() + 0.1)
	return true
end

function SWEP:Light()
	if self:GetLit() then return end

	self:SendWeaponAnim(ACT_VM_PULLPIN)

	self:SetLit(true)
	self:SetThrowTime(CurTime() + 1)
end

function SWEP:Throw()
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	self:EmitSound("npc/vort/claw_swing".. math.random(1, 2).. ".wav")
	self:SendWeaponAnim(ACT_VM_THROW)

	if SERVER then
		local molly = ents.Create("ent_molotov")
		molly:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 20)
		molly:Spawn()
		Molotov:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector() * 1500)

		self.Owner:ConCommand("lastinv")
		self.Owner:StripWeapon(self.ClassName)
	end
end
