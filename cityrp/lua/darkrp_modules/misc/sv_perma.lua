
-- entity permanence #NoSimplerr#

local dir = "permanent_ents"
file.CreateDir(dir)

local PermEnts = {}

local function SaveToFile(tab)
	local path = dir .. "/" .. game.GetMap() .. ".txt"
	file.Write(path, util.TableToJSON(tab))
end

local function GetStored()
	local path = dir .. "/" .. game.GetMap() .. ".txt"
	if not file.Exists(path, "DATA") then return {} end

	local data = file.Read(path)
	if not data then return {} end

	local tab = util.JSONToTable(data)
	if not tab then return {} end

	return tab
end

local function AddPermanentEntity(ent)
	if not IsValid(ent) or ent:IsPlayer() or ent:IsWorld() then return end

	local tab = GetStored()
	if not tab then return end

	local fr = false
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) and not phys:IsMotionEnabled() then
		fr = true
	end

	ent.PermID = math.random(999999999)

	table.insert(PermEnts, ent)

	table.insert(tab, {class = ent:GetClass(), model = ent:GetModel(), pos = ent:GetPos(), ang = ent:GetAngles(), frozen = fr, id = ent.PermID})

	SaveToFile(tab)
end

local function RemovePermanentEntity(ent)
	if not IsValid(ent) or ent:IsPlayer() or ent:IsWorld() then return end

	local tab = GetStored()
	if not tab then return end

	for k, v in pairs(tab) do -- Brion
		if v.id == ent.PermID then
			tab[k] = nil
			SaveToFile(tab)
			SafeRemoveEntity(ent)
			return
		end
	end
end

local function ClearPermanentEntities()
	for k, v in pairs(PermEnts) do
		if IsValid(v) then
			SafeRemoveEntity(v)
		end
	end
	PermEnts = {}
end

local function SpawnPermanentEntities()
	for k, v in pairs(GetStored()) do
		local ent = ents.Create(v.class)
		ent:SetModel(v.model)
		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(not v.frozen)
		end

		ent.PermID = v.id

		table.insert(PermEnts, ent)
	end
end

local function ResetPermanentEntities()
	ClearPermanentEntities()
	SpawnPermanentEntities()
end

concommand.Add("perment_add", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	local tr = ply:GetEyeTrace()
	local ent = tr.Entity

	AddPermanentEntity(ent)
end)

concommand.Add("perment_remove", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	local tr = ply:GetEyeTrace()
	local ent = tr.Entity

	RemovePermanentEntity(ent)
end)

concommand.Add("perment_reload", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	ResetPermanentEntities()
end)

concommand.Add("perment_killall", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	ClearPermanentEntities()
end)
