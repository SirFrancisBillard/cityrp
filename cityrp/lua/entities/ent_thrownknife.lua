AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Thrown Knife"

ENT.Spawnable = false
ENT.Model = "models/weapons/w_knife_t.mdl"

local Damage = 15

local color_white = color_white or Color(255, 255, 255)
local color_red = Color(255, 0, 0)

local StuckSound = Sound("Weapon_Knife.HitWall")
local HitSound = Sound("Weapon_Knife.Hit")

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInitSphere(1, "metal")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()

		util.SpriteTrail(self, 0, color_white, false, 4, 1, 0.3, 0.1, "trails/smoke.vmt")

		self:SetNWBool("stuck", false)
	end

	function ENT:PhysicsCollide(data, phys)
		if data.HitEntity:IsWorld() and not self:GetNWBool("stuck", false) then
			timer.Simple(0, function()
				if not IsValid(self) then return end
				self:SetNWBool("stuck", true)
				self:SetMoveType(MOVETYPE_NONE)
				self:EmitSound(StuckSound)
				SafeRemoveEntityDelayed(self, 10)
			end
		end
	end

	function ENT:StartTouch(ent)
		if not self:GetNWBool("stuck", false) and IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) then
			ent:TakeDamage(Damage, self:GetOwner() or self, self)
			SafeRemoveEntity(self)
		end
	end
else -- CLIENT
	function ENT:Draw()
		if not self:GetNWBool("stuck", false) then
			local pitch = (CurTime() * 180) % 360
			local angles = self:GetAngles()
			self:SetAngles(Angle(pitch, angles.y, angles.r))
		end
		self:DrawModel()
	end
end
