AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Barrel"
ENT.Category = "Cocaine Making"
ENT.Spawnable = true
ENT.Model = "models/props_borealis/bluebarrel001.mdl"

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
end
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "MixingProgress")
	self:NetworkVar("Bool", 0, "IsMixing")
	self:NetworkVar("Bool", 1, "HasLeaves")
	self:NetworkVar("Bool", 2, "HasCaustic")
end
function ENT:CanMix()
	return (self:GetHasLeaves() and self:GetHasCaustic())
end
function ENT:DoneMixing()
	return (self:GetMixingProgress() >= 100)
end

if SERVER then
	function ENT:StartTouch(ent)
		if IsValid(ent) then
			if (ent:GetClass() == "ent_leaves") and (not self:GetHasLeaves()) then
				SafeRemoveEntity(ent)
				self:SetHasLeaves(true)
				self:EmitSound(Sound("physics/cardboard/cardboard_box_impact_hard"..math.random(1, 7)..".wav"))
			end
			if (ent:GetClass() == "ent_caustic") and (not self:GetHasCaustic()) then
				SafeRemoveEntity(ent)
				self:SetHasCaustic(true)
				self:EmitSound(Sound("ambient/water/drip"..math.random(1, 4)..".wav"))
			end
		end
	end
	function ENT:Think()
		if self:CanMix() and (not self:DoneMixing()) then
			self:SetMixingProgress(math.Clamp(self:GetMixingProgress() + 1, 0, 100))
		end
		self:NextThink(CurTime() + 1)
		return true
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if self:DoneMixing() then
				self:SetMixingProgress(0)
				self:SetHasLeaves(false)
				self:SetHasCaustic(false)
				local coke = ents.Create("ent_cocaine")
				coke:SetPos(self:GetPos() + Vector(0, 0, 30))
				coke:Spawn()
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
		Ang:RotateAroundAxis(Ang:Right(), -90)

		cam.Start3D2D(Pos + (Ang:Up() * 15) + (Ang:Right() * -10), Ang, 0.12)
			draw.RoundedBox(2, -50, -65, 100, 30, Color(140, 0, 0, 100))
			if (self:GetMixingProgress() > 0) then
				draw.RoundedBox(2, -50, -65, self:GetMixingProgress(), 30, Color(0, 225, 0, 100))
			end
			draw.SimpleText("Progress", "Trebuchet24", -40, -63, Color(255, 255, 255, 255))
			draw.WordBox(2, -55, -30, "Ingredients:", "Trebuchet24", Color(0, 225, 0, 100), Color(255, 255, 255, 255))
			draw.WordBox(2, -55, 5, "Coca Leaves", "Trebuchet24", self:GetHasLeaves() and Color(0, 225, 0, 100) or Color(140, 0, 0, 100), Color(255, 255, 255, 255))
			draw.WordBox(2, -55, 40, "Caustic Soda", "Trebuchet24", self:GetHasCaustic() and Color(0, 225, 0, 100) or Color(140, 0, 0, 100), Color(255, 255, 255, 255))
		cam.End3D2D()
	end
end
