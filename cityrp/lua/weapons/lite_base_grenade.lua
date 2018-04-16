AddCSLuaFile()

SWEP.PrintName = "Base Grenade"
SWEP.Category = "Lite Weapons"
SWEP.DrawWeaponInfoBox = false
SWEP.IconLetter = "O"

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.HoldType = "grenade"

SWEP.WorldModel = Model( "models/weapons/w_eq_fraggrenade.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_eq_fraggrenade.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.Primary.Ammo = "grenade"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.GrenadeEntity = "ent_lite_base_grenade"
SWEP.ThrowForce = 1024

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "NextIdle" )
	self:NetworkVar( "Float", 1, "ThrowTime" )
end

function SWEP:QueueIdle()
	self:SetNextIdle( CurTime() + self.Owner:GetViewModel():SequenceDuration() + 0.1 )
end

function SWEP:IdleThink()
	if self:GetNextIdle() == 0 then return end

	if CurTime() > self:GetNextIdle() then
		self:SetNextIdle( 0 )
		self:SendWeaponAnim( ACT_VM_DRAW )
	end
end

function SWEP:PullPin()
	self:SendWeaponAnim( ACT_VM_PULLPIN )
	self:SetThrowTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
end

function SWEP:ThrowGrenade()
	self:TakePrimaryAmmo( 1 )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_THROW )

	self:SetThrowTime( 0 )
	self:QueueIdle()

	if CLIENT then return end

	timer.Simple( 0.4, function()
		if not IsValid( self ) or not IsValid( self.Owner ) then return end

		local ent = ents.Create( self.GrenadeEntity )
		ent:SetOwner( self.Owner )
		ent:SetPos( self.Owner:EyePos() + self.Owner:GetAimVector() * 16 )
		ent:SetAngles( AngleRand() )
		ent:Spawn()

		local phys = ent:GetPhysicsObject() 
		if IsValid( phys ) then
			phys:SetVelocity( self.Owner:GetAimVector() * self.ThrowForce )
			phys:AddAngleVelocity( VectorRand() * 1000 )
		end
	end )
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	if self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() ) <= 0 or
		self:GetThrowTime() ~= 0 then return end

	self:PullPin()
	self:SetNextPrimaryFire( CurTime() + 2.5 )
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	self:SetThrowTime( 0 )
	return true
end

function SWEP:GrenadeThink()
	if self:GetThrowTime() == 0 or CurTime() < self:GetThrowTime() 
		or self.Owner:KeyDown( IN_ATTACK ) then return end

	self:ThrowGrenade()
end

function SWEP:Think()
	self:IdleThink()
	self:GrenadeThink()
end

function SWEP:DrawWeaponSelection( x, y, w, h, a )
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + w / 2, y + h * 0.65,
		Color( 255, 210, 0, a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end