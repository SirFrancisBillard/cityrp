AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Thrown Molotov"

if CLIENT then return end

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_glassbottle003a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
	
	local Phys = self:GetPhysicsObject()
	if not Phys or not Phys:IsValid() then return end
	self:GetPhysicsObject():Wake()
	self.What = CurTime()


	util.SpriteTrail(self, 0, Color(255, 120, 0), false, 8, 2, 0.4, 1 / 10 * 0.5, "trails/smoke.vmt")
end

function ENT:Explode(pos)
	sound.Play("physics/glass/glass_cup_break".. math.random(1, 2).. ".wav", self:GetPos(), 150, 150)

	local fire = ents.Create("ent_fire")
	fire:SetPos(pos)
	fire:Spawn()
	self:Remove()
end

function ENT:Think()
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = self:GetPos() + self:GetVelocity() * 5
	trace.filter = self
	
	if self.What + 10 < CurTime() then
		self:Explode(self:GetPos())
		return false
	end
	
	local tr = util.TraceLine(trace)
	if tr.Hit and tr.HitPos:Distance(self:GetPos()) < 75 then
		self:Explode(tr.HitPos)
	end
end
