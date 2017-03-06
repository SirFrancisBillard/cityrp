AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "STD Medication"
ENT.Category = "RP"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_lab/jar01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		self:PhysWake()
	end

	function ENT:Use(activator, caller)
		caller:CureSTD()
		self:Remove()
	end
else -- CLIENT
	function ENT:Draw()
		self:DrawModel() 
	end
end
