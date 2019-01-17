
local PLAYER = FindMetaTable("Player")

function PLAYER:GetLynchVotes()
	local votes = 0
	for k, v in pairs(player.GetAll()) do
		if v.GetLynchTarget and v:GetLynchTarget() == self then
			votes = votes + 1
		end
	end
	return votes
end
