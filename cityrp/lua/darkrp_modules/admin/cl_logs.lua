--[[Ignore All of This]]--
local ShouldDisplayDeath = true
local ShouldDisplayProp = true
local ShouldDisplayJob = true
local ShouldDisplayConnect = true
local ShouldDisplayTool = true
local ShouldDisplayDMG = true
local ShouldDisplayName = true
local ShouldDisplayArrest = true
local ShouldDisplayDemote = true
local ShouldDisplayHit = true
--[[Ignore All of This]]--

	local DeathLog = {}
	DeathLog.Time = {}
	DeathLog.SteamID = {}
	DeathLog.HSteamID = {}
	DeathLog.Name = {}
	DeathLog.KillerName = {}
	DeathLog.InflictorName = {}
	DeathLog.KSteamID = {}



	local PropLog = {}
	PropLog.Time = {}
	PropLog.SteamID = {}
	PropLog.HSteamID = {}
	PropLog.Name = {}
	PropLog.Model= {}



	local JobLog = {}
	JobLog.Time = {}
	JobLog.SteamID = {}
	JobLog.HSteamID = {}
	JobLog.Name = {}
	JobLog.OldTeam = {}
	JobLog.NewTeam = {}



	local ConnectLog = {}
	ConnectLog.Time = {}
	ConnectLog.SteamID = {}
	ConnectLog.HSteamID = {}
	ConnectLog.Name = {}
	ConnectLog.Method = {}



	local ToolLog = {}
	ToolLog.Time = {}
	ToolLog.SteamID = {}
	ToolLog.HSteamID = {}
	ToolLog.Name = {}
	ToolLog.Tool = {}



	local DMGLog = {}
	DMGLog.Time = {}
	DMGLog.SteamID = {}
	DMGLog.HSteamID = {}
	DMGLog.Name = {}
	DMGLog.KillerName = {}
	DMGLog.KSteamID = {}
	DMGLog.InflictorName = {}
	DMGLog.Method = {}
	DMGLog.Damage = {}



	local NameLog = {}
	NameLog.Time = {}
	NameLog.Name = {}
	NameLog.SteamID = {}
	NameLog.HSteamID = {}
	NameLog.OldName = {}
	NameLog.NewName = {}



	local ArrestLog = {}
	ArrestLog.Time = {}
	ArrestLog.Name = {}
	ArrestLog.SteamID = {}
	ArrestLog.HSteamID = {}
	ArrestLog.Method = {}
	ArrestLog.Officer = {}
	ArrestLog.OSteamID = {}

	local DemoteLog = {}
	DemoteLog.Time = {}
	DemoteLog.Name = {}
	DemoteLog.SteamID = {}
	DemoteLog.HSteamID = {}
	DemoteLog.Demoter = {}
	DemoteLog.DSteamID = {}
	DemoteLog.Job = {}
	DemoteLog.Reason = {}

	local HitLog = {}
	HitLog.Time = {}
	HitLog.Name = {}
	HitLog.SteamID = {}
	HitLog.HSteamID = {}
	HitLog.Target = {}
	HitLog.TSteamID = {}
	HitLog.Method = {}
	HitLog.Customer = {}
	HitLog.CSteamID = {}




net.Receive("OpenLogs", function()
	--[[Specific Groups for Specific Categories]]--
	for i=1,#LOGS_NAME_GROUPS do
			if LOGS_NAME_GROUPS[i] == "*" then
				ShouldDisplayName=true
			
				
			elseif LocalPlayer():IsUserGroup(LOGS_NAME_GROUPS[i]) then
						ShouldDisplayName=true
						
	    				
				 
			else
				ShouldDisplayName=false

			
			end
		end

		for i=1,#LOGS_KILLS_GROUPS do
			if LOGS_KILLS_GROUPS[i] == "*" then
				ShouldDisplayDeath=true
			elseif LocalPlayer():IsUserGroup(LOGS_KILLS_GROUPS[i]) then
						ShouldDisplayDeath=true
	    				
				 
			else
				ShouldDisplayDeath=false
			end
		end

			for i=1,#LOGS_JOB_GROUPS do
			if LOGS_JOB_GROUPS[i] == "*" then
				ShouldDisplayJob=true
			elseif LocalPlayer():IsUserGroup(LOGS_JOB_GROUPS[i]) then
						ShouldDisplayJob=true
	    				
				 
			else
				ShouldDisplayJob=false
			end
		end

			for i=1,#LOGS_PROP_GROUPS do
			if LOGS_PROP_GROUPS[i] == "*" then
				ShouldDisplayProp=true
			elseif LocalPlayer():IsUserGroup(LOGS_PROP_GROUPS[i]) then
						ShouldDisplayProp=true
	    				
				 
			else
				ShouldDisplayProp=false
			end
		end

					for i=1,#LOGS_TOOL_GROUPS do
			if LOGS_TOOL_GROUPS[i] == "*" then
				ShouldDisplayTool=true
			elseif LocalPlayer():IsUserGroup(LOGS_TOOL_GROUPS[i]) then
						ShouldDisplayTool=true
	    				
				 
			else
				ShouldDisplayTool=false
			end
		end

			for i=1,#LOGS_CONNECT_GROUPS do
			if LOGS_CONNECT_GROUPS[i] == "*" then
				ShouldDisplayConnect=true
			elseif LocalPlayer():IsUserGroup(LOGS_CONNECT_GROUPS[i]) then
						ShouldDisplayConnect=true
	    				
				 
			else
				ShouldDisplayConnect=false
			end
		end

			for i=1,#LOGS_DMG_GROUPS do
			if LOGS_DMG_GROUPS[i] == "*" then
				ShouldDisplayDMG=true
			elseif LocalPlayer():IsUserGroup(LOGS_DMG_GROUPS[i]) then
						ShouldDisplayDMG=true
	    				
				 
			else
				ShouldDisplayDMG=false
			end
		end

			for i=1,#LOGS_ARREST_GROUPS do
			if LOGS_ARREST_GROUPS[i] == "*" then
				ShouldDisplayArrest=true
			elseif LocalPlayer():IsUserGroup(LOGS_ARREST_GROUPS[i]) then
						ShouldDisplayArrest=true
	    				
				 
			else
				ShouldDisplayArrest=false
			end
		end

			for i=1,#LOGS_DEMOTE_GROUPS do
			if LOGS_DEMOTE_GROUPS[i] == "*" then
				ShouldDisplayDemote=true
			elseif LocalPlayer():IsUserGroup(LOGS_DEMOTE_GROUPS[i]) then
						ShouldDisplayDemote=true
	    				
				 
			else
				ShouldDisplayDemote=false
			end
		end

				for i=1,#LOGS_HIT_GROUPS do
			if LOGS_HIT_GROUPS[i] == "*" then
				ShouldDisplayHit=true
			elseif LocalPlayer():IsUserGroup(LOGS_HIT_GROUPS[i]) then
						ShouldDisplayHit=true
	    				
				 
			else
				ShouldDisplayHit=false
			end
		end

  	local LogFrame = vgui.Create("DFrame")
			LogFrame:SetSize(700, 500)
			LogFrame:MakePopup()
			LogFrame:SetTitle("")
			LogFrame:ShowCloseButton(true)
			LogFrame:Center()
			LogFrame.Paint = function()
				DLogFrame(LogFrame:GetWide(), LogFrame:GetTall(), Color(30,30,30,255))
				surface.SetFont("Title")
				-- Edit this colour for the Title Colour!
				surface.SetTextColor( 255, 128, 0, 255 )
				surface.SetTextPos( LogFrame:GetWide()/4, 5 ) 
				surface.DrawText( LOGS_TITLETEXT )
			end

			local LogSheet = vgui.Create("DPropertySheet",LogFrame)
			LogSheet:SetPos(5,80)
			LogSheet:SetSize(LogFrame:GetWide()-10,400)


			local Credits = vgui.Create("DLabel",LogFrame)
			Credits:SetPos(5,LogFrame:GetTall()-17) 
			Credits:SetColor(Color(255,255,255,255)) 
			Credits:SetFont("default")
			Credits:SetText("Created by Deagler") 
			Credits:SizeToContents()


			local NamePanel = vgui.Create("DPanel",LogSheet)
			NamePanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())


			local NameLogs = vgui.Create("DListView",NamePanel)
			NameLogs:SetPos(5, 5)
			NameLogs:SetSize(NamePanel:GetWide()-25, NamePanel:GetTall()-70)
			NameLogs:SetMultiSelect(false)
			NameLogs:AddColumn("Time"):SetFixedWidth(80) 
			NameLogs:AddColumn("Steam Name"):SetFixedWidth(160)
			NameLogs:AddColumn("Previous Name")
			NameLogs:AddColumn("New Name")
			
			local JobPanel = vgui.Create("DPanel",LogSheet)
			JobPanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())

	
			local JobLogs = vgui.Create("DListView",JobPanel)
			JobLogs:SetPos(5, 5)
			JobLogs:SetSize(JobPanel:GetWide()-25, JobPanel:GetTall()-70)
			JobLogs:SetMultiSelect(false)
			JobLogs:AddColumn("Time"):SetFixedWidth(80) 
			JobLogs:AddColumn("Name"):SetFixedWidth(160)
			JobLogs:AddColumn("Previous Job")
			JobLogs:AddColumn("New Job")
		
			local DeathPanel = vgui.Create("DPanel",LogSheet)
			DeathPanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())
			
			local DeathLogs = vgui.Create("DListView",DeathPanel)
			DeathLogs:SetPos(5, 5)
			DeathLogs:SetSize(DeathPanel:GetWide()-25, DeathPanel:GetTall()-70)
			DeathLogs:SetMultiSelect(false)
			DeathLogs:AddColumn("Time"):SetFixedWidth(80)  
			DeathLogs:AddColumn("Killer"):SetFixedWidth(160)
			DeathLogs:AddColumn("Victim"):SetFixedWidth(160)
			DeathLogs:AddColumn("Weapon")
		

			local PropPanel = vgui.Create("DPanel",LogSheet)
			PropPanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())

			local PropLogs = vgui.Create("DListView",PropPanel)
			PropLogs:SetPos(5, 5)
			PropLogs:SetSize(PropPanel:GetWide()-25, PropPanel:GetTall()-70)
			PropLogs:SetMultiSelect(false)
			PropLogs:AddColumn("Time"):SetFixedWidth(80)  
			PropLogs:AddColumn("Name"):SetFixedWidth(160)
			PropLogs:AddColumn("Model")
		
			local ToolPanel = vgui.Create("DPanel",LogSheet)
			ToolPanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())

			local ToolLogs = vgui.Create("DListView",ToolPanel)
			ToolLogs:SetPos(5, 5)
			ToolLogs:SetSize(ToolPanel:GetWide()-25, ToolPanel:GetTall()-70)
			ToolLogs:SetMultiSelect(false)
			ToolLogs:AddColumn("Time"):SetFixedWidth(80)  
			ToolLogs:AddColumn("Name"):SetFixedWidth(200)
			ToolLogs:AddColumn("Tool")

			local ConnectPanel = vgui.Create("DPanel",LogSheet)
			ConnectPanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())

			local ConnectionLogs = vgui.Create("DListView",ConnectPanel)
			ConnectionLogs:SetPos(5, 5)
			ConnectionLogs:SetSize(ConnectPanel:GetWide()-25, ConnectPanel:GetTall()-70)
			ConnectionLogs:SetMultiSelect(false)
			ConnectionLogs:AddColumn("Time"):SetFixedWidth(80)  
			ConnectionLogs:AddColumn("Type"):SetFixedWidth(90) 
			ConnectionLogs:AddColumn("Name")


			local DMGPanel = vgui.Create("DPanel",LogSheet)
			DMGPanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())

			local DMGLogs = vgui.Create("DListView",DMGPanel)
			DMGLogs:SetPos(5, 5)
			DMGLogs:SetSize(DMGPanel:GetWide()-25,DMGPanel:GetTall()-70)
			DMGLogs:SetMultiSelect(false)
			DMGLogs:AddColumn("Time"):SetFixedWidth(80)  
			DMGLogs:AddColumn("Type"):SetFixedWidth(35) 
			DMGLogs:AddColumn("Attacker"):SetFixedWidth(160)
			DMGLogs:AddColumn("Victim"):SetFixedWidth(160)
			DMGLogs:AddColumn("DMG"):SetFixedWidth(38) 
			DMGLogs:AddColumn("Weapon")

			local ArrestPanel = vgui.Create("DPanel",LogSheet)
			ArrestPanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())

			local ArrestLogs = vgui.Create("DListView",ArrestPanel)
			ArrestLogs:SetPos(5, 5)
			ArrestLogs:SetSize(ArrestPanel:GetWide()-25,ArrestPanel:GetTall()-70)
			ArrestLogs:SetMultiSelect(false)
			ArrestLogs:AddColumn("Time"):SetFixedWidth(80)  
			ArrestLogs:AddColumn("Type"):SetFixedWidth(75) 
			ArrestLogs:AddColumn("Officer")
			ArrestLogs:AddColumn("Culprit")

			local DemotePanel = vgui.Create("DPanel",LogSheet)
			DemotePanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())

			local DemoteLogs = vgui.Create("DListView",DemotePanel)
			DemoteLogs:SetPos(5, 5)
			DemoteLogs:SetSize(DemotePanel:GetWide()-25,DemotePanel:GetTall()-70)
			DemoteLogs:SetMultiSelect(false)
			DemoteLogs:AddColumn("Time"):SetFixedWidth(80)  
			DemoteLogs:AddColumn("Demoter")
			DemoteLogs:AddColumn("Demotee")
			DemoteLogs:AddColumn("Job")
			DemoteLogs:AddColumn("Reason")

			local HitPanel = vgui.Create("DPanel",LogSheet)
			HitPanel:SetSize(LogSheet:GetWide(),LogSheet:GetTall())

			local HitLogs = vgui.Create("DListView",HitPanel)
			HitLogs:SetPos(5, 5)
			HitLogs:SetSize(HitPanel:GetWide()-25,HitPanel:GetTall()-70)
			HitLogs:SetMultiSelect(false)
			HitLogs:AddColumn("Time"):SetFixedWidth(80)  
			HitLogs:AddColumn("Type")
			HitLogs:AddColumn("Hitman")
			HitLogs:AddColumn("Target")
			HitLogs:AddColumn("Customer/Reason")
		

			if LOGS_DISPLAY_KILLS	== 0 or ShouldDisplayDeath == false then
				DeathLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_NAME	== 0 or ShouldDisplayName == false then
				NameLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_JOB		== 0 or ShouldDisplayJob == false then
				JobLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_PROP	== 0 or ShouldDisplayProp == false then
				PropLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_TOOLGUN	== 0 or ShouldDisplayTool == false then 
				ToolLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_CONNECT == 0 or ShouldDisplayConnect == false then
				ConnectionLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_DMG		== 0 or ShouldDisplayDMG == false then
				DMGLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_ARREST 	== 0 or ShouldDisplayArrest == false then
				ArrestLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_DEMOTE 	== 0 or ShouldDisplayDemote == false then
				DemoteLogs:SetVisible(false)
			end

			if LOGS_DISPLAY_HIT 	== 0 or ShouldDisplayHit == false then
				HitLogs:SetVisible(false)
			end

		
	
	--Death Search Player--


		--[[Kills/Deaths]]--	
local DComboBox = vgui.Create("DComboBox",DeathPanel)
DComboBox:SetPos(5,DeathPanel:GetTall()-60)
DComboBox:SetSize(200,20)
DComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
DComboBox:AddChoice(v:Name())
table.insert(DeathLog.HSteamID,v:SteamID())
end

DComboBox.OnSelect = function(panel,index,value,data)
DeathLogs:Clear()

for i=1,#DeathLog.SteamID do
                               
 	   DeathLogs:AddLine(DeathLog.Time[i],DeathLog.KillerName[i].."("..DeathLog.KSteamID[i]..")",DeathLog.Name[i].."("..DeathLog.SteamID[i]..")",DeathLog.InflictorName[i])
 		DeathLogs:SortByColumn(1, true)

 		if (DeathLog.HSteamID[index] == DeathLog.SteamID[i]) then
 		DeathLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(0,230,0,255)
		surface.DrawRect(1, 1, DeathLogs:GetLine(i):GetWide()-3,DeathLogs:GetLine(i):GetTall())
end
end

if (DeathLog.HSteamID[index] == DeathLog.KSteamID[i])  then
		DeathLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, DeathLogs:GetLine(i):GetWide()-3,DeathLogs:GetLine(i):GetTall())

	end
	end

end
end

local DButton = vgui.Create("DButton",DeathPanel)
DButton:SetPos(220,DeathPanel:GetTall()-60)
DButton:SetSize(150,20)
DButton:SetText("Update/Remove Highlights")
DButton.DoClick = function()
DeathLogs:Clear()
DComboBox:Clear(true)
table.Empty(DeathLog.HSteamID)
DComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		DComboBox:AddChoice(v:Name())
		table.insert(DeathLog.HSteamID,v:SteamID())
	end


	for i=1,#DeathLog.SteamID do
                               
        DeathLogs:AddLine(DeathLog.Time[i],DeathLog.KillerName[i].."("..DeathLog.KSteamID[i]..")",DeathLog.Name[i].."("..DeathLog.SteamID[i]..")",DeathLog.InflictorName[i])
 		DeathLogs:SortByColumn(1, true)

 	end
end
for i=1,#DeathLog.SteamID do
                               
        DeathLogs:AddLine(DeathLog.Time[i],DeathLog.KillerName[i].."("..DeathLog.KSteamID[i]..")",DeathLog.Name[i].."("..DeathLog.SteamID[i]..")",DeathLog.InflictorName[i])
 		DeathLogs:SortByColumn(1, true)
end


DeathLogs.OnRowRightClick = function(parent, line) 
    local DeathLogsMenu = DermaMenu() 
  	DeathLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(DeathLogs:GetLine(line):GetValue(1).." "..DeathLogs:GetLine(line):GetValue(2).." killed "..DeathLogs:GetLine(line):GetValue(3).." with "..tostring(DeathLogs:GetLine(line):GetValue(4))) 
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		DeathLogsMenu:Hide() 
  		end )

    DeathLogsMenu:AddOption("Copy "..DeathLog.KillerName[line].."'s(Killer) SteamID", function() 
    	SetClipboardText(DeathLog.KSteamID[line]) 
    	LocalPlayer():ChatPrint("Killer's SteamID copied to clipboard.")
    	DeathLogsMenu:Hide() 
end )

  
    DeathLogsMenu:AddOption("Copy "..DeathLog.Name[line].."'s(Victim) SteamID", function() 
    	SetClipboardText(DeathLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("Victim's SteamID copied to clipboard.")
    	DeathLogsMenu:Hide() 
     end )


    DeathLogsMenu:Open() 

end

--[[Props]]--
local PComboBox = vgui.Create("DComboBox",PropPanel)
PComboBox:SetPos(5,PropPanel:GetTall()-60)
PComboBox:SetSize(200,20)
PComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
PComboBox:AddChoice(v:Name())
table.insert(PropLog.HSteamID,v:SteamID())
end

PComboBox.OnSelect = function(panel,index,value,data)
PropLogs:Clear()

	for i=1,#PropLog.SteamID do
                               
        PropLogs:AddLine(PropLog.Time[i],PropLog.Name[i].."("..PropLog.SteamID[i]..")",PropLog.Model[i])
 		PropLogs:SortByColumn(1, true)

 		if (PropLog.HSteamID[index] == PropLog.SteamID[i]) then
 		PropLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, PropLogs:GetLine(i):GetWide()-3,PropLogs:GetLine(i):GetTall())
end
end

end
end

local PButton = vgui.Create("DButton",PropPanel)
PButton:SetPos(220,PropPanel:GetTall()-60)
PButton:SetSize(150,20)
PButton:SetText("Update/Remove Highlights")
PButton.DoClick = function()
DeathLogs:Clear()
PComboBox:Clear(true)
table.Empty(PropLog.HSteamID)
PComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		PComboBox:AddChoice(v:Name())
		table.insert(PropLog.HSteamID,v:SteamID())
	end


	for i=1,#PropLog.SteamID do
                               
        PropLogs:AddLine(PropLog.Time[i],PropLog.Name[i].."("..PropLog.SteamID[i]..")",PropLog.Model[i])
 		PropLogs:SortByColumn(1, true)
	end

end
for i=1,#PropLog.SteamID do
                               
        PropLogs:AddLine(PropLog.Time[i],PropLog.Name[i].."("..PropLog.SteamID[i]..")",PropLog.Model[i])
 		PropLogs:SortByColumn(1, true)
end


PropLogs.OnRowRightClick = function(parent, line) 

    local PropLogsMenu = DermaMenu() 
  	PropLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(PropLogs:GetLine(line):GetValue(1).." "..PropLogs:GetLine(line):GetValue(2).." spawned a "..PropLogs:GetLine(line):GetValue(3))
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		PropLogsMenu:Hide() 
  		end )

    PropLogsMenu:AddOption("Copy "..PropLog.Name[line].."'s SteamID", function() 
    	SetClipboardText(PropLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	PropLogsMenu:Hide() 
end )

  	PropLogsMenu:AddOption("Copy Model", function() 
   	SetClipboardText(PropLogs:GetLine(line):GetValue(3)) 
   	LocalPlayer():ChatPrint("Model copied to clipboard.")
    PropLogsMenu:Hide() 
end )

  


    PropLogsMenu:Open() 

end

--[[Jobs]]--
--[[Name Logs]]--
local JComboBox = vgui.Create("DComboBox",JobPanel)
JComboBox:SetPos(5,JobPanel:GetTall()-60)
JComboBox:SetSize(200,20)
JComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
JComboBox:AddChoice(v:Name())
table.insert(JobLog.HSteamID,v:SteamID())
end

JComboBox.OnSelect = function(panel,index,value,data)
JobLogs:Clear()

for i=1,#JobLog.SteamID do
                               
 		JobLogs:AddLine(JobLog.Time[i],JobLog.Name[i].."("..JobLog.SteamID[i]..")",JobLog.OldTeam[i],JobLog.NewTeam[i])
 		JobLogs:SortByColumn(1, true)

 		if JobLog.HSteamID[index] == JobLog.SteamID[i] then
 		JobLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, JobLogs:GetLine(i):GetWide()-3, JobLogs:GetLine(i):GetTall())
end
end

end
end

local JButton = vgui.Create("DButton",JobPanel)
JButton:SetPos(220,JobPanel:GetTall()-60)
JButton:SetSize(150,20)
JButton:SetText("Update/Remove Highlights")
JButton.DoClick = function()
JobLogs:Clear()
JComboBox:Clear(true)
table.Empty(JobLog.HSteamID)
JComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		JComboBox:AddChoice(v:Name())
		table.insert(JobLog.HSteamID,v:SteamID())
	end


	for i=1,#JobLog.SteamID do
                               
         JobLogs:AddLine(JobLog.Time[i],JobLog.Name[i].."("..JobLog.SteamID[i]..")",JobLog.OldTeam[i],JobLog.NewTeam[i])
 		JobLogs:SortByColumn(1, true)

 	end
end

for i=1,#JobLog.SteamID do
                               
        JobLogs:AddLine(JobLog.Time[i],JobLog.Name[i].."("..JobLog.SteamID[i]..")",JobLog.OldTeam[i],JobLog.NewTeam[i])
 		JobLogs:SortByColumn(1, true)
end


JobLogs.OnRowRightClick = function(parent, line) 
    local JobLogsMenu = DermaMenu() 
  	JobLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(JobLogs:GetLine(line):GetValue(1).." "..JobLogs:GetLine(line):GetValue(2).." switched from "..JobLogs:GetLine(line):GetValue(3).." to a "..JobLogs:GetLine(line):GetValue(4))
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		JobLogsMenu:Hide() 
  		end )

    JobLogsMenu:AddOption("Copy "..JobLog.Name[line].."'s SteamID", function() 
    	SetClipboardText(JobLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	JobLogsMenu:Hide() 
end )



  


    JobLogsMenu:Open() 

end

--[[Connection]]--
local CoComboBox = vgui.Create("DComboBox",ConnectPanel)
CoComboBox:SetPos(5,ConnectPanel:GetTall()-60)
CoComboBox:SetSize(200,20)
CoComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
CoComboBox:AddChoice(v:Name())
table.insert(ConnectLog.HSteamID,v:SteamID())
end

CoComboBox.OnSelect = function(panel,index,value,data)
ConnectionLogs:Clear()

                              
     for i=1,#ConnectLog.SteamID do
                               
        ConnectionLogs:AddLine(ConnectLog.Time[i],ConnectLog.Method[i],ConnectLog.Name[i].."("..ConnectLog.SteamID[i]..")")
 		ConnectionLogs:SortByColumn(1, true)
	

 		if ConnectLog.HSteamID[index] == ConnectLog.SteamID[i] then
 		ConnectionLogs:GetLine(i).Paint = function()
 		if ConnectLog.Method[i] == "Connected" then
 		surface.SetDrawColor(0,255,0,255)
		surface.DrawRect(1, 1, ConnectionLogs:GetLine(i):GetWide()-3, ConnectionLogs:GetLine(i):GetTall())
	elseif ConnectLog.Method[i] == "Disconnected" then
		surface.SetDrawColor(255,0,0,255)
		surface.DrawRect(1, 1, ConnectionLogs:GetLine(i):GetWide()-3, ConnectionLogs:GetLine(i):GetTall())
	end
end
end

end
end

local CoButton = vgui.Create("DButton",ConnectPanel)
CoButton:SetPos(220,ConnectPanel:GetTall()-60)
CoButton:SetSize(150,20)
CoButton:SetText("Update/Remove Highlights")
CoButton.DoClick = function()
ConnectionLogs:Clear()
CoComboBox:Clear(true)
table.Empty(ConnectLog.HSteamID)
CoComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		CoComboBox:AddChoice(v:Name())
		table.insert(ConnectLog.HSteamID,v:SteamID())
	end


for i=1,#ConnectLog.SteamID do
                               
        ConnectionLogs:AddLine(ConnectLog.Time[i],ConnectLog.Method[i],ConnectLog.Name[i].."("..ConnectLog.SteamID[i]..")")
 		ConnectionLogs:SortByColumn(1, true)
end


end
for i=1,#ConnectLog.SteamID do
                               
        ConnectionLogs:AddLine(ConnectLog.Time[i],ConnectLog.Method[i],ConnectLog.Name[i].."("..ConnectLog.SteamID[i]..")")
 		ConnectionLogs:SortByColumn(1, true)
end


ConnectionLogs.OnRowRightClick = function(parent, line) 
    local ConnectLogsMenu = DermaMenu() 
  	ConnectLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(ConnectionLogs:GetLine(line):GetValue(1).." "..ConnectionLogs:GetLine(line):GetValue(3).." just "..ConnectionLogs:GetLine(line):GetValue(2)..".")
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		ConnectLogsMenu:Hide() 
  		end )

    ConnectLogsMenu:AddOption("Copy "..ConnectLog.Name[line].."'s SteamID", function() 
    	SetClipboardText(ConnectLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	ConnectLogsMenu:Hide() 
end )


    ConnectLogsMenu:Open() 

end

--[[Tools]]--
local TComboBox = vgui.Create("DComboBox",ToolPanel)
TComboBox:SetPos(5,ToolPanel:GetTall()-60)
TComboBox:SetSize(200,20)
TComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
TComboBox:AddChoice(v:Name())
table.insert(ToolLog.HSteamID,v:SteamID())
end

TComboBox.OnSelect = function(panel,index,value,data)
ToolLogs:Clear()

for i=1,#ToolLog.SteamID do
                               
        ToolLogs:AddLine(ToolLog.Time[i],ToolLog.Name[i].."("..ToolLog.SteamID[i]..")",ToolLog.Tool[i])
 		ToolLogs:SortByColumn(1, true)

 		if ToolLog.HSteamID[index] == ToolLog.SteamID[i] then
 		ToolLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, ToolLogs:GetLine(i):GetWide()-3, ToolLogs:GetLine(i):GetTall())
end
end

end
end

local TButton = vgui.Create("DButton",ToolPanel)
TButton:SetPos(220,ToolPanel:GetTall()-60)
TButton:SetSize(150,20)
TButton:SetText("Update/Remove Highlights")
TButton.DoClick = function()
ToolLogs:Clear()
TComboBox:Clear(true)
table.Empty(ToolLog.HSteamID)
TComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		TComboBox:AddChoice(v:Name())
		table.insert(ToolLog.HSteamID,v:SteamID())
	end


for i=1,#ToolLog.SteamID do
                               
        ToolLogs:AddLine(ToolLog.Time[i],ToolLog.Name[i].."("..ToolLog.SteamID[i]..")",ToolLog.Tool[i])
 		ToolLogs:SortByColumn(1, true)
end

end
for i=1,#ToolLog.SteamID do
                               
        ToolLogs:AddLine(ToolLog.Time[i],ToolLog.Name[i].."("..ToolLog.SteamID[i]..")",ToolLog.Tool[i])
 		ToolLogs:SortByColumn(1, true)
end


	ToolLogs.OnRowRightClick = function(parent, line) 
    local ToolLogsMenu = DermaMenu() 
  	ToolLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(ToolLogs:GetLine(line):GetValue(1).." "..ToolLogs:GetLine(line):GetValue(2).." attempted to use tool "..ToolLogs:GetLine(line):GetValue(3))
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		ToolLogsMenu:Hide() 
  		end )

    ToolLogsMenu:AddOption("Copy "..ToolLog.Name[line].."'s SteamID", function() 
    	SetClipboardText(ToolLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	ToolLogsMenu:Hide() 
end )

        ToolLogsMenu:AddOption("Copy ToolName", function() 
    	SetClipboardText(ToolLogs:GetLine(line):GetValue(3)) 
    	LocalPlayer():ChatPrint("ToolName copied to clipboard.")
    	ToolLogsMenu:Hide() 
end )


    ToolLogsMenu:Open() 

end

--[[Damage Logs]]--
local DmComboBox = vgui.Create("DComboBox",DMGPanel)
DmComboBox:SetPos(5,DMGPanel:GetTall()-60)
DmComboBox:SetSize(200,20)
DmComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
DmComboBox:AddChoice(v:Name())
table.insert(DMGLog.HSteamID,v:SteamID())
end




DmComboBox.OnSelect = function(panel,index,value,data)
DMGLogs:Clear()

for i=1,#DMGLog.SteamID do
                               
        DMGLogs:AddLine(DMGLog.Time[i],"["..DMGLog.Method[i].."]",DMGLog.KillerName[i].."("..DMGLog.KSteamID[i]..")",DMGLog.Name[i].."("..DMGLog.SteamID[i]..")",tostring(DMGLog.Damage[i]),tostring(DMGLog.InflictorName[i]))
 		DMGLogs:SortByColumn(1, true)

 		if DMGLog.Method[i] == "DMG" then

 		if DMGLog.HSteamID[index] == DMGLog.SteamID[i] then
 		DMGLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(0,190,0,225)
		surface.DrawRect(1, 1, DMGLogs:GetLine(i):GetWide()-3, DMGLogs:GetLine(i):GetTall())
		end
	end
		if DMGLog.HSteamID[index] == DMGLog.KSteamID[i] then
 		DMGLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(190,0,0,225)
		surface.DrawRect(1, 1, DMGLogs:GetLine(i):GetWide()-3, DMGLogs:GetLine(i):GetTall())
		end
	end
end

		if DMGLog.Method[i] == "KILL" then

 		if DMGLog.HSteamID[index] == DMGLog.SteamID[i] then
 		DMGLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(0,255,0,255)
		surface.DrawRect(1, 1, DMGLogs:GetLine(i):GetWide()-3, DMGLogs:GetLine(i):GetTall())
		end
	end
		if DMGLog.HSteamID[index] == DMGLog.KSteamID[i] then
 		DMGLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(255,0,0,255)
		surface.DrawRect(1, 1, DMGLogs:GetLine(i):GetWide()-3, DMGLogs:GetLine(i):GetTall())
		end
	end


end

end
end





local DmButton = vgui.Create("DButton",DMGPanel)
DmButton:SetPos(220,DMGPanel:GetTall()-60)
DmButton:SetSize(150,20)
DmButton:SetText("Update/Remove Highlights")
DmButton.DoClick = function()
DMGLogs:Clear()
DmComboBox:Clear(true)
table.Empty(DMGLog.HSteamID)
DmComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		DmComboBox:AddChoice(v:Name())
		table.insert(DMGLog.HSteamID,v:SteamID())
	end

for i=1,#DMGLog.SteamID do
                               
        DMGLogs:AddLine(DMGLog.Time[i],"["..DMGLog.Method[i].."]",DMGLog.KillerName[i].."("..DMGLog.KSteamID[i]..")",DMGLog.Name[i].."("..DMGLog.SteamID[i]..")",tostring(DMGLog.Damage[i]),tostring(DMGLog.InflictorName[i]))
 		DMGLogs:SortByColumn(1, true)
end
end


for i=1,#DMGLog.SteamID do
                               
        DMGLogs:AddLine(DMGLog.Time[i],"["..DMGLog.Method[i].."]",DMGLog.KillerName[i].."("..DMGLog.KSteamID[i]..")",DMGLog.Name[i].."("..DMGLog.SteamID[i]..")",tostring(DMGLog.Damage[i]),tostring(DMGLog.InflictorName[i]))
 		DMGLogs:SortByColumn(1, true)
end


	DMGLogs.OnRowRightClick = function(parent, line) 
    local DMGLogsMenu = DermaMenu() 
  	DMGLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(DMGLogs:GetLine(line):GetValue(1).." "..DMGLogs:GetLine(line):GetValue(2)..DMGLogs:GetLine(line):GetValue(3).." hurt "..DMGLogs:GetLine(line):GetValue(4).." with "..DMGLogs:GetLine(line):GetValue(6).." for "..DMGLogs:GetLine(line):GetValue(5).." damage.")
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		DMGLogsMenu:Hide() 
  		end )

   		DMGLogsMenu:AddOption("Copy "..DMGLog.KillerName[line].."'s(Killer) SteamID", function() 
    	SetClipboardText(DMGLog.KSteamID[line]) 
    	LocalPlayer():ChatPrint("Killer's SteamID copied to clipboard.")
    	DMGLogsMenu:Hide() 
end )

  
    	DMGLogsMenu:AddOption("Copy "..DMGLog.Name[line].."'s(Victim) SteamID", function() 
    	SetClipboardText(DMGLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("Victim's SteamID copied to clipboard.")
    	DMGLogsMenu:Hide() 
     end )


    DMGLogsMenu:Open() 

end

--[[Name Logs]]--
local NComboBox = vgui.Create("DComboBox",NamePanel)
NComboBox:SetPos(5,NamePanel:GetTall()-60)
NComboBox:SetSize(200,20)
NComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
NComboBox:AddChoice(v:Name())
table.insert(NameLog.HSteamID,v:SteamID())
end

NComboBox.OnSelect = function(panel,index,value,data)
NameLogs:Clear()

for i=1,#NameLog.SteamID do
                               
        NameLogs:AddLine(NameLog.Time[i],NameLog.Name[i].."("..NameLog.SteamID[i]..")",NameLog.OldName[i],NameLog.NewName[i])
 		NameLogs:SortByColumn(1, true)

 		if NameLog.HSteamID[index] == NameLog.SteamID[i] then
 		NameLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, NameLogs:GetLine(i):GetWide()-3, NameLogs:GetLine(i):GetTall())
end
end

end
end

local NButton = vgui.Create("DButton",NamePanel)
NButton:SetPos(220,NamePanel:GetTall()-60)
NButton:SetSize(150,20)
NButton:SetText("Update/Remove Highlights")
NButton.DoClick = function()
NameLogs:Clear()
NComboBox:Clear(true)
table.Empty(NameLog.HSteamID)
NComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		NComboBox:AddChoice(v:Name())
		table.insert(NameLog.HSteamID,v:SteamID())
	end

	for i=1,#NameLog.SteamID do
                               
        NameLogs:AddLine(NameLog.Time[i],NameLog.Name[i].."("..NameLog.SteamID[i]..")",NameLog.OldName[i],NameLog.NewName[i])
 		NameLogs:SortByColumn(1, true)

 	end
end
for i=1,#NameLog.SteamID do
                               
        NameLogs:AddLine(NameLog.Time[i],NameLog.Name[i].."("..NameLog.SteamID[i]..")",NameLog.OldName[i],NameLog.NewName[i])
 		NameLogs:SortByColumn(1, true)
 		end
	NameLogs.OnRowRightClick = function(parent, line) 
    local NameLogsMenu = DermaMenu() 
  	NameLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(NameLogs:GetLine(line):GetValue(1).." "..NameLogs:GetLine(line):GetValue(2).." changed their name from \""..NameLogs:GetLine(line):GetValue(3).."\" to \""..NameLogs:GetLine(line):GetValue(4).."\"")
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		NameLogsMenu:Hide() 
  		end )

   		NameLogsMenu:AddOption("Copy "..NameLog.Name[line].."'s SteamID", function() 
    	SetClipboardText(NameLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	NameLogsMenu:Hide() 
end )

 
    NameLogsMenu:Open() 

end
--[[ARREST/UNARREST LOGS]]--
local AComboBox = vgui.Create("DComboBox",ArrestPanel)
AComboBox:SetPos(5,ArrestPanel:GetTall()-60)
AComboBox:SetSize(200,20)
AComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
AComboBox:AddChoice(v:Name())
table.insert(ArrestLog.HSteamID,v:SteamID())
end

AComboBox.OnSelect = function(panel,index,value,data)
ArrestLogs:Clear()

for i=1,#ArrestLog.SteamID do
                               
        ArrestLogs:AddLine(ArrestLog.Time[i],ArrestLog.Method[i],ArrestLog.Officer[i].."("..ArrestLog.OSteamID[i]..")",ArrestLog.Name[i].."("..ArrestLog.SteamID[i]..")")
 		ArrestLogs:SortByColumn(1, true)

 		if ArrestLog.HSteamID[index] == ArrestLog.SteamID[i] or ArrestLog.HSteamID[index] == ArrestLog.OSteamID[i] then
 			if ArrestLog.Method[i] == "Arrested" then
 		ArrestLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, ArrestLogs:GetLine(i):GetWide()-3, ArrestLogs:GetLine(i):GetTall())
		end

			end
				if ArrestLog.Method[i] == "Unarrested" then
 		ArrestLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(0,230,0,255)
		surface.DrawRect(1, 1, ArrestLogs:GetLine(i):GetWide()-3, ArrestLogs:GetLine(i):GetTall())
		end

			end
end

end
end

local AButton = vgui.Create("DButton",ArrestPanel)
AButton:SetPos(220,ArrestPanel:GetTall()-60)
AButton:SetSize(150,20)
AButton:SetText("Update/Remove Highlights")
AButton.DoClick = function()
ArrestLogs:Clear()
AComboBox:Clear(true)
table.Empty(ArrestLog.HSteamID)
AComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		AComboBox:AddChoice(v:Name())
		table.insert(ArrestLog.HSteamID,v:SteamID())
	end

for i=1,#ArrestLog.SteamID do
                               
        ArrestLogs:AddLine(ArrestLog.Time[i],ArrestLog.Method[i],ArrestLog.Officer[i].."("..ArrestLog.OSteamID[i]..")",ArrestLog.Name[i].."("..ArrestLog.SteamID[i]..")")
 		ArrestLogs:SortByColumn(1, true)
end
end
for i=1,#ArrestLog.SteamID do
                               
        ArrestLogs:AddLine(ArrestLog.Time[i],ArrestLog.Method[i],ArrestLog.Officer[i].."("..ArrestLog.OSteamID[i]..")",ArrestLog.Name[i].."("..ArrestLog.SteamID[i]..")")
 		ArrestLogs:SortByColumn(1, true)
end


	ArrestLogs.OnRowRightClick = function(parent, line) 
    local ArrestLogsMenu = DermaMenu() 
  	ArrestLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(ArrestLogs:GetLine(line):GetValue(1).." "..ArrestLogs:GetLine(line):GetValue(3).." "..ArrestLogs:GetLine(line):GetValue(2).." "..ArrestLogs:GetLine(line):GetValue(4))
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		ArrestLogsMenu:Hide() 
  		end )

   		ArrestLogsMenu:AddOption("Copy "..ArrestLog.Officer[line].."'s(Officer) SteamID", function() 
    	SetClipboardText(ArrestLog.OSteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	ArrestLogsMenu:Hide() 
end )

   		ArrestLogsMenu:AddOption("Copy "..ArrestLog.Name[line].."'s(Culprit) SteamID", function() 
    	SetClipboardText(ArrestLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	ArrestLogsMenu:Hide() 
end )

 
    ArrestLogsMenu:Open() 

end


--[[DEMOTE LOGS]]--
local DemComboBox = vgui.Create("DComboBox",DemotePanel)
DemComboBox:SetPos(5,DemotePanel:GetTall()-60)
DemComboBox:SetSize(200,20)
DemComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
DemComboBox:AddChoice(v:Name())
table.insert(DemoteLog.HSteamID,v:SteamID())
end

DemComboBox.OnSelect = function(panel,index,value,data)
DemoteLogs:Clear()

for i=1,#DemoteLog.SteamID do
                               
        DemoteLogs:AddLine(DemoteLog.Time[i],DemoteLog.Demoter[i].."("..DemoteLog.DSteamID[i]..")",DemoteLog.Name[i].."("..DemoteLog.SteamID[i]..")",DemoteLog.Job[i],DemoteLog.Reason[i])
 		DemoteLogs:SortByColumn(1, true)

 		if DemoteLog.HSteamID[index] == DemoteLog.SteamID[i]  then
 		
 		DemoteLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(0,230,0,255)
		surface.DrawRect(1, 1, DemoteLogs:GetLine(i):GetWide()-3, DemoteLogs:GetLine(i):GetTall())
		end
	end
			
		if DemoteLog.HSteamID[index] == DemoteLog.DSteamID[i] then
 		DemoteLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, DemoteLogs:GetLine(i):GetWide()-3, DemoteLogs:GetLine(i):GetTall())
		end
	end
			


end
end

local DemButton = vgui.Create("DButton",DemotePanel)
DemButton:SetPos(220,DemotePanel:GetTall()-60)
DemButton:SetSize(150,20)
DemButton:SetText("Update/Remove Highlights")
DemButton.DoClick = function()
DemoteLogs:Clear()
DemComboBox:Clear(true)
table.Empty(DemoteLog.HSteamID)
DemComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		DemComboBox:AddChoice(v:Name())
		table.insert(DemoteLog.HSteamID,v:SteamID())
	end

for i=1,#DemoteLog.SteamID do
                               
        DemoteLogs:AddLine(DemoteLog.Time[i],DemoteLog.Demoter[i].."("..DemoteLog.DSteamID[i]..")",DemoteLog.Name[i].."("..DemoteLog.SteamID[i]..")",DemoteLog.Job[i],DemoteLog.Reason[i])
 		DemoteLogs:SortByColumn(1, true)
end
end


for i=1,#DemoteLog.SteamID do
                               
        DemoteLogs:AddLine(DemoteLog.Time[i],DemoteLog.Demoter[i].."("..DemoteLog.DSteamID[i]..")",DemoteLog.Name[i].."("..DemoteLog.SteamID[i]..")",DemoteLog.Job[i],DemoteLog.Reason[i])
 		DemoteLogs:SortByColumn(1, true)
end


	DemoteLogs.OnRowRightClick = function(parent, line) 
    local DemoteLogsMenu = DermaMenu() 
  	DemoteLogsMenu:AddOption("Copy Line", function() 
  		SetClipboardText(DemoteLogs:GetLine(line):GetValue(1).." "..DemoteLogs:GetLine(line):GetValue(2).." started a demotion vote on "..DemoteLogs:GetLine(line):GetValue(3).." who was a "..DemoteLogs:GetLine(line):GetValue(4).." for the reason: "..DemoteLogs:GetLine(line):GetValue(5))
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		DemoteLogsMenu:Hide() 
  		end )

   		DemoteLogsMenu:AddOption("Copy "..DemoteLog.Demoter[line].."'s(Demoter) SteamID", function() 
    	SetClipboardText(DemoteLog.DSteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	DemoteLogsMenu:Hide() 
end )

   		DemoteLogsMenu:AddOption("Copy "..DemoteLog.Name[line].."'s(Demotee) SteamID", function() 
    	SetClipboardText(DemoteLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	DemoteLogsMenu:Hide() 
end )

 
    DemoteLogsMenu:Open() 

end
--[[HIT LOGS]]--
local HComboBox = vgui.Create("DComboBox",HitPanel)
HComboBox:SetPos(5,HitPanel:GetTall()-60)
HComboBox:SetSize(200,20)
HComboBox:SetValue("Select a Player!")
for k,v in pairs(player.GetAll()) do
HComboBox:AddChoice(v:Name())
table.insert(HitLog.HSteamID,v:SteamID())
end

HComboBox.OnSelect = function(panel,index,value,data)
HitLogs:Clear()


for i=1,#HitLog.SteamID do
          if HitLog.Method[i] != "Failed" then                  
        HitLogs:AddLine(HitLog.Time[i],HitLog.Method[i],HitLog.Name[i].."("..HitLog.SteamID[i]..")",HitLog.Target[i].."("..HitLog.TSteamID[i]..")",HitLog.Customer[i].."("..HitLog.CSteamID[i]..")")
 		HitLogs:SortByColumn(1, true)
 	else
		HitLogs:AddLine(HitLog.Time[i],HitLog.Method[i],HitLog.Name[i].."("..HitLog.SteamID[i]..")",HitLog.Target[i].."("..HitLog.TSteamID[i]..")",HitLog.Customer[i])
 		HitLogs:SortByColumn(1, true)
 	end



 		if HitLog.HSteamID[index] == HitLog.SteamID[i]  then
 		
 		HitLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, HitLogs:GetLine(i):GetWide()-3, HitLogs:GetLine(i):GetTall())
		end
	end
			
		if HitLog.HSteamID[index] == HitLog.TSteamID[i] then
 		DemoteLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(230,0,0,255)
		surface.DrawRect(1, 1, HitLogs:GetLine(i):GetWide()-3, HitLogs:GetLine(i):GetTall())
		end
	end
			
    if HitLog.HSteamID[index] == HitLog.CSteamID[i] then
 		DemoteLogs:GetLine(i).Paint = function()
 		surface.SetDrawColor(255,128,0,255)
		surface.DrawRect(1, 1, HitLogs:GetLine(i):GetWide()-3, HitLogs:GetLine(i):GetTall())
		end
	end

end
end

local HButton = vgui.Create("DButton",HitPanel)
HButton:SetPos(220,HitPanel:GetTall()-60)
HButton:SetSize(150,20)
HButton:SetText("Update/Remove Highlights")
HButton.DoClick = function()
DemoteLogs:Clear()
HComboBox:Clear(true)
table.Empty(HitLog.HSteamID)
HComboBox:SetValue("Select a Player!")
	for k,v in pairs(player.GetAll()) do
		HComboBox:AddChoice(v:Name())
		table.insert(HitLog.HSteamID,v:SteamID())
	end


for i=1,#HitLog.SteamID do
          if HitLog.Method[i] != "Failed" then                  
        HitLogs:AddLine(HitLog.Time[i],HitLog.Method[i],HitLog.Name[i].."("..HitLog.SteamID[i]..")",HitLog.Target[i].."("..HitLog.TSteamID[i]..")",HitLog.Customer[i].."("..HitLog.CSteamID[i]..")")
 		HitLogs:SortByColumn(1, true)
 	else
		HitLogs:AddLine(HitLog.Time[i],HitLog.Method[i],HitLog.Name[i].."("..HitLog.SteamID[i]..")",HitLog.Target[i].."("..HitLog.TSteamID[i]..")",HitLog.Customer[i])
 		HitLogs:SortByColumn(1, true)
 	end

end
end

for i=1,#HitLog.SteamID do
          if HitLog.Method[i] != "Failed" then                  
        HitLogs:AddLine(HitLog.Time[i],HitLog.Method[i],HitLog.Name[i].."("..HitLog.SteamID[i]..")",HitLog.Target[i].."("..HitLog.TSteamID[i]..")",HitLog.Customer[i].."("..HitLog.CSteamID[i]..")")
 		HitLogs:SortByColumn(1, true)
 	else
		HitLogs:AddLine(HitLog.Time[i],HitLog.Method[i],HitLog.Name[i].."("..HitLog.SteamID[i]..")",HitLog.Target[i].."("..HitLog.TSteamID[i]..")",HitLog.Customer[i])
 		HitLogs:SortByColumn(1, true)
 	end

end


	HitLogs.OnRowRightClick = function(parent, line) 
    local HitLogsMenu = DermaMenu() 
  	HitLogsMenu:AddOption("Copy Line", function() 
  		if HitLog.Method[line] == "Accepted" then
  		SetClipboardText(HitLogs:GetLine(line):GetValue(1).." ["..HitLogs:GetLine(line):GetValue(2).."] "..HitLogs:GetLine(line):GetValue(5).." put a hit on "..HitLogs:GetLine(line):GetValue(4).." via "..HitLogs:GetLine(line):GetValue(3))
  		elseif HitLog.Method[line] == "Completed" then
  			SetClipboardText(HitLogs:GetLine(line):GetValue(1).." ["..HitLogs:GetLine(line):GetValue(2).."] "..HitLogs:GetLine(line):GetValue(3).." completed their hit on "..HitLogs:GetLine(line):GetValue(4).." which was put out by "..HitLogs:GetLine(line):GetValue(5))

  		elseif HitLog.Method[line] == "Failed" then
  			SetClipboardText(HitLogs:GetLine(line):GetValue(1).." ["..HitLogs:GetLine(line):GetValue(2).."] "..HitLogs:GetLine(line):GetValue(3).." failed their hit on "..HitLogs:GetLine(line):GetValue(4).." because "..HitLogs:GetLine(line):GetValue(5))

  		end
  		LocalPlayer():ChatPrint("Line coped to clipboard.")
  		HitLogsMenu:Hide() 

  		end )

   		HitLogsMenu:AddOption("Copy "..HitLog.Name[line].."'s(Hitman) SteamID", function() 
    	SetClipboardText(HitLog.SteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	HitLogsMenu:Hide() 
end )

   		HitLogsMenu:AddOption("Copy "..HitLog.Target[line].."'s(Target) SteamID", function() 
    	SetClipboardText(HitLog.TSteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	HitLogsMenu:Hide() 
end )
if HitLog.Method[line] != "Failed" then
   		HitLogsMenu:AddOption("Copy "..HitLog.Customer[line].."'s(Customer) SteamID", function() 
    	SetClipboardText(HitLog.CSteamID[line]) 
    	LocalPlayer():ChatPrint("SteamID copied to clipboard.")
    	HitLogsMenu:Hide() 
end )
   	else
   		 HitLogsMenu:AddOption("Copy Reason", function() 
    	SetClipboardText(HitLog.Customer[line]) 
    	LocalPlayer():ChatPrint("Reason copied to clipboard.")
    	HitLogsMenu:Hide() 
end )
 end
    HitLogsMenu:Open() 

end



			--[[Specific Groups for Specific Categories]]--






		if LOGS_DISPLAY_NAME==1 and ShouldDisplayName== true  then
			LogSheet:AddSheet("Name Changes",NamePanel, _,false,false,"Shows Name Changes")
		end

		if LOGS_DISPLAY_JOB==1 and ShouldDisplayJob== true then
			LogSheet:AddSheet("Job Changes",JobPanel, _,false,false,"Shows Job Changes")
		end
		if LOGS_DISPLAY_KILLS==1 and ShouldDisplayDeath== true then
			LogSheet:AddSheet("Kills/Deaths",DeathPanel, _,false,false,"Shows the Kills/Deaths")
		end
		if LOGS_DISPLAY_PROP==1 and ShouldDisplayProp== true then
			LogSheet:AddSheet("Props",PropPanel, _,false,false,"Shows the PropSpawn logs")
		end
		if LOGS_DISPLAY_TOOLGUN==1 and ShouldDisplayTool== true then
			LogSheet:AddSheet("Toolgun",ToolPanel, _,false,false,"Shows the ToolGun logs")
		end
		if LOGS_DISPLAY_CONNECT==1 and ShouldDisplayConnect== true then
			LogSheet:AddSheet("Connections",ConnectPanel, _,false,false,"Shows the Connects/Disconnects")
		end
		if LOGS_DISPLAY_DMG==1 and ShouldDisplayDMG== true then
			LogSheet:AddSheet("Damage Logs",DMGPanel, _,false,false,"Shows the Damage Log")
		end
		if LOGS_DISPLAY_ARREST==1 and ShouldDisplayArrest== true then
			LogSheet:AddSheet("Arrests/Unarrests",ArrestPanel, _,false,false,"Logs Arrests/Unarrests")
		end

		if LOGS_DISPLAY_DEMOTE == 1 and ShouldDisplayDemote== true then
			LogSheet:AddSheet("Demotions",DemotePanel, _,false,false,"Logs Demotes")
		end

		if LOGS_DISPLAY_HIT == 1 and ShouldDisplayHit== true then
			LogSheet:AddSheet("Hits",HitPanel, _,false,false,"Logs Hits")
		end


		
end)


net.Receive("SendLogs", function()

local a = {}

a = net.ReadTable()

--[[Kills/Deaths]]--

if a.Type == "Death" and LOGS_DISPLAY_KILLS==1 then

a.Time = os.date("[%I:%M:%S %p]",os.time())


table.insert(DeathLog.Time,a.Time)
table.insert(DeathLog.SteamID,a.SteamID)
table.insert(DeathLog.Name,a.Name)
table.insert(DeathLog.KillerName,a.KillerName)
table.insert(DeathLog.InflictorName,a.InflictorName)
table.insert(DeathLog.KSteamID,a.KillerSteamID)


	if #DeathLog.SteamID > LOGS_MAX_KILLS then
		table.remove(DeathLog.SteamID,1)
		table.remove(DeathLog.KSteamID,1)
		table.remove(DeathLog.Name,1)
		table.remove(DeathLog.KillerName,1)
		table.remove(DeathLog.Time,1)
		table.remove(DeathLog.InflictorName,1)
	end

end


--[[Props]]--
if a.Type == "Prop" and LOGS_DISPLAY_PROP==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(PropLog.Time,a.Time)
table.insert(PropLog.SteamID,a.SteamID)
table.insert(PropLog.Name,a.Name)
table.insert(PropLog.Model,a.Model)

	if #PropLog.SteamID > LOGS_MAX_PROP then
		table.remove(PropLog.SteamID,1)
		table.remove(PropLog.Model,1)
		table.remove(PropLog.Name,1)
		table.remove(PropLog.Time,1)
	end
end
--[[Jobs]]--
if a.Type == "Job" and LOGS_DISPLAY_JOB==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(JobLog.Time,a.Time)
table.insert(JobLog.SteamID,a.SteamID)
table.insert(JobLog.Name,a.Name)
table.insert(JobLog.OldTeam,a.OldTeam)
table.insert(JobLog.NewTeam,a.NewTeam)

	if #JobLog.SteamID > LOGS_MAX_JOB then
		table.remove(JobLog.SteamID,1)
		table.remove(JobLog.Name,1)
		table.remove(JobLog.Time,1)
		table.remove(JobLog.OldTeam,1)
		table.remove(JobLog.NewTeam,1)

	end

end
--[[Connection]]--
if a.Type == "Connect" and LOGS_DISPLAY_CONNECT==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(ConnectLog.Time,a.Time)
table.insert(ConnectLog.SteamID,a.SteamID)
table.insert(ConnectLog.Name,a.Name)
table.insert(ConnectLog.Method,a.Method)

	if #ConnectLog.SteamID > LOGS_MAX_CONNECT then
		table.remove(ConnectLog.Time,1)
		table.remove(ConnectLog.SteamID,1)
		table.remove(ConnectLog.Name,1)
		table.remove(ConnectLog.Method,1)

	end

end

--[[Tool Logs]]--
if a.Type == "ToolGun" and LOGS_DISPLAY_TOOLGUN==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(ToolLog.Time,a.Time)
table.insert(ToolLog.SteamID,a.SteamID)
table.insert(ToolLog.Name,a.Name)
table.insert(ToolLog.Tool,a.Tool)

	if #ToolLog.SteamID > LOGS_MAX_TOOLGUN then
		table.remove(ToolLog.Time,1)
		table.remove(ToolLog.SteamID,1)
		table.remove(ToolLog.Name,1)
		table.remove(ToolLog.Tool,1)
	end

end
--[[DMG Logs]]--
if a.Type == "DMG" and LOGS_DISPLAY_DMG==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(DMGLog.Time,a.Time)
table.insert(DMGLog.SteamID,a.SteamID)
table.insert(DMGLog.Name,a.Name)
table.insert(DMGLog.KillerName,a.KillerName)
table.insert(DMGLog.KSteamID,a.KillerSteamID)
table.insert(DMGLog.Method,a.Method)
table.insert(DMGLog.InflictorName,a.InflictorName)
table.insert(DMGLog.Damage,a.Damage)

	if #DMGLog.SteamID > LOGS_MAX_DMG then
		table.remove(DMGLog.Time,1)
		table.remove(DMGLog.SteamID,1)
		table.remove(DMGLog.Name,1)
		table.remove(DMGLog.KillerName,1)
		table.remove(DMGLog.KSteamID,1)
		table.remove(DMGLog.InflictorName,1)
		table.remove(DMGLog.Method,1)
		table.remove(DMGLog.Damage,1)

	end
end

--[[Name Logs]]--
if a.Type == "Name" and LOGS_DISPLAY_NAME==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(NameLog.Time,a.Time)
table.insert(NameLog.SteamID,a.SteamID)
table.insert(NameLog.Name,a.Name)
table.insert(NameLog.OldName,a.OldName)
table.insert(NameLog.NewName,a.NewName)

	if #NameLog.SteamID > LOGS_MAX_NAME then
		table.remove(NameLog.SteamID,1)
		table.remove(NameLog.Name,1)
		table.remove(NameLog.Time,1)
		table.remove(NameLog.OldName,1)
		table.remove(NameLog.NewName,1)

	end

end

--[[Arrest/Unarrest Logs]]--
if a.Type == "Arrest" and LOGS_DISPLAY_ARREST==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(ArrestLog.Time,a.Time)
table.insert(ArrestLog.SteamID,a.SteamID)
table.insert(ArrestLog.Name,a.Name)
table.insert(ArrestLog.Method,a.Method)
table.insert(ArrestLog.Officer,a.Officer)
table.insert(ArrestLog.OSteamID,a.OSteamID)

	if #ArrestLog.SteamID > LOGS_MAX_ARREST then
		table.remove(ArrestLog.SteamID,1)
		table.remove(ArrestLog.Name,1)
		table.remove(ArrestLog.Time,1)
		table.remove(ArrestLog.Method,1)
		table.remove(ArrestLog.Officer,1)
		table.remove(ArrestLog.OSteamID,1)

	end
end


--[[Demote Logs]]--
if a.Type == "Demote" and LOGS_DISPLAY_DEMOTE==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(DemoteLog.Time,a.Time)
table.insert(DemoteLog.SteamID,a.SteamID)
table.insert(DemoteLog.Name,a.Name)
table.insert(DemoteLog.Demoter,a.Demoter)
table.insert(DemoteLog.DSteamID,a.DSteamID)
table.insert(DemoteLog.Job,a.Job)
table.insert(DemoteLog.Reason,a.Reason)

	if #DemoteLog.SteamID > LOGS_MAX_DEMOTE then
		table.remove(DemoteLog.SteamID,1)
		table.remove(DemoteLog.Name,1)
		table.remove(DemoteLog.Time,1)
		table.remove(DemoteLog.Demoter,1)
		table.remove(DemoteLog.DSteamID,1)
		table.remove(DemoteLog.Job,1)
		table.remove(DemoteLog.Reason,1)

	end
end

--[[Demote Logs]]--
if a.Type == "Hit" and LOGS_DISPLAY_HIT==1 then
a.Time = os.date("[%I:%M:%S %p]",os.time())

table.insert(HitLog.Time,a.Time)
table.insert(HitLog.SteamID,a.SteamID)
table.insert(HitLog.Name,a.Name)
table.insert(HitLog.Method,a.Method)
table.insert(HitLog.TSteamID,a.TSteamID)
table.insert(HitLog.Target,a.Target)
table.insert(HitLog.Customer,a.Customer)
table.insert(HitLog.CSteamID,a.CSteamID)

	if #HitLog.SteamID > LOGS_MAX_HIT then
		table.remove(HitLog.SteamID,1)
		table.remove(HitLog.Name,1)
		table.remove(HitLog.Time,1)
		table.remove(HitLog.Method,1)
		table.remove(HitLog.TSteamID,1)
		table.remove(HitLog.Target,1)
		table.remove(HitLog.Customer,1)
		table.remove(HitLog.CSteamID,1)

	end
end
	end)