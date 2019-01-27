
-- burn a book, save a tree!
-- sign text used in weapon_protest.lua
-- #NoSimplerr#

local PLAYER = FindMetaTable("Player")

function PLAYER:GetProtestText()
	return self:GetNWString("protest_text", "Burn a Book,\nSave a Tree!")
end

if SERVER then
	util.AddNetworkString("UpdateProtestSign")

	function PLAYER:SetProtestText(text)
		self:SetNWString("protest_text", text)
	end

	-- note: ply.LastProtestUpdate are completely different variables on the client and
	-- server, but they should be similar enough to not cause problems
	net.Receive("UpdateProtestSign", function(len, ply)
		local text = net.ReadString()
		if string.len(text) > 64 then return end
		if CurTime() - self.LastProtestUpdate < 10 then return end
		self.LastProtestUpdate = CurTime()
		ply:SetProtestText(text)
	end)
else
	function SendProtestText(text)
		if self ~= LocalPlayer() then return end
		if string.len(text) > 64 then return end
		if CurTime() - LocalPlayer().LastProtestUpdate < 10 then return end
		LocalPlayer().LastProtestUpdate = CurTime()
		net.Start("UpdateProtestSign")
		net.WriteString(text)
		net.SendToServer()
	end
end


