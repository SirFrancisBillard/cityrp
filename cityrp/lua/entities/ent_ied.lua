AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "IED"
ENT.Category = "Bombs"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/props_junk/metalgascan.mdl"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Planted")
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	self:SetPlanted(false)
end

if SERVER then
	function ENT:Explode()
		local boom = EffectData()
		boom:SetOrigin(self:GetPos())
		util.Effect("Explosion", boom)
		util.BlastDamage(self, self, self:GetPos(), 512, 125)
		for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), 128)) do
			if v:GetClass() == "prop_physics" then
				constraint.RemoveAll(v)
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					phys:EnableMotion(true)
					phys:Wake()
				end
			elseif v:GetClass() == "func_door" or v:GetClass() == "func_door_rotating" or v:GetClass() == "prop_door_rotating" then
				v:Fire("Unlock")
				v:Fire("Open")
			end
		end
		local blaze = ents.Create("ent_fire")
		blaze:SetPos(self:GetPos())
		blaze:Spawn()
		SafeRemoveEntity(self)
	end

	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() and not self:GetPlanted() then
			self:SetPlanted(true)
			self:EmitSound(Sound("weapons/c4/c4_plant.wav"))
			for i = 1, 10, 0.5 do
				timer.Simple(i, function()
					if not IsValid(self) then return end
					self:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
				end)
			end
			timer.Simple(10.5, function()
				if not IsValid(self) then return end
				self:Explode()
			end)
		end
	end
else
	local childEnts = {
		{
			ang = Angle(-0.71043199300766, 89.247634887695, 0.92707043886185),
			mdl	= "models/props_junk/propane_tank001a.mdl",
			pos	= Vector(6.956591129303, -3.6574130058289, 1.3440700769424),
		},
		{
			ang	= Angle(-0.84790033102036, 86.216766357422, 0.92841762304306),
			mdl	= "models/props_junk/propane_tank001a.mdl",
			pos	= Vector(6.7806782722473, 4.2794122695923, 1.3085737228394),
		},
	--	{
	--		ang	= Angle(-89.998901367188, 177.32270812988, 0),
	--		mdl	= "models/weapons/w_c4.mdl",
	--		pos	= Vector(9.0503721237183, -0.35993930697441, 7.3240814208984),
	--	},
		{
			ang	= Angle(-0.0014814040623605, -8.2703456878662, -89.999572753906),
			mdl	= "models/props_lab/reciever01d.mdl",
			pos	= Vector(2.7293961048126, 11.237145423889, 1.6811606884003),
		},
		{
			ang	= Angle(-2.0977239608765, 90.672309875488, 2.1830611228943),
			mdl	= "models/props_c17/trappropeller_lever.mdl",
			pos	= Vector(5.5323352813721, 3.9967401027679, 18.92527961731),
		},
		{
			ang	= Angle(-1.9546107053757, 178.92985534668, -8.3510999679565),
			mdl	= "models/items/grenadeammo.mdl",
			pos	= Vector(0.12789961695671, -6.145797252655, 10.323998451233),
		},
		{
			ang	= Angle(-1.225460767746, 117.96973419189, -179.49627685547),
			mdl	= "models/props_canal/mattpipe.mdl",
			pos	= Vector(4.5169386863708, -8.3076028823853, -0.39293086528778),
		},
	}

	function ENT:Initialize()
		self.m_tblEnts = {}

		for k, v in pairs( childEnts ) do
			-- pin pulled
			if self:GetPlanted() and v.mdl == "models/props_c17/trappropeller_lever.mdl" then continue end

			local ent = ClientsideModel( v.mdl, RENDERGROUP_BOTH )
			ent:SetPos( self:LocalToWorld(v.pos) )
			ent:SetAngles( self:LocalToWorldAngles(v.ang) )
			ent:SetParent( self )
			self.m_tblEnts[ent] = k
		end
	end

	function ENT:OnRemove()
		for k, v in pairs( self.m_tblEnts ) do
			k:Remove()
		end
	end

	function ENT:Draw()
		for k, v in pairs( self.m_tblEnts ) do
			if IsValid( k ) and IsValid( k:GetParent() ) then break end
			if not IsValid( k ) then continue end

			k:SetPos( self:LocalToWorld(childEnts[v].pos) )
			k:SetAngles( self:LocalToWorldAngles(childEnts[v].ang) )
			k:SetParent( self )
		end		

		self:DrawModel()
	end
end
