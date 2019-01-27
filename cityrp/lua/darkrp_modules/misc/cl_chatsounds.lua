
local cooldown = CreateClientConVar("chatsounds_delay", "4", true, false)

local snd_prefix = "https://raw.githubusercontent.com/SirFrancisBillard/chatsounds/master/sounds/"
local snd_suffix = ".ogg"

hook.Add("OnPlayerChat", "ClientSidedChatSounds", function(ply, txt)
	if ply.NextChatSound and CurTime() < ply.NextChatSound then return end
	ply.NextChatSound = CurTime() + cvars.Number("chatsounds_delay", 4)

	-- keep it URL safe
	local url = snd_prefix .. string.Replace(string.lower(txt), " ", "%20") .. snd_suffix
	print("Playing chatsound " .. url .. "...")

	sound.PlayURL(url, "3d", function(station)
		if IsValid(station) then
			station:SetPos(ply:GetPos())
			station:Play()
			ply.NextChatSound = ply.NextChatSound + station:GetLength()
		end
	end)

	return false
end)
