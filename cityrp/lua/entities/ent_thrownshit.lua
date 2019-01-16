AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Thrown Shit"

ENT.Spawnable = false
ENT.Model = "models/Gibs/HGIBS_spine.mdl"

local ShitMat = Material("models/debug/debugwhite")
local ShitBrown = Color(102, 57, 0, 255)

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInitSphere(1, "flesh")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:SetMaterial(ShitMat, true)
		self:SetColor(ShitBrown)
		self:SetAngles(AngleRand())
	end

	function ENT:PhysicsCollide(data, phys)
		if data.HitEntity:IsPlayer() and data.HitEntity.Vomit and math.random(8) == 8 then
			data.HitEntity:Vomit()
		end
		util.Decal("BeerSplash", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
		self:EmitSound(Sound("physics/flesh/flesh_squishy_impact_hard" .. math.random(4) .. ".wav"))
		self:Remove()
	end
else -- CLIENT
	function ENT:Draw()
		self:DrawModel()
	end
end
