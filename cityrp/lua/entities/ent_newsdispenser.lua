AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Newspaper Dispenser"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/props/CS_militia/newspaperstack01.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if caller:HasWeapon("weapon_newspaper") then
				caller:ChatPrint("You already have a newspaper.")
			else
				if caller:canAfford(5) then
					caller:addMoney(-5)
					caller:Give("weapon_newspaper")
					caller:ChatPrint("You have bought a newspaper for " .. DarkRP.formatMoney(5) .. ".")
					self:EmitSound("ambient/office/coinslot1.wav")
				else
					caller:ChatPrint("You can't even afford a newspaper... Get a job, loser.")
				end
			end
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
