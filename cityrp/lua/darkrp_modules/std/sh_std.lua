local moans = {}

for i = 1, 5 do
	table.insert(moans, "vo/npc/male01/moan0" .. i .. ".wav")
end

sound.Add({
	name = "STD.Moan",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = moans
})
