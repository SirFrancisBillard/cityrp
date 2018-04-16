
local PLAYER = FindMetaTable("Player")

function PLAYER:SetLynchVotes(amt)
	self:SetNWInt("lynch_votes", amt)
end

function PLAYER:AddLynchVote(ply)
	self:SetLynchVotes(self:GetLynchVotes() + 1)
end

function PLAYER:Lynch()
	for k, v in pairs(player.GetAll()) do
		if v.LynchTarget == self:SteamID() then
			v.LynchTarget = false
		end
	end

	PrintMessage(HUD_PRINTTALK, self:Nick() .. " has been lynched!")
	self.CauseOfDeath = "lynch"
	self:Kill()
end

function PLAYER:VoteToLynch(ply)
	if self.LynchTarget == ply:SteamID() then
		self:ChatPrint("You are already voting to lynch " .. ply:Nick() .. "!")
		return
	end

	self.LynchTarget = ply:SteamID()

	if ply:GetLynchVotes() < GetVotesNeededToLynch() then
		PrintMessage(HUD_PRINTTALK, self:Nick() .. " is voting to lynch " .. ply:Nick() .. ".\n" .. tostring(GetVotesNeededToLynch() - ply:GetLynchVotes()) .. " more votes are needed to lynch " .. ply:Nick() .. ".\nType /lynch <name> to vote.")
	else
		ply:Lynch()
	end
end
