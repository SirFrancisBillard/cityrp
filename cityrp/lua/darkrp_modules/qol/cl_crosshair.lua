
do return end -- fuck it

hook.Add("HUDShouldDraw", "HideOldCrosshairFromHUD", function(name)
	if name == "CHudCrosshair" then return false end
end)

local CrosshairS = 5

-- stupid function made by a stupid person
local function sw(w)
	return w * ScrW() / 1768
end

hook.Add("HUDPaint", "CircularCrosshair", function()
	local ply = LocalPlayer()
	if ply:Alive() then
		CrosshairS = Lerp(5 * FrameTime(), CrosshairS, math.Clamp(ply:GetVelocity():Length() / 8, 2, 40))
		local wep = ply:GetActiveWeapon()
		local swb = IsValid(wep) and wep.SWBWeapon
		if not ply:InVehicle() and not swb then
			surface.DrawCircle(ScrW() / 2, ScrH() / 2, sw(CrosshairS), 255, 255, 255, 60)
		end
	end
end)
