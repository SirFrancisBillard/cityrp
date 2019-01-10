AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Dumpster Diving Base Entity"
ENT.Category = "Dumpster Diving"
ENT.Spawnable = false 
ENT.Model = "models/Items/combine_rifle_ammo01.mdl"
ENT.Size = 1

DUMPSTER_DIVING_STUFF = {
	{class = "spawned_money", func = function(ent) ent:Setamount(math.random(1, 100)) end},
	{class = "spawned_money", func = function(ent) ent:Setamount(math.random(1, 100)) end},
	{class = "spawned_money", func = function(ent) ent:Setamount(math.random(1, 100)) end},
	{class = "spawned_money", func = function(ent) ent:Setamount(math.random(1, 100)) end},
	{class = "spawned_money", func = function(ent) ent:Setamount(math.random(1, 100)) end},
	{class = "spawned_money", func = function(ent) ent:Setamount(math.random(100, 1000)) end},
	{class = "item_ammo_pistol", func = function(ent) end},
	{class = "item_ammo_smg1", func = function(ent) end},
	{class = "item_box_buckshot", func = function(ent) end},
	{class = "item_battery", func = function(ent) end},
	{class = "item_healthvial", func = function(ent) end}
}

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Cooldown")
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
			phys:SetMass(self.Size * 10)
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
		if self.ExtraInit then
			self:ExtraInit()
		end
	end
	function ENT:Think()
		self:SetCooldown(math.Clamp(self:GetCooldown() - 1, 0, self:GetCooldown()))
		self:NextThink(CurTime() + 1)
		return true
	end
	function ENT:Use(activator, caller)
		if (self:GetCooldown() == 0) then
			self:SetCooldown(120)
			local thing = DUMPSTER_DIVING_STUFF[math.random(1, #DUMPSTER_DIVING_STUFF)]
			local ent = ents.Create(thing.class)
			ent:SetPos(self:GetPos() + Vector(0, 0, self.Size * 12))
			ent:Spawn()
			thing.func(ent)
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
		
		cam.Start3D2D(Vector(pos.x, pos.y, pos.z + (top - pos.z) - 8), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.125)
			draw.SimpleTextOutlined((self:GetCooldown() > 0) and ("Please wait "..self:GetCooldown().." seconds.") or ("Press "..string.upper(input.LookupBinding("+use", true)).." to rummage."), "Trebuchet24", 8, -98, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end