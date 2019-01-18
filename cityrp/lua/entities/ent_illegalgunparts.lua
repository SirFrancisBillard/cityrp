AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Illegal Gun Parts"
ENT.Category = "Weapon Crafting"
ENT.Spawnable = true

ENT.Model = "models/weapons/w_pist_elite_dropped.mdl"
ENT.CraftingIngredient = "illegal_parts"

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:PhysWake()
	end
end
