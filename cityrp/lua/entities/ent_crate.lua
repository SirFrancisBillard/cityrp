AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Shipping Crate"
ENT.Category = "Alcohol (Old)"
ENT.Spawnable = true
ENT.Model = "models/props_wasteland/laundry_cart002.mdl"

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
	self:SetHasEntityOne(false)
	self:SetHasEntityTwo(false)
	self:SetHasEntityThree(false)
end
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "HasEntityOne")
	self:NetworkVar("Bool", 1, "HasEntityTwo")
	self:NetworkVar("Bool", 2, "HasEntityThree")
	self:NetworkVar("Entity", 0, "EntityOne")
	self:NetworkVar("Entity", 1, "EntityTwo")
	self:NetworkVar("Entity", 2, "EntityThree")
end

if SERVER then
	function ENT:StartTouch(ent)
		if IsValid(ent) then
			if (ent.SellPrice != nil) then
				if (not self:GetHasEntityOne()) then
					self:SetHasEntityOne(true)
					self:SetEntityOne(ent)
				end
				if (not self:GetHasEntityTwo()) then
					self:SetHasEntityTwo(true)
					self:SetEntityTwo(ent)
				end
				if (not self:GetHasEntityThree()) then
					self:SetHasEntityThree(true)
					self:SetEntityThree(ent)
				end
			end
		end
	end
	function ENT:EndTouch(ent)
		if IsValid(ent) then
			if (ent.SellPrice != nil) then
				if (self:GetEntityOne() == ent) then
					self:SetHasEntityOne(false)
					self:SetEntityOne(ent)
				end
				if (self:GetEntityTwo() == ent) then
					self:SetHasEntityTwo(false)
					self:SetEntityTwo(ent)
				end
				if (self:GetEntityThree() == ent) then
					self:SetHasEntityThree(false)
					self:SetEntityThree(ent)
				end
			end
		end
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if self:GetHasEntityOne() or self:GetHasEntityTwo() or self:GetHasEntityThree() then
				if self:GetHasEntityOne() then
					caller:addMoney(self:GetEntityOne():SellPrice())
					SafeRemoveEntity(self:GetEntityOne())
				end
				if self:GetHasEntityTwo() then
					caller:addMoney(self:GetEntityTwo():SellPrice())
					SafeRemoveEntity(self:GetEntityTwo())
				end
				if self:GetHasEntityThree() then
					caller:addMoney(self:GetEntityThree():SellPrice())
					SafeRemoveEntity(self:GetEntityThree())
				end
				SafeRemoveEntity(self)
			end
		end
	end
end
