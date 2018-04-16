AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Coca Plant"
ENT.Category = "Crime+"
ENT.Spawnable = true
ENT.Model = "models/props/cs_office/plant01.mdl"

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
	end
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Up(), 90)
	self:SetAngles(Ang)
end
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Growth")
end
function ENT:DoneGrowing()
	return (self:GetGrowth() >= 100)
end

if SERVER then
	function ENT:Think()
		if (not self:DoneGrowing()) then
			self:SetGrowth(math.Clamp(self:GetGrowth() + 1, 0, 100))
		end
		self:NextThink(CurTime() + 1)
		return true
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if self:DoneGrowing() then
				self:SetGrowth(0)
				local coke = ents.Create("rp_leaves")
				coke:SetPos(self:GetPos() + Vector(0, 0, 30))
				coke:Spawn()
				self:EmitSound("physics/wood/wood_box_impact_soft"..math.random(1, 3)..".wav")
			end
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

		cam.Start3D2D(Pos + (Ang:Up() * 15) + (Ang:Right() * -10), Ang, 0.12)
			draw.RoundedBox(2, -50, -65, 100, 30, Color(140, 0, 0, 100))
			if (self:GetGrowth() > 0) then
				draw.RoundedBox(2, -50, -65, self:GetGrowth(), 30, Color(0, 225, 0, 100))
			end
			draw.SimpleText("Growth", "Trebuchet24", -40, -63, Color(255, 255, 255, 255))
		cam.End3D2D()
	end
end
