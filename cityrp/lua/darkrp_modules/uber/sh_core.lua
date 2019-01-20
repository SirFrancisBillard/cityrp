
uber = uber or {}

net.Receive("uber.syncDrivers", function()
	local tab = net.ReadTable()

	uber.drivers = tab
end)

function uber:getActiveDrivers()
	return self.drivers
end

function uber:isUberDriver(ply)
	return self.drivers[ ply ]
end

function uber:getUberPrice()
	return self:GetNWInt("uberPrice")
end

local meta = FindMetaTable("Player")
function meta:isUbering()
	local person = self:GetNWEntity("ubering")

	if (IsValid(person)) then
		return true, person
	end
end
