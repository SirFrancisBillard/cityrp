
util.AddNetworkString("OpenLogs") 
util.AddNetworkString("SendLogs") 




function ViewLogs(ply, text, public)
	if (string.sub(string.lower(text), 1, string.len(LOGS_COMMAND)) == LOGS_COMMAND) then 
			for i=1,#LOGS_ALLOWEDGROUPS do
				if ply:IsUserGroup(LOGS_ALLOWEDGROUPS[i]) then
						net.Start("OpenLogs")
	    				net.Send(ply)
	    				print(ply:Name().." loaded up Deaglers RP Logs.")
	    				return ""
				 
			end
   		end
    end
end
hook.Add("PlayerSay", "OpenDeagLogs", ViewLogs)

    hook.Add("CanTool", "SendToolDeagLog", function(ply, tr, toolclass) 
    	if(ply:IsPlayer()) then
		local Name,SteamID = (IsValid(ply) and ply:Name() or "N/A"),(IsValid(ply) and ply:SteamID() or "N/A")
		local Tool = toolclass
	
		net.Start("SendLogs")
		net.WriteTable({Type= "ToolGun",Name=Name,SteamID=SteamID,Tool=Tool}) 
		net.Broadcast()

	end
end)



hook.Add("PlayerDeath", "SendDeagLog", function(ply, inflictor, Killer)
	
	local Name, SteamID, KillerName,KillerSteamID = (IsValid(ply) and ply:Name() or "N/A"), (IsValid(ply) and ply:SteamID() or "N/A"),
		(IsValid(Killer) and (Killer:IsPlayer() and Killer:Nick() or Killer:GetClass()) or "N/A"),
		(Killer:IsPlayer() and Killer:SteamID() or "N/A")

		local InflictorName = nil
	if IsValid(inflictor) then
                if inflictor:IsWeapon() or inflictor.Projectile then
                        InflictorName = inflictor
                elseif inflictor:IsPlayer() then
                        InflictorName = inflictor:GetActiveWeapon()
                        if not IsValid(InflictorName) then
                                InflictorName = IsValid(inflictor.dying_wep) and inflictor.dying_wep or "Unknown"
                        end
                end
        end
        if type(InflictorName) != "string" then
                InflictorName= IsValid(InflictorName) and InflictorName:GetClass() or "Unknown"
        else
                InflictorName=InflictorName
        end

      

		net.Start("SendLogs")
		net.WriteTable({Type= "Death",Name=Name,SteamID=SteamID,KillerName=KillerName,InflictorName=InflictorName,KillerSteamID=KillerSteamID}) 
		net.Broadcast()


end)

hook.Add("PlayerSpawnProp", "SendPropLog", function(ply, class)
	if not IsValid(ply) then return end
	local Name,SteamID,Model = (IsValid(ply) and ply:Name() or "N/A"),(IsValid(ply) and ply:SteamID() or "N/A"),class
		net.Start("SendLogs")
		net.WriteTable({Type= "Prop",Name=Name,SteamID=SteamID,Model=Model}) 
		net.Broadcast()
end)

hook.Add("OnPlayerChangedTeam", "SendJobLog", function(ply, oldteam, newteam) 
	if not IsValid(ply) then return end
	local Name,SteamID,OldTeamName,NewTeamName = (ply:Name() or "N/A"),(ply:SteamID() or "N/A"),(team.GetName(oldteam) or "N/A"),(team.GetName(newteam))

		net.Start("SendLogs")
		net.WriteTable({Type= "Job",Name=Name,SteamID=SteamID,OldTeam=OldTeamName,NewTeam=NewTeamName}) 
		net.Broadcast()

end)

hook.Add("PlayerDisconnected", "SendDisconnectLog", function(ply) 
	local Name,SteamID = (IsValid(ply) and ply:Name() or "N/A"),(IsValid(ply) and ply:SteamID() or "N/A")
		net.Start("SendLogs")
		net.WriteTable({Type= "Connect",Method="Disconnected",Name=Name,SteamID=SteamID}) 
		net.Broadcast()

	end)

hook.Add("PlayerInitialSpawn", "SendConnectLog", function(ply) 
	local Name,SteamID = (ply:IsPlayer() and ply:Name() or "N/A"),(ply:IsPlayer() and ply:SteamID() or "N/A")

		net.Start("SendLogs")
		net.WriteTable({Type= "Connect",Method="Connected",Name=Name,SteamID=SteamID}) 
		net.Broadcast()
 end)

hook.Add("EntityTakeDamage","SendDamageLog", function(ply,dmginfo)
	local Name, SteamID, KillerName,KillerSteamID,Damage = 
	(ply:IsPlayer() and ply:Name() or "N/A"), 
	(ply:IsPlayer() and ply:SteamID() or "N/A"),
	(IsValid(dmginfo:GetAttacker()) and (dmginfo:GetAttacker():IsPlayer() and 
	dmginfo:GetAttacker():Nick() or dmginfo:GetAttacker():GetClass()) or "N/A"),
	(dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():SteamID() or "N/A"),
	dmginfo:GetDamage()

	local InflictorName = nil
	if IsValid(dmginfo:GetInflictor()) then
                if dmginfo:GetInflictor():IsWeapon() or dmginfo:GetInflictor().Projectile then
                        InflictorName = dmginfo:GetInflictor()
                elseif dmginfo:GetInflictor():IsPlayer() then
                        InflictorName = dmginfo:GetInflictor():GetActiveWeapon()
                        if not IsValid(InflictorName) then
                                InflictorName = IsValid(dmginfo:GetInflictor().dying_wep) and dmginfo:GetInflictor().dying_wep or "Unknown"
                        end
                end
        end
        if type(InflictorName) != "string" then
                InflictorName= IsValid(InflictorName) and InflictorName:GetClass() or "Unknown"
        else
                InflictorName=InflictorName
        end

        if dmginfo:IsExplosionDamage() then
        	InflictorName= "an explosion"

        end

        if dmginfo:IsFallDamage() then
        	InflictorName="fall damage"
        end

        local Method = "N/A"
    		local damagetake= ply:Health() - Damage

    		if damagetake <=0 then
    			Method="KILL"
    	
    		else
    			Method="DMG"
    		
    		end
    	if not  ply:IsPlayer() then return end
        if ply:IsPlayer() and !ply:Alive() then return end
        net.Start("SendLogs")
		net.WriteTable({Type= "DMG",Damage=Damage,Method=Method,Name=Name,SteamID=SteamID,KillerName=KillerName,InflictorName=InflictorName,KillerSteamID=KillerSteamID}) 
		net.Broadcast()
end)

hook.Add("onHitAccepted", "SendHitALog", function(hitman,target,customer) 
	local Name,SteamID = (IsValid(hitman) and hitman:Name() or "N/A"),(IsValid(hitman) and hitman:SteamID() or "N/A")
	local Target,TSteamID= (IsValid(target) and target:Name() or "N/A"),(IsValid(target) and target:SteamID() or "N/A")
	local Customer,CSteamID= (IsValid(customer) and customer:Name() or "N/A"),(IsValid(customer) and customer:SteamID() or "N/A")

		net.Start("SendLogs")
		net.WriteTable({Type= "Hit",Method="Accepted",Name=Name,SteamID=SteamID,Target=Target,TSteamID=TSteamID,Customer=Customer,CSteamID=CSteamID}) 
		net.Broadcast()
 end)

hook.Add("onHitCompleted", "SendHitCLog", function(hitman,target,customer) 
	local Name,SteamID = (IsValid(hitman) and hitman:Name() or "N/A"),(IsValid(hitman) and hitman:SteamID() or "N/A")
	local Target,TSteamID= (IsValid(target) and target:Name() or "N/A"),(IsValid(target) and target:SteamID() or "N/A")
	local Customer,CSteamID= (IsValid(customer) and customer:Name() or "N/A"),(IsValid(customer) and customer:SteamID() or "N/A")

		net.Start("SendLogs")
		net.WriteTable({Type= "Hit",Method="Completed",Name=Name,SteamID=SteamID,Target=Target,TSteamID=TSteamID,Customer=Customer,CSteamID=CSteamID}) 
		net.Broadcast()
 end)

hook.Add("onHitFailed", "SendHitFLog", function(hitman,target,reason) 
	local Name,SteamID = (IsValid(hitman) and hitman:Name() or "N/A"),(IsValid(hitman) and hitman:SteamID() or "N/A")
	local Target,TSteamID= (IsValid(target) and target:Name() or "N/A"),(IsValid(target) and target:SteamID() or "N/A")
	local Customer,CSteamID = tostring(reason),"N/A"

		net.Start("SendLogs")
		net.WriteTable({Type= "Hit",Method="Failed",Name=Name,SteamID=SteamID,Target=Target,TSteamID=TSteamID,Customer=Customer,CSteamID=CSteamID}) 
		net.Broadcast()
 end)
