surface.CreateFont("SWB_HUD72", {font = "Default", size = 72, weight = 700, blursize = 0, antialias = true, shadow = false})
surface.CreateFont("SWB_HUD48", {font = "Default", size = 48, weight = 700, blursize = 0, antialias = true, shadow = false})
surface.CreateFont("SWB_HUD36", {font = "Default", size = 36, weight = 700, blursize = 0, antialias = true, shadow = false})
surface.CreateFont("SWB_HUD28", {font = "Default", size = 28, weight = 700, blursize = 0, antialias = true, shadow = false})
surface.CreateFont("SWB_HUD24", {font = "Default", size = 24, weight = 700, blursize = 0, antialias = true, shadow = false})
surface.CreateFont("SWB_HUD16", {font = "Default", size = 16, weight = 700, blursize = 0, antialias = true, shadow = false})
surface.CreateFont("SWB_KillIcons", {font = "csd", size = ScreenScale(30), weight = 500, blursize = 0, antialias = true, shadow = false})
surface.CreateFont("SWB_SelectIcons", {font = "csd", size = ScreenScale(60), weight = 500, blursize = 0, antialias = true, shadow = false})

SWEP.CrossAmount = 0
SWEP.CrossAlpha = 255
SWEP.FadeAlpha = 0
SWEP.AimTime = 0

local ClumpSpread = surface.GetTextureID("swb/clumpspread_ring")
local Bullet = surface.GetTextureID("swb/bullet")
local White, Black = Color(255, 255, 255, 255), Color(0, 0, 0, 255)
local x, y, x2, y2, lp, size, FT, CT, tr, x3, x4, y3, y4, UCT, sc1, sc2
local td = {}

local dst = draw.SimpleText

function draw.ShadowText(text, font, x, y, colortext, colorshadow, dist, xalign, yalign)
	dst(text, font, x + dist, y + dist, colorshadow, xalign, yalign)
	dst(text, font, x, y, colortext, xalign, yalign)
end

function SWEP:DrawHUD()
	FT, CT, x, y = FrameTime(), CurTime(), ScrW(), ScrH()
	UCT = UnPredictedCurTime()
	
	if self.dt.State == SWB_AIMING then
		if UCT > self.AimTime then
			if self.DrawBlackBarsOnAim then
				surface.SetDrawColor(0, 0, 0, 255)
				
				if self.ScaleOverlayToScreenHeight then
					x3 = (x - y) / 2
					y3 = y / 2
					x4 = x - x3
					y4 = y - y3
					
					surface.DrawRect(0, 0, x3, y)
					surface.DrawRect(x4, 0, x3, y)
				else
					x3 = (x - 1024) / 2
					y3 = (y - 1024) / 2
					x4 = x - x3
					y4 = y - y3
					
					surface.DrawRect(0, 0, x3, y)
					surface.DrawRect(x4, 0, x3, y)
					surface.DrawRect(0, 0, x, y3)
					surface.DrawRect(0, y4, x, y3)
				end
			end
		end
		
		if self.AimOverlay then
			if UCT > self.AimTime or self.InstantDissapearOnAim then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetTexture(self.AimOverlay)
				
				if self.StretchOverlayToScreen then
					surface.DrawTexturedRect(0, 0, x, y)
				elseif self.ScaleOverlayToScreenHeight then
					surface.DrawTexturedRect(x * 0.5 - y * 0.5, y * 0.5 - y * 0.5, y, y)
				else
					surface.DrawTexturedRect(x * 0.5 - 512, y * 0.5 - 512, 1024, 1024)
				end
			end
		end
		
		if self.FadeDuringAiming then
			if UCT < self.AimTime then
				self.FadeAlpha = math.Approach(self.FadeAlpha, 255, FT * 1500)
			else
				self.FadeAlpha = Lerp(FT * 10, self.FadeAlpha, 0)
			end
			
			surface.SetDrawColor(0, 0, 0, self.FadeAlpha)
			surface.DrawRect(0, 0, x, y)
		end
	else
		self.FadeAlpha = 0
	end
	
	if self.CrosshairEnabled then
		lp = self.Owner:ShouldDrawLocalPlayer()
		
		if lp then
			td.start = self.Owner:GetShootPos()
			td.endpos = td.start + (self.Owner:EyeAngles() + self.Owner:GetPunchAngle()):Forward() * 16384
			td.filter = self.Owner
			
			tr = util.TraceLine(td)
			
			x2 = tr.HitPos:ToScreen()
			x2, y2 = x2.x, x2.y
		else
			x2, y2 = math.Round(x * 0.5), math.Round(y * 0.5)
		end
		
		if (self.dt.State == SWB_AIMING and self.FadeCrosshairOnAim) or self.dt.State == SWB_RUNNING or self.dt.State == SWB_ACTION or self.dt.Safe or self.Owner:InVehicle() or ((self.IsReloading or self.IsFiddlingWithSuppressor) and self.Cycle <= 0.9) then
			self.CrossAlpha = Lerp(FT * 15, self.CrossAlpha, 0)
		else
			self.CrossAlpha = Lerp(FT * 15, self.CrossAlpha, 255)
		end
		
		if self.ClumpSpread then
			size = math.ceil(self.ClumpSpread * 2500)
			surface.SetDrawColor(0, 0, 0, self.CrossAlpha)
			surface.SetTexture(ClumpSpread)
			surface.DrawTexturedRect(x2 - size * 0.5 - 1, y2 - size * 0.5 - 1, size + 2, size + 2)
					
			surface.SetDrawColor(255, 255, 255, self.CrossAlpha)
			surface.DrawTexturedRect(x2 - size * 0.5, y2 - size * 0.5, size, size)
		end

		self.CrossAmount = Lerp(FT * 10, self.CrossAmount, (self.CurCone * 350) * (90 / (math.Clamp(GetConVarNumber("fov_desired"), 75, 90) - self.CurFOVMod)))
		surface.SetDrawColor(0, 0, 0, self.CrossAlpha * 0.75) -- BLACK crosshair parts
		
		if self.CrosshairParts.left then
			surface.DrawRect(x2 - 13 - self.CrossAmount, y2 - 1, 12, 3) -- left cross
		end
		
		if self.CrosshairParts.right then
			surface.DrawRect(x2 + 3 + self.CrossAmount, y2 - 1, 12, 3) -- right cross
		end
		
		if self.CrosshairParts.upper then
			surface.DrawRect(x2 - 1, y2 - 13 - self.CrossAmount, 3, 12) -- upper cross
		end
		
		if self.CrosshairParts.lower then
			surface.DrawRect(x2 - 1, y2 + 3 + self.CrossAmount, 3, 12) -- lower cross
		end
		
		surface.SetDrawColor(255, 255, 255, self.CrossAlpha) -- WHITE crosshair parts
		
		if self.CrosshairParts.left then
			surface.DrawRect(x2 - 12 - self.CrossAmount, y2, 10, 1) -- left cross
		end
		
		if self.CrosshairParts.right then
			surface.DrawRect(x2 + 4 + self.CrossAmount, y2, 10, 1) -- right cross
		end
		
		if self.CrosshairParts.upper then
			surface.DrawRect(x2, y2 - 12 - self.CrossAmount, 1, 10) -- upper cross
		end
		
		if self.CrosshairParts.lower then
			surface.DrawRect(x2, y2 + 4 + self.CrossAmount, 1, 10) -- lower cross
		end
	end
	
	sc1, sc2 = ScreenScale(35), ScreenScale(44)
	draw.ShadowText(self.FireModeDisplay, "SWB_HUD16", x - sc1 - self.BulletDisplay * 20, y - sc2 - 20, White, Black, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		
	if self.BulletDisplay and self.BulletDisplay > 0 then
		surface.SetTexture(Bullet)
		for i = 1, self.BulletDisplay do
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRect(x - sc1 - (i - 1) * 20 - 5, y - sc2 - 25, 16, 16)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(x - sc1 - (i - 1) * 20 - 6, y - sc2 - 25, 16, 16)
		end
	end
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	if self.SelectIcon then
		surface.SetDrawColor(255, 210, 0, 255)
		surface.SetTexture(self.SelectIcon)
		surface.DrawTexturedRect(x + tall * 0.2, y, tall, tall)
	else
		draw.SimpleText(self.IconLetter, "SWB_SelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, alpha ), TEXT_ALIGN_CENTER)
	end
end