AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "ZigPrint Base"
ENT.Category = "ZigPrint"
ENT.Spawnable = true
ENT.Model = "models/props_c17/consolebox01a.mdl"

ENT.Print = ENT.Print or {}
ENT.Print.Max = ENT.Print.Max or {}
ENT.Display = ENT.Display or {}
ENT.Print.Amount = ENT.Print.Amount or 250
ENT.Print.Time = ENT.Print.Time or 60
ENT.Print.Max.Ink = ENT.Print.Max.Ink or 10
ENT.Print.Max.Batteries = ENT.Print.Max.Ink or 10
ENT.Display.Background = ENT.Display.Background or Color(255, 100, 100)
ENT.Display.Border = ENT.Display.Border or Color(255, 0, 0)
ENT.Display.Text = ENT.Display.Text or Color(255, 255, 255)

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
	self:SetStoredMoney(0)
	self:SetPrintingProgress(0)
	self:SetInk(0)
	self:SetBatteries(0)
end
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "StoredMoney")
	self:NetworkVar("Int", 1, "PrintingProgress")
	self:NetworkVar("Int", 2, "Ink")
	self:NetworkVar("Int", 3, "Batteries")
end
function ENT:StartSound()
	self.Noise = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
	self.Noise:SetSoundLevel(50)
	self.Noise:PlayEx(1, 50)
end
function ENT:CanPrint()
	return (self:GetInk() > 0) and (self:GetBatteries() > 0)
end
function ENT:OnRemove()
	if self.Noise then
		self.Noise:Stop()
	end
end
function ENT:PrinterError()
	if (self:GetInk() < 1) then
		return "No ink"
	end
	if (self:GetBatteries() < 1) then
		return "No battery"
	end
	return false
end

if SERVER then
	function ENT:StartTouch(ent)
		if IsValid(ent) then
			if (ent:GetClass() == "zig_ink") and (self:GetInk() < self.Print.Max.Ink) then
				SafeRemoveEntity(ent)
				self:SetInk(math.Clamp(self:GetInk() + 1, 0, self.Print.Max.Ink))
				self:EmitSound("ambient/water/drip" .. math.random(1, 4) .. ".wav")
			end
			if (ent:GetClass() == "zig_battery") and (self:GetBatteries() < self.Print.Max.Batteries) then
				SafeRemoveEntity(ent)
				self:SetBatteries(math.Clamp(self:GetBatteries() + 1, 0, self.Print.Max.Batteries))
				self:EmitSound("items/battery_pickup.wav")
			end
		end
	end
	function ENT:Think()
		if self:CanPrint() then
			self.RealPrintTime = self.Print.Time - (5 * self:GetBatteries())
			self.RealPrintAmount = self.Print.Amount + (10 * self:GetInk())
			if (self.RealPrintTime < 1) then
				self.RealPrintTime = 1
			end
			if self:CanPrint() then
				self:SetPrintingProgress(math.Clamp(self:GetPrintingProgress() + 1, 0, self.RealPrintTime))
				self:StartSound()
			end
			if (self:GetPrintingProgress() == self.RealPrintTime) then
				self:SetPrintingProgress(0)
				self:SetStoredMoney(math.Clamp(self:GetStoredMoney() + self.RealPrintAmount, 0, 2000000000))
			end
		end
		self:NextThink(CurTime() + 1)
		return true
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() and self:GetStoredMoney() > 0 then
			caller:addMoney(self:GetStoredMoney())
			self:SetStoredMoney(0)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		local Ang2 = self:GetAngles()

		surface.SetFont("Trebuchet24")

		Ang:RotateAroundAxis(Ang:Up(), 90)
		Ang2:RotateAroundAxis(Ang2:Up(), 90)
		Ang2:RotateAroundAxis(Ang2:Forward(), 90)

		local PrinterWidth = 130
		local FrontHeight = 40
		local BorderWidth = 20
		local BorderColor = self.Display.Border or Color(255, 0, 0)
		local BackgroundColor = self.Display.Background or Color(255, 100, 100)
		local TextColor = self.Display.Text or Color(255, 255, 255)

		local SingleDouble = -PrinterWidth + (BorderWidth * 2)

		local prog = math.ceil(Lerp(self:GetPrintingProgress() / math.max(self.Print.Time - (5 * self:GetBatteries()), 1), 0, 100))
		local err = self:PrinterError()

		cam.Start3D2D(Pos + Ang:Up() * 11.5, Ang, 0.11)
			draw.RoundedBox(2, -PrinterWidth, -PrinterWidth, PrinterWidth * 2, PrinterWidth * 2, BorderColor)
			draw.RoundedBox(2, -PrinterWidth + BorderWidth, -PrinterWidth + BorderWidth, (PrinterWidth * 2) - (BorderWidth * 2), (PrinterWidth * 2) - (BorderWidth * 2), BackgroundColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 0), "Money: $" .. string.Comma(self:GetStoredMoney()), "Trebuchet24", BorderColor, TextColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 1), "Progress: " .. prog .. "%", "Trebuchet24", BorderColor, TextColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 2), "Ink: " .. self:GetInk(), "Trebuchet24", BorderColor, TextColor)
			draw.WordBox(2, SingleDouble, SingleDouble + (40 * 3), "Batteries: " .. self:GetBatteries(), "Trebuchet24", BorderColor, TextColor)
			if err then
				draw.WordBox(2, SingleDouble, SingleDouble + (40 * 4), err, "Trebuchet24", BorderColor, TextColor)
			end
		cam.End3D2D()
		cam.Start3D2D(Pos + (Ang2:Up() * 17) + (Ang2:Right() * 4), Ang2, 0.11)
			draw.RoundedBox(2, -PrinterWidth, -PrinterWidth, PrinterWidth * 2, FrontHeight * 2, BorderColor)
			draw.RoundedBox(2, -PrinterWidth + BorderWidth, -PrinterWidth + BorderWidth, (PrinterWidth * 2) - (BorderWidth * 2), (FrontHeight * 2) - (BorderWidth * 2), BackgroundColor)
			draw.WordBox(2, SingleDouble, SingleDouble - 13, self.PrintName, "Trebuchet24", BorderColor, TextColor)
		cam.End3D2D()
	end
end
