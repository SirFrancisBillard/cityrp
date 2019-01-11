AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Queue Locker"
ENT.Category = "Battle Royale"
ENT.Spawnable = true
ENT.Model = "models/props_wasteland/controlroom_storagecloset001a.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

	self:PhysWake()
	self:SetColor(RarityColors[self:GetRarity()])
end

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:TryQueueBR()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
