
local g_RegisterJobWithColor
local g_RegisterJobWithCategory

local function RegisterJobCategory(name, color)
	g_RegisterJobWithColor = color or Color(255, 0, 0)
	g_RegisterJobWithCategory = name or "Other"
end

local Models = {
	Citizens = {
		"models/player/Group01/Female_01.mdl",
		"models/player/Group01/Female_02.mdl",
		"models/player/Group01/Female_03.mdl",
		"models/player/Group01/Female_04.mdl",
		"models/player/Group01/Female_06.mdl",
		"models/player/group01/male_01.mdl",
		"models/player/Group01/Male_02.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group01/Male_04.mdl",
		"models/player/Group01/Male_05.mdl",
		"models/player/Group01/Male_06.mdl",
		"models/player/Group01/Male_07.mdl",
		"models/player/Group01/Male_08.mdl",
		"models/player/Group01/Male_09.mdl"
	},
	Gangsters = {
		"models/player/Group03/Female_01.mdl",
		"models/player/Group03/Female_02.mdl",
		"models/player/Group03/Female_03.mdl",
		"models/player/Group03/Female_04.mdl",
		"models/player/Group03/Female_06.mdl",
		"models/player/group03/male_01.mdl",
		"models/player/Group03/Male_02.mdl",
		"models/player/Group03/male_03.mdl",
		"models/player/Group03/Male_04.mdl",
		"models/player/Group03/Male_05.mdl",
		"models/player/Group03/Male_06.mdl",
		"models/player/Group03/Male_07.mdl",
		"models/player/Group03/Male_08.mdl",
		"models/player/Group03/Male_09.mdl"
	},
	BlackCitizens = {
		"models/player/Group01/male_01.mdl",
		"models/player/Group01/male_03.mdl",
	},
	BlackGangsters = { -- redundant xdddd
		"models/player/Group03/male_01.mdl",
		"models/player/Group03/male_03.mdl",
	},
	FancyCitizens = {
		"models/player/Group02/male_02.mdl",
		"models/player/Group02/male_04.mdl",
		"models/player/Group02/male_06.mdl",
		"models/player/Group02/male_08.mdl",
	},
	Hostages = {
		"models/player/hostage/hostage_01.mdl",
		"models/player/hostage/hostage_02.mdl",
		"models/player/hostage/hostage_03.mdl",
		"models/player/hostage/hostage_04.mdl",
	},
	WhiteHostages = {
		"models/player/hostage/hostage_01.mdl",
		"models/player/hostage/hostage_04.mdl",
	},
	BlueHostages = {
		"models/player/hostage/hostage_02.mdl",
		"models/player/hostage/hostage_03.mdl",
	}
}

RegisterJobCategory("Citizens", Color(0, 255, 0))

TEAM_CITIZEN = DarkRP.createJob("Citizen", {
	color = g_RegisterJobWithColor,
	model = Models.Citizens,
	description = [[The Citizen is the most basic level of society you can hold besides being a hobo.
		You have no specific role in city life.]],
	weapons = {},
	command = "citizen",
	max = 0,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = false,
	category = g_RegisterJobWithCategory,
})

TEAM_DOCTOR = DarkRP.createJob("Doctor", {
	color = g_RegisterJobWithColor,
	model = "models/player/kleiner.mdl",
	description = [[With your medical knowledge you work to restore players to full health.
		Without a medic, people cannot be healed.
		Left click with the Medical Kit to heal other players.
		Right click with the Medical Kit to heal yourself.
		Surgery can be performed using your knife.
		Be careful not to kill your patients!]],
	weapons = {"med_kit", "weapon_knife"},
	command = "doctor",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	medic = true,
	category = g_RegisterJobWithCategory,
})

TEAM_BAR = DarkRP.createJob("Bartender", {
	color = g_RegisterJobWithColor,
	model = "models/player/mossman.mdl",
	description = [[Bartenders sell beverages to people.
		They can set up a bar or roam around.]],
	weapons = {},
	command = "bartender",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_DJ = DarkRP.createJob("DJ", {
	color = g_RegisterJobWithColor,
	model = "models/player/odessa.mdl",
	description = [[DJs are allowed to play music.
		They can set up a club or roam around.]],
	weapons = {"weapon_jukebox"},
	command = "dj",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_BANKER = DarkRP.createJob("Banker", {
	color = g_RegisterJobWithColor,
	model = "models/player/magnusson.mdl",
	description = [[Bankers can legally own money printers.
		Bankers loan money to people and allow pople to invest in a money printing businesses.]],
	weapons = {"weapon_jewdetector"},
	command = "banker",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_LAWYER = DarkRP.createJob("Lawyer", {
	color = g_RegisterJobWithColor,
	model = "models/player/gman_high.mdl",
	description = [[Lawyers use their knowledge of the law to release people from jail.
		Releasing people from jail is legal, and you can charge for your services.]],
	weapons = {"unarrest_stick"},
	command = "lawyer",
	max = 4,
	salary = GAMEMODE.Config.normalsalary * 1.5,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_GUARD = DarkRP.createJob("Guard", {
	color = g_RegisterJobWithColor,
	model = "models/player/barney.mdl",
	description = [[Guards can be paid to protect certain areas or people.]],
	weapons = {"lite_p228", "stunstick"},
	command = "guard",
	max = 2,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = true,
	candemote = false,
	category = g_RegisterJobWithCategory,
})

TEAM_VIGILANTE = DarkRP.createJob("Vigilante", {
	color = g_RegisterJobWithColor,
	model = "models/player/barney.mdl",
	description = [[You aren't a cop, but you hate crime just as much.
		Only kill scumbugs who commit crimes.]],
	weapons = {"lite_usp"},
	command = "vigilante",
	max = 2,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = true,
	candemote = false,
	category = g_RegisterJobWithCategory,
})

TEAM_GATOR = DarkRP.createJob("Gator Hunter", {
	color = g_RegisterJobWithColor,
	model = "models/player/group01/male_03.mdl",
			description = [[Now Amos Moses was a Cajun.
		He lived by himself in the swamp.
		He hunted alligator for a living.
		He'd just knock them in the head with a stump.
		The Louisiana law gonna get you, Amos.
		It ain't legal hunting alligator down in the swamp, boy.
		Now everyone blamed his old man.
		For making him mean as a snake.
		When Amos Moses was a boy.
		His daddy would use him for alligator bait.
		Tie a rope around his neck and throw him in the swamp.
		Alligator bait in the Louisiana bayou.
		About forty-five minutes southeast of Thibodaux, Louisiana.
		Lived a man called Doc Mills South and his pretty wife Hannah.
		Well, they raised up a son that could eat up his weight in groceries.
		Named him after a man of the cloth.
		Called him Amos Moses, yeah.
		Now the folks around south Louisiana.
		Said Amos was a hell of a man.
		He could trap the biggest, the meanest alligator.
		And he'd just use one hand.
		That's all he got left 'cause an alligator bit it.
		Left arm gone clear up to the elbow.
		Well the sheriff caught wind that Amos was in the swamp trapping alligator skin.
		So he snuck in the swamp gonna get the boy.
		But he never come out again.
		Well I wonder where the Louisiana sheriff went to.
		Well you can sure get lost in the Louisiana bayou.
		About forty-five minutes southeast of Thibodaux, Louisiana.
		Lived a cat called Doc Mills South and his pretty wife Hannah.
		Well, they raised up a son that could eat up his weight in groceries.
		Named him after a man of the cloth.
		Called him Amos Moses.]],
	weapons = {"lite_m3"},
	command = "gatorhunter",
	max = 1,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	ammo = {
		["buckshot"] = 64
	},
	vote = false,
	hasLicense = true,
	candemote = false,
	category = g_RegisterJobWithCategory,
})

--[[---------------------------------------------------------------------------
CRIMINALS
---------------------------------------------------------------------------]]

RegisterJobCategory("Criminals", Color(75, 75, 75))

TEAM_RAPPER = DarkRP.createJob("Rapper", {
	color = g_RegisterJobWithColor,
	model = Models.Gangsters,
	description = [[Like DJs, but with more gang shit.
		Don't let the other rappers diss you or your coast.
		Feud with other rappers and eliminate them at all costs.]],
	weapons = {"lite_mac10", "lite_glock", "weapon_lean"},
	command = "rapper",
	max = 2,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_THUG = DarkRP.createJob("Thug", {
	color = g_RegisterJobWithColor,
	model = Models.Gangsters,
	description = [[The lowest person of crime.
		Thugs commit petty unorganized crimes and can form gangs.]],
	weapons = {"weapon_knife", "weapon_pickpocket"},
	command = "thug",
	max = 8,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_MAFIA = DarkRP.createJob("Mafia", {
	color = g_RegisterJobWithColor,
	model = Models.Gangsters,
	description = [[The goons of the Mafia.
		The Mafia must work for the Godfather who runs the crime family.
		The Godfather sets your agenda and you follow it or you can be killed.]],
	weapons = {"lite_fiveseven", "weapon_pickpocket"},
	command = "mafia",
	max = 6,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_GODFATHER = DarkRP.createJob("Godfather", {
	color = g_RegisterJobWithColor,
	model = "models/player/gman_high.mdl",
	description = [[The Godfather is the boss of the mafia in the city.
		With his power he coordinates the mafia and forms an efficient crime organization.
		He has the ability to break into houses by using a lockpick.
		The Godfather posesses the ability to unarrest you.]],
	weapons = {"lite_ak47", "lite_fiveseven", "lockpick", "weapon_pickpocket", "unarrest_stick"},
	command = "godfather",
	max = 1,
	salary = GAMEMODE.Config.normalsalary * 1.75,
	admin = 0,
	vote = true,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_THIEF = DarkRP.createJob("Thief", {
	color = g_RegisterJobWithColor,
	model = {"models/player/phoenix.mdl", "models/player/arctic.mdl"},
	description = [[Thieves pick locks to break into peoples homes and steal their possessions.
		They can also pick pockets of unaware citizens for extra cash.]],
	weapons = {"lockpick", "weapon_pickpocket"},
	command = "thief",
	max = 6,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_LOOTER = DarkRP.createJob("Looter", {
	color = g_RegisterJobWithColor,
	model = {"models/player/phoenix.mdl", "models/player/arctic.mdl"},
	description = [[Looters specialize in raiding bases.
		C4 can be planted on doors to blow them open.
		They explode quickly, so be careful!]],
	weapons = {"weapon_c4"},
	command = "looter",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	ammo = {
		["C4"] = 3
	},
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_KIDNAPPER = DarkRP.createJob("Kidnapper", {
	color = g_RegisterJobWithColor,
	model = {"models/player/phoenix.mdl", "models/player/arctic.mdl"},
	description = [[Kidnappers can take hostages and hold them for ransom.
		If no ransom is paid, you can torture and behead your captives.]],
	weapons = {"weapon_zipties", "weapon_knife"},
	command = "kidnapper",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_HACKER = DarkRP.createJob("Hacker", {
	color = g_RegisterJobWithColor,
	model = "models/player/magnusson.mdl",
	description = [[Hackers hack keypads to break into peoples homes and steal their possessions.]],
	weapons = {"keypad_cracker"},
	command = "hacker",
	max = 6,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

--[[---------------------------------------------------------------------------
KILLERS
---------------------------------------------------------------------------]]

RegisterJobCategory("Killers", Color(255, 0, 0))

TEAM_SHOOTER = DarkRP.createJob("Mass Shooter", {
	color = g_RegisterJobWithColor,
	model = Models.Citizens,
	description = [[You will not let yourself be bullied any longer.]],
	weapons = {"lite_m249", "lite_ak47", "lite_m3", "lite_deagle"},
	command = "schoolshooter",
	max = 1,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	ammo = {
		["pistol"] = 999,
		["buckshot"] = 999,
		["rifle"] = 999
	},
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
	PlayerDeath = function(ply, weapon, killer)
		g_SchoolShooterAnnounced = false
		ply:teamBan()
		ply:changeTeam(GAMEMODE.DefaultTeam, true)
		net.Start("SchoolShooterDied")
		net.Broadcast()
	end
})

TEAM_HITMAN = DarkRP.createJob("Hitman", {
	color = g_RegisterJobWithColor,
	model = "models/player/leet.mdl",
	description = [[Hitmen are paid to kill.
		However, killing is still illegal.]],
	weapons = {"lite_scout", "lite_usp"},
	command = "hitman",
	max = 2,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_ANTIFA = DarkRP.createJob("Antifa", {
	color = g_RegisterJobWithColor,
	model = Models.Gangsters,
	description = [[Antifa is all about bashing fash.
		What that means? Nobody really knows for sure.
		Go make innocent white people's lives worse.]],
	weapons = {"weapon_molotov", "weapon_protest"},
	command = "antifa",
	max = 2,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory
})

TEAM_TERROR = DarkRP.createJob("Terrorist", {
	color = g_RegisterJobWithColor,
	model = "models/player/guerilla.mdl",
	description = [[Terrorists spread terror throughout the city and are in a constant war with the government.]],
	weapons = {"lite_ak47", "weapon_jihad"},
	command = "terrorist",
	max = 2,
	salary = 0,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory
})

TEAM_TERRORLEADER = DarkRP.createJob("Terrorist Leader", {
	color = g_RegisterJobWithColor,
	model = "models/player/guerilla.mdl",
	description = [[The terrorist leader leads the terrorists in their war against the government.]],
	weapons = {"lite_ak47", "weapon_jihad", "weapon_c4"},
	command = "terroristleader",
	max = 1,
	salary = 0,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory
})

TEAM_NAZI = DarkRP.createJob("Nazi", {
	color = g_RegisterJobWithColor,
	model = "models/player/dod_german.mdl",
	description = [[Nazis are on a quest to exterminate all jews and correct everyone's grammar.
		Killing jews in public is legal, but they can fight back.]],
	weapons = {"lite_fiveseven", "weapon_jewdetector", "weapon_heil"},
	command = "nazi",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

--[[---------------------------------------------------------------------------
DEALERS
---------------------------------------------------------------------------]]

RegisterJobCategory("Merchants", Color(30, 190, 120))

TEAM_GUN = DarkRP.createJob("Gun Dealer", {
	color = g_RegisterJobWithColor,
	model = "models/player/monk.mdl",
	description = [[Gun dealers sell firearms to other people.
		Make sure you aren't caught selling illegal firearms to the public! You might get arrested!]],
	weapons = {},
	command = "gundealer",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_DRUG = DarkRP.createJob("Drug Dealer", {
	color = g_RegisterJobWithColor,
	model = "models/player/soldier_stripped.mdl",
	description = [[Drug dealers sell drugs to other people.
		Make sure you aren't caught selling illegal drugs to the public! You might get arrested!]],
	weapons = {},
	command = "drugdealer",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_BLACKMARKET = DarkRP.createJob("Black Market Dealer", {
	color = g_RegisterJobWithColor,
	model = "models/player/eli.mdl",
	description = [[Black market dealers sell highly illegal items to other people.
		Make sure you aren't caught selling illegal items to the public! You might get arrested!]],
	weapons = {},
	command = "blackmarket",
	max = 4,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

--[[---------------------------------------------------------------------------
HOMELESS
---------------------------------------------------------------------------]]

RegisterJobCategory("Homeless", Color(100, 60, 20))

TEAM_HOBO = DarkRP.createJob("Hobo", {
	color = g_RegisterJobWithColor,
	model = "models/player/corpse1.mdl",
	description = [[The lowest member of society. Everybody laughs at you.
		You have no home.
		Beg for your food and money.
		Sing for everyone who passes to get money.
		Make your own wooden home somewhere in a corner or outside someone else's door.]],
	weapons = {"weapon_throwshit"},
	command = "hobo",
	max = 6,
	salary = 0,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = false,
	hobo = true,
	category = g_RegisterJobWithCategory,
})

TEAM_SUPERHOBO = DarkRP.createJob("Super Hobo", {
	color = g_RegisterJobWithColor,
	model = "models/player/charple.mdl",
	description = [[Slightly higher than the lowest member of society.
		Hobos look up to you, but to everyone else, you're just another hobo.
		You can lead the hobos to a rebellion against the higher class.
		You carry a bent paperclip that can be used to pick locks.
		You also carry your family heirloom, a crudely made shotgun.]],
	weapons = {"weapon_pipeshotgun", "lockpick", "weapon_throwshit"},
	command = "superhobo",
	max = 1,
	salary = 0,
	admin = 0,
	ammo = {
		["buckshot"] = 10
	},
	vote = false,
	hasLicense = false,
	candemote = false,
	hobo = true,
	category = g_RegisterJobWithCategory,
})

TEAM_SEWER = DarkRP.createJob("Sewer Monster", {
	color = g_RegisterJobWithColor,
	model = "models/player/zombie_soldier.mdl",
	description = [[There isn't even a sewer.
		How did you get here?]],
	weapons = {"weapon_throwshit", "weapon_knife"},
	command = "sewermonster",
	max = 1,
	salary = 0,
	admin = 0,
	vote = false,
	hasLicense = false,
	candemote = false,
	hobo = true,
	category = g_RegisterJobWithCategory,
})

--[[---------------------------------------------------------------------------
GOVERNMENT
---------------------------------------------------------------------------]]

RegisterJobCategory("Government", Color(0, 0, 255))

TEAM_POLICE = DarkRP.createJob("Police Officer", {
	color = g_RegisterJobWithColor,
	model = {"models/player/police.mdl", "models/player/police_fem.mdl"},
	description = [[The protector of every citizen that lives in the city.
		You have the power to arrest criminals and protect innocents.
		Hit a player with your arrest baton to put them in jail.
		Bash a player with a stunstick and they may learn to obey the law.
		The Battering Ram can break down the door of a criminal, with a warrant for their arrest.
		The Battering Ram can also unfreeze frozen props (if enabled).
		Type /wanted <name> to alert the public to the presence of a criminal.]],
	weapons = {"arrest_stick", "unarrest_stick", "lite_fiveseven", "weapon_taser", "weapon_pepperspray", "stunstick", "door_ram", "weaponchecker"},
	command = "police",
	max = 8,
	salary = GAMEMODE.Config.normalsalary * 1.5,
	admin = 0,
	vote = false,
	hasLicense = true,
	ammo = {
		["pistol"] = 60,
	},
	category = g_RegisterJobWithCategory,
})

TEAM_CHIEF = DarkRP.createJob("Police Chief", {
	color = g_RegisterJobWithColor,
	model = "models/player/combine_soldier_prisonguard.mdl",
	description = [[The Chief is the leader of the Civil Protection unit.
		Coordinate the police force to enforce law in the city.
		Hit a player with arrest baton to put them in jail.
		Bash a player with a stunstick and they may learn to obey the law.
		The Battering Ram can break down the door of a criminal, with a warrant for his/her arrest.
		Type /wanted <name> to alert the public to the presence of a criminal.
		Type /jailpos to set the Jail Position.]],
	weapons = {"arrest_stick", "unarrest_stick", "lite_deagle", "lite_mp5", "weapon_taser", "weapon_pepperspray", "stunstick", "door_ram", "weaponchecker"},
	command = "chief",
	max = 1,
	salary = GAMEMODE.Config.normalsalary * 1.75,
	admin = 0,
	vote = true,
	hasLicense = true,
	chief = true,
	ammo = {
		["pistol"] = 60,
		["smg1"] = 90
	},
	category = g_RegisterJobWithCategory,
})

TEAM_ADMIN = DarkRP.createJob("National Guard", {
	color = g_RegisterJobWithColor,
	model = "models/player/swat.mdl",
	description = [[Think of the national guard as in-character admins.
		They will not patrol or raid, but any genocides that pop up will be dealt with.
		You shouldn't fuck with the National Guard.]],
	weapons = {"arrest_stick", "unarrest_stick", "lite_deagle", "lite_m4a1", "lite_m249", "weapon_taser", "weapon_pepperspray", "stunstick", "door_ram", "weaponchecker"},
	command = "nationalguard",
	max = 6,
	salary = GAMEMODE.Config.normalsalary * 2,
	admin = 1,
	vote = false,
	hasLicense = true,
	chief = true,
	ammo = {
		["pistol"] = 200,
		["rifle"] = 600
	},
	category = g_RegisterJobWithCategory,
})

TEAM_MAYOR = DarkRP.createJob("Mayor", {
	color = g_RegisterJobWithColor,
	model = "models/player/breen.mdl",
	description = [[The Mayor of the city creates laws to govern the city.
		If you are the mayor you may create and accept warrants.
		Type /wanted <name>  to warrant a player.
		Type /jailpos to set the Jail Position.
		Type /lockdown initiate a lockdown of the city.
		Everyone must be inside during a lockdown.
		The cops patrol the area.
		Type /unlockdown to end a lockdown.]],
	weapons = {},
	command = "mayor",
	max = 1,
	salary = GAMEMODE.Config.normalsalary * 2,
	admin = 0,
	vote = true,
	hasLicense = false,
	mayor = true,
	category = g_RegisterJobWithCategory,
})

TEAM_MAIL = DarkRP.createJob("Mailman", {
	color = g_RegisterJobWithColor,
	model = {"models/player/mossman_arctic.mdl", "models/player/odessa.mdl"},
	description = [[Mailmen collect mail for money.
		Look for mailboxes throughout the city to collect the mail.
		Mailmen also deliver things among players for money.]],
	weapons = {"weapon_mail"},
	command = "mailman",
	max = 2,
	salary = GAMEMODE.Config.normalsalary * 1.5,
	admin = 0,
	vote = false,
	category = g_RegisterJobWithCategory,
})

--[[---------------------------------------------------------------------------
SPECIAL
---------------------------------------------------------------------------]]

RegisterJobCategory("Special", Color(255, 0, 255))

TEAM_KARDASHIAN = DarkRP.createJob("Kim Kardashian", {
	color = g_RegisterJobWithColor,
	model = "models/player/alyx.mdl",
	description = [[You aren't very bright.
		You make lots of money.
		You are always KOS.]],
	weapons = {},
	command = "kardashian",
	max = 1,
	salary = GAMEMODE.Config.normalsalary * 4,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
	customCheck = function(ply) return #player.GetAll() > 3 end,
	CustomCheckFailMsg = "There must be at least four players on the server to play as Kim Kardashian!"
})

TEAM_EDGYTEEN = DarkRP.createJob("Edgy Teen", {
	color = g_RegisterJobWithColor,
	model = "models/player/p2_chell.mdl",
	description = [[Your tumblr is filled with suicidal memes.]],
	weapons = {},
	command = "edgyteen",
	max = 1,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_SHITTYSTARWARSCOSPLAYER = DarkRP.createJob("Star Wars Cosplayer", {
	color = g_RegisterJobWithColor,
	model = "models/player/odessa.mdl",
	description = [[You think you are cool.
		You carry around a small blue plastic lightsaber.
		You are free to hit people, but they can kill you if you do.]],
	weapons = {"stunstick"},
	command = "starwarscosplayer",
	max = 1,
	salary = GAMEMODE.Config.normalsalary,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_MURDER = DarkRP.createJob("Murderer", {
	color = g_RegisterJobWithColor,
	model = "models/player/corpse1.mdl",
	description = [[You have escaped from the murder gamemode somehow, only to find yourself here.]],
	weapons = {"weapon_knife"},
	command = "murderer",
	max = 1,
	salary = 0,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

TEAM_DAUGHTER = DarkRP.createJob("Mayor's Daughter", {
	color = g_RegisterJobWithColor,
	model = {"models/player/alyx.mdl"},
	description = [[You are the mayor's daughter.
		You are just like a citizen but richer.
		Watch out though, getting kidnapped will force the mayor to pay a ransom to get you back!]],
	weapons = {"weapon_pepperspray"},
	command = "daughter",
	max = 1,
	salary = GAMEMODE.Config.normalsalary * 1.75,
	admin = 0,
	vote = false,
	hasLicense = false,
	category = g_RegisterJobWithCategory,
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN

--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
	[TEAM_POLICE] = true,
	[TEAM_CHIEF] = true,
	[TEAM_MAYOR] = true,
}

--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_GODFATHER)
DarkRP.addHitmanTeam(TEAM_HITMAN)
