AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bottle"
ENT.Category = "Alcohol (Old)"
ENT.Spawnable = true
ENT.Model = "models/props_junk/garbage_glassbottle003a.mdl"

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

	self:SetSwigs(6)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Swigs")
	self:NetworkVar("String", 0, "Alcohol")
end

local Drinks = {
	["Pruno"] = 2,
	["Moonshine"] = 4,
	["Rum"] = 6,
	["Vodka"] = 8
}

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if (self:GetSwigs() > 0) then
				self:SetSwigs(math.Clamp(self:GetSwigs() - 1, 0, 6))
				if Drinks[self:GetAlcohol()] then
					caller:SetHealth(math.Clamp(caller:Health() + Drinks[self:GetAlcohol()], 0, caller:GetMaxHealth()))
				end
				caller:EmitSound(Sound("npc/barnacle/barnacle_gulp"..math.random(1, 2)..".wav"))
				if math.random(1, 5) == 1 then
					caller:ConCommand("pp_motionblur 1")
					caller:ConCommand("pp_motionblur_delay 0.01")
					caller:ConCommand("pp_motionblur_addalpha 0.05")
					caller:ConCommand("pp_motionblur_drawalpha 1")
				end
			else
				SafeRemoveEntity(self)
			end
		end
	end
end
