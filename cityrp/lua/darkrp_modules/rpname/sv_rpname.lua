util.AddNetworkString("OpenRPNameMenu")

hook.Add("PlayerInitialSpawn", "RPNameSelectInitial", function(ply)
	if (file.Exists("rpname/"..string.Replace(ply:SteamID(), ":", "_")..".txt", "DATA")) then
        DarkRP.notify(ply, 0, 10, "Welcome Back to the Server!")
    else
		net.Start("OpenRPNameMenu")
		    net.WriteTable({})
        net.Send(ply)
	end
end)

hook.Add("PlayerSay", "RPNameDarkRPGloriusDisable", function(ply, text)
    local start, ending = string.find(text, "rpname")

	if (start == 2 && ending == 7 && file.Exists("rpname/"..string.Replace(ply:SteamID(), ":", "_")..".txt", "DATA")) then
	    DarkRP.notify(ply, 1, 10, "This is a shitty workaround to block you from changing names... Sorry!")
	    return ""
	end
end)

net.Receive("OpenRPNameMenu", function(len, ply)
    local steamid = string.Replace(ply:SteamID(), ":", "_")

    if (!file.Exists("rpname", "DATA")) then 
		file.CreateDir("rpname")
	end
	
	ply:setRPName(net.ReadString())
	
	file.Write("rpname/"..steamid..".txt", ply:GetName())
end)

DarkRP.defineChatCommand("forcerpname", function(ply, target)
   if (ply:IsAdmin()) then
	    if (DarkRP.findPlayer(target[1])) then
			if (file.Exists("rpname/"..string.Replace(ply:SteamID(), ":", "_")..".txt", "DATA")) then
		        net.Start("OpenRPNameMenu")
		            net.WriteTable(string.Explode(" ", DarkRP.findPlayer(target[1]):GetName()))
                net.Send(DarkRP.findPlayer(target[1]))
				
				DarkRP.notify(DarkRP.findPlayer(target[1]), 1, 5, ply:GetName().." forced you to change your name!")
			    DarkRP.notify(ply, 0, 5, "You forced "..DarkRP.findPlayer(target[1]):GetName().." to change his name!")
				
				file.Delete("rpname/"..string.Replace(ply:SteamID(), ":", "_")..".txt")
			else
			    DarkRP.notify(ply, 1, 5, "This player doesn't have an RPName!")
			end
		else
		    DarkRP.notify(ply, 1, 5, "The player you entered isn't valid!")
		end
	else
	    DarkRP.notify(ply, 1, 5, "You aren't an admin!")
	end

	return ""
end)

DarkRP.defineChatCommand("changerpname", function(ply) //There's no need to check if he has a Roleplay Name since he can't type this without one.
	if (ply:canAfford(RPNameConfig["ChangeNameCost"])) then
	    net.Start("OpenRPNameMenu")
		    net.WriteTable(string.Explode(" ", ply:GetName()))
        net.Send(ply)

		ply:addMoney(-RPNameConfig["ChangeNameCost"])
		DarkRP.notify(ply, 0, 5, "You payed "..DarkRP.formatMoney(RPNameConfig["ChangeNameCost"]).." to change your name!")
		
		file.Delete("rpname/"..string.Replace(ply:SteamID(), ":", "_")..".txt")
	else
	    DarkRP.notify(ply, 1, 5, "You can't afford to change your name!")
	end
end)