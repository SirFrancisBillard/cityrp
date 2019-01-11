local StoredHitInformation = {}

StoredHitInformation[CurTime()] = {Position = Vector(0,0,0),Damage = 100}

net.Receive("BDI_SendToClient", function()

	local Position = net.ReadVector() or Vector(0,0,0)
	local Damage = net.ReadFloat() or 1
	
	local LingerDamage = math.min(Damage,100) / 100
	
	StoredHitInformation[CurTime() + 1 + LingerDamage] = {Position = Position, Damage = Damage}

end)

local ArrowMat = Material("sprites/640_pain_up")

local LeftMat = Material("sprites/640_pain_left")
local RightMat = Material("sprites/640_pain_right")
local UpMat = Material("sprites/640_pain_up")
local DownMat = Material("sprites/640_pain_down")

local GradR = Material("vgui/gradient-r")
local GradU = Material("vgui/gradient-r")

local tl = {x = 0, y = 0, u = 1, v = 1,}
local tr = {x = ScrW(), y = 0, u = 1, v = 1}
local br = {x = ScrW(), y = ScrH(), u = 1, v = 1}
local bl = {x = 0, y = ScrH(), u = 1, v = 1}

local s1 = {x = math.floor(ScrW()*0.25), y = math.floor(ScrH()*0.25), u = 0.01, v = 0.01}
local s2 = {x = math.floor(ScrW()*0.75), y = math.floor(ScrH()*0.25), u = 0.01, v = 0.01}
local s3 = {x = math.floor(ScrW()*0.75), y = math.floor(ScrH()*0.75), u = 0.01, v = 0.01}
local s4 = {x = math.floor(ScrW()*0.25), y = math.floor(ScrH()*0.75), u = 0.01, v = 0.01}

local Shape01 = {
	tl,
	tr,
	s2,
	s1,
}

local Shape02 = {
	tr,
	br,
	s3,
	s2,	
}

local Shape03 = {
	br,
	bl,
	s4,
	s3
}

local Shape04 = {
	bl,
	tl,
	s1,
	s4
}

local Grad = Material("pp/morph/brush1")

function BDI_HudShouldDraw(element)
	if element == "CHudDamageIndicator" then return false end
end

hook.Add("HUDShouldDraw","BDI: HideHUD",BDI_HudShouldDraw)

function BDI_HUDPaint()

	local ply = LocalPlayer()
	
	local x = ScrW()
	local y = ScrH()
	
	if ply:Alive() then
	
		for k,v in pairs(StoredHitInformation) do
		
			if k <= (CurTime() - 2) then
			
				table.remove(StoredHitInformation,k)
				
			else
				
				local ScreenTable = v.Position:ToScreen()
				
				local PosX = ScreenTable.x
				local PosY = ScreenTable.y
				local IsVisible = ScreenTable.visible
				
				local DistanceX = math.abs(x*0.5 - PosX)
				local DistanceY = math.abs(y*0.5 - PosY)
				local Distance = Vector(DistanceX,DistanceY,0):Length()

				local Ang = (Vector(x/2,y/2) - Vector(ScreenTable.x,ScreenTable.y) ):Angle()
				
				--local Alpha = math.Clamp(Distance*0.5,0,255)
				local Alpha =  math.Clamp( (1 - (CurTime() - k))*255 , 0 , 255 )
				
				surface.SetDrawColor( Color(255,0,0,Alpha) )

				if Distance >= 1000 then
					if PosX > x/2 then
						surface.SetMaterial(GradR)
						surface.DrawPoly( Shape02 ) -- right
					elseif PosX < x/2 then
						surface.SetMaterial(GradR)
						surface.DrawPoly( Shape04 ) -- left
					end	
				end
				
				if IsVisible then
					surface.SetMaterial(GradU)
					surface.DrawPoly( Shape01 )
				else
					surface.SetMaterial(GradU)
					surface.DrawPoly( Shape03 )
				end
				
			end

		end

	end

end

hook.Add("HUDPaintBackground","BDI: HUDPaint",BDI_HUDPaint)