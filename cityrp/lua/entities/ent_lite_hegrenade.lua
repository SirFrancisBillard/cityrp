AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ent_lite_base_grenade"

ENT.Model = Model( "models/weapons/w_eq_fraggrenade_thrown.mdl" )
ENT.LifeTime = 3
ENT.BounceSound = Sound( "HEGrenade.Bounce" )

function ENT:Explode()
	util.BlastDamage( self, self:GetOwner(), self:GetPos(), 200, 200 )

	local ef = EffectData()
	ef:SetOrigin( self:GetPos() )
	util.Effect( "Explosion", ef, true, true )
end