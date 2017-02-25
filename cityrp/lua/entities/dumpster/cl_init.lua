include("shared.lua")

local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector

local color_white = Color(255,255,255)
local color_black = Color(0,0,0)

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local mypos = LocalPlayer():GetPos()

	local dist = pos:Distance(mypos)

	if dist > 500 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then
		return
	end

	color_white.a = 500 - dist
	color_black.a = 500 - dist
	
	if self:GetDTInt(0) - CurTime() > 0 then
		cam.Start3D2D(pos + Vector(0, 0, 45), ang + Angle(0, 90, 90), .1)
			draw.SimpleTextOutlined(string.FormattedTime(self:GetDTInt(0) - CurTime(), "%01i:%02i"), 'DermaLarge', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam.End3D2D()
	else 
		cam.Start3D2D(pos + Vector(0, 0, 45), ang + Angle(0, 90, 90), .1)
			draw.SimpleTextOutlined("Dumpster", 'DermaLarge', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam.End3D2D()
	end
end
