
local PLAYER = FindMetaTable("Player")

BR_STATUS_NONE = 0 -- not playing or queued
BR_STATUS_QUEUE = 1 -- in queue to play
BR_STATUS_PLAYING = 2 -- currently playing

function PLAYER:SetBRStatus(status)
	self:SetNWInt("br_status", status)
end

function PLAYER:GetBRStatus()
	return self:GetNWInt("br_status", BR_STATUS_NONE)
end

function PLAYER:TryQueueBR()
	local status = self:GetBRStatus()
	if status == BR_STATUS_NONE then
		self:SetBRStatus(BR_STATUS_QUEUE)
		self:ChatPrint("You've been added to the queue!")
	elseif status == BR_STATUS_QUEUE then
		self:SetBRStatus(BR_STATUS_NONE)
		self:ChatPrint("You've been removed from the queue.")
	end
end

local DefaultBRWeapons = {
	"weapon_fists",
}

if CLIENT then return end

function PLAYER:InitBR()
	self:SaveWeaponInventory(true)
	self:SetBRStatus(BR_STATUS_PLAYING)

	for k, v in pairs(DefaultBRWeapons) do
		self:Give(v)
	end
end

function PLAYER:FinishBR()
	self:LoadWeaponInventory(true)
	self:SetBRStatus(BR_STATUS_NONE)
end

function PLAYER:WinBR()
	self:addMoney(5000)
	self:ChatPrint("+$5000 for winning Battle Royale.")
end
