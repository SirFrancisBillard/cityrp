
-- #NoSimplerr#

local function PlayerName(ply)
	return isfunction(ply.SteamName) and ply:SteamName() or ply:Nick()
	-- return isfunction(ply.SteamName) and (ply:Nick() .. " (" .. ply:SteamName() .. ")") or ply:Nick()
end

local function FindPlayer(name)
	name = string.lower(name)
	for k, v in ipairs(player.GetHumans()) do
		if string.find(string.lower(v:Nick()), name, 1, true) ~= nil then
			return v
		end
		if isfunction(v.SteamName) and string.find(string.lower(v:SteamName()), name, 1, true) ~= nil then
			return v
		end
	end
	return false
end

local badmin_cmds = {
	["!burn"] = {
		help = [[<target> [time]
		Ignite the target.]],
		func = function(ply, args)
			if not ply:IsAdmin() or not args[2] then return end
			local found = FindPlayer(args[2])
			if not found then return end
			found:Ignite(args[3] or 30)
		end,
	},
	["!launch"] = {
		help = [[<target> [magnitude]
		Launch a target into the air.
		Magnitude is a multiplier of force, default is 1.]],
		func = function(ply, args)
			if not ply:IsAdmin() or not args[2] or not args[3] then return end
			local found = FindPlayer(args[2])
			if not found then return end
			local mult = args[3] or 1
			found:SetVelocity(found:GetVelocity() + Vector(0, 0, 300 * mult))
		end,
	},
	["!swap"] = {
		help = [[<target>
		Swap places with the target.]],
		func = function(ply, args)
			if not ply:IsAdmin() or not args[2] then return end
			local found = FindPlayer(args[2])
			if not found then return end
			local ourPos = ply:GetPos()
			ply:SetPos(found:GetPos())
			found:SetPos(ourPos)
		end,
	},
	["!spin"] = {
		help = [[<target> [magnitude]
		Give the target a little spin.
		Magnitude is a multiplier of speed, default is 1.]],
		func = function(ply, args)
			if not ply:IsAdmin() or not args[2] then return end
			local found = FindPlayer(args[2])
			if not found then return end
			local mult = args[3] or 1
			found:SetVelocity(found:GetVelocity() + Vector(0, 300 * mult, 2))
		end,
	},
}

-- after constructor, we need the table itself
badmin_cmds["!badmin"] = {
	help = [[
	Brings up this message.]],
	func = function(ply, args)
		if not ply:IsAdmin() then return end
		for k, v in pairs(badmin_cmds) do
			ply:ChatPrint(v.help and (k .. " " .. v.help) or k)
		end
	end,
},

-- call string.lower AFTER so we dont fuck up the link
hook.Add("PlayerSay", "BadminChatCommand", function(ply, txt)
	if not IsValid(ply) or not ply:IsAdmin() then return end
	local args = string.Split(txt, " ")
	if badmin_cmds[string.lower(args[1])] and isfunction(badmin_cmds[string.lower(args[1])].func) then
		badmin_cmds[string.lower(args[1])].func(ply, args)
	end
end)
