
hook.Add("PlayerInitialSpawn", "ResetLynchTarget", function(ply)
	ply.LynchTarget = false
end)

DarkRP.defineChatCommand("lynch", function(ply, args)
	local namepos = string.find(args, " ")
	if not namepos then
		DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
		return ""
	end

	local name = string.sub(args, 1, namepos - 1)

	local target = DarkRP.findPlayer(name)

	if target then
		ply:VoteToLynch(target)
	else
		DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("could_not_find", tostring(name)))
	end

	return ""
end)
