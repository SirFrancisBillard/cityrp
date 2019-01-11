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

net.Receive("FS_AskForFolders", function(len)

	local Asker = net.ReadEntity()	
	local GmodFiles, GmodFolders = file.Find('addons/*', 'GAME') 
	
	net.Start("FS_FoldersSend")
		net.WriteEntity(Asker)
		net.WriteTable(GmodFiles)
		net.WriteTable(GmodFolders)
	net.SendToServer()

end)

net.Receive("FS_SendToAsker", function(len)

	local Victim = net.ReadEntity()
	local GMAs = net.ReadTable()
	local Folders = net.ReadTable()
	
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	MsgC(Color(255,255,255,255),Victim:Nick() .. "'s Addon's Folder")		; MsgN("")
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	MsgC(Color(255,255,255,255),"-----------------GMA------------------")	; MsgN("")
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	
	for k,filename in pairs(GMAs) do
	
		local PrintColor = Color(255,255,0,255)

		for l,scary in pairs(ScaryWords) do
			if string.find(string.lower(filename),scary) then
				PrintColor = Color(255,0,0,255)
			end
		end
		
		MsgC(PrintColor,filename);MsgN("")

	end
	
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	MsgC(Color(255,255,255,255),"----------------FOLDERS---------------")	; MsgN("")
	MsgC(Color(255,255,255,255),"--------------------------------------")	; MsgN("")
	
	for k,filename in pairs(Folders) do
	
		local PrintColor = Color(255,255,0,255)

		for l,scary in pairs(ScaryWords) do
			if string.find(string.lower(filename),scary) then
				PrintColor = Color(255,0,0,255)
			end
		end
		
		MsgC(PrintColor,filename);MsgN("")

	end

end)