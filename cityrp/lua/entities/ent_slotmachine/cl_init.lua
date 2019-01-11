include('shared.lua')
function ENT:Initialize()
	
	self.CoreDelay = {}
	self.CoreRoll = {}
	
	self.CreatedTime = CurTime()
	
	self.TopLightColors = {}
	self.IdleLightDelay = {}
end

function ENT:Draw()
		local Ang = self:GetAngles()
		Ang:RotateAroundAxis(Ang:Forward(), 0)
		Ang:RotateAroundAxis(Ang:Right(), 260)
		Ang:RotateAroundAxis(Ang:Up(),90)
		-- 앞뒤 : Right ,  좌우 Up , 위아래 Forward
		
	cam.Start3D2D( self:GetPos() + self:GetForward()*16 + self:GetUp()*43+ self:GetRight()*0, Ang, 0.1 )
		local PX,PY,SX,SY = -230,-69,460,250
		surface.SetDrawColor( 0,0,0,255 )
		surface.DrawRect( PX,PY,SX,SY ) -- bg
		draw.SimpleText("Try out your luck", "SM_TEXT", 0, -40, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	--	-140 , 30
		for k,v in pairs(SlotMachine_Adjust.Slots) do
			draw.SimpleText(v.PrintText..v.PrintText..v.PrintText.. " = $" .. v.Price, "SM_PriceList", -100 + (200*((k+1)%2)), -40 + math.ceil(k/2)*30, v.PrintColor,TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
	
		local Ang = self:GetAngles()
		Ang:RotateAroundAxis(Ang:Forward(), 0)
		Ang:RotateAroundAxis(Ang:Right(), 287)
		Ang:RotateAroundAxis(Ang:Up(),90)
	
	cam.Start3D2D( self:GetPos() + self:GetForward()*16 + self:GetUp()*20 + self:GetRight()*0, Ang, 0.1 )
		local PX,PY,SX,SY = -200,-69,400,225
		surface.SetDrawColor( 0,0,0,255 )
		surface.DrawRect( PX,PY,SX,SY ) -- bg
		draw.SimpleText("Slot Machine", "SM_TEXT", 0, -20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText("1 bet : " .. SlotMachine_Adjust.BetPrice, "SM_PriceList", -70, 90, Color(255,255,255,255))

	---
		local CoreNum = 1
		local CX,CY = PX+60,PY+70
		surface.SetDrawColor( 255,255,255,100 )
		surface.DrawRect( CX,CY,70,70 )
		if self:GetDTInt(CoreNum) == 0 then
			if (self.CoreDelay[CoreNum] or 0) < CurTime() then
				self.CoreDelay[CoreNum] = CurTime()+0.05
				self.CoreRoll[CoreNum] = math.random(1,#SlotMachine_Adjust.Slots)
			end
		else
			self.CoreRoll[CoreNum] = self:GetDTInt(CoreNum)
		end
			draw.SimpleText(SlotMachine_Adjust.Slots[self.CoreRoll[CoreNum]].PrintText, "SM_CoreText", CX+35, CY+35, SlotMachine_Adjust.Slots[self.CoreRoll[CoreNum]].PrintColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	---
	
	---
		local CoreNum = 2
		local CX,CY = PX+160,PY+70
		surface.SetDrawColor( 255,255,255,100 )
		surface.DrawRect( CX,CY,70,70 )
		if self:GetDTInt(CoreNum) == 0 then
			if (self.CoreDelay[CoreNum] or 0) < CurTime() then
				self.CoreDelay[CoreNum] = CurTime()+0.05
				self.CoreRoll[CoreNum] = math.random(1,#SlotMachine_Adjust.Slots)
			end
		else
			self.CoreRoll[CoreNum] = self:GetDTInt(CoreNum)
		end
			draw.SimpleText(SlotMachine_Adjust.Slots[self.CoreRoll[CoreNum]].PrintText, "SM_CoreText", CX+35, CY+35, SlotMachine_Adjust.Slots[self.CoreRoll[CoreNum]].PrintColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	---

	---
		local CoreNum = 3
		local CX,CY = PX+260,PY+70
		surface.SetDrawColor( 255,255,255,100 )
		surface.DrawRect( CX,CY,70,70 )
		if self:GetDTInt(CoreNum) == 0 then
			if (self.CoreDelay[CoreNum] or 0) < CurTime() then
				self.CoreDelay[CoreNum] = CurTime()+0.05
				self.CoreRoll[CoreNum] = math.random(1,#SlotMachine_Adjust.Slots)
				if LocalPlayer():GetPos():Distance(self:GetPos()) < 500 then
					sound.Play("buttons/lightswitch2.wav",self:GetPos(),0.1,80,0.3)
				end
			end
		else
			self.CoreRoll[CoreNum] = self:GetDTInt(CoreNum)
		end
			draw.SimpleText(SlotMachine_Adjust.Slots[self.CoreRoll[CoreNum]].PrintText, "SM_CoreText", CX+35, CY+35, SlotMachine_Adjust.Slots[self.CoreRoll[CoreNum]].PrintColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	---
		
	cam.End3D2D()

	self:DrawLights()
end

local matLight = Material( "sprites/glow04_noz" )
function ENT:DrawLights()

	-- ( 위아래,앞뒤,양옆)
	local Light = {}
	Light[1] = Vector(15,-10,68)
	Light[2] = Vector(15,0,68)
	Light[3] = Vector(15,10,68)

	local Delay = (CurTime()%#Light)/#Light
	for k,v in pairs(Light) do
		self.TopLightColors[k] = self.TopLightColors[k] or Color(255,255,255,255)
		local DC = self.TopLightColors[k]
		if (self.CoreDelay[3] or 0) > CurTime() then -- rotating
			DC.r = math.random(0,255)
			DC.g = math.random(0,255)
			DC.b = math.random(0,255)
		else -- not rotating ( idle )
			-- Win
			if self.CoreRoll[1] == self.CoreRoll[2] and self.CoreRoll[2] == self.CoreRoll[3] then
				DC.r = math.random(0,255)
				DC.g = math.random(0,255)
				DC.b = math.random(0,255)
			else -- Just idle
				if (self.IdleLightDelay[k] or 0) < CurTime() then
					self.IdleLightDelay[k] = CurTime() + 0.5
					DC.r = math.random(0,255)
					DC.g = math.random(0,255)
					DC.b = math.random(0,255)
				end
			end
		end
		render.SetMaterial( matLight )
		render.DrawSprite( self:GetPos() + self:GetForward() *v.x + self:GetRight() *v.y + self:GetUp() *v.z,30, 30, self.TopLightColors[k] )
	end
end

hook.Add("HUDPaint","SlotMachine Info",function()
	local TR = LocalPlayer():GetEyeTrace()
	if TR.Hit and TR.Entity and TR.Entity:IsValid() and TR.Entity:GetClass() == "rx_slotmachine" then		
		local XX,YY = ScrW()/2,ScrH()/2
		draw.SimpleTextOutlined("Slot Machine", "SM_PriceList",XX, YY , Color(math.random(1,255),math.random(1,255),math.random(1,255),255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1.5,Color(0,0,0,255))
		if (TR.Entity.CoreDelay[3] or 0) > CurTime() then -- rotating

		else
			if LocalPlayer():KeyDown(IN_USE) then
				RunConsoleCommand("slotmachine_roll",TR.Entity:EntIndex())
			end
		end
	--	draw.SimpleTextOutlined("Range = " .. TR.Entity:GetDTInt(1) .. " ~ " .. TR.Entity:GetDTInt(2), "RXF_Treb_S25",XX, YY+70, Dice_Config.Color.HUDInfoTextColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1.5,Color(0,0,0,255))
	end
end)