AddCSLuaFile()

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Oil Dealer"
ENT.Category = "Oil"
ENT.Spawnable = true
ENT.Model = "models/player/odessa.mdl"
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetModel(self.Model)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetNPCState(NPC_STATE_SCRIPT)
		self:SetSolid(SOLID_BBOX)
		self:SetUseType(SIMPLE_USE)
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:DropToFloor()
		self:CapabilitiesAdd(CAP_ANIMATEDFACE || CAP_TURN_HEAD)
		self:SetMaxYawSpeed(90)
	end
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			local randy = math.random(1, 5)
			if (randy == 1) then
				caller:ChatPrint("Hey there!")
			elseif (randy == 2) then
				caller:ChatPrint("You got me some oil?")
			elseif (randy == 3) then
				caller:ChatPrint("Come back when you get some oil!")
			elseif (randy == 4) then
				caller:ChatPrint("I only accept genuine oil.")
			elseif (randy == 5) then
				caller:ChatPrint("I pay big bucks for it.")
			end
		end
	end
end

function ENT:Think()
	self:SetSequence("idle_all_02")
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)
		
		cam.Start3D2D(self:GetPos() + (self:GetUp() * 100), Ang, 0.35)
			draw.SimpleText("Oil Dealer", "Trebuchet24", 0, 0, Color(255, 0,0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("Bring me oil for cash", "Trebuchet24", 0, 40, Color(255, 0,0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		cam.End3D2D()
	end
end
