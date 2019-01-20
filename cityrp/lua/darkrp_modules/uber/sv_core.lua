
uber = uber or {}

util.AddNetworkString("uber.syncDrivers")
util.AddNetworkString("uber.uberPrompt")
util.AddNetworkString("uber.")

hook.Add("OnPlayerChangedTeam", "DetectUberChanges", function(ply, lastTeam, newTeam)
	local uberTeam = uber.driver_team

	if (lastTeam == uberTeam) then
		uber.drivers[ ply ] = nil
		uber:syncDrivers()
	elseif (newTeam == uberTeam) then
		uber.drivers[ ply ] = true
		uber:syncDrivers()
	end
end)

function uber:syncDrivers()
	net.Start("uber.syncDrivers")
		net.WriteTable(self.drivers)
	net.Broadcast()
end

function uber:start(driver, driving)
	driver:SetNWEntity("ubering", driving)
	driving:addMoney(- driver:getUberPrice())
end

local meta = FindMetaTable("Player")
function meta:setUber(person)
	self:SetNWEntity("ubering", person)
end

function uber:prompt(text)
	--do stuff
end

--Client asks the server to ask the driver to uber them
--requires: entity, the driver
local uberCache = {}
net.Receive("uber.uberPrompt", function(l, client)
	local target = net.ReadEntity()

	if (not IsValid(target)) then return end
	if (not uber:isUberDriver(target)) then return end	
	if (not client:canAfford(target:getUberPrice())) then return end

	local tab = [target, client]
	if (table.HasValue(uberCache, tab)) then return end

	net.Start("uber.uberPromptGUI")
		net.WriteEntity(client)
	net.Send(target)

	table.insert(uberCache, tab)

	timer.Simple(30, function()
		table.RemoveByValue(uberCache, tab)
	end)
end)

--The driver tells the server we want to drive the player
--requires: entity, the person who wants to be driven
--			bool, accept or decline
--this is safe because we check a compiled table against the pre existing ones on the server
net.Receive("uber.decision", function(l, driver)
	local driving = net.ReadEntity()
	local decision = net.ReadBool()

	local tab = {driver, driving}

	if (not table.HasValue(uberCache, tab)) then return end

	if (not decision) then
		table.RemoveByValue(uberCache, tab)

		uber:prompt("The driver has rejected this drive, sorry!")
		return
	end

	if (not IsValid(driving)) then return end
	if (not uber:isUberDriver(driving)) then return end	
	if (not client:canAfford(driving:getUberPrice())) then return end
	
	table.RemoveByValue(uberCache, tab)

	uber:start(driver, driving)
end)
