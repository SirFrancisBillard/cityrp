
surface.CreateFont("WeaponInfoComicSans", {
	font = "Arial",
	size = 24,
})

local function FixInfoDrawing()
	weapons.GetStored("weapon_base").PrintWeaponInfo(x, y, alpha)
		if self.DrawWeaponInfoBox == false then return end

		if self.InfoMarkup == nil and self.Instructions and self.Instructions ~= "" then
			local title_color = "<color=230, 230, 230, 255>"
			local text_color = "<color=150, 150, 150, 255>"

			local str = "<font=WeaponInfoComicSans>"
			str = str .. title_color .. "</color>\n" .. text_color .. self.Instructions .. "</color>\n"
			str = str .. "</font>"

			self.InfoMarkup = markup.Parse(str, 250)
		end

		surface.SetDrawColor(60, 60, 60, alpha)
		surface.SetTexture(self.SpeechBubbleLid)

		surface.DrawTexturedRect(x, y - 64 - 5, 128, 64)
		draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(60, 60, 60, alpha))

		if self.Instructions and self.Instructions ~= "" then
			self.InfoMarkup:Draw(x+5, y+5, nil, nil, alpha)
		end
	end
end

hook.Add("OnGamemodeLoaded", "OverrideWeaponInfo", FixInfoDrawing)
hook.Add("OnReloaded", "OverrideWeaponInfo", FixInfoDrawing)
