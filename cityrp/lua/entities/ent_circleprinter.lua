/*---------------------------------------------------------------------------
Tomas
---------------------------------------------------------------------------*/
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "Tomas"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")

	self.CrclCfg = {}--Keep this

	self.CrclCfg.Name = "Flepoch Printer" -- The name of the printer...
	self.CrclCfg.FireUpChance = 50 -- Printer break chance
	self.CrclCfg.MaxMoney = 4000 -- Max money that it can hold
	self.CrclCfg.PrintInterval = 10 -- Interval in sec that it prints
	self.CrclCfg.PrintRate = 100 -- Prints this amount of the money if it have 100% upgraded speed + exp money added to this 1lvl = 1/4 of this number
	self.CrclCfg.SpeedUpgradePrice = 100 -- Price for the speed upgrade
	self.CrclCfg.CoolingUpgradePrice = 1000 -- Price for the cooling upgrade
	self.CrclCfg.PlusSpeed = 20 -- If you push upgrade speed it will upgrade that much
	self.CrclCfg.ModelColor = Color(47, 56, 90, 255) -- Printer main model color
	self.CrclCfg.ComputerPartColor = Color(255, 255, 255, 255) -- Printer front computer part color
	self.CrclCfg.FanCaseColor = Color(27, 27, 27, 255) -- Printer front Fan case color
	self.CrclCfg.FanColor = Color(166, 166, 166, 255) -- Printer front Fan color
	self.CrclCfg.ModelMaterial = "models/debug/debugwhite" -- Printer main model material. Type "nomat" for no material
	self.CrclCfg.ComputerPartMaterial = "nomat" -- Printer front computer part material. Type "nomat" for no material
	self.CrclCfg.FanCaseMaterial = "models/debug/debugwhite" -- Printer front Fan case material. Type "nomat" for no material
	self.CrclCfg.FanMaterial = "models/debug/debugwhite" -- Printer front Fan material. Type "nomat" for no material
	self.CrclCfg.OnPrintFunc = function(ply) end -- Printer call this function onPrint so its useful for xp, lvl systems or anything You want +
	self.CrclCfg.PreventWireUsers = false -- It does that what variable name says (Limits use distance to 100 and checks if player is looking at entity)
end

if SERVER then
	util.AddNetworkString( "UPCCS" )

	local function UpdateCircleClientSide(ent)
		local tabls = {}
		tabls.Money = ent.Money
		tabls.Speed = ent.Speed
		tabls.Heat = ent.Heat
		tabls.Cooler = ent.Cooler
		tabls.PlusMoney = ent.PlusMoney
		tabls.LvlExp = ent.LvlExp
		tabls.NextPrint = ent.NextPrint
		tabls.PrintRate = ent.PrintRate

		net.Start( "UPCCS" )
			net.WriteTable( tabls )
			net.WriteEntity( ent )
		net.Broadcast()	
	end

	function ENT:Initialize()
		self:SetUseType(SIMPLE_USE)
		self:SetModel("models/props_c17/consolebox01a.mdl")
		
		self.ModelColor = Color(47, 56, 90, 255)
		self.ModelMaterial = "models/debug/debugwhite"

		if self.CrclCfg.ModelMaterial then self.ModelMaterial = self.CrclCfg.ModelMaterial end
		if self.CrclCfg.ModelColor then self.ModelColor = self.CrclCfg.ModelColor end

		if self.ModelMaterial != "nomat" then
			self:SetMaterial( self.ModelMaterial )
		end

		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:SetColor(self.ModelColor)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		phys:Wake()
		self.Working = true
		self.PlayerPressedE = true

		self.MaxMoney = 5000
		self.PlusMoney = 100
		self.PrintRate = 10
		self.PlusSpeed = 20
		self.SpeedPrice = 500
		self.CoolerPrice = 1000

		self.Money = 0 -- Startup things
		self.Speed = 20
		self.Heat = 0
		self.Cooler = false

		self.LvlExp = 100

		if self.CrclCfg.MaxMoney then self.MaxMoney = self.CrclCfg.MaxMoney end
		if self.CrclCfg.PrintRate then self.PlusMoney = self.CrclCfg.PrintRate end
		if self.CrclCfg.PrintInterval then self.PrintRate = self.CrclCfg.PrintInterval end
		if self.CrclCfg.PlusSpeed then self.PlusSpeed = self.CrclCfg.PlusSpeed end
		if self.CrclCfg.SpeedUpgradePrice then self.SpeedPrice = self.CrclCfg.SpeedUpgradePrice end
		if self.CrclCfg.CoolingUpgradePrice then self.CoolerPrice = self.CrclCfg.CoolingUpgradePrice end

		timer.Simple(1, function() 
			if IsValid(self) then 
				self.NextPrint = CurTime() + self.PrintRate
				UpdateCircleClientSide(self)
			end 
		end)
		timer.Simple(self.PrintRate, function() if IsValid(self) then self:Work() end end)
	end

	function ENT:AddMoney( amnt )
		if IsValid(self) then
			if self.Money < self.MaxMoney then
				self.Money = self.Money + (self.Speed/100*amnt)
				if self.Money > self.MaxMoney then
					self.Money = self.MaxMoney
				end
			end
		end
	end
	function ENT:Upgrade( item )
		if IsValid(self) then
			if item == "cooler" and self.Cooler == false then
				self.Cooler = true
			elseif item == "speed" and self.Speed < 100 then
				self.Speed = self.Speed + 20
			end
		end
	end

	function ENT:Destruct()
		if IsValid(self:Getowning_ent()) then
			local vPoint = self:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart(vPoint)
			effectdata:SetOrigin(vPoint)
			effectdata:SetScale(1)
			util.Effect("Explosion", effectdata)
			DarkRP.notify(self:Getowning_ent(), 1, 4, "Your money printer exploded")
		end
	end

	function ENT:OnTakeDamage(dmg)
		if self:IsOnFire() then return end

		self.damage = (self.damage or 100) - dmg:GetDamage()
		if self.damage <= 0 then
			self:Destruct()
			self:Remove()
		end
	end
	function ENT:Think()
		if not IsValid(self:Getowning_ent()) then
			self:Destruct()
			self:Remove()
		end

		if self.Working then return end
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(1)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
	end

	function ENT:HeatControll()
		if IsValid(self) then
			if self.Cooler then
				if self.Heat < 90 and self.Speed > 40 then
					self.Heat = self.Heat + 10
				else
					if self.Heat > 0 then
						self.Heat = self.Heat - 10
					end
				end
			else
				if self.Speed > 50 then
					self.Heat = self.Heat + 10
				else
					if self.Heat <= 50 then
						self.Heat = self.Heat + 10
					else
						self.Heat = self.Heat - 10
					end
				end
			end
			if self.Heat >= 100 then
				self:Destruct()
				self:Remove()
			end
		end
	end
	function ENT:BreakControll()
		if math.random(1, self.CrclCfg.FireUpChance) == 3 then
			self.Working = false
			DarkRP.notify( self:Getowning_ent(), 1, 5, "Your money printer is broken! Go fix it!")
		end
	end
	function ENT:Work()
		if IsValid(self) then
			if self.Working then
				self:AddMoney(self.PlusMoney + (math.floor(self.LvlExp/100)*self.PlusMoney/4))
				self.NextPrint = CurTime() + self.PrintRate
				self:HeatControll()
				if self.CrclCfg.OnPrintFunc and IsValid(self:Getowning_ent()) then
					self.CrclCfg.OnPrintFunc(self:Getowning_ent())
				end
				self:BreakControll()
				if self.LvlExp < 900 then
					self.LvlExp = self.LvlExp + 10 -- !
				end
			end
			UpdateCircleClientSide(self)
			timer.Simple(self.PrintRate, function() if IsValid(self) then self:Work() end end)
		end
	end

	local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
		local vWorldPos=vWorldPos-vPos
		vWorldPos:Rotate(Angle(0,-aRot.y,0))
		vWorldPos:Rotate(Angle(-aRot.p,0,0))
		vWorldPos:Rotate(Angle(0,0,-aRot.r))
		return vWorldPos.x/vScale,(-vWorldPos.y)/vScale
	end

	local function inrange(x, y, x2, y2, x3, y3)
		if x > x3 then return false end
		if y < y3 then return false end
		if x2 < x3 then return false end
		if y2 > y3 then return false end
		return true
	end

	function ENT:Use(ply)
		if self.CrclCfg.PreventWireUsers then
			self.trac = util.TraceLine( util.GetPlayerTrace( ply ) )
			self.players = ents.FindInSphere( self:GetPos(), 50 )
			for _, v in pairs(self.players) do
				if v == ply and self.trac.Entity == self then
					self.PlayerPressedE = true
					break
				else
					self.PlayerPressedE = false
				end
			end
		end
		if ply:IsPlayer() and self.PlayerPressedE then
			self.Working = true
			local lookAtX,lookAtY = WorldToScreen(ply:GetEyeTrace().HitPos or Vector(0,0,0),self:GetPos()+self:GetAngles():Up()*1.55, 0.2375, self:GetAngles())
			if inrange(44.45, -36.06, 51.41, -63.11, lookAtX, lookAtY) and ply:getDarkRPVar("money") >= self.SpeedPrice and self.Speed < 100 then
				sound.Play( "buttons/button15.wav", self:GetPos(), 100, 100, 1 )
				ply:addMoney( -self.SpeedPrice )
				DarkRP.notify( ply, 2, 5, "Printer speed has been upgraded!" )
				self.Speed = self.Speed + self.PlusSpeed
				UpdateCircleClientSide(self)
			elseif inrange(52.80, -36.06, 59.69, -63.11, lookAtX, lookAtY) and ply:getDarkRPVar("money") >= self.CoolerPrice and self.Cooler == false then
				sound.Play( "buttons/button15.wav", self:GetPos(), 100, 100, 1 )
				ply:addMoney( -self.CoolerPrice )
				DarkRP.notify( ply, 2, 5, "Printer cooler has been added!" )
				self.Cooler = true
				UpdateCircleClientSide(self)
			elseif self.Money > 0 then
				ply:addMoney( self.Money )
				DarkRP.notify( ply, 0, 5, "You picked up " .. DarkRP.formatMoney(self.Money))
				self.Money = 0
				UpdateCircleClientSide(self)
			end
		end
	end

	function ENT:UClSide()
		if IsValid(self) then
			UpdateCircleClientSide(self)
		end
	end
else
	surface.CreateFont( "SmallInfoFont", {
		font = "Arial",
		size = 12,
		weight = 800,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "InfoFont", {
		font = "Arial",
		size = 17,
		weight = 800,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "BigInfoFont", {
		font = "Arial",
		size = 32,
		weight = 0,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "BiggestInfoFont", {
		font = "Arial",
		size = 30,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )


	function ENT:Initialize()
		self.Money = 0
		self.rot = 0
		self.last = SysTime()
		self.Speed = 20
		self.Heat = 0
		self.PlusMoney = 0
		self.LvlExp = 100
		self.PrintRate = 10
		self.NextPrint = CurTime()

		self.Cooler = false

		self.ComputerPartColor = Color(255, 255, 255, 255)
		self.FanCaseColor = Color(27, 27, 27, 255)
		self.FanColor = Color(166, 166, 166, 255)

		self.ComputerPartMaterial = "nomat"
		self.FanCaseMaterial = "models/debug/debugwhite"
		self.FanMaterial = "models/debug/debugwhite"

		if self.CrclCfg.ComputerPartColor then self.ComputerPartColor = self.CrclCfg.ComputerPartColor end
		if self.CrclCfg.FanCaseColor then self.FanCaseColor = self.CrclCfg.FanCaseColor end
		if self.CrclCfg.FanColor then self.FanColor = self.CrclCfg.FanColor end
		if self.CrclCfg.ComputerPartMaterial then self.ComputerPartMaterial = self.CrclCfg.ComputerPartMaterial end
		if self.CrclCfg.FanCaseMaterial then self.FanCaseMaterial = self.CrclCfg.FanCaseMaterial end
		if self.CrclCfg.FanMaterial then self.FanMaterial = self.CrclCfg.FanMaterial end


		self.CoreComputer = ents.CreateClientProp()
		self.CoreComputer:SetPos( self:GetPos() + self:GetAngles():Right() * 3.3 + self:GetAngles():Forward() * 10.6 + self:GetAngles():Up() * 3.7 )
		self.CoreComputer:SetModel( "models/props_lab/reciever01a.mdl" )
		self.CoreComputer:SetAngles(self:GetAngles())
		if self.ComputerPartMaterial != "nomat" then
			self.CoreComputer:SetMaterial( self.ComputerPartMaterial )
		end
		self.CoreComputer:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.CoreComputer:SetColor( self.ComputerPartColor )
		self.CoreComputer:SetParent( self )
		self.CoreComputer:Spawn()

		self.FanCase = ents.CreateClientProp()
		self.FanCase:SetPos( self:GetPos() + self:GetAngles():Right() * -11.8 + self:GetAngles():Forward() * 17 + self:GetAngles():Up() * 3.6 )
		self.FanCase:SetModel( "models/hunter/misc/platehole1x1a.mdl" )
		self.FanCase:SetModelScale( 0.155, 0)
		self.FanCase:SetAngles(self:GetAngles()+Angle(90, 0, 0))
		if self.FanCaseMaterial != "nomat" then
			self.FanCase:SetMaterial( self.FanCaseMaterial )
		end
		self.FanCase:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.FanCase:SetColor( self.FanCaseColor )
		self.FanCase:SetParent( self )
		self.FanCase:Spawn()

		self.FanBlades = ents.CreateClientProp()
		self.FanBlades:SetPos( self:GetPos() + self:GetAngles():Right() * -11.8 + self:GetAngles():Forward() * 17 + self:GetAngles():Up() * 3.6 )
		self.FanBlades:SetModel( "models/xqm/jetenginepropellermedium.mdl" )
		self.FanBlades:SetModelScale( 0.15, 0)
		self.FanBlades:SetAngles(self:GetAngles())
		if self.FanMaterial != "nomat" then
			self.FanBlades:SetMaterial( self.FanMaterial )
		end
		self.FanBlades:SetRenderMode( RENDERMODE_TRANSALPHA )
		self.FanBlades:SetColor( self.FanColor )
		self.FanBlades:SetParent( self )
		self.FanBlades:Spawn()
	end

	function ENT:OnRemove()
		if IsValid(self.CoreComputer) then
			self.CoreComputer:Remove()
		end
		if IsValid(self.FanCase) then
			self.FanCase:Remove()
		end
		if IsValid(self.FanBlades) then
			self.FanBlades:Remove()
		end
	end

	local function drawCircle(x, y, ang, seg, p, rad, color)
		local cirle = {}

		table.insert( cirle, { x = x, y = y} )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -p + ang )
			table.insert( cirle, { x = x + math.sin( a ) * rad, y = y + math.cos( a ) * rad } )
		end
		surface.SetDrawColor( color )
		draw.NoTexture()
		surface.DrawPoly( cirle )
	end
	function ENT:Think()
		local Pos, Ang, Ang2 = self:GetPos(), self:GetAngles(), self:GetAngles()

		if IsValid(self.CoreComputer) then
			self.CoreComputer:SetPos( Pos + Ang:Right() * 3.45 + Ang:Forward() * 10.6 + Ang:Up() * 3.7 )
			self.CoreComputer:SetAngles(Ang2)
		end

		Ang2:RotateAroundAxis(Ang:Up(), 180)
		Ang2:RotateAroundAxis(Ang:Right(), 90)

		if IsValid(self.FanCase) then
			self.FanCase:SetPos( Pos + Ang:Right() * -11.8 + Ang:Forward() * 17 + Ang:Up() * 3.6 )
			self.FanCase:SetAngles(Ang2)
		end
	end

	function ENT:Draw()
		self:DrawModel()
		if self:GetPos():Distance( LocalPlayer():GetPos() ) > 1000 then return end

		if IsValid(self.FanBlades) then
				self.FanBlades:SetPos( self:GetPos() + self:GetAngles():Right() * -11.8 + self:GetAngles():Forward() * 17 + self:GetAngles():Up() * 3.6 )
				self.FanBlades:SetAngles(self:GetAngles()+Angle(0,0,self.rot))
			if self.Cooler == true then
				if ( self.rot > 359 ) then self.rot = 0 end

				self.rot = self.rot - ( 200*( self.last-SysTime() ) )
				self.last = SysTime()
				if IsValid(self.FanCase) then
					self.FanCase:SetColor(self.FanCaseColor)
				end
				if IsValid(self.FanBlades) then
					self.FanBlades:SetColor(self.FanColor)
				end
			else
				if IsValid(self.FanCase) then
					self.FanCase:SetColor(Color(255, 255, 255, 0))
				end
				if IsValid(self.FanBlades) then
					self.FanBlades:SetColor(Color(255, 255, 255, 0))
				end
			end
		end


		local Pos, Ang, pWidth = self:GetPos(), self:GetAngles(), 279

		local Owner = self:Getowning_ent()
		if IsValid(Owner) and Owner:Nick() then 
			Owner = Owner:Nick()
			if string.len(Owner) > 10 then
				Owner = string.Left( Owner, 10 ).."..."
			end
		else 
			Owner = "Unknown" 
		end

		Ang:RotateAroundAxis(Ang:Up(), 90)

		cam.Start3D2D(Pos + Ang:Up() * 10.70 + Ang:Forward() * -15.15 + Ang:Right() * -16.35, Ang, 0.11)
			surface.SetDrawColor(57, 66, 100)
			surface.DrawRect(0, 0, pWidth, 290)

			surface.SetDrawColor(80, 89, 123)
			surface.DrawRect(0, 0, pWidth, 50)

			surface.SetDrawColor(17, 168, 171)
			surface.DrawRect(0, 50, pWidth, 3)
			for i = 0, 3 do
				surface.SetDrawColor(80, 89, 123)
				surface.DrawRect(i*70, 225, 69, 65)
			end

			surface.SetDrawColor(230, 76, 101)
			surface.DrawRect(0, 222, 69, 3)

			surface.SetDrawColor(17, 168, 171)
			surface.DrawRect(70, 222, 69, 3)

			surface.SetDrawColor(252, 177, 80)
			surface.DrawRect(140, 222, 69, 3)

			surface.SetDrawColor(79, 196, 246)
			surface.DrawRect(210, 222, 69, 3)

			surface.SetDrawColor(57, 66, 100)
			surface.DrawRect(215, 244, 59, 15)

			surface.SetDrawColor(57, 66, 100)
			surface.DrawRect(215, 262, 59, 15)

			if self.Speed == 100 then
				surface.SetDrawColor(230, 76, 101)
			else
				surface.SetDrawColor(17, 168, 171)
			end
			surface.DrawRect(215, 244, 3, 15)

			if self.Cooler == true then
				surface.SetDrawColor(230, 76, 101)
			else
				surface.SetDrawColor(17, 168, 171)
			end
			surface.DrawRect(215, 262, 3, 15)

			drawCircle(pWidth/2, 137, 180, 40, 360, 80, Color(79, 196, 246))

			if CurTime() <= self.NextPrint then
				drawCircle(pWidth/2, 137, 180, 40, (self.NextPrint-CurTime())*360/self.PrintRate, 80, Color(230, 76, 101))
			end

			surface.SetDrawColor(57, 66, 100)
			drawCircle(pWidth/2, 137, 180, 40, 360, 60, Color(57, 66, 100))

			draw.DrawText( self.CrclCfg.Name, "BigInfoFont", pWidth/2, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

			draw.DrawText( "Rate", "InfoFont", 34, 225, Color( 131, 140, 171, 255 ), TEXT_ALIGN_CENTER )

			draw.DrawText("$"..self.PlusMoney/100*self.Speed + (math.floor(self.LvlExp/100)*self.PlusMoney/4), "BiggestInfoFont", 34, 242, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )

			draw.DrawText( "Heat", "InfoFont", 104, 225, Color( 131, 140, 171, 255 ), TEXT_ALIGN_CENTER )

			draw.DrawText(self.Heat.."%", "BiggestInfoFont", 104, 242, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )

			draw.DrawText( "Speed", "InfoFont", 174, 225, Color( 131, 140, 171, 255 ), TEXT_ALIGN_CENTER )

			draw.DrawText(self.Speed.."%", "BiggestInfoFont", 174, 242, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )

			draw.DrawText( "Upgrade", "InfoFont", 244, 225, Color( 131, 140, 171, 255 ), TEXT_ALIGN_CENTER )

			draw.DrawText( "Speed", "SmallInfoFont", 245, 245, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

			draw.DrawText( "Cooler", "SmallInfoFont", 245, 263, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

			draw.DrawText( "MONEY", "BiggestInfoFont", pWidth/2, 110, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			draw.DrawText( "$"..self.Money, "BigInfoFont", pWidth/2, 135, Color( 144, 153, 183, 255 ), TEXT_ALIGN_CENTER )
		cam.End3D2D()


		Ang:RotateAroundAxis(Ang:Forward(), 90)

		cam.Start3D2D(Pos + Ang:Up() * 16.20 + Ang:Forward() * -15 + Ang:Right() * -10.5, Ang, 0.11)
			surface.SetDrawColor(80, 89, 123)
			surface.DrawRect(0, 0, 210, 33.5)

			surface.SetDrawColor(230, 76, 101)
			surface.DrawRect(0, 31.5, 210, 3)

			draw.DrawText( Owner, "BigInfoFont", 105, 1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		cam.End3D2D()

		cam.Start3D2D(Pos + Ang:Up() * 16.6 + Ang:Forward() * 8.6 + Ang:Right() * -9.4, Ang, 0.11)
			surface.SetDrawColor(80, 89, 123)
			surface.DrawRect(0, 0, 58, 20)

			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(0, 0, tonumber(string.Right( self.LvlExp.."", 2 ),10)/100*58, 20)

			surface.SetDrawColor(230, 76, 101)
			surface.DrawRect(0, 18, 58, 3)

			draw.DrawText( "Level: "..math.floor(self.LvlExp/100), "InfoFont", 29, 1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end

	net.Receive("UPCCS", function()
		local tabl = net.ReadTable()
		local ent = net.ReadEntity()
		ent.Money = tabl.Money
		ent.Speed = tabl.Speed
		ent.Heat = tabl.Heat
		ent.Cooler = tabl.Cooler
		ent.PlusMoney = tabl.PlusMoney
		ent.LvlExp = tabl.LvlExp
		ent.PrintRate = tabl.PrintRate
		ent.NextPrint = tabl.NextPrint
	end)
end
