
hook.Add("CreateMove", "BHOP", function(cmd)
	if cmd:KeyDown(IN_JUMP) and LocalPlayer():GetMoveType() ~= MOVETYPE_NOCLIP and LocalPlayer():WaterLevel() < 2 and not LocalPlayer():IsOnGround() then
		cmd:RemoveKey(IN_JUMP)
	end
end)
