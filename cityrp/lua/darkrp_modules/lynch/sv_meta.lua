
local PLAYER = FindMetaTable("Player")

function PLAYER:SetLynchVotes(amt)
	self:SetNWInt("lynch_votes", amt)
end

function PLAYER:AddLynchVote(ply)
	self:SetLynchVotes(self:GetLynchVotes() + 1)
end

function PLAYER:Lynch()
	for k, v in pairs(player.GetAll()) do
		if v.LynchTarget == self then
			v.LynchTarget = false
		end
	end

	PrintMessage(HUD_PRINTTALK, self:Nick() .. " has been lynched!")
	self.CauseOfDeath = "lynch"
	self.NextLynchTime = CurTime() + 600
	self:Kill()
end

function PLAYER:TryLynch(ply)
	if player.GetCount() <= 2 then
		self:ChatPrint("Not enough players are on the server to start a lynch vote.")
		return
	end

	if ply.NextLynchTime and ply.NextLynchTime > CurTime() then
		self:ChatPrint(ply:Nick() .. " cannot be lynched for another " .. math.Round(ply.NextLynchTime - CurTime()) .. " seconds.")
		return
	end

	if self == ply then
		self:ChatPrint("You can't lynch yourself, bud.")
	end

	if self.LynchTarget and self.LynchTarget == ply then
		self:ChatPrint("You are no longer voting to lynch " .. ply:Nick() .. ".")
		self.LynchTarget = false
		return
	end

	self.LynchTarget = ply

	if ply:GetLynchVotes() < GetVotesNeededToLynch() then
		PrintMessage(HUD_PRINTTALK, self:Nick() .. " is voting to lynch " .. ply:Nick() .. ".\n" .. tostring(GetVotesNeededToLynch() - ply:GetLynchVotes()) .. " more votes are needed to lynch " .. ply:Nick() .. ".\nType /lynch <name> to vote.")
	else
		PrintMessage(HUD_PRINTTALK, self:Nick() .. " is voting to lynch " .. ply:Nick() .. ".\n" .. "That's the final vote!")
		ply:Lynch()
	end
end
