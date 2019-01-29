
-- #NoSimplerr#

local White = Color(255, 255, 255)
local Red = Color(255, 0, 0)
local Green = Color(0, 255, 0)
local Blue = Color(0, 0, 255)
local Magenta = Color(255, 0, 255)

local GreenBlue = Color(100, 100, 255)
local BlueGreen = Color(100, 255, 100)

local DisabledHintsOnceAlready = false

local ChatCommands = {
	["!hints"] = function()
		if gShowChatHints == nil then gShowChatHints = true end
		gShowChatHints = not gShowChatHints
		local on = gShowChatHints
		chat.AddText(White, "Chat hints are now ", on and Green or Red, on and "enabled" or "disabled", White, ".")
		if not on and not DisabledHintsOnceAlready then
			DisabledHintsOnceAlready = true
			chat.AddText(Red, "Sorry for the annoyance!")
		end
	end,
	["!headshot"] = function()
		if gPlayHeadshotSound == nil then gPlayHeadshotSound = true end
		gPlayHeadshotSound = not gPlayHeadshotSound
		local on = gPlayHeadshotSound
		chat.AddText(White, "Headshot sound is now ", on and Green or Red, on and "enabled" or "disabled", White, ".")
	end,
	["!rules"] = function()
		chat.AddText(Magenta, "GENERAL RULES")
		chat.AddText(Magenta, "1. Don't be a douche.")
		chat.AddText(Magenta, "2. Don't mass DM.")
		chat.AddText(Magenta, "3. Don't revenge kill.")
	end
}

hook.Add("OnPlayerChat", "ClientSidedChatCommands", function(ply, strText, bTeam, bDead)
	if ply ~= LocalPlayer() then return end

	local func = ChatCommands[string.lower(strText)]
	if isfunction(func) then
		func()
		return true
	end
end)
