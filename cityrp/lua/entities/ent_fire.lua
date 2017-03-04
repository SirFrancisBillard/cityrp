AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Fire"

if CLIENT then
	function ENT:Initialize()
		ParticleEffectAttach("fire_medium_02_nosmoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
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

	self.BurnSound = CreateSound(self, "interior_fire01_stereo.wav")
	if self.BurnSound then
		self.BurnSound:Play()
		self.BurnSound:ChangeVolume(0.15, 0)
	end

	SafeRemoveEntity(self, 60)
end

function ENT:Touch(other)
	if IsValid(other) then
		other:Ignite(8, 16)
	end
end

function ENT:OnRemove()
	self:StopParticles()
	if self.BurnSound then
		self.BurnSound:Stop()
	end
end
