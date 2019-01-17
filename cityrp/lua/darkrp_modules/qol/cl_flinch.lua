
net.Receive("ShowPlayerFlinch", function(len)
	local index = net.ReadEntity()
	local ply = Entity(index)
	if IsValid(ply) and ply:IsPlayer() then
		ply:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_HEAD, true)
	end
end)
