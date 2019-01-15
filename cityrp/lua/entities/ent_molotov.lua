AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Thrown Molotov"

if CLIENT then return end

function ENT:Initialize()
	self:SetModel("models/props_junk/GlassBottle01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
	
	self:PhysWake()

	util.SpriteTrail(self, 0, Color(255, 120, 0), false, 8, 2, 0.4, 1 / 10 * 0.5, "trails/smoke.vmt")
end

function ENT:Explode()
	sound.Play("physics/glass/glass_cup_break".. math.random(1, 2).. ".wav", self:GetPos(), 150, 150)

	local fire = ents.Create("ent_fire")
	fire:SetPos(self:GetPos())
	fire:Spawn()
	self:Remove()
end

function ENT:PhysicsCollide()
	self:Explode()
end
