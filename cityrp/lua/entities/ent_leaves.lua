AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Coca Leaves"
ENT.Category = "Cocaine Production"
ENT.Spawnable = true
ENT.Model = "models/props_junk/cardboard_box003a.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end
	self:PhysWake()
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		surface.SetFont("Trebuchet24")

		Ang:RotateAroundAxis(Ang:Up(), 90)

		cam.Start3D2D(Pos + (Ang:Up() * 5), Ang, 0.18)
			draw.WordBox(2, -50, 15, "Coca Leaves", "Trebuchet24", Color(140, 0, 0, 200), Color(255, 255, 255, 255))
		cam.End3D2D()
	end
end
