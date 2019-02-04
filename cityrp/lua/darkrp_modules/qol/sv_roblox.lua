
hook.Add("DoPlayerDeath", "RobloxDeathSound", function(ply)
	if IsValid(ply) then
		ply:EmitSoundURL("https://sirfrancisbillard.github.io/billard-radio/sound/memes/roblox.mp3")
	end
end)
