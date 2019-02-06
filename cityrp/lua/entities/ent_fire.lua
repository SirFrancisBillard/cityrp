AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Fire"

PrecacheParticleSystem("fire_medium_02")

if SERVER then
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

		self.BurnSound = CreateSound(self, "ambient/fire/fire_med_loop1.wav")
		if self.BurnSound then
			self.BurnSound:Play()
			self.BurnSound:ChangeVolume(1, 0)
		end

		SafeRemoveEntityDelayed(self, 60)
	end

	function ENT:Touch(other)
		if IsValid(other) then
			other:Ignite(10, 16)
			if other.NextFireBurn == nil then
				other.NextFireBurn = 0
			end
			if CurTime() > other.NextFireBurn then
				other.NextFireBurn = CurTime() + 1
				local dmg = DamageInfo()
				dmg:SetDamage(15)
				if IsValid(self:GetOwner()) then
					dmg:SetAttacker(self:GetOwner())
				end
				dmg:SetInflictor(self)
				dmg:SetDamageType(DMG_BURN)
				ent:TakeDamageInfo(dmg)
			end
		end
	end

	function ENT:OnRemove()
		self:StopParticles()
		if self.BurnSound then
			self.BurnSound:Stop()
		end
	end
else
	function ENT:Initialize()
		PrecacheParticleSystem("fire_medium_02")
	end

	function ENT:Think()
		ParticleEffect("fire_medium_02", self:GetPos(), self:GetAngles(), self)

		self:SetNextClientThink(CurTime() + 2)
		return true
	end

	function ENT:Draw() end
end


