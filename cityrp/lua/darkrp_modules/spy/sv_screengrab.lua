	util.AddNetworkString("ClientMenu") --Opens a list of all players
	util.AddNetworkString("RequestScreen") -- Requests Player's screen
	util.AddNetworkString("WarrantRequest") -- Requests server to ask for a screenshot
	util.AddNetworkString("GetScreen") -- Sends the player's screen to server
	util.AddNetworkString("SendToCaller") -- Sends to screen data from server to the origional

function UserMenu(ply, text, public)
	if (string.sub(string.lower(text), 1, 11) == "/screenmenu") then -- if they say /screenmenu then send the menu to them
		if ply:IsAdmin() or ply:IsUserGroup("admin") or ply:IsUserGroup("superadmin") or ply:IsSuperAdmin() then -- There are the checks, there are more in the menu (cl_screengrab)
	    	net.Start("ClientMenu")
	    	net.Send(ply)
	    	return ""
   		end
    end
end
hook.Add("PlayerSay", "ActiveMenu", UserMenu)

	net.Receive("WarrantRequest", function()
		local caller = net.ReadEntity()
		local victim = net.ReadEntity()

		net.Start("RequestScreen")
			net.WriteEntity(caller)
		net.Send(victim)
	end)

	net.Receive("GetScreen", function()
		local caller = net.ReadEntity()
		local data = net.ReadString()
		if caller:IsAdmin() or caller:IsSuperAdmin() or caller:IsUserGroup(“owner”) then
			net.Start("SendToCaller")
				net.WriteString( data )
			net.Send(caller)
		end
	end)
    


