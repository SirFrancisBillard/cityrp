----// Overhead Chat Messages //----
-- Author: Exho
-- Version: 10/13/14

-- Gamemode Selection:
local isTTT = false
local isSandbox = false -- Default to this if your gamemode is something different
local isDarkRP = true

-- Message Stuff:
local maxLength = 80 -- Maximum string length before it gets automatically ommitted
local maxMessages = 8 -- Maximum messages displayed above the player's head before it starts deleting

-- Colors:
local textColor = Color(255,255,255,255) -- Message color
local plyColor = Color(25, 200, 25, 255) -- Player name color
local textShadowColor = Color(0,0,0,255) -- Message shadow color

local plyCanSeeOwnMsg = false -- (not recommended) Allow the players to see their own messages above their head, glitchy AF

if SERVER then
	AddCSLuaFile()
	util.AddNetworkString( "PlayerSaidSomethin" )
	
	hook.Add( "PlayerSay", "PlayerHasSpoken", function( ply, text, team )
		if not ply:Alive() then return end
		local SayData = {}
		SayData.ply = ply
		SayData.txt = text
		net.Start("PlayerSaidSomethin")
			net.WriteTable(SayData)
		net.Broadcast() -- Tell erryone
	end)
end

if CLIENT then	
	surface.CreateFont( "Overhead_Msg", {
	font = "Arial",
	size = 30,
	weight = 500,
	antialias = true,
} )
	surface.CreateFont( "Overhead_Name", {
	font = "Arial",
	size = 32,
	weight = 650,
	antialias = true,
} )
	
	local function PlayerColor(ply)
		if isTTT then
			local role = ply:GetRole()
			if role == ROLE_TRAITOR and LocalPlayer:GetRole() == ROLE_TRAITOR then
				plyColor = Color(255,0,0,255)
			elseif role == ROLE_DETECTIVE then
				plyColor = Color(0,0,255,255)
			else
				plyColor = Color(0,255,0,255)
			end
			return
		elseif isSandbox or isDarkRP then
			plyColor = ply:GetPlayerColor( ) or Color(25, 200, 25, 255)
			return
		--elseif isCustomGamemode then
			--plyColor = YourColorGettingmethod
			--return
		end
	end

	local MsgTable = {}
	local Recieved = false
	net.Receive( "PlayerSaidSomethin", function( len, ply )
		-- Destroy duplicate messages
		if Recieved then return else Recieved = true timer.Simple(0.5, function() Recieved = false end) end
		
		local Data = net.ReadTable()
		local ply = Data.ply
		local msg = Data.txt
		msg = string.Trim(msg) -- Trimming whitespace is a good idea
		table.insert(MsgTable, 1, msg)
		
		PlayerColor(ply)
		
		if #MsgTable > maxMessages then -- To prevent the a tower of messages
			table.remove( MsgTable, #MsgTable ) -- Remove the last key/oldest message
		end
		
		if timer.Exists(ply:UniqueID().."_ChatMessage") then -- If chat is already displaying
			local tleft = timer.TimeLeft(ply:UniqueID().."_ChatMessage")
			timer.Adjust( ply:UniqueID().."_ChatMessage", tleft + 3, 1, function() -- Adjust it
				hook.Remove("PostDrawOpaqueRenderables", ply:UniqueID().."_ChatMessage")
				table.Empty(MsgTable)
			end)
		end
		
		hook.Add( "PostDrawOpaqueRenderables", ply:UniqueID().."_ChatMessage", function()	
			if ply == LocalPlayer() and not plyCanSeeOwnMsg then return end
			if not ply:Alive() then return end
			
			if #MsgTable < 1 then -- No messages
				timer.Simple(0.5, function() -- Delay for effect
					hook.Remove("PostDrawOpaqueRenderables", ply:UniqueID().."_ChatMessage")
					table.Empty(MsgTable)
				end)
			end
			local BoneIndx = ply:LookupBone("ValveBiped.Bip01_Head1")
			local BonePos, BoneAng = ply:GetBonePosition( BoneIndx )
			local pos = BonePos + Vector(0,0,80) -- Place above head bone
			local eyeang = LocalPlayer():EyeAngles().y - 90 -- Face upwards
			local ang = Angle( 0, eyeang, 90 )
			
			-- Start drawing 
			cam.Start3D2D(pos, ang, 0.1)
				local Height = 255
				local Width = 2
				local Buffer = 30
				
				-- Background
				surface.SetDrawColor( 255, 255, 255, 100 )
				surface.DrawRect(0-(Width/2), 600, Width, Height )
				surface.DrawRect(0-(Height/2), 600, Height, Width )
				
				for k, v in pairs(MsgTable) do
					if string.len(v) > maxLength then
						-- Prevent long messages from appearing, they will be in chat so all is good
						v = "[Message Omitted - Length]"
					end
					-- Draw the message
					draw.DrawText( v, "Overhead_Msg", 0+2, 600-Buffer+2, textShadowColor, TEXT_ALIGN_CENTER )
					draw.DrawText( v, "Overhead_Msg", 0, 600-Buffer, textColor, TEXT_ALIGN_CENTER )
					Buffer = Buffer + 30 -- Increase buffer by initial value
				end
				
				--draw.DrawText( ply:Nick()..":", "Overhead_Name", 0+2, 600-Buffer+2, plyShadowColor, TEXT_ALIGN_CENTER )
				draw.DrawText( ply:Nick()..":", "Overhead_Name", 0, 600-Buffer, plyColor, TEXT_ALIGN_CENTER )
			cam.End3D2D()
		end)
		
		timer.Create(ply:UniqueID().."_OldChatRemover", 5, #MsgTable, function() 
			-- Removes the oldest message, one element at a time.
			table.remove( MsgTable, #MsgTable )
		end)
		timer.Create(ply:UniqueID().."_ChatTimer", (#MsgTable*5)+6, 1, function()
			-- Removes the actual Hook when its not needed anymore
			hook.Remove("PostDrawOpaqueRenderables", ply:UniqueID().."_ChatMessage")
			table.Empty(MsgTable)
		end)
	end)
end
