
BattleRoyale = BattleRoyale or {}

BattleRoyale.GetTimer = function()
	local max = 300
	return string.TrimLeft(string.ToMinutesSeconds(max - (CurTime() % max)), "0")
end

BattleRoyale.GetPlayersWithStatus = function(status)
	local queued = {}
	for k, v in pairs(player.GetAll()) do
		if v:IsBRStatus(status) then
			table.insert(queued, v)
		end
	end
	return queued
end

BattleRoyale.GetActivePlayers = function()
	return BattleRoyale.GetPlayersWithStatus(BR_STATUS_PLAYING)
end

BattleRoyale.GetQueuedPlayers = function()
	return BattleRoyale.GetPlayersWithStatus(BR_STATUS_QUEUE)
end

-- returns the first person it finds
-- only used internally when only one player is left
BattleRoyale.GetSurvivor = function()
	return BattleRoyale.GetActivePlayers()[1]
end

------------------------------------------------------
-- faster alternatives if you just want the numbers --
------------------------------------------------------

BattleRoyale.GetCountWithStatus = function(status)
	local queued = 0
	for k, v in pairs(player.GetAll()) do
		if v:IsBRStatus(status) then
			queued = queued + 1
		end
	end
	return queued
end

BattleRoyale.GetQueueCount = function()
	return BattleRoyale.GetCountWithStatus(BR_STATUS_QUEUE)
end

BattleRoyale.GetActivePlayerCount = function()
	return BattleRoyale.GetCountWithStatus(BR_STATUS_PLAYING)
end
