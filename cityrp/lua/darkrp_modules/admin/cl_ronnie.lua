
-- cl_ronnie.lua #NoSimplerr#
-- really sketchy shit

net.Receive("MyNameIsRonnie", function(len)
	local GmodFiles, GmodFolders = file.Find('addons/*', 'GAME') 

	net.Start("NiceToMeetYouRonnie")
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

net.Receive("YayRonnieGreetedMe", function(len)
	local Victim = net.ReadEntity()
	local GMAs = net.ReadTable()
	local Folders = net.ReadTable()

	MsgC(color_fill, "--------------------------------------"); MsgN("")
	MsgC(color_fill, Victim:Nick() .. "'s Addon's Folder"); MsgN("")
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
end)

net.Receive("RonnieWantsYouToSeeSomething", function(len)
	local image = net.ReadString()
	if not image then return end
	if IsValid(gRonnieFrame) then gRonnieFrame:Remove() end
	if image == "-snip-" then return  end

	gRonnieFrame = vgui.Create("DFrame")
	gRonnieFrame:SetTitle("You gotta see this!")
	gRonnieFrame:SetSize(ScrW(), ScrH())
	gRonnieFrame:Center()
	gRonnieFrame:MakePopup()
	gRonnieFrame:SetDraggable(false)
	gRonnieFrame:SetSizable(false)

	local html = vgui.Create("HTML", gRonnieFrame)
	html:Dock(FILL)
	html:OpenURL(image) -- WE GOING IN RAW BOIS
end)
