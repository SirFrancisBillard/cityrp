AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[------------------------------------------------------------------------------------

	THINGS YOU CAN EDIT

--]]------------------------------------------------------------------------------------
local recharge_time = 180 //Time between each recharge after using the dumpster
local prop_delete_time = 10 //Time of how long the props that shoot out will last
local minimum_amount_items = 1 //Least amount of items that can come from dumpster
local maximum_amount_items = 4 //Max amount of items that can come from dumpster
local open_sound = "physics/metal/metal_solid_strain5.wav" //Sound played when the dumpster is used

--Keep all of these numbers whole numbers between 1-100
local prop_percentage = 100 //When set to 100, if no entities or weapons were created, then a prop will be 
local ent_percentage = 15
local weapon_percentage = 5
--Keep all of these numbers whole numbers between 1-100

local Dumpster_Items = {
	Props = { --Add/Change models of props
		"models/props_c17/FurnitureShelf001b.mdl",
		"models/props_c17/FurnitureDrawer001a_Chunk02.mdl",
		"models/props_interiors/refrigeratorDoor02a.mdl",
		"models/props_lab/lockerdoorleft.mdl",
		"models/props_wasteland/prison_lamp001c.mdl",
		"models/props_wasteland/prison_shelf002a.mdl",
		"models/props_vehicles/tire001c_car.mdl",
		"models/props_trainstation/traincar_rack001.mdl",
		"models/props_interiors/SinkKitchen01a.mdl",
		"models/props_c17/lampShade001a.mdl", 
		"models/props_junk/PlasticCrate01a.mdl",
		"models/props_c17/metalladder002b.mdl",
		"models/Gibs/HGIBS.mdl",
		"models/props_c17/metalPot001a.mdl",
		"models/props_c17/streetsign002b.mdl",
		"models/props_c17/pottery06a.mdl",
		"models/props_combine/breenbust.mdl",
		"models/props_lab/partsbin01.mdl",
		"models/props_trainstation/payphone_reciever001a.mdl",
		"models/props_vehicles/carparts_door01a.mdl",
		"models/props_vehicles/carparts_axel01a.mdl"
	},
	
	Ents =  { --Change these to entites you want
		"ent_kevlar",
		"durgz_alcohol",
		"durgz_aspirin",
		"durgz_cigarette",
		"durgz_cocaine",
		"durgz_heroine",
		"durgz_lsd",
		"durgz_weed",
		"durgz_mushroom",
		"durgz_water",
		--"spawned_food"
	},
	
	Weapons = { --Change these to weapons that you want
		"swb_357",
		"swb_ak47",
		"swb_awp",
		"swb_deagle",
		"swb_famas",
		"swb_fiveseven",
		"swb_p90",
		"swb_g3sg1",
		"swb_glock18",
		"swb_mp5",
		"swb_ump",
		"swb_galil",
		"swb_knife",
		"swb_m249",
		"swb_m3super90",
		"swb_sg550",
		"swb_sg552",
		"swb_aug",
		"swb_tmp",
		"swb_xm1014",
		"swb_usp"
	}
}

local Spawn_Positions = { //The locations/angles of each dumpster
	["gm_construct"] = {
		{Vector(-4468, 4635, -71), Angle(0,-90,0)},
		{Vector(1821, -2261, -119), Angle(0, -180, 0)},
		{Vector(-2264, -3355, 281), Angle(0, -90, 0)},
		{Vector(-2562, -1968, -119), Angle(0, 90, 0)},
	},
	["sup_silenthill_b5"] = {
		{Vector(1043.263062, -188.059464 ,-290), Angle(0,-90,0)},
		{Vector( -280.393860, -190.447861, -290), Angle(0,90,0)},
		{Vector( 4012.294189 ,-31.494734, -290), Angle(0,0,0)},
		{Vector(  -6015.644531, -697.101624, -290), Angle(0,90,0)},
		{Vector( -4811.559570, 1470.255127, -290), Angle(0,180,0)},
		{Vector( -1013.002136, 3309.323975, -290), Angle(0,0,0)}
	},
	["gm_freespace_13"] = {
		{Vector(-3738.651855, 1317.182373, -14550.384766), Angle(0, 180, 0)},
		{Vector(-485.403259, -1509.116455, -14550.296875), Angle(0, 0, 0)},
		{Vector(-3685.121826, -1210.586914, -14550.321289), Angle(0, -90, 0)},
		{Vector(-751.450317, 330.556427, -14550.302734), Angle(0, -90, 0)},
		{Vector(8296.434570, -8354.421875, -15774.299805), Angle(0, -90, 0)},
		{Vector(-12773.526367, -13676.253906, -14849.374023), Angle(0, 0, 0)},
	},
	["rp_downtown_sup_b4"] = {
		{Vector(-2065.028564, -2604.949219, -170), Angle(0,0,0)},
		{Vector( -2926.534424, -3257.844238, -170), Angle(0, 90,0)},
		{Vector(-255.703934, 3242.291992, -170), Angle(0,90,0)},
		{Vector( 165.549973, 198.393555, -170), Angle(0,90,0)},
		{Vector( 2434.471680, -581.484985, -170), Angle(0,-90,0)},
	},
	["rp_swarg_swg"] = {
		{Vector(3005.745117, 3124.854980, 1185), Angle(0,-90,0)},
		{Vector( 1912.455566, 1968.263062, 1185), Angle(0, 90,0)},
		{Vector( 1428.473999, 7101.634277, 1185), Angle(0,-90,0)},
		{Vector( -1291.589233, 3631.979248, 1305), Angle(0,90,0)},
		{Vector(  776.681030, 6781.849121, 1185), Angle(0,-90,0)},
		{Vector( 2886.830811, 5415.509766, 1185), Angle(0,180,0)},
		{Vector( -882.622253, 5432.959473, 1305), Angle(0,-90,0)}
	},
	["rp_evildead_v7_a"] = {
		{Vector(5019.967285, 147.107407, 496), Angle(0,90,0)},
		{Vector(2837.843750, -1338.970337, 496), Angle(0,180,0)},
		{Vector(-926.194885, -314.009399, 240), Angle(0,0,0)},
		{Vector(1952.856445, 1073.990479, 240), Angle(0,0,0)},
		{Vector(-813.725403, 2594.270752, 224), Angle(0,90,0)},
		{Vector(-1783.434937, 4575.547363, 240), Angle(0,0,0)},
		{Vector( 502.183533, 6567.982422, 249), Angle(0,-90,0)},
		{Vector( 3246.807617, 2248.892578, 244), Angle(0,180,0)},
		{Vector( 4402.424805, -1861.911743, 5494), Angle(0,-90,0)},
		{Vector( 2231.231201, -155.293365, 224), Angle(0,180,0)}
	},
	["zm_downtown_night_v3"] = {
		{Vector(-2836.166992, -992.012146, -170), Angle(0,0,0)},
		{Vector(-50.300377, -1140.369385, -170), Angle(0,-90,0)},
		{Vector( 944.861877, 1769.429443, -170), Angle(0,0,0)},
		{Vector( 1616.231079, 615.020630, -170), Angle(0,180,0)},
		{Vector( -951.004395, 2065.097412, -170), Angle(0,-25,0)},
		{Vector(-2109.381592, -592.016479, -170), Angle(0,180,0)}
	}
}
--[[------------------------------------------------------------------------------------

	THINGS YOU CAN EDIT

--]]------------------------------------------------------------------------------------

function ENT:Initialize()
	self:SetModel("models/props_junk/TrashDumpster01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:OnTakeDamage(dmginfo)
	return
end

function ENT:EmitItems(searcher)
	self:EmitSound(open_sound, 300, 100)
	local pos = self:GetPos() + ((self:GetAngles():Up() * 15) + (self:GetAngles():Forward() * 20))
	
	for i = 1, math.random(minimum_amount_items,maximum_amount_items) do
		if math.random(1, 100) <= weapon_percentage then
			local ent = ents.Create(table.Random(Dumpster_Items["Weapons"]))
			ent:SetPos(pos)
			ent:Spawn()
		elseif math.random(1, 100) <= ent_percentage then
			local ent = ents.Create(table.Random(Dumpster_Items["Ents"]))
			ent:SetPos(pos)
			ent:Spawn()
		elseif math.random(1, 100) <= prop_percentage then
			local prop = ents.Create("prop_physics_multiplayer")
			prop:SetModel(table.Random(Dumpster_Items["Props"]))
			prop:SetPos(pos)
			prop:Spawn()
			
			timer.Simple(prop_delete_time, function() -- Remove the prop after x seconds
				if prop:IsValid() then
					prop:Remove()
				end
			end)
		end
	end
end

function ENT:Use(activator)
	if self:GetDTInt(0) > CurTime() then return end

	self:SetDTInt(0, CurTime() + recharge_time)
	self:EmitItems(activator)
end

hook.Add("InitPostEntity", "SpawnDumpsters", function()
	timer.Simple(2, function()
		for k,v in pairs(Spawn_Positions[game.GetMap()] or {}) do
			local dump = ents.Create("dumpster")
			dump:SetPos(v[1])
			dump:SetAngles(v[2])
			dump:Spawn()
		end
	end)
end)