
local DefaultSpawns = {
	Vector(2807.027344, -2358.466064, -131.968750),
	Vector(2791.989258, -2214.955078, -139.968750),
	Vector(2587.632080, -2275.581055, -139.968750),
	Vector(2658.037354, -2120.956543, -139.968750),
	Vector(2135.565430, -1629.572021, -131.968750),
	Vector(2152.742676, -1906.613159, -131.968750),
	Vector(-960.306091, -7220.356445, -134.968750),
	Vector(-1088.253540, -7267.926758, -134.968750),
	Vector(-1005.868530, -7121.097656, -134.968750),
	Vector(-1122.368774, -7075.062500, -134.968750),
	Vector(294.314697, -6934.529785, -133.968750),
	Vector(317.071136, -7038.627930, -133.968750),
	Vector(222.960587, -7043.773926, -133.968750),
	Vector(196.341721, -6910.149902, -133.968750),
	Vector(-1770.222534, -4420.104004, -134.968735),
	Vector(-1809.032471, -4504.180176, -134.968750),
	Vector(-1921.234009, -4534.461426, -134.968750),
	Vector(-1926.432129, -4398.599609, -134.968750),
	Vector(-2070.110107, -4450.074707, -134.968750),
	Vector(-2273.791260, -4760.438477, -134.963287),
	Vector(-2123.276123, -4837.902832, -134.963287),
	Vector(-2244.162598, -4935.196777, -134.963287),
	Vector(-2849.141357, -6519.867676, -134.968750),
	Vector(-2776.006592, -6414.119629, -139.968750),
	Vector(-2677.930176, -6511.730957, -134.968750),
	Vector(-2859.400635, -6332.612793, -134.968750),
	Vector(-2170.533447, -214.647308, -131.968750),
	Vector(-2332.108398, -308.527588, -131.968750),
	Vector(503.765442, 2703.794922, -131.968750),
	Vector(521.750732, 2810.066162, -131.968750),
	Vector(419.899536, 2837.711670, -131.968750),
	Vector(47.337708, 478.785736, -131.535126),
	Vector(44.183643, 586.613708, -139.968750),
	Vector(-62.675262, 559.101013, -139.968750),
	Vector(-82.638695, 682.853333, -139.968750),
	Vector(-1361.503540, 880.912476, -131.968750),
	Vector(-1248.470459, 833.953857, -139.968750),
	Vector(-1300.494751, 900.953369, -131.968750),
	Vector(-1370.811279, 942.968750, -131.968750),
	Vector(-1417.056274, -862.558350, -139.968750),
	Vector(-1308.619873, -871.583496, -139.968750),
	Vector(-1190.508789, -874.034058, -139.968750),
	Vector(-1207.510742, -962.352173, -139.968750),
	Vector(-1228.218994, -1043.668091, -139.968750),
	Vector(-1301.048828, -1054.504028, -139.968750),
	Vector(-1349.578735, -976.021973, -139.968750)
}

local EventData = {
	["combine"] = {
		enabled = true,
		title = "Combine Invasion",
		text = {
			start = "The Combine are invading the city!",
			over = "The Combine have stopped invading the city!"
		},
		length = 360,
		enemies = {"npc_metropolice", "npc_combine_s"},
		chance = 60,
		music = "music/hl2_song20_submix0.mp3",
		spawns = DefaultSpawns
	},
	["zombie"] = {
		enabled = true,
		title = "Zombie Apocalypse",
		text = {
			start = "The dead are rising!",
			over = "The dead have stopped rising!"
		},
		length = 360,
		enemies = {"npc_zombie", "npc_fastzombie"},
		chance = 80,
		music = "music/ravenholm_1.mp3",
		spawns = DefaultSpawns
	}
}

function CreateEvent(name)
	local event = EventData[name]
	if type(event) ~= "table" or not event.enabled then return end
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) and v:IsPlayer() then
			v:SendLua("chat.AddText(Color(255, 0, 0), '" .. event.text.start .. "')")
			v:SendLua("surface.PlaySound('" .. event.music .. "')")
		end
	end
	local spawnedEnemies = {}
	for k, v in pairs(event.spawns) do
		if math.random(1, 100) <= event.chance then
			spawnedEnemies[#spawnedEnemies + 1] = ents.Create(event.enemies[math.random(1, #event.enemies)])
			spawnedEnemies[#spawnedEnemies]:SetPos(v)
			spawnedEnemies[#spawnedEnemies]:Spawn()
		end
	end
	timer.Simple(event.length, function()
		for k, v in pairs(player.GetAll()) do
			if IsValid(v) and v:IsPlayer() then
				v:SendLua("chat.AddText(Color(255, 0, 0), '" .. event.text.over .. "')")
			end
		end
	end)
end
