
hook.Add("PlayerSay", "NoHeckHere", function(ply, text)
	if ply:IsAdmin() then return end
	local heckStart, heckEnd = string.find(text:lower(), "heck")
	if heckStart then
		local civilText = string.sub(text, 1, heckStart - 1) .. "****" .. string.sub(text, heckEnd + 1)
		ply:ChatPrint("Please do not use offensive language in this Christian server.")
		return civilText
	end
end)
