
--[[What Groups are allowed to use these logs.]]
LOGS_ALLOWEDGROUPS =
{
	"admin",
	"superadmin",
	"moderator",
	"trialmod",
	"donatoradmin+",
	"donatormod+",
	"donatoradmin",
	"donatormod"
}
--[[Command to open Logs Menu (type bind key "say /dlogs" to open it via key)]]--
LOGS_COMMAND = "/logs"

if CLIENT then

--[[Toggles/Settings]]--
--Toggle Logs 1 = On 0 = Off 
-- Default is set to On
LOGS_DISPLAY_NAME = 1
LOGS_DISPLAY_JOB = 1
LOGS_DISPLAY_KILLS = 1
LOGS_DISPLAY_PROP = 1
LOGS_DISPLAY_TOOLGUN = 1
LOGS_DISPLAY_CONNECT = 1  
LOGS_DISPLAY_DMG = 1
LOGS_DISPLAY_ARREST = 1   
LOGS_DISPLAY_DEMOTE = 1
LOGS_DISPLAY_HIT = 1      
LOGS_TITLETEXT = "DarkRP Logs"

--[[Amount of Logs to show! (Show last 300 Name changes/Show last 300 Damage logs etc..)]]--
LOGS_MAX_TOOLGUN = 300
LOGS_MAX_NAME = 300
LOGS_MAX_JOB = 300
LOGS_MAX_PROP = 300 -- Just edit the number for each log based on how many of them you want to show up
LOGS_MAX_KILLS = 300
LOGS_MAX_CONNECT = 300
LOGS_MAX_DMG = 300
LOGS_MAX_ARREST = 300
LOGS_MAX_DEMOTE = 300
LOGS_MAX_HIT = 300
--[[
This following area was suggested by [SUP] Penguin

It allows you to set what groups can see what categories, It works in the same format as the LOGS_ALLOWEDGROUPS.

If you want the same people as LOGS_ALLOWEDGROUPS to be able to see the category just make it so the only field is "*"
like I've done for LOGS_HIT_GROUPS

]]--
LOGS_HIT_GROUPS = 
{
"*"
}

LOGS_DEMOTE_GROUPS = 
{
"*"
}

LOGS_ARREST_GROUPS = 
{
"*"
}

LOGS_NAME_GROUPS = 
{
"*"
}

LOGS_PROP_GROUPS = 
{
"*"
}

LOGS_JOB_GROUPS = 
{
"*"
}

LOGS_KILLS_GROUPS = 
{
"*"
}

LOGS_DMG_GROUPS = 
{
"*"
}

LOGS_TOOL_GROUPS = 
{
"*"
}

LOGS_CONNECT_GROUPS = 
{
"*"
}
--[[Derma "Theme"]]--
	function DLogFrame(w, h, col)
		--BACKGROUND OF MENU
		surface.SetDrawColor(col)
		surface.DrawRect(0, 0 , w, h)

		--BAR AT BOTTOM COLOUR--
		surface.SetDrawColor(255,128,0,255)
		--EDIT THE BAR AT BOTTOM-
		surface.DrawRect(w/4, h-10 , w/2, 10)

		--OUTLINE AROUND BOX--
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0, 0, w, h)
	end


--[[LOGS_TITLETEXT FONT]]--
surface.CreateFont( "Title", {
 font = "Default",
 size = 72,
 weight = 600,
 shadow=true,
 italic=true


} )


end