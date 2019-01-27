
do return end

local White = Color(255, 255, 255)
local Red = Color(255, 0, 0)
local Green = Color(0, 255, 0)
local Blue = Color(0, 0, 255)
local Magenta = Color(255, 0, 255)

local GreenBlue = Color(100, 100, 255)
local BlueGreen = Color(100, 255, 100)

local ChatMessages = {
	{Red, "Hey did you know my knee grows?"},
	{White, "You can get VIP instantly by typing ", Magenta, "!vip", White, ". You get a free golden deagle!"},
	{White, "Round end music is disabled by default. You can toggle it by typing ", Magenta, "!music", White, "."},
	{White, "Want to disable the headshot sound? You can toggle it by typing ", Magenta, "!headshot", White, "."},
	{White, "You can change your hitsound by typing ", Magenta, "!hitsound", White, " and typing in a URL."},
	{White, "This server currently has ", Magenta, "26,524", White, " different chat sounds."},
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
		chat.AddText(unpack(ChatMessages[int]))
	end)
end
