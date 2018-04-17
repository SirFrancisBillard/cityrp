
gDarkRPCustomEntList = gDarkRPCustomEntList or {}

local function WeaponShipment(who, cat, wep, amt)
	gDarkRPCustomEntList[wep] = true
	DarkRP.createShipment(g_DarkRPEntData[wep] and g_DarkRPEntData[wep].PrintName or "ERROR NAME", {
		model = g_DarkRPEntData[wep] and g_DarkRPEntData[wep].Model or "models/props_junk/watermelon01.mdl",
		entity = wep,
		price = amt * 10,
		amount = 10,
		separate = true,
		pricesep = amt,
		noship = false,
		allowed = who,
		category = cat
	})
end

local function EntityShipment(who, cat, what, com, amt)
	gDarkRPCustomEntList[what] = true
	DarkRP.createShipment(g_DarkRPEntData[what] and g_DarkRPEntData[what].PrintName or "ERROR NAME", {
		model = g_DarkRPEntData[what] and g_DarkRPEntData[what].Model,
		entity = what,
		price = amt * 10,
		amount = 10,
		separate = false,
		pricesep = nil,
		noship = false,
		allowed = who,
		category = cat
	})
	DarkRP.createEntity(g_DarkRPEntData[what].PrintName or "ERROR NAME", {
		ent = what,
		model = g_DarkRPEntData[what] and g_DarkRPEntData[what].Model,
		price = amt,
		max = 4,
		cmd = "buy" .. com,
		allowed = who,
		category = cat
	})
end

--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]

WeaponShipment(nil, "Pistols", "lite_glock", 600)
WeaponShipment(nil, "Pistols", "lite_dualberettas", 800)
WeaponShipment(nil, "Pistols", "lite_deagle", 1000)
WeaponShipment(nil, "Pistols", "lite_fiveseven", 800)
WeaponShipment(nil, "Pistols", "lite_p228", 600)

WeaponShipment(TEAM_GUN, "Shotguns", "lite_m3", 5000)
WeaponShipment(TEAM_GUN, "Shotguns", "lite_xm1014", 8000)

WeaponShipment(TEAM_GUN, "Submachine Guns", "lite_tmp", 4000)
WeaponShipment(TEAM_GUN, "Submachine Guns", "lite_mp5", 3000)
WeaponShipment(TEAM_GUN, "Submachine Guns", "lite_ump", 3000)
WeaponShipment(TEAM_GUN, "Submachine Guns", "lite_mac10", 2000)
WeaponShipment(TEAM_GUN, "Submachine Guns", "lite_p90", 4000)

WeaponShipment(TEAM_GUN, "Assault Rifles", "lite_ak47", 7000)
WeaponShipment(TEAM_GUN, "Assault Rifles", "lite_m4a1", 7000)
WeaponShipment(TEAM_GUN, "Assault Rifles", "lite_galil", 5000)
WeaponShipment(TEAM_GUN, "Assault Rifles", "lite_famas", 5000)
WeaponShipment(TEAM_GUN, "Assault Rifles", "lite_sg552", 6000)
WeaponShipment(TEAM_GUN, "Assault Rifles", "lite_aug", 6000)

WeaponShipment(TEAM_GUN, "Sniper Rifles", "lite_scout", 8000)
WeaponShipment(TEAM_GUN, "Sniper Rifles", "lite_awp", 10000)
WeaponShipment(TEAM_GUN, "Sniper Rifles", "lite_g3sg1", 9000)
WeaponShipment(TEAM_GUN, "Sniper Rifles", "lite_sg550", 9000)

WeaponShipment(TEAM_GUN, "Machine Guns", "lite_m249", 10000)

WeaponShipment(nil, "Grenades", "lite_hegrenade", 1200)
WeaponShipment(nil, "Grenades", "lite_flashbang", 1600)
WeaponShipment(nil, "Grenades", "lite_smokegrenade", 2000)

WeaponShipment(nil, "Black Market", "weapon_molotov", 400)
WeaponShipment(TEAM_BLACKMARKET, "Black Market", "lockpick", 1600)
WeaponShipment(TEAM_BLACKMARKET, "Black Market", "keypad_cracker", 2400)
WeaponShipment({TEAM_BLACKMARKET, TEAM_DOCTOR}, "Black Market", "med_kit", 2000)
WeaponShipment(TEAM_BLACKMARKET, "Black Market", "unarrest_stick", 4200)
WeaponShipment(TEAM_BLACKMARKET, "Black Market", "weapon_zipties", 5400)

WeaponShipment(nil, "Explosives", "weapon_grenadelauncher", 12000)
WeaponShipment(nil, "Explosives", "weapon_c4", 14000)
WeaponShipment(nil, "Explosives", "weapon_rocketlauncher", 16000)
WeaponShipment(nil, "Explosives", "weapon_remotemine", 18000)
WeaponShipment(nil, "Explosives", "weapon_stickylauncher", 20000)
WeaponShipment(nil, "Explosives", "weapon_jihad", 25000)

WeaponShipment(nil, "Toys", "weapon_bbgun", 1000)

EntityShipment(nil, "Chemicals", "ent_bleach", "bleach", 400)
EntityShipment(nil, "Chemicals", "ent_volatile", "volatilewaste", 800)

--[[

EntityShipment(TEAM_BAR, "Beverages", "durgz_alcohol", "alcohol", 400)
EntityShipment(TEAM_BAR, "Beverages", "durgz_water", "water", 200)

EntityShipment(TEAM_DRUG, "Drugs", "durgz_weed", "weed", 800)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_mushroom", "mushrooms", 1000)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_meth", "meth", 1200)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_lsd", "lsd", 1400)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_pcp", "pcp", 1600)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_heroine", "heroin", 1800)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_cocaine", "cocaine", 2000)

--]]
