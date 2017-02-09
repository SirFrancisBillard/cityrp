--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]

AddDoorGroup("Government only", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
AddDoorGroup("Terrorists only", TEAM_TERROR, TEAM_TERRORLEADER)
AddDoorGroup("Nazis only", TEAM_NAZI, TEAM_HITLER)
AddDoorGroup("ALL MEN ARE PIGS", TEAM_FEMINIST)
AddDoorGroup("Gun dealer only", TEAM_GUN)
AddDoorGroup("Drug dealer only", TEAM_DRUG)
AddDoorGroup("Black market dealer only", TEAM_BLACKMARKET)
