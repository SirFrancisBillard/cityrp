
GENDER_MALE = "male"
GENDER_FEMALE = "female"

gPlayerHurtSounds = {
	[HITGROUP_HEAD] = {
		Sound("physics/flesh/flesh_squishy_impact_hard1.wav"),
		Sound("physics/flesh/flesh_squishy_impact_hard2.wav"),
		Sound("physics/flesh/flesh_squishy_impact_hard3.wav"),
		Sound("physics/flesh/flesh_squishy_impact_hard4.wav")
	},
	[GENDER_MALE] = {
		["generic"] = {
			Sound("vo/npc/male01/pain01.wav"),
			Sound("vo/npc/male01/pain02.wav"),
			Sound("vo/npc/male01/pain03.wav"),
			Sound("vo/npc/male01/pain04.wav"),
			Sound("vo/npc/male01/pain05.wav"),
			Sound("vo/npc/male01/pain06.wav"),
			Sound("vo/npc/male01/pain07.wav"),
			Sound("vo/npc/male01/pain08.wav"),
			Sound("vo/npc/male01/pain09.wav"),
			Sound("vo/ravenholm/monk_pain01"),
			Sound("vo/ravenholm/monk_pain02"),
			Sound("vo/ravenholm/monk_pain03"),
			Sound("vo/ravenholm/monk_pain04"),
			Sound("vo/ravenholm/monk_pain05"),
			Sound("vo/ravenholm/monk_pain06"),
			Sound("vo/ravenholm/monk_pain07"),
			Sound("vo/ravenholm/monk_pain08"),
			Sound("vo/ravenholm/monk_pain09"),
			Sound("vo/ravenholm/monk_pain10"),
			Sound("vo/ravenholm/monk_pain12"),
			Sound("vo/npc/male01/moan01.wav"),
			Sound("vo/npc/male01/moan02.wav"),
			Sound("vo/npc/male01/moan03.wav"),
			Sound("vo/npc/male01/moan04.wav"),
			Sound("vo/npc/male01/moan05.wav")
		},
		[HITGROUP_LEFTARM] = {
			Sound("vo/npc/male01/myarm01.wav"),
			Sound("vo/npc/male01/myarm02.wav")
		},
		[HITGROUP_LEFTLEG] = {
			Sound("vo/npc/male01/myleg01.wav"),
			Sound("vo/npc/male01/myleg02.wav")
		},
		[HITGROUP_STOMACH] = {
			Sound("vo/npc/male01/mygut02.wav"),
			Sound("vo/npc/male01/hitingut01.wav"),
			Sound("vo/npc/male01/hitingut02.wav")
		}
	},
	[GENDER_FEMALE] = {
		["generic"] = {
			Sound("vo/npc/female01/pain01.wav"),
			Sound("vo/npc/female01/pain02.wav"),
			Sound("vo/npc/female01/pain03.wav"),
			Sound("vo/npc/female01/pain04.wav"),
			Sound("vo/npc/female01/pain05.wav"),
			Sound("vo/npc/female01/pain06.wav"),
			Sound("vo/npc/female01/pain07.wav"),
			Sound("vo/npc/female01/pain08.wav"),
			Sound("vo/npc/female01/pain09.wav"),
			Sound("vo/npc/female01/moan01.wav"),
			Sound("vo/npc/female01/moan02.wav"),
			Sound("vo/npc/female01/moan03.wav"),
			Sound("vo/npc/female01/moan04.wav"),
			Sound("vo/npc/female01/moan05.wav")
		},
		[HITGROUP_LEFTARM] = {
			Sound("vo/npc/female01/myarm01.wav"),
			Sound("vo/npc/female01/myarm02.wav")
		},
		[HITGROUP_LEFTLEG] = {
			Sound("vo/npc/female01/myleg01.wav"),
			Sound("vo/npc/female01/myleg02.wav")
		},
		[HITGROUP_STOMACH] = {
			Sound("vo/npc/female01/mygut02.wav"),
			Sound("vo/npc/female01/hitingut01.wav"),
			Sound("vo/npc/female01/hitingut02.wav")
		}
	}
}

gPlayerHurtSounds[GENDER_MALE][HITGROUP_RIGHTARM] = gPlayerHurtSounds[GENDER_MALE][HITGROUP_LEFTARM]
gPlayerHurtSounds[GENDER_MALE][HITGROUP_RIGHTLEG] = gPlayerHurtSounds[GENDER_MALE][HITGROUP_LEFTLEG]

gPlayerHurtSounds[GENDER_FEMALE][HITGROUP_RIGHTARM] = gPlayerHurtSounds[GENDER_FEMALE][HITGROUP_LEFTARM]
gPlayerHurtSounds[GENDER_FEMALE][HITGROUP_RIGHTLEG] = gPlayerHurtSounds[GENDER_FEMALE][HITGROUP_LEFTLEG]

-- easier format, will be automatically converted on lua refresh
local GenderConfig = {
	[GENDER_MALE] = {
		"models/player/group03/male_01.mdl",
		"models/player/Group03/Male_02.mdl",
		"models/player/Group03/male_03.mdl",
		"models/player/Group03/Male_04.mdl",
		"models/player/Group03/Male_05.mdl",
		"models/player/Group03/Male_06.mdl",
		"models/player/Group03/Male_07.mdl",
		"models/player/Group03/Male_08.mdl",
		"models/player/Group03/Male_09.mdl",
		"models/player/group01/male_01.mdl",
		"models/player/Group01/Male_02.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group01/Male_04.mdl",
		"models/player/Group01/Male_05.mdl",
		"models/player/Group01/Male_06.mdl",
		"models/player/Group01/Male_07.mdl",
		"models/player/Group01/Male_08.mdl",
		"models/player/Group01/Male_09.mdl",
		"models/player/Group02/male_02.mdl",
		"models/player/Group02/male_04.mdl",
		"models/player/Group02/male_06.mdl",
		"models/player/Group02/male_08.mdl",
		"models/player/hostage/hostage_01.mdl",
		"models/player/hostage/hostage_02.mdl",
		"models/player/hostage/hostage_03.mdl",
		"models/player/hostage/hostage_04.mdl",
		"models/player/arctic.mdl",
		"models/player/guerilla.mdl",
		"models/player/leet.mdl",
		"models/player/phoenix.mdl",
		"models/player/magnusson.mdl",
		"models/player/eli.mdl",
		"models/player/monk.mdl"
	},
	[GENDER_FEMALE] = {
		"models/player/Group03/Female_01.mdl",
		"models/player/Group03/Female_02.mdl",
		"models/player/Group03/Female_03.mdl",
		"models/player/Group03/Female_04.mdl",
		"models/player/Group03/Female_06.mdl",
		"models/player/Group01/Female_01.mdl",
		"models/player/Group01/Female_02.mdl",
		"models/player/Group01/Female_03.mdl",
		"models/player/Group01/Female_04.mdl",
		"models/player/Group01/Female_06.mdl",
		"models/player/alyx.mdl"
	}
}

gPlayerModelGenders = {}

for k, v in pairs(GenderConfig[GENDER_MALE]) do
	gPlayerModelGenders[v] = GENDER_MALE
end

for k, v in pairs(GenderConfig[GENDER_FEMALE]) do
	gPlayerModelGenders[v] = GENDER_FEMALE
end
