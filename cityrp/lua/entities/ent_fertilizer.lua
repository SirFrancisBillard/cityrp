AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Fertilizer"
ENT.Category = "Weed Growing"
ENT.Spawnable = true
ENT.Model = "models/props_junk/garbage_bag001a.mdl"
ENT.IsFertilizer = true

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
