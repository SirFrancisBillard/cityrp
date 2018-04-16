AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Keg"
ENT.Category = "Crime+"
ENT.Spawnable = true
ENT.Model = "models/props_c17/woodbarrel001.mdl"

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
	self:SetFermentingProgress(0)
	self:SetAlcohol("None")
	self:SetIsFermenting(false)
end
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "FermentingProgress")
	self:NetworkVar("String", 0, "Alcohol")
	self:NetworkVar("Bool", 0, "IsFermenting")
end
function ENT:CanFerment()
	return (self:GetAlcohol() != "None")
end
function ENT:DoneFermenting()
	return (self:GetFermentingProgress() >= 100)
end

if SERVER then
	function ENT:StartTouch(ent)
		if IsValid(ent) then
			if (ent:GetClass() == "rp_orange") and (not self:GetIsFermenting()) then
				SafeRemoveEntity(ent)
				self:SetIsFermenting(true)
				self:SetAlcohol("Pruno")
				self:EmitSound("ambient/water/drip"..math.random(1, 4)..".wav")
			end
			if (ent:GetClass() == "rp_banana") and (not self:GetIsFermenting()) then
				SafeRemoveEntity(ent)
				self:SetIsFermenting(true)
				self:SetAlcohol("Rum")
				self:EmitSound("ambient/water/drip"..math.random(1, 4)..".wav")
			end
			if (ent:GetClass() == "rp_potato") and (not self:GetIsFermenting()) then
				SafeRemoveEntity(ent)
				self:SetIsFermenting(true)
				self:SetAlcohol("Vodka")
				self:EmitSound("ambient/water/drip"..math.random(1, 4)..".wav")
			end
			if (ent:GetClass() == "rp_melon") and (not self:GetIsFermenting()) then
				SafeRemoveEntity(ent)
				self:SetIsFermenting(true)
				self:SetAlcohol("Moonshine")
				self:EmitSound("ambient/water/drip"..math.random(1, 4)..".wav")
			end
		end
	end
	function ENT:Think()
		if self:CanFerment() and (not self:DoneFermenting()) then
			self:SetFermentingProgress(math.Clamp(self:GetFermentingProgress() + 1, 0, 100))
		end
		self:NextThink(CurTime() + 1)
		return true
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if self:DoneFermenting() then
				self:SetIsFermenting(false)
				self:SetFermentingProgress(0)
				local logic = ents.Create("rp_sixpack")
				logic:SetPos(self:GetPos() + Vector(0, 0, 60))
				logic:Spawn()
				logic:SetAlcohol(self:GetAlcohol())
				self:SetAlcohol("None")
				self:EmitSound("physics/glass/glass_bottle_impact_hard"..math.random(1, 3)..".wav")
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

		cam.Start3D2D(Pos + (Ang:Up() * 15) + (Ang:Right() * -27.5), Ang, 0.12)
			draw.RoundedBox(2, -50, -65, 100, 30, Color(140, 0, 0, 100))
			if (self:GetFermentingProgress() > 0) then
				draw.RoundedBox(2, -50, -65, self:GetFermentingProgress(), 30, Color(0, 225, 0, 100))
			end
			draw.SimpleText("Progress", "Trebuchet24", -40, -63, Color(255, 255, 255, 255))
			draw.WordBox(2, -35, -30, "Making:", "Trebuchet24", Color(0, 225, 0, 100), Color(255, 255, 255, 255))
			draw.WordBox(2, (self:GetAlcohol() == "None") and -22.5 or (self:GetAlcohol() == "Moonshine") and -45 or (self:GetAlcohol() == "Rum") and -20 or -27.5, 5, self:GetAlcohol(), "Trebuchet24", (self:GetAlcohol() != "None") and Color(0, 225, 0, 100) or Color(140, 0, 0, 100), Color(255, 255, 255, 255))
		cam.End3D2D()
	end
end
