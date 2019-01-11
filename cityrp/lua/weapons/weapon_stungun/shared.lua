
/*
Stungun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
*/

STUNGUN = {} // General stungun stuff table
include("config.lua")

STUNGUN.IsDarkRP = ((type(DarkRP) == "table") or (RPExtraTeams != nil))
STUNGUN.IsDarkRP25 = (STUNGUN.IsDarkRP and (type(DarkRP) == "table") and DarkRP.getPhrase)

STUNGUN.IsTTT = ((ROLE_TRAITOR != nil) and (ROLE_INNOCENT != nil) and (ROLE_DETECTIVE != nil)) // For a gamemode to be TTT, these should probably exist.
if STUNGUN.IsTTT then
	SWEP.Base = "weapon_tttbase"
	SWEP.AmmoEnt = ""
	SWEP.IsSilent = false
	SWEP.NoSights = true
end

SWEP.Author = "Donkie"
SWEP.Instructions = "Left click to stun a person."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_pistol.mdl")
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

//SWEP.InfiniteAmmo = (SWEP.Ammo <= -1) //Not used anymore
if SWEP.InfiniteAmmo then
	SWEP.Primary.ClipSize = -1
	SWEP.Primary.DefaultClip = 0
	SWEP.Primary.Ammo = "none"
else
	SWEP.Primary.ClipSize = 1
	SWEP.Primary.DefaultClip = 1
	
	if STUNGUN.IsTTT then
		SWEP.Primary.ClipMax = SWEP.Ammo
	end
	
	SWEP.Primary.Ammo = "ammo_stungun"
end
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

//print(SERVER and "SERVER INIT" or "CLIENT INIT")

SWEP.Uncharging = false

game.AddAmmoType({
	name = "ammo_stungun",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
})

if STUNGUN.AddAmmoItem >= 0 then
	if DarkRP and DarkRP.createAmmoType then
		DarkRP.createAmmoType("ammo_stungun", {
			name = "Stungun Charges",
			model = "models/Items/battery.mdl",
			price = math.ceil(STUNGUN.AddAmmoItem),
			amountGiven = 1
		})
	elseif GAMEMODE.AddAmmoType then
		GAMEMODE:AddAmmoType("ammo_stungun", "Stungun Charges", "models/Items/battery.mdl", math.ceil(STUNGUN.AddAmmoItem), 1)
	end
end

function SWEP:PrimaryAttack()
	if self.Charge < 100 then return end
	
	if not self.InfiniteAmmo then
		if self:Clip1() <= 0 then return end
		self:TakePrimaryAmmo(1)
	end
	
	self.Uncharging = true
	
	//Shoot trace
	self.Owner:LagCompensation(true)
	local tr = util.TraceLine(util.GetPlayerTrace( self.Owner ))
	self.Owner:LagCompensation(false)
	
	//Animations
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	//Electric bolt, taken from toolgun
	local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )
	
	if SERVER then
		self.Owner:EmitSound("npc/turret_floor/shoot1.wav",100,100)
	end
	
	local ent = tr.Entity
	
	if CLIENT then return end
	
	//Don't proceed if we don't hit any player
	if not IsValid(ent) or not ent:IsPlayer() then return end
	if ent == self.Owner then return end
	if self.Owner:GetShootPos():Distance(tr.HitPos) > self.Range then return end
	
	if not STUNGUN.IsPlayerImmune(ent) and (STUNGUN.AllowFriendlyFire or not STUNGUN.SameTeam(self.Owner, ent)) then
		//Electrolute the player
		STUNGUN.Electrolute( ent, (ent:GetPos() - self.Owner:GetPos()):GetNormal() )
	end
end

local chargeinc
function SWEP:Think()
	//In charge of charging the swep
	//Since we got the same in-sensitive code both client and serverside we don't need to network anything.
	if SERVER or (CLIENT and IsFirstTimePredicted()) then
		if not chargeinc then
			//Calculate how much we should increase charge every tick based on how long we want it to take.
			chargeinc = ((100 / self.RechargeTime) * engine.TickInterval())
		end
		
		local inc = self.Uncharging and (-5) or chargeinc
		
		if self:Clip1() <= 0 and not self.InfiniteAmmo then inc = math.min(inc, 0) end // If we're out of clip, we shouldn't be allowed to recharge.
		
		self.Charge = math.min(self.Charge + inc, 100)
		if self.Charge < 0 then self:Reload() self.Uncharging = false self.Charge = 0 end
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	return true
end

local shoulddisable = {} // Disables muzzleflashes and ejections
shoulddisable[21] = true
shoulddisable[5003] = true
shoulddisable[6001] = true
function SWEP:FireAnimationEvent( pos, ang, event, options )
	if shoulddisable[event] then return true end
end

hook.Add("PhysgunPickup", "Tazer", function(_,ent)
	if not STUNGUN.AllowPhysgun and IsValid(ent:GetNWEntity("plyowner")) then return false end
end)
hook.Add("CanTool", "Tazer", function(_,tr,_)
	if not STUNGUN.AllowToolgun and IsValid(tr.Entity) and IsValid(tr.Entity:GetNWEntity("plyowner")) then return false end
end)

