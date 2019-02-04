
local Green = Color(0, 255, 0)

hook.Add("OnPlayerChat", "ChangeHitsound", function(ply, strText, bTeam, bDead)
	if ply ~= LocalPlayer() then return end

	if string.lower(strText) == "!hitsound" then
		local frame = Derma_StringRequest("Hitsound", "Enter a file path to use as your hitsound.", "hitmarkers/mlg.wav", function(text)
			gHitsound = text
			chat.AddText(color_white, "Hitsound set to ", Green, text)
		end, function()
			chat.AddText(color_white, "Hitsound is still ", gHitsound)
		end)
		frame:SetSkin("PinkFlat") -- just testing for now
		return true
	end
end)
