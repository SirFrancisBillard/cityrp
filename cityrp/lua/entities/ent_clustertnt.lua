AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cluster TNT"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local time = 1.5
local damage = 50
local radius = 150

if SERVER then
	function ENT:Initialize()
		self:SetModel( "models/dav0r/tnt/tnt.mdl" )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end
		
		timer.Simple( time * ( math.random( 90, 110 ) / 100 ), function()
			if IsValid( self ) then
				local entList = ents.FindInSphere( self:GetPos(), radius )
				
				for k, v in pairs( entList ) do
					if ( v:IsPlayer() or v:IsNPC() ) then
						local scaleDam = damage * ( 1 - math.min( v:GetPos():Distance( self:GetPos() )/radius, 1 ) )
						v:TakeDamage( scaleDam, self, self )
					end
				end
				
				local vPoint = self:GetPos()
				local effectdata = EffectData()
				effectdata:SetOrigin( vPoint )
				util.Effect( "Explosion", effectdata )
				
				util.ScreenShake( vPoint, 50, 50, 2, radius )
				
				self:Remove()
			end
		end)
		
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
