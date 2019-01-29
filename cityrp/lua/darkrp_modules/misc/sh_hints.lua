
-- #NoSimplerr#

local White = Color(255, 255, 255)
local Red = Color(255, 0, 0)
local Green = Color(0, 255, 0)
local Blue = Color(0, 0, 255)
local Magenta = Color(255, 0, 255)
local DarkGray = Color(90, 90, 90)

local GreenBlue = Color(100, 100, 255)
local BlueGreen = Color(100, 255, 100)

local ChatMessages = {
	--{Red, "Hey did you know my knee grows?"},
	--{White, "You can get VIP instantly by typing ", Magenta, "!vip", White, ". You get a free golden deagle!"},
	{White, "Want to disable these hints? They can be toggled by typing ", Magenta, "!hints", White, "."},
	{White, "We don't have many rules. You can view them by typing ", Magenta, "!rules", White, "."},
	{White, "Want to disable the headshot sound? You can toggle it by typing ", Magenta, "!headshot", White, "."},
	{White, "You can change your hitsound by typing ", Magenta, "!hitsound", White, " and typing in a URL."},
	{White, "This server currently has ", Magenta, "26,524", White, " different chat sounds."},
	function()
		http.Fetch("https://api.codetabs.com/v1/loc?github=sirfrancisbillard/cityrp", function(body, len, headers, code)
			local tab = util.JSONToTable(body)
			chat.AddText(White, "Right now, we're running ", Magenta, string.Comma(tab[#tab].lines), White, " lines of custom code. ")
			chat.AddText(DarkGray, "Source: https://codetabs.com/count-loc/count-loc-online.html")
		end)
	end,
}

if SERVER then
	util.AddNetworkString("SendChatHint")

	if timer.Exists("SendChatHintTimer") then
		timer.Remove("SendChatHintTimer")
	end

	timer.Create("SendChatHintTimer", 300, 0, function()
		net.Start("SendChatHint")
		net.WriteInt(math.random(#ChatMessages), 6)
		net.Broadcast()
	end)
else
	net.Receive("SendChatHint", function()
		local int = net.ReadInt(6)
		if gShowChatHints == false then return end
		if istable(ChatMessages[int]) then
			chat.AddText(unpack(ChatMessages[int]))
		elseif isfunction(ChatMessages[int]) then
			ChatMessages[int]()
		end
	end)
end
