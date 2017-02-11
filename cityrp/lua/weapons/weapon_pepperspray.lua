SWEP.PrintName			= "Pepper Spray"
SWEP.Instructions		= "Primary fire to disorient someone."

game.AddAmmoType({
	name = "pepperspray_ammo",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
})

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize		= 1000
SWEP.Primary.DefaultClip	= 10000
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pepperspray_ammo"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 20
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 4
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= true

SWEP.ViewModel				= "models/weapons/c_grenade.mdl"
SWEP.WorldModel				= "models/weapons/w_grenade.mdl"
SWEP.UseHands				= true

SWEP.Reloading = false

local ShootSound = Sound("player/sprayer.wav")

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimaryFire(CurTime() + 0.1)

	self:ShootEffects()
	self:TakePrimaryAmmo(1)
	self:EmitSound(ShootSound)

	if CLIENT then return end
	local ent = ents.Create("ent_pepperparticle")
	if not IsValid(ent) then return end

	ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 8))
	ent:SetAngles(self.Owner:EyeAngles())
	ent:SetOwner(self.Owner)
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if not IsValid(phys) then ent:Remove() return end

	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 200
	velocity = velocity + (VectorRand() * 10)
	phys:ApplyForceCenter(velocity)
end

function SWEP:SecondaryAttack() end

function SWEP:Deploy()
	self:SetHoldType("pistol")
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.Reloading = false
end

function SWEP:Reload()
	self:DefaultReload(ACT_VM_DRAW)
end
