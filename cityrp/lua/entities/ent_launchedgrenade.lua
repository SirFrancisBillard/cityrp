AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Launched Grenade"

ENT.Spawnable = false
ENT.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"

local DamageRoller = 40
local DamageDirect = 80
local SplodeRadius = 250
local SplodeTime = 2

local color_white = color_white or Color(255, 255, 255)
local color_red = Color(255, 0, 0)

local SpriteMat = Material("sprites/light_glow02_add")

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetModelScale(0.2)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysicsInitSphere(3, "metal")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysWake()

		util.SpriteTrail(self, 0, color_white, false, 4, 1, 0.3, 0.1, "trails/smoke.vmt")

		self.Roller = false
		self.ExplodeTime = false
	end

	function ENT:Detonate()
		local boom = EffectData()
		boom:SetOrigin(self:GetPos())
		boom:SetFlags(4)
		util.Effect("Explosion", boom, true, true)

		self:EmitSound(Sound("Arena.Explosion"))

		util.BlastDamage(self, self.Owner, self:GetPos(), SplodeRadius, self.Roller and DamageRoller or DamageDirect)

		self:Remove()
	end

	function ENT:PhysicsCollide(data, phys)
		if data.HitEntity:IsWorld() and not self.Roller then
			self.Roller = true
			self.ExplodeTime = CurTime() + SplodeTime
		end

		if data.Speed > 50 then
			self:EmitSound(Sound("HEGrenade.Bounce"))
		end
	end

	function ENT:Think()
		if self.ExplodeTime and self.ExplodeTime < CurTime() then
			self:Detonate()
		end
	end

	function ENT:StartTouch(ent)
		if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
			self:Detonate()
		end
	end
else -- CLIENT
	function ENT:Draw()
		render.SetMaterial(SpriteMat)
		render.DrawSprite(self:GetPos(), 24, 24, self:GetOwner() == LocalPlayer() and color_white or color_red)

		self:DrawModel()
	end
end
