
local valid_accents = {
	["en"] = true,
	["de"] = true,
	["sv"] = true,
	["ru"] = true,
	["es"] = true,
	["fr"] = true,
	["it"] = true,
	["fi"] = true,
	["ja"] = true
}

net.Receive("TTS.Parse",  function()
	local text = net.ReadString()
	local ply = net.ReadEntity()
	local accent = "en"
	if valid_accents[string.sub(text, 1, 2)] then
		accent = string.sub(text, 1, 2)
		text = string.sub(text, 3, #text)
	end
	text = string.sub(string.Replace(text, " ", "%20"), 1, 100)

	sound.PlayURL("http://translate.google.com/translate_tts?tl=" .. accent .. "&q=" .. text .. "&client=tw-ob", "3d", function(station)
		if IsValid(station) then
			station:SetPos(ply:GetPos())
			-- sound:SetVolume(1)
			station:Play()
			station:Set3DFadeDistance(2000, 10000)
			ply.tts_sound = station
		end
	end)
end)

local tts_NextThink

hook.Add("Think", "TTS.FollowPlayerSound", function()
	if tts_NextThink and tts_NextThink < CurTime() then
		for k, v in pairs(player.GetAll()) do
			if IsValid(v.tts_sound) then
				v.tts_sound:SetPos(v:GetPos())
			end
		end
		tts_NextThink = CurTime() + 3
	end
end)
