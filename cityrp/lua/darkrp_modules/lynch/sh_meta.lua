
local PLAYER = FindMetaTable("Player")

function PLAYER:GetLynchVotes()
	return self:GetNWInt("lynch_votes", 0)
end
