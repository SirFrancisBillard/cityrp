AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Vending Machine"
ENT.Spawnable = true
ENT.Model = "models/props_interiors/VendingMachineSoda01a.mdl"

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysWake()

		self.LastUse = 0
	end

	function ENT:Use(ply, activator)
		if CurTime() - self.LastUse < 5 then return end

		self.LastUse = CurTime()

		self:EmitSound("ambient/office/coinslot1.wav", 50, 100)

		timer.Simple(1.5, function()
			if not IsValid(self) then return end
			self:CreateSoda()
		end)
	end

	function ENT:CreateSoda()
		local pos, ang = LocalToWorld(Vector(20, -5, -30), Angle(-90, -90, 0), self:GetPos(), self:GetAngles())
		local soda = ents.Create("ent_soda")
		soda:SetPos(pos)
		soda:SetAngles(ang)
		soda:Spawn()
	end
end
