AddCSLuaFile()

ENT.Type = "anim"

ENT.Model = Model( "models/weapons/w_eq_fraggrenade_thrown.mdl" )
ENT.LifeTime = 4
ENT.BounceSound = Sound( "HEGrenade.Bounce" )

if SERVER then
	AccessorFunc( ENT, "ExplosionTimer", "ExplosionTimer" )

	function ENT:Initialize()
		self:SetModel( self.Model )

		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )

		self:GetPhysicsObject():Wake()

		self:SetExplosionTimer( CurTime() + self.LifeTime )
	end

	function ENT:PhysicsCollide( coldata )
		if coldata.Speed > 100 then self:Bounce() end
	end

	function ENT:Bounce()
		self:EmitSound( self.BounceSound )
	end

	function ENT:Explode()
	end

	function ENT:Think()
		if CurTime() > self:GetExplosionTimer() then
			self:Explode()
			self:Remove()
		end
	end
end