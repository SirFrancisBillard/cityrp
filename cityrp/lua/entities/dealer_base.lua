AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Base Dealer"
ENT.Category = "NPCs"
ENT.Spawnable = true

ENT.Model = "models/player/guerilla.mdl"
ENT.Description = "Template to make dealers from!"
ENT.TextColor = color_white
ENT.Animation = "menu_combine"

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
		phys:EnableMotion(false)
	end
	self:SetPos(self:GetPos() - Vector(0, 0, 10))
end

function ENT:Think()
	self:SetSequence(self.Animation)
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 100), Ang, 0.35)
			draw.SimpleTextOutlined(self.PrintName, "DermaLarge", 0, 0, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
			draw.SimpleTextOutlined(self.Description, "DermaLarge", 0, 40, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end
