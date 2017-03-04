
-- Shut up, it works

local cards = {
	"Ace of Clubs",
	"Two of Clubs",
	"Three of Clubs",
	"Four of Clubs",
	"Five of Clubs",
	"Six of Clubs",
	"Seven of Clubs",
	"Eight of Clubs",
	"Nine of Clubs",
	"Ten of Clubs",
	"Jack of Clubs",
	"Queen of Clubs",
	"King of Clubs",
	"Ace of Diamonds",
	"Two of Diamonds",
	"Three of Diamonds",
	"Four of Diamonds",
	"Five of Diamonds",
	"Six of Diamonds",
	"Seven of Diamonds",
	"Eight of Diamonds",
	"Nine of Diamonds",
	"Ten of Diamonds",
	"Jack of Diamonds",
	"Queen of Diamonds",
	"King of Diamonds",
	"Ace of Hearts",
	"Two of Hearts",
	"Three of Hearts",
	"Four of Hearts",
	"Five of Hearts",
	"Six of Hearts",
	"Seven of Hearts",
	"Eight of Hearts",
	"Nine of Hearts",
	"Ten of Hearts",
	"Jack of Hearts",
	"Queen of Hearts",
	"King of Hearts",
	"Ace of Spades",
	"Two of Spades",
	"Three of Spades",
	"Four of Spades",
	"Five of Spades",
	"Six of Spades",
	"Seven of Spades",
	"Eight of Spades",
	"Nine of Spades",
	"Ten of Spades",
	"Jack of Spades",
	"Queen of Spades",
	"King of Spades"
}

local function LocalChat(ply, txt)
	if not IsValid(ply) or not ply:IsPlayer() then return "" end
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
		v:ChatPrint(txt)
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
	return LocalChat(ply, "[CARD] " .. ply:Nick() .. " has drawn " .. cards[math.random(#cards)] .. ".")
end

DarkRP.defineChatCommand("card", PickCard)
DarkRP.defineChatCommand("pickcard", PickCard)
DarkRP.defineChatCommand("drawcard", PickCard)
