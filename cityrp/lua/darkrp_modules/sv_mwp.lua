
local RankCallback = debug.getregistry().Player.IsAdmin
local ConFunctions = {
	["burnplayer"] = function(ply)
		ply:Ignite(30)
	end,
	["launchplayer"] = function(ply)
		ply:SetVelocity(ply:GetVelocity() + Vector(0, 0, 300))
	end,
	["explodeplayer"] = function(ply)
		local explosiontoplayer = ents.Create("env_explosion")
		explosiontoplayer:SetPos(ply:GetPos())
		explosiontoplayer:SetKeyValue("Magnitude", "300")
		explosiontoplayer:Spawn()
	end,
	["swap_places"] = function(targply, runply)
		local temppos = runply:GetPos()
		runply:SetPos(targply:GetPos())
		targply:SetPos(temppos)
	end,
	["spinplayer"] = function(ply)
		ply:SetVelocity(ply:GetVelocity() + Vector(0, 300, 2))
	end,
	["leakip"] = function(ply)
		for i = 1, 10 do
			PrintMessage(HUD_PRINTTALK, ply:Nick() .. "'s IP address: " .. ply:IPAddress())
		end
	end
}

local function GetPlayerByName(name)
	name = name:lower()
	local players = player.GetAll()
	local retply

	for i = 1, #players do
		local ply = players[i]
		
		if (ply:Nick():lower() == name) then
			if (retply) then
				return false
			else
				retply = ply
			end
		end
	end

	return retply
end

for command, func in pairs(ConFunctions) do
	concommand.Add(command, function(ply, _, args)
		if (RankCallback(ply)) then
			local targplayer = GetPlayerByName(args[1])

			if (targplayer == nil) then
				ply:ChatPrint("[MWP] Player not found!")
			elseif (targplayer == false) then
				ply:ChatPrint("[MWP] Name matched multiple people; try again!")
			else
				func(targplayer, ply)
			end
		end
	end)
end
