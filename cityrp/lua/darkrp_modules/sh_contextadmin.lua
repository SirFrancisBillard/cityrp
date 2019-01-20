
local JOHN_CENA = 1
local GO_SLAYER = 2

if CLIENT then
	-- ulx commands, these can be split up
	local commands = {
		["Moderation"] = {cmds = {
			{txt="Slay",cmd="ulx slay",icon="icon16/lightning.png"},
			{txt="Spectate",cmd="ulx spectate",icon="icon16/eye.png"},
			{txt="Bring",cmd="ulx bring",icon="icon16/arrow_left.png"},
			{txt="Freeze",cmd="ulx freeze",icon="icon16/link.png",opp="ulx unfreeze",oppicon="icon16/link_break.png"},
			{txt="Jail (∞)",cmd="ulx jail",icon="icon16/lock.png",opp="ulx unjail",oppicon="icon16/lock_open.png"},
			{txt="Jail (60s)",cmd="ulx jail",icon="icon16/lock.png",args={60},opp="ulx unjail",oppicon="icon16/lock_open.png"},
			{txt="Gag",cmd="ulx gag",icon="icon16/sound_mute.png",opp="ulx ungag",oppicon="icon16/sound.png"},
			{txt="Restore Health",cmd="ulx hp",icon="flags16/ch.png",args={100}},
			
			},
			icon = "icon16/shield.png"
		},
		["Administration"] = {cmds={
			{txt="Kick",cmd="ulx kick",icon="icon16/door_open.png"},
			{cmd="ulx ban",pnl=function(parent,ply)
				
				local times = {
					{txt="An hour",t=60},
					{txt="A day",t=60*24},
					{txt="A week",t=60*24*7},
					{txt="Permanent",t=0}
									}
				
				local subm,but = parent:AddSubMenu("Ban",function()
					LocalPlayer():ConCommand("ulx ban $"..ply:SteamID())
				end)
				but:SetIcon("icon16/cancel.png")
				
				for _,t in pairs(times) do
					local tmen,but = subm:AddSubMenu(t.txt,function()
						LocalPlayer():ConCommand("ulx ban $"..ply:SteamID().." "..t.t)
					end)
					
					for _,reason in pairs(ulx.common_kick_reasons) do
						tmen:AddOption(reason,function()
							LocalPlayer():ConCommand("ulx ban $"..ply:SteamID().." "..t.t.. " "..reason)
						end)
					end	
					
				end
				
			end
			},
			{cmd="ulx adduser",pnl=function(parent,ply)
				

				local subm,but = parent:AddSubMenu("Adduser",function()
				end)
				but:SetIcon("icon16/user_add.png")
				
				local sorted = {}
				local function sortGroups( t )
					for k, v in pairs(t) do
						sortGroups( v )
						table.insert( sorted, k )
					end
				end
				sortGroups(ULib.ucl.getInheritanceTree())
				
				for _,group in pairs(sorted) do
					local str = group
					subm:AddOption(str:sub(1,1):upper()..str:sub(2),function()
						LocalPlayer():ConCommand("ulx adduser $"..ply:SteamID().." "..group)
					end)
				end
				
			end
			},
			{txt="Demote to user",cmd="ulx removeuser",icon="icon16/user_delete.png"}
			
			},
			icon = "icon16/shield_add.png"
			
		}
	}
	
	local function ulxcontext(ply)
		local men = DermaMenu()
		men:AddOption(ply:Nick()):SetIcon("icon16/user.png")
		men:AddSpacer()
		
		-- information
		
		local inf,but = men:AddSubMenu("Information")
		but:SetIcon("icon16/information.png")
		
		local str = ply:GetUserGroup()
		
		local usr = inf:AddOption(str:sub(1,1):upper()..str:sub(2),function()
		end)
		if ply:IsSuperAdmin() then
			usr:SetIcon("icon16/star.png")
		elseif ply:IsAdmin() then
			usr:SetIcon("icon16/shield.png")
		else
			usr:SetIcon("icon16/user.png")
		end
		
		inf:AddOption("Copy SteamID",function()
			SetClipboardText(ply:SteamID())
			chat.AddText(Color(255,255,255),"'",team.GetColor(ply:Team()),ply:SteamID(),Color(255,255,255),"'"," copied")
		end):SetIcon("icon16/paste_plain.png")
		
		inf:AddOption("Open profile",function()
			ply:ShowProfile()
		end):SetIcon("icon16/vcard.png")
		
		-- ulx categories
		
		for cat,content in pairs(commands) do
			
			local access = false
			for k,v in pairs(content.cmds) do
				if (v.check and v.check(ply)) or LocalPlayer():query(v.cmd) then
					access = true
					break
				end
			end
			
			if access then
				
				local ulxmen,but = men:AddSubMenu( cat )
				but:SetIcon(content.icon)
				
				for k,v in pairs(content.cmds) do
					if not (v.check and v.check(ply)) and not LocalPlayer():query(v.cmd) then continue end
						
					if v.pnl then 
						v.pnl(ulxmen,ply)
						continue
					end	
					
					if not v.args then v.args = {} end

					if v.opp  then
						local subm,but = ulxmen:AddSubMenu(v.txt,function()
							LocalPlayer():ConCommand(v.cmd.." $"..ply:SteamID().." "..table.concat(v.args," "))
						end)
						but:SetIcon(v.icon)
						local str = string.Explode(" ",v.txt)
						local uncmd = subm:AddOption("Un"..str[1]:lower(),function()
							LocalPlayer():ConCommand(v.opp.." $"..ply:SteamID())
						end)
						if v.oppicon then
							uncmd:SetIcon(v.oppicon)
						end
					else
						ulxmen:AddOption(v.txt,function()
							LocalPlayer():ConCommand(v.cmd.." $"..ply:SteamID().." "..table.concat(v.args," "))
						end):SetIcon(v.icon)
					end
				
				end
			end
		end
		
		-- darkrp
		
		if DarkRP and LocalPlayer():IsSuperAdmin() then
			local darkmen,but = men:AddSubMenu("DarkRP")
			but:SetIcon("icon16/gun.png")
			
			darkmen:AddOption("Unarrest",function()
				LocalPlayer():ConCommand([[rp_unarrest "]]..ply:SteamID()..[["]])
			end):SetIcon("icon16/lock_break.png")
			
			darkmen:AddOption("Set money",function()
				Derma_StringRequest(
					"Set money ("..ply:Nick()..")",
					"How much money? (number)",
					"",
					function( text )
						if isnumber(tonumber(text)) then
							LocalPlayer():ConCommand([[rp_setmoney "]]..ply:SteamID()..[[" ]]..tonumber(text))
						else
							chat.AddText("Not a number!")
						end
					end,
					function( text ) end
	 			)
			end):SetIcon("icon16/money.png")
	
			darkmen:AddOption("Add money",function()
				Derma_StringRequest(
					"Add money ("..ply:Nick()..")",
					"How much money? (number)",
					"",
					function( text )
						if isnumber(tonumber(text)) then
							LocalPlayer():ConCommand([[rp_addmoney "]]..ply:SteamID()..[[" ]]..tonumber(text))
						else
							chat.AddText("Not a number!")
						end
					end,
					function( text ) end
	 			)
			end):SetIcon("icon16/money_add.png")
	
			darkmen:AddOption("Ban from job",function()
				LocalPlayer():ConCommand([[rp_teamban "]]..ply:SteamID()..[[" "]]..team.GetName(ply:Team())..[["]])
				if FAdmin then
					LocalPlayer():ConCommand([[_FAdmin setteam "]]..ply:SteamID()..[[" "citizen"]])
				end	
			end):SetIcon("icon16/user_delete.png")	
	
		end
		
		
		-- misc
		
		if LocalPlayer():IsSuperAdmin() and (medialib or urlpanel) then
			local mmen,but = men:AddSubMenu("Misc")
			but:SetIcon("icon16/vee.png")
			
			if medialib then
				mmen:AddOption("Go slayer",function()
					net.Start("medialibmeme")
						net.WriteEntity(ply)
						net.WriteUInt(GO_SLAYER,4)
					net.SendToServer()
				end):SetIcon("icon16/music.png")

				mmen:AddOption("John Cena",function()
					net.Start("medialibmeme")
						net.WriteEntity(ply)
						net.WriteUInt(JOHN_CENA,4)
					net.SendToServer()
				end):SetIcon("icon16/user_green.png")

			end

			if urlpanel then
				mmen:AddOption("Give spins",function()
					LocalPlayer():ConCommand("ulx gibespin $"..ply:SteamID().." 5")
				end):SetIcon("icon16/arrow_rotate_clockwise.png")
			end

		end
		men:Open()
	end

	properties.OldOnScreenClick = properties.OldOnScreenClick or properties.OnScreenClick
	
	properties.OnScreenClick = function(eyep,eyev)
		local ent,tbl = properties.GetHovered(eyep,eyev)
		if ent and ent:IsValid() and ent:IsPlayer() then 
			ulxcontext(ent)
		else
			properties.OldOnScreenClick(eyep,eyev)
		end	
	end
end	

if SERVER then
	util.AddNetworkString("medialibmeme")
	
	net.Receive("medialibmeme",function(len,ply)
		local nerd = net.ReadEntity()
		local const = net.ReadUInt(4)
		if ply:IsSuperAdmin() then
			
			if const == GO_SLAYER then
				nerd:SendLua([[
					local link = "https://www.youtube.com/watch?v=ldN9fNhZcsQ"
					medialib.load("media").guessService(link):load(link):play()
				]])
			elseif const == JOHN_CENA then
				nerd:SendLua([[
					local link = "https://www.youtube.com/watch?v=Am4oKAmc2To"
					medialib.load("media").guessService(link):load(link):play()
				]])	
			end
		end
	end)
end
