AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Crossbow Bolt"

ENT.Spawnable = false
ENT.Model = "models/crossbow_bolt.mdl"

local Damage = 50

local color_white = color_white or Color(255, 255, 255)
local color_red = Color(255, 0, 0)

local StuckSound = Sound("weapons/crossbow/hit1.wav")
local HitSound = Sound("weapons/crossbow/bolt_skewer1.wav")

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInitSphere(1, "metal")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()

		util.SpriteTrail(self, 0, color_white, false, 4, 1, 0.3, 0.1, "trails/smoke.vmt")

		self.Stuck = false
	end

	function ENT:PhysicsCollide(data, phys)
		if data.HitEntity:IsWorld() and not self.Stuck then
			self.Stuck = true
			self:SetMoveType(MOVETYPE_NONE)
			self:EmitSound(StuckSound)
			SafeRemoveEntityDelayed(self, 10)
		end
	end

	function ENT:StartTouch(ent)
		if not self.Stuck and IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
			ent:TakeDamage(Damage, self:GetOwner() or self, self)
			SafeRemoveEntity(self)
		end
	end
else -- CLIENT
	function ENT:Draw()
		self:DrawModel()
	end
end
