AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Orange"
ENT.Category = "Food"
ENT.Spawnable = true
ENT.Model = "models/props/cs_italy/orange.mdl"
ENT.MakesAlcohol = {"Pruno", "ent_pruno"}

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysWake()
	end
end
