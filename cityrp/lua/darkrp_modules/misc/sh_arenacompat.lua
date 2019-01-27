
-- compatibility for Arena3D weapons

local SoundNames = {}

for i = 0, 6, 1 do
	SoundNames[#SoundNames + 1] = "^phx/explode0" .. i .. ".wav"
end

sound.Add({
	name = "Arena.Explosion",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 120,
	pitch = {95, 110},
	sound = SoundNames
})
