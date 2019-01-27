
-- separate file for specific stuff
-- yes, i know its not at all secure
-- but also its just a meme so idc

if SERVER then
	local QuickAdd = {
		["TakeTerroristQuiz"] = "terror_quiz",
		["TakePoliceQuiz"] = "police_quiz",
		["TakeShooterQuiz"] = "shooter_quiz",
	}

	for k, v in pairs(QuickAdd) do
		util.AddNetworkString(k)

		net.Receive(k, function(len, ply)
			ply:SetNWBool(v, net.ReadBool())
		end)
	end
else
	local function AlreadyTaken()
		chat.AddText(Color(255, 0, 0), "You've already passed this quiz!")
	end

	local function OurResults(passed)
		if passed then
			surface.PlaySound("garrysmod/save_load1.wav")
			chat.AddText(Color(0, 255, 0), "You passed the quiz!")
		else
			surface.PlaySound("ambient/alarms/klaxon1.wav")
			chat.AddText(Color(255, 0, 0), "You failed the quiz!")
		end
	end

	function TakeTerroristQuiz()
		if LocalPlayer():GetNWBool("terror_quiz") then
			AlreadyTaken()
			return
		end
		DermaQuiz("Terrorist Quiz",
		{
			{question = "Are you ready to be a terrorist?", answers = {"Yes", "No"}, correct = 1},
			{question = "What religion is the greatest?", answers = {"Christianity", "Judaism", "Islam", "Buddhism"}, correct = 3},
			{question = "How do you feel about infidels?", answers = {"I don't really care.", "KILL ALL INFIDELS", "All people deserve respect.", "I love infidels! One of my child brides is one."}, correct = 2},
			{question = "Allahu akbar?", answers = {"ALLAHU AKBAR!", "nah"}, correct = 1},
		},
		function(correct, total)
			net.Start("TakeTerroristQuiz")
			net.WriteBool(correct == total)
			net.SendToServer()
		end)
	end

	function TakePoliceQuiz()
		if LocalPlayer():GetNWBool("police_quiz") then
			AlreadyTaken()
			return
		end
		DermaQuiz("Police Quiz",
		{
			{question = "Are you ready to be Police?", answers = {"Yes", "No"}, correct = 1},
			{question = "What is the Police's job?", answers = {"KILL BLACK PEOPLE", "To serve and protect.", "RDM because I get to spawn with a gun.", "Gun down jaywalkers like the degenerate scum they are."}, correct = 2},
			{question = "When is lethal force necessary?", answers = {"Always.", "When they're black.", "When they're gonna kill me.", "Never. All people are part of God's creation!"}, correct = 3},
		},
		function(correct, total)
			net.Start("TakePoliceQuiz")
			net.WriteBool(correct == total)
			net.SendToServer()
		end)
	end

	function TakeShooterQuiz()
		if LocalPlayer():GetNWBool("shooter_quiz") then
			AlreadyTaken()
			return
		end
		DermaQuiz("Shooter Quiz",
		{
			{question = "Are you ready to be a shooter?", answers = {"Yes", "No"}, correct = 1},
			{question = "What are you going to do?", answers = {"Go raiding because I spawn with guns.", "Kill multiple civillians, then myself.", "Kill people who don't want to be bothered.", "Mug people and steal shit."}, correct = 2},
		},
		function(correct, total)
			net.Start("TakeShooterQuiz")
			net.WriteBool(correct == total)
			net.SendToServer()
		end)
	end
end
