
local HeadshotSound = "https://sirfrancisbillard.github.io/billard-radio/sound/misc/headshot.mp3"

gPlayHeadshotSound = true

if SERVER then
	util.AddNetworkString("SendHeadshotSound")

	hook.Add("EntityTakeDamage", "PlayHeadshotSound",function(ent, dmg)
		local atk = dmg:GetAttacker()
		if IsValid(ent) and IsValid(atk) and ent:IsPlayer() and atk:IsPlayer() and ent:LastHitGroup() == HITGROUP_HEAD then
			net.Start("SendHeadshotSound")
			net.Send({atk, ent})
		end
	end)
else
	gHeadshotSoundStation = false
	sound.PlayURL("https://sirfrancisbillard.github.io/billard-radio/sound/misc/headshot.mp3", "noblock noplay", function(station)
		if IsValid(station) then
			gHeadshotSoundStation = station
		end
	end)

	net.Receive("SendHeadshotSound", function()
		gHeadshotSoundStation:SetTime(0)
		gHeadshotSoundStation:Play()
	end)
end
