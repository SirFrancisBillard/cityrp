AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Stove"
ENT.Category = "Meth Cooking"
ENT.Spawnable = true
ENT.Model = "models/props_c17/furnitureStove001a.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(200)
	end
end
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "HasCanister")
	self:NetworkVar("Entity", 0, "Canister")
end

if SERVER then
	function ENT:StartTouch(ent)
		if IsValid(ent) and (ent:GetClass() == "ent_gas") and (not self:GetHasCanister()) and (not ent:GetHasStove()) then
			if (not ent:IsReadyForStove()) then return end
			self:SetHasCanister(true)
			self:SetCanister(ent)
			ent:SetHasStove(true)
			ent:SetStove(self)
			local weld = constraint.Weld(self, ent, 0, 0, 0, true, false)
			self:EmitSound("physics/metal/metal_barrel_impact_soft"..math.random(1, 4)..".wav")
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		surface.SetFont("Trebuchet24")

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)

		cam.Start3D2D(Pos + (Ang:Up() * 18) + (Ang:Right() * -2), Ang, 0.3)
			draw.WordBox(2, -30, -50, "Stove", "Trebuchet24", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
			draw.WordBox(2, -42.5, -10, "Gas: "..(self:GetHasCanister() and self:GetCanister():GetFuel() or "None"), "Trebuchet24", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
		cam.End3D2D()
	end
end
