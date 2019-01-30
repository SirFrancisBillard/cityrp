AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Gas"
ENT.Category = "Crime+"
ENT.Spawnable = true
ENT.Model = "models/props_junk/propane_tank001a.mdl"

ENT.IsStoveGas = true

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
		phys:SetMass(40)
	end
	self:SetFuel(200)
	self:SetBoom(40)
	self:SetLastStove(CurTime())
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Up(), 90)
	self:SetAngles(Ang)
end
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "HasStove")
	self:NetworkVar("Entity", 0, "Stove")
	self:NetworkVar("Float", 0, "LastStove")
	self:NetworkVar("Int", 0, "Fuel")
	self:NetworkVar("Int", 1, "Boom")
end
function ENT:IsReadyForStove()
	return ((CurTime() - self:GetLastStove()) > 2)
end

if SERVER then
	function ENT:Think()
		local phys = self:GetPhysicsObject()
		if self:GetHasStove() and IsValid(phys) then
			phys:SetMass(1)
		elseif IsValid(phys) then
			phys:SetMass(40)
		end
	end
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() and (self:GetFuel() <= 0) and (not self:GetHasStove()) then
			SafeRemoveEntity(self)
		end
		if IsValid(caller) and caller:IsPlayer() and self:GetHasStove() then
			self:SetHasStove(false)
			self:GetStove():SetHasCanister(false)
			constraint.RemoveAll(self)
			self:EmitSound("physics/metal/metal_barrel_impact_soft"..math.random(1, 4)..".wav")
			self:SetLastStove(CurTime())
		end
	end
	function ENT:OnRemove()
		if (not self:GetHasStove()) then return end
		self:SetHasStove(false)
		self:GetStove():SetHasCanister(false)
		constraint.RemoveAll(self)
		self:EmitSound("physics/metal/metal_barrel_impact_soft"..math.random(1, 4)..".wav")
		self:SetLastStove(CurTime())
	end
	function ENT:OnTakeDamage(dmg)
		if (self:GetFuel() < 2) then return end
		self:SetBoom(self:GetBoom() - dmg:GetDamage())
		if (self:GetBoom() <= dmg:GetDamage()) then
			self:Explode()
		end
	end
	function ENT:Explode()
		if (self:GetFuel() < 2) then return end
		local ExplosionSize = (self:GetFuel() / 2)
		local explosion = ents.Create("env_explosion")			
		explosion:SetPos(self:GetPos())
		explosion:SetKeyValue("iMagnitude", ExplosionSize)
		explosion:Spawn()
		explosion:Activate()
		explosion:Fire("Explode", 0, 0)
		local shake = ents.Create("env_shake")
		shake:SetPos(self:GetPos())
		shake:SetKeyValue("amplitude", (ExplosionSize * 2))
		shake:SetKeyValue("radius", ExplosionSize)
		shake:SetKeyValue("duration", "1.5")
		shake:SetKeyValue("frequency", "255")
		shake:SetKeyValue("spawnflags", "4")
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)
		if self:GetHasStove() then
    		self:SetHasStove(false)
    		self:GetStove():SetHasCanister(false)
    		constraint.RemoveAll(self)
		end
		SafeRemoveEntity(self)
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Up(), 180)

		cam.Start3D2D(Pos + (Ang:Up() * 4.5) + (Ang:Right() * -6) + (Ang:Forward() * 4), Ang, 0.12)
			draw.RoundedBox(2, -50, -65, 30, 200, Color(140, 0, 0, 100))
			if (self:GetFuel() > 0) then
				draw.RoundedBox(2, -50, -65, 30, self:GetFuel(), Color(0, 225, 0, 100))
			end
		cam.End3D2D()
	end
end