AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Spring"
ENT.Category = "Weapon Crafting"
ENT.Spawnable = true

ENT.Model = "models/props_c17/TrapPropeller_Lever.mdl"
ENT.CraftingIngredient = "spring"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:PhysicsInit(SOLID_VPHYSICS)
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

	self:PhysWake()
end
