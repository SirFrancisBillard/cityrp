AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ent_lite_base_grenade"

ENT.Model = Model( "models/weapons/w_eq_flashbang_thrown.mdl" )
ENT.LifeTime = 3
ENT.BounceSound = Sound( "Flashbang.Bounce" )

function ENT:Explode()
	self:EmitSound( "Flashbang.Explode" )

	for k, v in ipairs( ents.FindInSphere( self:GetPos(), 512 ) ) do
		if IsValid( v ) and v:IsPlayer() then
			local tr = util.TraceLine{
				start = self:GetPos(),
				endpos = v:EyePos(),
				filter = { self, v }
			}

			if not tr.Hit then
				v:ScreenFade( SCREENFADE.IN, color_white, 1, 2 )
				v:SetDSP( 35, false )
			end
		end
	end
end