
local function WeaponShipment(who, cat, wep, amt)
	DarkRP.createShipment(g_DarkRPEntData[wep].PrintName or "ERROR NAME", {
		model = g_DarkRPEntData[wep].Model or "models/props_junk/watermelon01.mdl",
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
	DarkRP.createShipment(g_DarkRPEntData[what].PrintName or "ERROR NAME", {
		model = g_DarkRPEntData[what].Model,
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
		model = g_DarkRPEntData[what].Model,
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

WeaponShipment(TEAM_GUN, "Pistols", "swb_glock18", 600)
WeaponShipment(TEAM_GUN, "Pistols", "swb_357", 800)
WeaponShipment(TEAM_GUN, "Pistols", "swb_deagle", 1000)
WeaponShipment(TEAM_GUN, "Pistols", "swb_fiveseven", 800)
WeaponShipment(TEAM_GUN, "Pistols", "swb_p228", 600)

WeaponShipment(TEAM_GUN, "Shotguns", "swb_m3super90", 50000)
WeaponShipment(TEAM_GUN, "Shotguns", "swb_xm1014", 12000)

WeaponShipment(TEAM_GUN, "Submachine Guns", "swb_tmp", 8000)
WeaponShipment(TEAM_GUN, "Submachine Guns", "swb_mp5", 6000)
WeaponShipment(TEAM_GUN, "Submachine Guns", "swb_ump", 6000)
WeaponShipment(TEAM_GUN, "Submachine Guns", "swb_mac10", 4000)
WeaponShipment(TEAM_GUN, "Submachine Guns", "swb_p90", 8000)

WeaponShipment(TEAM_GUN, "Assault Rifles", "swb_ak47", 12000)
WeaponShipment(TEAM_GUN, "Assault Rifles", "swb_m4a1", 12000)
WeaponShipment(TEAM_GUN, "Assault Rifles", "swb_galil", 10500)
WeaponShipment(TEAM_GUN, "Assault Rifles", "swb_famas", 10500)
WeaponShipment(TEAM_GUN, "Assault Rifles", "swb_sg552", 12500)
WeaponShipment(TEAM_GUN, "Assault Rifles", "swb_aug", 12500)

WeaponShipment(TEAM_GUN, "Sniper Rifles", "swb_scout", 20000)
WeaponShipment(TEAM_GUN, "Sniper Rifles", "swb_awp", 50000)
WeaponShipment(TEAM_GUN, "Sniper Rifles", "swb_g3sg1", 30000)
WeaponShipment(TEAM_GUN, "Sniper Rifles", "swb_sg550", 30000)

WeaponShipment(TEAM_GUN, "Machine Guns", "swb_m249", 30000)

WeaponShipment(TEAM_BLACKMARKET, "Black Market", "lockpick", 4200)
WeaponShipment(TEAM_BLACKMARKET, "Black Market", "keypad_cracker", 2400)
WeaponShipment({TEAM_BLACKMARKET, TEAM_DOCTOR}, "Black Market", "med_kit", 3600)
WeaponShipment(TEAM_BLACKMARKET, "Black Market", "unarrest_stick", 9800)
WeaponShipment(TEAM_BLACKMARKET, "Black Market", "weapon_c4", 12000)

WeaponShipment(TEAM_VAPE, "Vapes", "weapon_vape", 1000)
WeaponShipment(TEAM_VAPE, "Vapes", "weapon_vape_juicy", 5000)
WeaponShipment(TEAM_VAPE, "Vapes", "weapon_vape_american", 7500)
WeaponShipment(TEAM_VAPE, "Vapes", "weapon_vape_medicinal", 10000)
WeaponShipment(TEAM_VAPE, "Vapes", "weapon_vape_mega", 1000000)

WeaponShipment(nil, "Toys", "weapon_bbgun", 1000)

EntityShipment(TEAM_DOCTOR, "Medical", "durgz_aspirin", "aspirin", 1200)
EntityShipment(TEAM_DOCTOR, "Medical", "ent_medkit", "medicalkit", 1000)

EntityShipment(TEAM_BAR, "Beverages", "durgz_alcohol", "alcohol", 400)
EntityShipment(TEAM_BAR, "Beverages", "durgz_water", "water", 200)

EntityShipment(TEAM_DRUG, "Drugs", "durgz_weed", "weed", 800)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_mushroom", "mushrooms", 1000)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_meth", "meth", 1200)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_lsd", "lsd", 1400)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_pcp", "pcp", 1600)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_heroine", "heroin", 1800)
EntityShipment(TEAM_DRUG, "Drugs", "durgz_cocaine", "cocaine", 2000)
