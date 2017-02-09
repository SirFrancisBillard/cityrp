AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Base CityRP Entity"
ENT.Category = "CityRP"
ENT.Spawnable = false
ENT.Model = "models/props_junk/watermelon01.mdl"

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
		self:SetUseType(SIMPLE_USE or 3)
		if self.PermaMaterial then
			self:SetMaterial(self.PermaMaterial)
		end
		if self.PermaColor then
			self:SetColor(self.PermaColor)
		end
		if self.PermaScale and (self.PermaScale != 1.0) then
			self:SetModelScale(self.PermaScale)
		end
	end
	hook.Add("PlayerSpawn", "CityRP_SpawnWithoutStuff", function(ply)
		ply.CarryingC4Defuser = false
		ply.FlashlightBattery = false
		ply.WearingKevlar = false
		ply.SprayCan = false
	end)
end


