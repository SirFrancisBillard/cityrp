net.Receive("OpenRPNameMenu", function()
    if (!GAMEMODE.Config.allowrpnames) then
	    Derma_Message(
		    "A-M-A-Z-I-N-G-!\nIt seems like the stupid owner of this server doesn't read descriptions and disabled /rpname.\nThis won't work without it, stop kissing his ass and go swear at him!",
			"GG ANALPHABETISM",
			"What a Dumbfuck!"
		)
	return end
	
	local Name = net.ReadTable()
	
	if (#Name > 0) then
	    NameTable = {
		    ["FirstName"] = Name[1],
		    ["LastName"] = Name[2]
		}
    else
	    NameTable = {
		    ["FirstName"] = "First Name",
		    ["LastName"] = "Last Name"
		}
	end
	
	local base = vgui.Create("DFrame")
	
	base:SetTitle("Set Your Roleplay Name")
	base:SetSize(ScrW() *0.190, ScrH() *0.135)
    base:SetSkin("DarkRP")
	base:ShowCloseButton(false)
	base:Center()
	base:MakePopup()
	
	local panel = vgui.Create("DPanel", base)
	
	panel:SetSize(ScrW() *0.074, ScrH() *0.090)
	panel:SetPos(ScrW() *0.006, ScrH() *0.037)

	local icon = vgui.Create("AvatarImage", panel)
    
	icon:SetSize(ScrW() *0.070, ScrH() *0.085)
    icon:SetPos(ScrW() *0.002, ScrH() *0.003)
    icon:SetPlayer(LocalPlayer(), 84)
	
	local name = vgui.Create("DTextEntry", base)
	
	name:SetText(NameTable["FirstName"])
	name:SetSize(ScrW() *0.099, ScrH() *0.020)
	name:SetPos(ScrW() *0.084, ScrH() *0.040)
	
	local lastname = vgui.Create("DTextEntry", base)
	
	lastname:SetText(NameTable["LastName"])
	lastname:SetSize(ScrW() *0.099, ScrH() *0.020)
	lastname:SetPos(ScrW() *0.084, ScrH() *0.068)
	
	local button = vgui.Create("DButton", base)
	
	button:SetText("Confirm")
	button:SetSize(ScrW() *0.099, ScrH() *0.030)
	button:SetPos(ScrW() *0.084, ScrH() *0.097)
	function button:DoClick()	 
		if (string.len(name:GetValue()) > RPNameConfig["MaxCaracters"]) then
		    Derma_Message(
			    "The first name you entered is too long!",
				"Notification",
				"OK"
			)
			return
		elseif (string.len(name:GetValue()) < RPNameConfig["MinCaracters"]) then
		    Derma_Message(
			    "The first name you entered is too short!",
				"Notification",
				"OK"
			)
			return
	    elseif (string.find(name:GetValue(), " ")) then
		    Derma_Message(
			    "Your first name can't contain spaces!",
				"Notification",
				"OK"
			)
			return
		else
			for _, caracters in pairs(RPNameConfig["NotAllowed"]) do
				if (!string.find(string.lower(name:GetValue()), caracters)) then
					NameTable["FirstName"] = name:GetValue()
				else
				    Derma_Message(
			            "The first name you entered contains prohibited caracters!",
				        "Notification",
				        "OK"
			        )
				return end
			end
		end
		
		if (string.len(lastname:GetValue()) > RPNameConfig["MaxCaracters"]) then
		    Derma_Message(
			    "The last name you entered is too long!",
				"Notification",
				"OK"
			)
			return
		elseif (string.len(lastname:GetValue()) < RPNameConfig["MinCaracters"]) then
		    Derma_Message(
			    "The last name you entered is too short!",
				"Notification",
				"OK"
			)
			return
		elseif (string.find(lastname:GetValue(), " ")) then
		    Derma_Message(
			    "Your last name can't contain spaces!",
				"Notification",
				"OK"
			)
			return
		else
			for _, caracters in pairs(RPNameConfig["NotAllowed"]) do
				if (!string.find(string.lower(lastname:GetValue()), caracters)) then
					NameTable["LastName"] = lastname:GetValue()
				else
				    Derma_Message(
			            "The last name you entered contains prohibited caracters!",
				        "Notification",
				        "OK"
			        )
				return end
			end
		end
	
	    if (LocalPlayer():GetName() == NameTable["FirstName"].." "..NameTable["LastName"]) then
		    Derma_Message(
			    "You haven't changed your name!",
		        "Notification",
			    "OK"
		    )
			return
		else
		    for k, v in pairs(player.GetAll()) do
			    if (v:GetName() == NameTable["FirstName"].." "..NameTable["LastName"] && v != LocalPlayer()) then
				    Derma_Message(
			            "Someone already has your name!",
		                "Notification",
			            "OK"
		            )
				return end
			end
		end
		
		net.Start("OpenRPNameMenu")
		    net.WriteString(NameTable["FirstName"].." "..NameTable["LastName"])
	    net.SendToServer()
		
		Derma_Message(
			"Congratulations!\nYour name is now: "..NameTable["FirstName"].." "..NameTable["LastName"]..".\nThe only way of changing it it's by paying "..DarkRP.formatMoney(RPNameConfig["ChangeNameCost"])..".",
			"Notification",
			"OK"
		)
        
		base:Close()
	end
end)