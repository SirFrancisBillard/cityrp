
local PLAYER = FindMetaTable("Player")

function PLAYER:SetMentalState(num)
	self:SetNWInt("mental_state", num)
end

function PLAYER:AddMentalState(num)
	self:SetNWInt("mental_state", math.min(100, self:GetNWInt("mental_state", 100) + num))
end

function PLAYER:SubtractMentalState(num)
	self:SetNWInt("mental_state", math.max(0, self:GetNWInt("mental_state", 100) - num))
end
