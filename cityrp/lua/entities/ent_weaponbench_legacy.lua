ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Weapon Bench"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.Category = "Weapon Crafting (Legacy)"

AddCSLuaFile()

function ENT:Initialize()

	self:GenerateWeapons()
	

	if SERVER then
	
		self:SetModel("models/props_combine/breendesk.mdl") 
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
			phys:SetMass(50)
		end
		
		self:SetNWInt("ScrapCount",0)
		self:SetNWFloat("BuildPercent",0)
		
		self.Building = false
		
		
		
		--self:SpawnWeapon()
		
	end
	
	
	if CLIENT then
		self.ClientProp = ents.CreateClientProp("models/hunter/plates/plate1x1.mdl")
		self.ClientProp:SetPos(self:GetPos() + self:GetUp()*40)
		self.ClientProp:SetAngles(self:GetAngles())
		self.ClientProp:SetParent(self)
		self.ClientProp:SetMaterial("models/wireframe")
		--self.ClientProp:SetModelScale(5)
		self.ClientProp:Spawn()
		
		print(self.ClientProp)
		
		
		
	end
	
	self.NextTick = 0
	self.SpawnTime = CurTime()
	
	
end




function ENT:GenerateWeapons()


	self.CSSWeaponsTable = {}

	for k,v in pairs(weapons.GetList()) do

		if v.Base == "weapon_cs_base" then
		
			if v.WeaponType	~= "Free" and v.WeaponType ~= "Throwable" then
			
				table.Add(self.CSSWeaponsTable,{v.ClassName})
				
			end
				
		end
			
	end

end



function ENT:PhysicsCollide(data, physobj)


end

function ENT:Use(activator,caller,useType,value)
	if self:GetNWFloat("BuildPercent",0) == 0 and self:GetNWInt("ScrapCount",0) >= 4 then
		self:SetNWFloat("BuildPercent",1)
		self:SetNWInt("ScrapCount",self:GetNWInt("ScrapCount",4) - 4)
		self.Building = true
	end
end


function ENT:Think()

	if SERVER then
		if self.Building == true then
			if self.NextTick <= CurTime() then
			
				local AddBuild = self:GetNWFloat("BuildPercent",0) + math.random(1,2)
			
				if AddBuild >= 100 then
					self.Building = false
					self:SpawnWeapon()
					self:SetNWFloat("BuildPercent",0)
				else
					self:SetNWFloat("BuildPercent",AddBuild)
					--self:EmitSound("ambient/machines/pneumatic_drill_"..math.random(1,4)..".wav")
				end

				self.NextTick = CurTime() + 0.25
				
			end
		end
	end
	
	if CLIENT then
		if self.NextTick <= CurTime() then
			local Choice = self.CSSWeaponsTable[math.random(1,table.Count(self.CSSWeaponsTable))]
			self.ClientProp:SetModel(weapons.GetStored(Choice).WorldModel)
			self.NextTick = CurTime() + 2
		end
		
		local Vec,Ang = LocalToWorld(Vector(0,0,0),Angle(0,CurTime()*180,0),self:GetPos(),self:GetAngles())

		self.ClientProp:SetAngles(Ang)
	end
	
	
end





function ENT:Draw()
	if CLIENT then
		self:DrawModel()

		local AdjVec, AdjAng = LocalToWorld(Vector(0,0,self:OBBMaxs().z),Angle(0,90,0),self:GetPos(),self:GetAngles())

		if not self.PulseOne then
			self.PulseOne = 0
		end

		if self.PulseOne <= 255 then
			self.PulseOne = self.PulseOne + (255*RealFrameTime())
		else
			self.PulseOne = 0
		end

		local ObjectNameText = "[WEAPON WORKBENCH]"
		local InsertScrapText = "[INSERT SCRAP]"
		local PressEText = "[PRESS E]"
		local BuildPercentText = self:GetNWFloat("BuildPercent",0) .. "%"
		local ScrapCountText = "[Scrap: ".. self:GetNWInt("ScrapCount",0) .."/4]"

		cam.Start3D2D( AdjVec, AdjAng  , 0.1 )
			surface.SetFont( "LargeWeaponFont" )
			local Width,Height = surface.GetTextSize( ObjectNameText )
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( -Width/2, -Height/2 - self:OBBMaxs().y*4 )
			surface.DrawText( ObjectNameText )

			if self:GetNWFloat("BuildPercent",0) == 0 and self:GetNWInt("ScrapCount",0) < 4 then
				local Width,Height = surface.GetTextSize( InsertScrapText )
				surface.SetTextPos( -Width/2, -Height/2 )
				surface.SetTextColor( 255, 255, 255, self.PulseOne )
				surface.DrawText( InsertScrapText )
			elseif self:GetNWFloat("BuildPercent",0) == 0 and self:GetNWInt("ScrapCount",0) >= 4 then
				local Width,Height = surface.GetTextSize( PressEText )
				surface.SetTextPos( -Width/2, Height/2 )
				surface.SetTextColor( 255, 255, 255, self.PulseOne )
				surface.DrawText( PressEText )
			else
				local Width,Height = surface.GetTextSize( BuildPercentText )
				surface.SetTextPos( -Width/2, -Height/2 )
				surface.SetTextColor( 255, 255, 255, 255 )
				surface.DrawText( BuildPercentText )
			end

			surface.SetFont( "SmallWeaponFont" )
			local Width,Height = surface.GetTextSize( ScrapCountText )
			surface.SetTextPos( -Width/2, -Height/2 + self:OBBMaxs().y*4 )

			if self:GetNWInt("ScrapCount",0) < 4 and self:GetNWFloat("BuildPercent",0) == 0 then
				surface.SetTextColor( 255, 255, 255, self.PulseOne )
			else
				surface.SetTextColor( 255, 255, 255, 255 )
			end

			surface.DrawText( ScrapCountText )
		cam.End3D2D()
	end
end




function ENT:SpawnWeapon()

	local Choice = self.CSSWeaponsTable[math.random(1,table.Count(self.CSSWeaponsTable))]
	
	local gun = ents.Create("spawned_weapon")
	gun:SetModel(weapons.GetStored(Choice).WorldModel)
	gun:SetWeaponClass(Choice)
	gun:SetPos(self:GetPos() + self:GetUp()*40)
	gun.ShareGravgun = true
	gun.nodupe = true
	gun:Spawn()
	self.sparking = true

end

function ENT:OnRemove()

	SafeRemoveEntity(self.ClientProp)

end