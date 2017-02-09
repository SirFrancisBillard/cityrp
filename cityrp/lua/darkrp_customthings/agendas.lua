--[[---------------------------------------------------------------------------
DarkRP Agenda's
---------------------------------------------------------------------------
Agenda's can be set by the agenda manager and read by both the agenda manager and the other teams connected to it.


HOW TO MAKE AN AGENDA:
AddAgenda(Title of the agenda, Manager (who edits it), {Listeners (the ones who just see and follow the agenda)})
---------------------------------------------------------------------------]]

AddAgenda("Mafia Agenda", TEAM_GODFATHER, {TEAM_MAFIA})
AddAgenda("Police Agenda", TEAM_MAYOR, {TEAM_CHIEF, TEAM_POLICE})
AddAgenda("Terrorist Agenda", TEAM_TERRORLEADER, {TEAM_TERROR})
AddAgenda("Nazi Agenda", TEAM_HITLER, {TEAM_NAZI})
AddAgenda("Hobo Agenda", TEAM_SUPERHOBO, {TEAM_HOBO})
