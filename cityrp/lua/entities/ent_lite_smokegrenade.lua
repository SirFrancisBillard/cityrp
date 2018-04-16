AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ent_lite_base_grenade"

ENT.Model = Model( "models/weapons/w_eq_smokegrenade_thrown.mdl" )
ENT.LifeTime = 3
ENT.BounceSound = Sound( "SmokeGrenade.Bounce" )

function ENT:Explode()
	self:EmitSound( "BaseSmokeEffect.Sound" )

	local ef = EffectData()
	ef:SetOrigin( self:GetPos() )
	util.Effect( "LiteSmoke", ef, true, true )
end