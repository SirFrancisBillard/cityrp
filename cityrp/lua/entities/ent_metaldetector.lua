AddCSLuaFile()

ENT.Type 		= "anim" 
ENT.Base		= "base_anim" 

ENT.PrintName	= "Metal Detector"
ENT.Spawnable	= true
ENT.MaxHealth 	= 150

function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "Mode")
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/interior_fence002e.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		
		self:PhysWake()
		self:SetMode(1)

		self:SetMaterial("phoenix_storms/gear")
	end
	function ENT:Pass()
		self:SetMode(2)
		self:EmitSound("HL1/fvox/bell.wav")
		timer.Simple(0.75, function()
			if IsValid(self) then
				self:SetMode(1)
			end
		end)
	end

	function ENT:Alarm()
		self:SetMode(3)
		for i = 1, 3 do
			timer.Simple(i - 1, function()
				if IsValid(self) then
					self:EmitSound("ambient/alarms/klaxon1.wav")
					if (i == 3) then
						self:SetMode(1)
					end
				end
			end)
		end
	end

	local vec = Vector(0,0,30)
	function ENT:Think()
		local cen = self:OBBCenter()
		local real = self:LocalToWorld(Vector(cen.x, cen.y, self:OBBMins().z)) + vec

		for k, v in ipairs(ents.FindInSphere(self:GetPos(), 35)) do
			if v:IsPlayer() and ((not v.LastChecked) or (v.LastChecked <= CurTime())) and (v:GetPos():Distance(real) < 35) then
				v.LastChecked = CurTime() + 2
				for k, v in ipairs(v:GetWeapons()) do
					if v:IsIllegalWeapon() then
						self:Alarm()
						self:NextThink(CurTime() + 2)
						return
					end
				end
				self:Pass()
				self:NextThink(CurTime() + 1)
			end
		end
	end
else
	local colors = {
		color_black,
		Color(0, 255, 0),
		Color(255, 0, 0),
	}

	function ENT:Draw()
		self:DrawModel()

		local ang = self:GetAngles()

		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)

		cam.Start3D2D(self:GetPos() + ang:Up() * 0.65, ang, 0.1)
			draw.Box(-225, -606, 460, 144, colors[self:GetMode()])
		cam.End3D2D()
	end
end
