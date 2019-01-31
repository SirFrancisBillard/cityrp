
-- infinitely less taxing on the server

net.Receive("JihadAnimation", function(len)
	local ply = net.ReadEntity()
	if not IsValid(ply) or not ply:IsPlayer() then return end
	ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
end)
