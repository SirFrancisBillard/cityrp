
local DiceDesc = "Roll a number between 1 and 6."
local CardDesc = "Pick a random card."

DarkRP.declareChatCommand({
	command = "roll",
	description = "Roll a number between 1 and 100.",
	delay = 1.5
})

DarkRP.declareChatCommand({
	command = "dice",
	description = DiceDesc,
	delay = 1.5
})

DarkRP.declareChatCommand({
	command = "rolldice",
	description = DiceDesc,
	delay = 1.5
})

DarkRP.declareChatCommand({
	command = "card",
	description = CardDesc,
	delay = 1.5
})

DarkRP.declareChatCommand({
	command = "pickcard",
	description = CardDesc,
	delay = 1.5
})

DarkRP.declareChatCommand({
	command = "drawcard",
	description = CardDesc,
	delay = 1.5
})

