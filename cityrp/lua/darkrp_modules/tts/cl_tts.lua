
local valid_accents = {
	["en"] = true,
	["de"] = true,
	["sv"] = true,
	["ru"] = true,
	["es"] = true,
	["fr"] = true,
	["it"] = true,
	["fi"] = true,
	["ja"] = true,
	["cn"] = true -- not currently supported, pls fix
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

	sound.PlayURL("http://translate.google.com/translate_tts?tl=" .. accent .. "&q=" .. text .. "&client=tw-ob", "3d", function(sound)
		if IsValid(sound) then
			sound:SetPos(ply:GetPos())
			-- sound:SetVolume(1)
			sound:Play()
			sound:Set3DFadeDistance(2000, 10000)
			ply.sound = sound
		end
	end)
end)

hook.Add("Think", "FollowPlayerSound", function()
	for k,v in pairs(player.GetAll()) do
		if IsValid(v.sound) then
			v.sound:SetPos(v:GetPos())
		end
	end
end)
