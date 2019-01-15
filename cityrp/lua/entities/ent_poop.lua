AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Poop"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/Gibs/HGIBS_spine.mdl")
		self:SetColor(Color(102, 51, 0))
		self:SetMaterial("models/props_pipes/pipeset_metal") 
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		self:PhysWake()
	end

	function ENT:Use(activator, caller)
		if math.random(1, 4) == 1 then
			caller:GiveSTD()
			self:Remove()
			return
		end

		if caller:Health() <= 10 then 
			caller:Kill()
		else
			caller:SetHealth(caller:Health() - 10)
		end

		self:Remove()
	end
else -- CLIENT
	function ENT:Draw()
		self:DrawModel() 
	end
end
