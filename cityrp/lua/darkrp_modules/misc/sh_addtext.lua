
local PLAYER = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString("SendAddText")

	function PLAYER:AddText(...)
		net.Start("SendAddText")
			net.WriteTable({...})
		net.Send(self)
	end
else
	net.Receive("SendAddText", function()
		chat.AddText(unpack(net.ReadTable()))
	end)
end
