AddCSLuaFile()

SWEP.Base = "lite_base"

SWEP.PrintName = "Lite Weapon Base Shotgun"
SWEP.Category = "Lite Weapons"
SWEP.DrawWeaponInfoBox = false

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model( "models/weapons/w_shot_m3super90.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_shot_m3super90.mdl" )
SWEP.ViewModelFOV = 55
SWEP.UseHands = true

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Primary.Sound = Sound( "Weapon_M3.Single" )
SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 8
SWEP.Primary.Cone = 0.07
SWEP.Primary.Delay = 0.9

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.5
SWEP.Spread.IronsightsMod = 0.1
SWEP.Spread.CrouchMod = 0.6
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0.025
SWEP.Spread.VelocityMod = 0.5

SWEP.IronsightsPos = Vector( -7.65, -5, 2.8 )
SWEP.IronsightsAng = Angle( 1, 0, 0 )
SWEP.IronsightsFOV = 0.8

SWEP.LoweredPos = Vector( 1.6397, -5.089, 4 )
SWEP.LoweredAng = Angle( -17.2767, 28.3565, -0.4145 )

function SWEP:Reload()
	if not self:CanReload() then return end

	self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
	self.Owner:DoReloadEvent()
	self:QueueIdle()

	self:SetReloading( true )
	self:SetReloadTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
end

function SWEP:InsertShell()
	self:SetClip1( self:Clip1() + 1 )
	self.Owner:RemoveAmmo( 1, self:GetPrimaryAmmoType() )

	self:SendWeaponAnim( ACT_VM_RELOAD )
	self:QueueIdle()

	self:SetReloadTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
end

function SWEP:ReloadThink()
	if self:GetReloadTime() > CurTime() then return end

	if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() ) > 0
		and not self.Owner:KeyDown( IN_ATTACK ) then
		self:InsertShell()
	else
		self:FinishReload()
	end
end

function SWEP:FinishReload()
	self:SetReloading( false )

	self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
	self:SetReloadTime( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	self:QueueIdle()

	if self.PumpSound then self:EmitSound( self.PumpSound ) end
end
