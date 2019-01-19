
net.Receive("ShowPlayerFlinch", function(len)
	local ply = net.ReadEntity()
	if IsValid(ply) and ply:IsPlayer() then
		ply:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_HEAD, true)
	end
end)
