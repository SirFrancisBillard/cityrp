AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Fire"

PrecacheParticleSystem("fire_medium_02_nosmoke")

if CLIENT then
	function ENT:Initialize()
		PrecacheParticleSystem("fire_medium_02_nosmoke")
	end

	function ENT:Think()
		ParticleEffect("fire_medium_02_nosmoke", self:GetPos(), self:GetAngles(), self)

		self:SetNextClientThink(CurTime() + 2)
		return true
	end

	function ENT:Draw() end

	return
end

function ENT:Initialize()
	local fireSize = Vector(1, 1, 1) * 52

	self:SetModel("models/props_wasteland/kitchen_counter001c.mdl")
	self:PhysicsInitBox(-fireSize, fireSize)

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetCollisionBounds(-fireSize, fireSize)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:DrawShadow(false)
	self:SetTrigger(true)

	self.BurnSound = CreateSound(self, "npc/headcrab/headcrab_burning_loop2")
	if self.BurnSound then
		self.BurnSound:Play()
		self.BurnSound:ChangeVolume(0.15, 0)
	end

	SafeRemoveEntityDelayed(self, 60)
end

function ENT:Touch(other)
	if IsValid(other) then
		other:Ignite(4, 16)
	end
end

function ENT:OnRemove()
	self:StopParticles()
	if self.BurnSound then
		self.BurnSound:Stop()
	end
end
