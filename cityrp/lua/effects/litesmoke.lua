AddCSLuaFile()

function EFFECT:Init( data )
	self.Origin = data:GetOrigin()
	self.Emitter = ParticleEmitter( self.Origin )

	for i = 1, 30 do
		local p = self.Emitter:Add( "particle/particle_smokegrenade", self.Origin )
		p:SetLifeTime( 0 )
		p:SetDieTime( 20 + math.random() * 10 )
		p:SetStartSize( 192 )
		p:SetEndSize( 192 )
		p:SetStartAlpha( 255 )
		p:SetEndAlpha( 0 )
		p:SetColor( 255, 255, 255 )
		p:SetVelocity( VectorRand() * 256 )
		p:SetAirResistance( 100 )
		p:SetRollDelta( math.Rand( -1, 1 ) * 0.2 * math.pi )
	end

	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end