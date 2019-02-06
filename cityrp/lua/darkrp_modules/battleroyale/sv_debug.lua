
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
		{pos = Vector(3762, -4681, -130), ang = Angle(0, -135, 0)},
		{pos = Vector(2758, -4583, -130), ang = Angle(0, -90, 0)},
		{pos = Vector(1645, -4788, -130), ang = Angle(0, -45, 0)},
		{pos = Vector(1503, -5716, -130), ang = Angle(0, 0, 0)},
		{pos = Vector(1553, -6641, -130), ang = Angle(0, 30, 0)},
		{pos = Vector(2410, -7162, -130), ang = Angle(0, 75, 0)},
		{pos = Vector(3442, -7060, -130), ang = Angle(0, 125, 0)},
		{pos = Vector(3638, -6098, -130), ang = Angle(0, 180, 0)}
	}
}

local PermaEnts = {
	{class = "prop_physics", mdl = "models/props_c17/furniturefridge001a.mdl", pos = Vector(2144, -5177, -162), ang = Angle(0, 121, 0)},
	{class = "prop_physics", mdl = "models/props_c17/oildrum001.mdl", pos = Vector(2749, -6060, -199), ang = Angle(0, -54, 0)},
	{class = "prop_physics", mdl = "models/props_c17/oildrum001.mdl", pos = Vector(2812, -6065, -185), ang = Angle(-55, 102, -90)},
	{class = "prop_physics", mdl = "models/props_c17/oildrum001.mdl", pos = Vector(2772, -6044, -199), ang = Angle(0, -55, 0)},
	{class = "prop_physics", mdl = "models/props_c17/oildrum001_explosive.mdl", pos = Vector(2745, -6032, -199), ang = Angle(0, 29, 0)},
	{class = "prop_physics", mdl = "models/props_wasteland/laundry_dryer002.mdl", pos = Vector(2731, -5661, -145), ang = Angle(0, 42, 0)},
	{class = "prop_physics", mdl = "models/props_wasteland/horizontalcoolingtank04.mdl", pos = Vector(2578, -6490, -138), ang = Angle(0, 7, 0)},
	{class = "prop_vehicle_jeep", mdl = "models/buggy.mdl", pos = Vector(3165, -5521, -197), ang = Angle(0, -151, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2332, -5602, -199), ang = Angle(0, 157, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2454, -5896, -199), ang = Angle(0, 121, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2263, -5831, -199), ang = Angle(0, 121, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2027, -5704, -164), ang = Angle(0, 16, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2029, -5726, -189), ang = Angle(0, 71, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2027, -5679, -188), ang = Angle(0, 16, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(3023, -4893, -199), ang = Angle(0, 120, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2204, -5114, -199), ang = Angle(0, 101, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(1493, -5978, -199), ang = Angle(0, 74, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(1870, -6439, -199), ang = Angle(0, 126, 0)},
	{class = "battleroyale_loot", mdl = "models/items/item_item_crate.mdl", pos = Vector(2740, -6452, -199), ang = Angle(0, -60, 0)},
}

gBattleRoyaleCleanupEnts = {}

BattleRoyale = BattleRoyale or {}

BattleRoyale.Start = function()
	local MapTable = SpawnPoints[game.GetMap()]
	if not MapTable then return end

	local PlayersSpawned = 1
	for k, v in RandomPairs(player.GetAll()) do
		if PlayersSpawned > #MapTable or (v:IsBRStatus(BR_STATUS_NONE) and not v:IsBot()) then continue end
		v:InitBR()
		v:SetPos(MapTable[PlayersSpawned].pos)
		v:SetEyeAngles(MapTable[PlayersSpawned].ang)
		PlayersSpawned = PlayersSpawned + 1
	end

	for _, v in ipairs(gBattleRoyaleCleanupEnts) do
		if IsValid(v) then
			SafeRemoveEntity(v)
		end
	end

	gBattleRoyaleCleanupEnts = {}

	for _, v in ipairs(PermaEnts) do
		local new = ents.Create(v.class)
		new:SetPos(v.pos)
		new:SetAngles(v.ang)
		new:SetModel(v.mdl)
		new:Spawn()
		table.insert(gBattleRoyaleCleanupEnts, new)
	end
end

BattleRoyale.End = function() end

concommand.Add("br_debugstart", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	BattleRoyale.Start()
end)
