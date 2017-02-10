AddCSLuaFile()

ENT.Type = "anim"

local Tmodel = Model( "models/props_c17/TrapPropeller_Lever.mdl" )
local Tsound = Sound( "ambient/energy/spark5.wav" )

local time = {
	hit = 5,
	miss = 3,
	remove = 8
}
	

local MissTime = 3
local TaseTime = 5

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Damage" )
end

function ENT:Initialize()
	self:SetModel( Tmodel )
	
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	
	-- self:SetModelScale( 0.5, 0 )
	self:SetDamage( 0 )
	
	timer.Simple( time.remove, function()
		if ( IsValid( self ) and SERVER ) then self:Remove() end
	end )
end

local function ResetPlayer( ply )
	if ( not IsValid( ply ) ) then return end
	
	ply:ConCommand("pp_motionblur 0")    
	ply:ConCommand("pp_dof 0")
	ply.IsTased = false
	ply:SetMoveType( MOVETYPE_WALK )
end

function ENT:PhysicsCollide( data, physnum )
	local ent = data.HitEntity
	
	if IsValid( ent ) then
		local tr = util.TraceLine({
			start = self:GetPos(), 
			endpos = ent:LocalToWorld( ent:OBBCenter() ), 
			filter={ self, self.Owner }, 
			mask = MASK_SHOT_HULL
		})
		
		if ( ent:IsPlayer() and not ent.IsTased ) then
			if ( not ent:IsWanted() ) then
				if ( SERVER and IsValid( self.Weapon ) and IsValid( self.Weapon.Owner ) ) then
					rp.Notify(self.Weapon.Owner, NOTIFY_ERROR, rp.Term('PlayerNotWanted'))
				end
				self:Remove()
				return
			end
			
			ent:ConCommand("pp_motionblur 1")  
			ent:ConCommand("pp_motionblur_addalpha 0.05")  
			ent:ConCommand("pp_motionblur_delay 0.035")  
			ent:ConCommand("pp_motionblur_drawalpha 1.00")  
			ent:ConCommand("pp_dof 1")  
			ent:ConCommand("pp_dof_initlength 9")  
			ent:ConCommand("pp_dof_spacing 8")

			--local move = ent:GetMoveType()
			ent:SetMoveType( MOVETYPE_NONE )
			ent.IsTased = true
			
			timer.Simple( time.hit, function() ResetPlayer( ent ) end )
		end
		
		self:SetPos( data.HitPos - data.HitNormal * 1 )
		self:SetAngles( data.HitNormal:Angle() )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:SetParent( ent )
		
		local phys = ent:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:SetVelocity( data.TheirOldVelocity )
		else
			ent:SetVelocity( data.TheirOldVelocity )
		end
		
		local ef = EffectData()
		ef:SetOrigin( data.HitPos )
		ef:SetNormal( data.HitNormal )
		ef:SetStart( data.HitPos )
		ef:SetEntity( ent )
		ef:SetMagnitude( 2 )
		
		util.Effect( "Sparks", ef, true, true )
		util.Effect( "TeslaHitBoxes", ef, true, true )
		
		sound.Play( Tsound, data.HitPos, 100, 100 )
		
		timer.Simple( time.hit, function() 
			if IsValid( self ) then
				self:SetMoveType( MOVETYPE_NOCLIP )
				self:SetSolid( SOLID_NONE )
				self:SetParent( nil )
				self.Retracting = true
			end
		end )
		
		--if ply then ply:TakeDamage( self:GetDamage(), self:GetOwner(), self ) else ent:TakeDamage( self:GetDamage(), self:GetOwner(), self ) end
	else
		self:SetPos( data.HitPos - data.HitNormal * 3 )
		self:SetAngles( data.HitNormal:Angle() )
		self:SetMoveType( MOVETYPE_NONE )
		
		local ef = EffectData()
		ef:SetOrigin( data.HitPos )
		ef:SetNormal( data.HitNormal )
		ef:SetStart( data.HitPos )
		ef:SetMagnitude( 2 )
		
		util.Effect( "Sparks", ef, true, true )
		
		sound.Play( Tsound, data.HitPos, 100, 100 )
		
		timer.Simple( time.miss, function() 
			if IsValid( self ) then
				self:SetMoveType( MOVETYPE_NOCLIP )
				self:SetSolid( SOLID_NONE )
				self:SetParent( nil )
				self.Retracting = true
			end
		end )
	end
end

function ENT:Think()
	local vWeapon = IsValid( self.Weapon )
	local vOwner = vWeapon and IsValid( self.Weapon.Owner )
	
	if ( not vWeapon ) then return end

	if SERVER then
		if not self.Fired then
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity( self.FireVelocity )
				self.Fired = true
			else
				--self:PhysWake()
				--local phys = self:GetPhysicsObject()
				--phys:SetVelocity( self.FireVelocity )
				--self.Fired = true
			end
		end
	end
	
	if ( self.Retracting ) then
		if ( not vWeapon ) then self:Remove() return end
		
		local target = vOwner and self.Weapon.Owner:GetPos() or self.Weapon:GetPos()		-- FIX this fucking awful shit
		local dir = ( target - self:GetPos() ):GetNormal()
		
		self:SetAngles( dir:Angle() )
		
		self:SetVelocity( dir * 200 )
		
		if self:GetPos():Distance( target ) < 150 then self:Remove() return end
	end
end

if CLIENT then return end

hook.Add( "CanPlayerSuicide", "GS-Taser-CanPlayerSuicide", function( ply ) 
	if ( IsValid( ply ) and ply.Tased ) then 
		return false 
	end 
end )

hook.Add( "DoPlayerDeath", "GS-Taser-DoPlayerDeath", function( ply )
	if ( IsValid( ply ) and ply.Tased ) then
		ResetPlayer( ply )
	end
end )