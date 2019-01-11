
concommand.Add("br_gettracepos", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	local tr = ply:GetEyeTrace()
	local ent = tr.Entity

	if IsValid(ent) then
		local pos = ent:GetPos()
		local ang = ent:GetAngles()
		print(string.format("{class = \"%s\", mdl = \"%s\", pos = Vector(%i, %i, %i), ang = Angle(%i, %i, %i)},", ent:GetClass(), ent:GetModel(), pos.x, pos.y, pos.z, ang.p, ang.y, ang.r))
	end
end)

local SpawnPoints = {
	["rp_downtown_v4c_v2"] = {
		{pos = Vector(3762.098389, -4681.362305, -134.968750), ang = Angle(2.359634, -134.699875, 0)},
		{pos = Vector(2758.201172, -4583.227539, -134.968750), ang = Angle(0.302634, -90.837486, 0)},
		{pos = Vector(1645.156494, -4788.036133, -134.968750), ang = Angle(-0.907367, -49.757748, 0)},
		{pos = Vector(1503.023315, -5716.068848, -134.968750), ang = Angle(-0.604868, -2.991198, 0)},
		{pos = Vector(1553.342407, -6641.727051, -134.968750), ang = Angle(-2.238368, 31.493793, 0)},
		{pos = Vector(2410.653564, -7162.333496, -134.462219), ang = Angle(-2.359373, 74.932732, 0)},
		{pos = Vector(3442.490723, -7060.241211, -134.539978), ang = Angle(-0.302375, 126.115860, 0)},
		{pos = Vector(3638.252686, -6098.387695, -134.968750), ang = Angle(2.904099, 175.181091, 0)}
	}
}

local PermaEnts = {
	{class = "prop_physics", mdl = "models/props_c17/furniturefridge001a.mdl", pos = Vector(2144, -5177, -162), ang = Angle(0, 121, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2332, -5602, -199), ang = Angle(0, 157, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2454, -5896, -199), ang = Angle(0, 121, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2263, -5831, -199), ang = Angle(0, 121, 0)},
}

gBattleRoyaleCleanupEnts = {}

concommand.Add("br_debugstart", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	local MapTable = SpawnPoints[game.GetMap()]
	if not MapTable then return end

	local PlayersSpawned = 1
	for k, v in pairs(player.GetAll()) do
		if PlayersSpawned > #MapTable then continue end
		v:InitBR()
		v:SetPos(MapTable[PlayersSpawned].pos)
		v:SetEyeAngles(MapTable[PlayersSpawned].ang)
		PlayersSpawned = PlayersSpawned + 1
	end

	-- delete all our old shit
	for k, v in pairs(gBattleRoyaleCleanupEnts) do
		if IsValid(v) then
			SafeRemoveEntity(v)
		end
	end

	-- reset the table just in case
	gBattleRoyaleCleanupEnts = {}

	for k, v in pairs(PermaEnts) do
		local new = ents.Create(v.class)
		new:SetPos(v.pos)
		new:SetAngles(v.ang)
		new:SetModel(v.mdl)
		new:Spawn()
		table.insert(gBattleRoyaleCleanupEnts, new)
	end
end)
