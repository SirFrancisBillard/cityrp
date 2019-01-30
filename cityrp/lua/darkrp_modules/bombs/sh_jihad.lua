
sound.Add({
	name = "Jihad.Scream",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 150,
	pitch = {95, 110},
	sound = {"jihad/jihad_1.wav", "jihad/jihad_2.wav"}
})

-- same as Arena.Explosion, just much louder

local SoundNames = {}

for i = 0, 6, 1 do
	SoundNames[#SoundNames + 1] = "^phx/explode0" .. i .. ".wav"
end

sound.Add({
	name = "Jihad.Explode",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 150,
	pitch = {95, 110},
	sound = SoundNames
})

sound.Add({
	name = "Jihad.Islam",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 150,
	pitch = {100},
	sound = {"music/islam.wav"}
})
