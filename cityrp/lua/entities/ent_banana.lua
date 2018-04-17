AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Banana"
ENT.Category = "Food"
ENT.Spawnable = true
ENT.Model = "models/props/cs_italy/bananna.mdl"
ENT.MakesAlcohol = {"Rum", "ent_rum"}

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	if SERVER then
		self:PhysicsInitSphere(2, "watermelon")
		self:SetUseType(SIMPLE_USE)
	end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(10)
	end
end
