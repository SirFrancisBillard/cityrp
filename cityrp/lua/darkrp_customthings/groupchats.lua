--[[---------------------------------------------------------------------------
Group chats
---------------------------------------------------------------------------
Team chat for when you have a certain job.
e.g. with the default police group chat, police officers, chiefs and mayors can
talk to one another through /g or team chat.

HOW TO MAKE A GROUP CHAT:
Simple method:
GAMEMODE:AddGroupChat(List of team variables separated by comma)

Advanced method:
GAMEMODE:AddGroupChat(a function with ply as argument that returns whether a random player is in one chat group)
This is for people who know how to script Lua.

---------------------------------------------------------------------------]]

GAMEMODE:AddGroupChat(TEAM_MAYOR, TEAM_CHIEF, TEAM_POLICE)
GAMEMODE:AddGroupChat(TEAM_GODFATHER, TEAM_MAFIA)
GAMEMODE:AddGroupChat(TEAM_TERRORLEADER, TEAM_TERROR)
GAMEMODE:AddGroupChat(TEAM_HITLER, TEAM_NAZI)
