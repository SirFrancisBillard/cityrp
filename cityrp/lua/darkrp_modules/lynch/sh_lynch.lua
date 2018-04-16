
function LynchingEnabled()
	return player.GetCount() > 2
end

function GetVotesNeededToLynch()
	return math.ceil(player.GetCount() * 0.6)
end

DarkRP.declareChatCommand({
	command = "lynch",
	description = "Vote to lynch a player.",
	delay = 1.5
})
