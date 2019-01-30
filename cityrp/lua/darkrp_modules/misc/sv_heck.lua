
local CommandStarts = {
	["/"] = true,
	["!"] = true
}

local Red = Color(255, 0, 0)

hook.Add("PlayerSay", "NoHeckHere", function(ply, text)
	if ply:IsAdmin() or CommandStarts[string.Left(text, 1)] then return end
	local heckStart, heckEnd = string.find(text:lower(), "heck")
	if heckStart then
		local civilText = string.sub(text, 1, heckStart - 1) .. "****" .. string.sub(text, heckEnd + 1)
		ply:AddText(Red, "Please do not use offensive language in this Christian server.")
		return civilText
	end
end)
