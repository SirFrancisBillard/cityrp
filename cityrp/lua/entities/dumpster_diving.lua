AddCSLuaFile()

DUMPSTER_DIVING_ENTITIES = {
	["dd_dumpster"] = {Base = "dumpster_diving_base", Spawnable = true, PrintName = "Dumpster", Model = "models/props_junk/TrashDumpster01a.mdl", Size = 3, Category = "Dumpster Diving"},
	["dd_trash_can"] = {Base = "dumpster_diving_base", Spawnable = true, PrintName = "Trash Can", Model = "models/props_trainstation/trashcan_indoor001a.mdl", Size = 4, Category = "Dumpster Diving"},
	["dd_recycling_bin"] = {Base = "dumpster_diving_base", Spawnable = true, PrintName = "Recycling Bin", Model = "models/props_junk/TrashBin01a.mdl", Size = 3, Category = "Dumpster Diving"},
	["dd_small_box"] = {Base = "dumpster_diving_base", Spawnable = true, PrintName = "Small Box", Model = "models/props_junk/cardboard_box004a.mdl", Size = 1, Category = "Dumpster Diving"},
	["dd_large_box"] = {Base = "dumpster_diving_base", Spawnable = true, PrintName = "Large Box", Model = "models/props_junk/cardboard_box003a.mdl", Size = 1, Category = "Dumpster Diving"},
}

print("[DD] Registering dumpster diving entities...")

for k, v in SortedPairs(DUMPSTER_DIVING_ENTITIES) do
	DEFINE_BASECLASS("dumpster_diving_base")
	scripted_ents.Register(v, k)
	print("[DD] Registered entity: "..k)
end

print("[DD] Dumpster diving entities registered!")