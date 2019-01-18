AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Melon"
ENT.Category = "Food"
ENT.Spawnable = true
ENT.Model = "models/props_junk/watermelon01.mdl"

ENT.MakesAlcohol = {"Moonshine", "ent_moonshine"}

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
