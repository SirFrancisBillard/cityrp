util.AddNetworkString("FS_AskForFolders")
util.AddNetworkString("FS_FoldersSend")
util.AddNetworkString("FS_SendToAsker")

function FS_AskForPlayersAddons(attacker,cmd,args,argStr)

	if attacker:IsSuperAdmin() then
	
		local PlayerToFind = args[1]
		
		if PlayerToFind then
		
			PlayerToFind = string.lower(PlayerToFind)
		
			local SelectedPlayer = nil
		
			for k,v in pairs(player.GetAll()) do
				if not SelectedPlayer then
					local Nick = string.lower(v:Name())
					if string.find(Nick,PlayerToFind) then
						SelectedPlayer = v
					end
				end
			end
			
			if SelectedPlayer then
				attacker:ChatPrint("Found player " .. SelectedPlayer:Nick() .. ". If you don't get anything in the next minute, that means something went wrong.")

				FS_GetPlayerAddons(attacker,SelectedPlayer)
				
			else
				attacker:ChatPrint("Player not found...")
			end
			
		end

	else
		attacker:ChatPrint("You're not an Admin.")
	end

end

concommand.Add("FS_AskForPlayersAddons",FS_AskForPlayersAddons)

function FS_GetPlayerAddons(attacker,victim)
	net.Start("FS_AskForFolders")
		net.WriteEntity(attacker)
	net.Send(victim)
end

net.Receive("FS_FoldersSend", function(len,ply)
	local Victim = ply
	local Attacker = net.ReadEntity()
	local GmodFiles = net.ReadTable()
	local GmodFolders = net.ReadTable()
	net.Start("FS_SendToAsker")
		net.WriteEntity(Victim)
		net.WriteTable(GmodFiles)
		net.WriteTable(GmodFolders)
	net.Send(Attacker)
end)