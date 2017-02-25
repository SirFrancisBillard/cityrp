AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bank Vault"
ENT.Category = "Bank Robbery"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/props/cs_assault/MoneyPallet.mdl"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "BeingRobbed")
	self:NetworkVar("Int", 0, "Cooldown")
	self:NetworkVar("Int", 1, "Money")
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
			phys:SetMass(200)
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
		self:SetMoney(80000)
	end
	function ENT:Think()
		if (self:GetMoney() < 1) then
			self:SetBeingRobbed(false)
		end
		if self:GetBeingRobbed() then
			local amount
			if (self:GetMoney() < 10000) then
				amount = self:GetMoney()
			else
				amount = 10000
			end
			self:SetMoney(self:GetMoney() - amount)
			local bag = ents.Create("bank_briefcase")
			bag:SetPos(self:GetPos() + Vector(0, 0, 100))
			bag:Spawn()
			bag:SetMoney(amount)
		else
			self:SetMoney(math.Clamp(self:GetMoney() + 250, 0, 1000000))
			self:SetCooldown(math.Clamp(self:GetCooldown() - 1, 0, self:GetCooldown()))
		end
		self:NextThink(CurTime() + 1)
		return true
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if not caller.isCP then return end
			if caller:isCP() then
				ply:ChatPrint("Only criminals can rob vaults!")
			else
				if self:GetBeingRobbed() then
					caller:ChatPrint("This vault is currently being robbed!")
				else
					if (self:GetCooldown() <= 0) then
						self:SetCooldown(360)
						self:SetBeingRobbed(true)
						timer.Simple(30, function()
							if (not IsValid(self)) then return end
							self:SetBeingRobbed(false)
						end)
						BroadcastLua([[chat.AddText(Color(255, 0, 0), "The Bank Vault is being robbed!")]])
					else
						caller:ChatPrint("Please wait "..self:GetCooldown().." seconds.")
					end
				end
			end
		end
	end
end

if CLIENT then
	surface.CreateFont("BankVaultFont", {
		font = "Trebuchet",
		size = 48,
	})
	function ENT:Draw()
		self:DrawModel()
		
		local pos = self:GetPos()
		local ang = self:GetAngles()


		local stuff = {}

		stuff[#stuff + 1] = {content = ("$"..string.Comma(self:GetMoney())), color = Color(0, 255, 0)}
		stuff[#stuff + 1] = {content = self:GetBeingRobbed() and "Robbery in progress" or ((self:GetCooldown() <= 0) and "Ready to be robbed!" or "Cooldown: "..self:GetCooldown()), color = Color(255, 0, 0)}
		stuff[#stuff + 1] = {content = self.PrintName, color = Color(255, 255, 255)}

		cam.Start3D2D(pos + (ang:Up() * 60), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.125)
			for k, v in pairs(stuff) do
				draw.SimpleTextOutlined(v.content, "BankVaultFont", 0, -100 - (45 * (k - 1)), v.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25))
			end
		cam.End3D2D()
	end
end
