--[[
You can use this function to create weapon sound scripts if you plan to make weapons with separate sounds
Example usage:
SWB_RegisterSound("ExampleSound", "path/to/example/sound.format", 100)

Supported formats: .wav, .mp3, .ogg
The 'level' argument indicates how far the sound will be audible.
The 'pstart' and 'pend' arguments dictate the random pitch that will be used when the sound is played.
]]--

function SWB_RegisterSound(n, s, l, pstart, pend)
	local tbl = {channel = CHAN_STATIC,
		volume = 1,
		level = l,
		name = n,
		sound = s,
		pitchstart = pstart,
		pitchend = pend}
	
	sound.Add(tbl)
end

SWB_RegisterSound("SWB_Empty", "weapons/shotgun/shotgun_empty.wav", 60, 95, 112)
SWB_RegisterSound("SWB_Knife_Hit", {"weapons/knife/knife_hit1.wav", "weapons/knife/knife_hit2.wav", "weapons/knife/knife_hit3.wav", "weapons/knife/knife_hit4.wav"}, 70, 92, 122)
SWB_RegisterSound("SWB_Knife_HitElse", "weapons/knife/knife_hitwall1.wav", 70, 92, 122)
SWB_RegisterSound("SWB_Knife_Swing", {"weapons/knife/knife_slash1.wav", "weapons/knife/knife_slash2.wav"}, 65, 92, 122)