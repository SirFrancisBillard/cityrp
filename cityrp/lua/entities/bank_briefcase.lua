AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Bag"
ENT.Category = "Bank Robbery"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/props_c17/SuitCase_Passenger_Physics.mdl"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "CanCollect")
	self:NetworkVar("Int", 0, "Money")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass(60)
		end
		self:SetUseType(SIMPLE_USE)

		self:SetCanCollect(false)
	end

	function ENT:Think()
		local nope = false
		for k, v in pairs(ents.FindByClass("bank_vault")) do
			if self:GetPos():Distance(v:GetPos()) < 1600 then
				nope = true
			end
		end
		self:SetCanCollect(nope)

		if self:GetMoney() < 1 then
			SafeRemoveEntity(self)
		end

		self:NextThink(CurTime() + 1)
		return true
	end

	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if self:GetCanCollect() the 
				local amount
				if (self:GetMoney() < 1000) then
					amount = self:GetMoney()
				else
					amount = 1000
				end

				self:SetMoney(self:GetMoney() - amount)
				DarkRP.createMoneyBag(self:GetPos() + Vector(0, 0, 12), amount)

				if self:GetMoney() < 1 then
					SafeRemoveEntity(self)
				end
			else
				ply:ChatPrint("You are too close to the bank vault!")
			end
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local pos = self:GetPos()
		local maxs = self:LocalToWorld(self:OBBMaxs())
		local mins = self:LocalToWorld(self:OBBMins())
		local ang = self:GetAngles()
		local top

		if (maxs.z > mins.z) then
			top = maxs.z
		else
			top = mins.z
		end

		local stuff = {}

		stuff[#stuff + 1] = {content = ("$" .. string.Comma(self:GetMoney())), color = Color(0, 255, 0)}
		stuff[#stuff + 1] = {content = self.PrintName, color = Color(255, 255, 255)}

		cam.Start3D2D(Vector(pos.x, pos.y, pos.z + (top - pos.z) - 8), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.125)
			for k, v in pairs(stuff) do
				draw.SimpleTextOutlined(v.content, "Trebuchet24", 0, -100 - (35 * (k - 1)), v.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25))
			end
		cam.End3D2D()
	end
end
