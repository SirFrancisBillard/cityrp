DOOR_STATE_CLOSED = 0
DOOR_STATE_OPENING = 1
DOOR_STATE_OPEN = 2
DOOR_STATE_CLOSING = 3
DOOR_STATE_AJAR = 4

local meta = FindMetaTable("Entity")

function meta:IsDoor()
	local class = self:GetClass()
		if class == "prop_door_rotating" or class == "func_door" or class == "func_door_rotating" or class == "prop_dynamic" then
			return true
		end
	return false
end

function meta:GetDoorState()
	return self:GetSaveTable().m_eDoorState
end

function meta:IsDoorClosed()
	return self:GetDoorState() == DOOR_STATE_CLOSED
end

function meta:IsDoorClosing()
	return self:GetDoorState() == DOOR_STATE_CLOSING
end

function meta:IsDoorOpening()
	return self:GetDoorState() == DOOR_STATE_OPENING
end

function meta:IsDoorOpen()
	return self:GetDoorState() == DOOR_STATE_OPEN
end

function meta:IsDoorAjar()
	return self:GetDoorState() == DOOR_STATE_AJAR
end

function meta:IsDoorBlocked()
	return IsValid(self:GetSaveTable().m_hBlocker) 
end

function meta:IsDoorLocked()
	return self:GetSaveTable().m_bLocked 
end

function meta:IsPlayerOpening()
	return (self:GetActivator() and self:GetActivator():IsPlayer())
end

function meta:GetActivator()
	return self:GetSaveTable().m_hActivator
end

function meta:IsActivator( ent )
	return ent == self:GetSaveTable().m_hActivator
end