AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Thrown Flame"

ENT.Spawnable = false
ENT.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"

local StickTime = 5
local BurnRadius = 32

local color_white = color_white or Color(255, 255, 255)
local color_orange = Color(255, 128, 0)

local SpriteMat = Material("sprites/light_glow02_add")

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetModelScale(0.2)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysicsInitSphere(1, "gmod_silent")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysWake()
		self:DrawShadow(false)

		self:Ignite(9999)
	end

	function ENT:PhysicsCollide(data, phys)
		if IsValid(data.HitEntity) then
			local d = DamageInfo()
			d:SetDamage(15)
			d:SetAttacker(self:GetOwner())
			d:SetInflictor(self)
			d:SetDamageType(DMG_BURN)
			data.HitEntity:TakeDamageInfo( d )
			data.HitEntity:Ignite(6)
			SafeRemoveEntity(self)
		elseif not self.landed then
			self:GetPhysicsObject():EnableMotion(false)
			self:Extinguish()
			self:Ignite(StickTime, BurnRadius)
			self.landed = CurTime()
		end
	end

	function ENT:Think()
		if self.landed and CurTime() - self.landed > StickTime then
			SafeRemoveEntity(self)
		end
		self:NextThink(CurTime() + 0.1)
		return true
	end
else -- CLIENT
	function ENT:Draw()
		--render.SetMaterial(SpriteMat)
		--render.DrawSprite(self:GetPos(), 64, 64, color_orange)

		-- dont draw the ball, we're a flame
		-- self:DrawModel()
	end
end
