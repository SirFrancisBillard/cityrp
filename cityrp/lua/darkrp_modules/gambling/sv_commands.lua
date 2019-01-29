
local Values = {"Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"}
local Suits = {"Clubs", "Diamonds", "Hearts", "Spades"}
local Middle = " of "

local function RandomCard()
	return Values[math.random(#Values)] .. Middle .. Suits[math.random(#Suits)]
end

local function LocalChat(ply, txt)
	if not IsValid(ply) or not ply:IsPlayer() then return "" end
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
		if IsValid(v) and v:IsPlayer() then
			v:ChatPrint(txt)
		end
	end
	return ""
end

local function RollHundred(ply)
	return LocalChat(ply, "[ROLL] " .. ply:Nick() .. " has rolled " .. tostring(math.random(100)) .. " out of 100.")
end

DarkRP.defineChatCommand("roll", RollHundred)

local function RollDice(ply)
	return LocalChat(ply, "[DICE] " .. ply:Nick() .. " has rolled " .. tostring(math.random(6)) .. " and " .. tostring(math.random(6)) .. ".")
end

DarkRP.defineChatCommand("dice", RollHundred)
DarkRP.defineChatCommand("rolldice", RollHundred)

local function PickCard(ply)
	return LocalChat(ply, "[CARD] " .. ply:Nick() .. " has drawn a " .. RandomCard() .. ".")
end

DarkRP.defineChatCommand("card", PickCard)
DarkRP.defineChatCommand("pickcard", PickCard)
DarkRP.defineChatCommand("drawcard", PickCard)
