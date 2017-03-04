
local color_red = Color(255, 0, 0)

net.Receive("AnnounceSchoolShooting", function(len)
	local name = net.ReadString()
	chat.AddText(color_red, name .. " has begun a school shooting!")
	g_SchoolShootingSiren = CreateSound(LocalPlayer(), "ambient/alarms/combine_bank_alarm_loop4.wav")
	g_SchoolShootingSiren:Play()
	g_SchoolShootingSiren:FadeOut(10)
end)

net.Receive("SchoolShooterDied", function(len)
	chat.AddText(color_red, "The school shooter has died!")
	if g_SchoolShootingSiren then
		g_SchoolShootingSiren:Stop()
	end
end)
