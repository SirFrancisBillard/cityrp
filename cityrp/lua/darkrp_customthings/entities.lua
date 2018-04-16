
gDarkRPCustomEntList = gDarkRPCustomEntList or {}

local m_Max = 4

local function EasyEntity(cls, cost, com, cat, who)
	gDarkRPCustomEntList[cls] = true
	if who == nil then
		DarkRP.createEntity(g_DarkRPEntData[cls] and g_DarkRPEntData[cls].PrintName or "ERROR NAME", {
			ent = cls,
			model = g_DarkRPEntData[cls] and g_DarkRPEntData[cls].Model or "models/props_junk/watermelon01.mdl",
			price = cost,
			max = m_Max,
			cmd = "buy" .. com,
			category = cat
		})
	else
		DarkRP.createEntity(g_DarkRPEntData[cls] and g_DarkRPEntData[cls].PrintName or "ERROR NAME", {
			ent = cls,
			model = g_DarkRPEntData[cls] and g_DarkRPEntData[cls].Model or "models/props_junk/watermelon01.mdl",
			price = cost,
			max = m_Max,
			cmd = "buy" .. com,
			allowed = who,
			category = cat
		})
	end
end

--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

EasyEntity("zig_printer_topaz", 2500, "topazprinter", "Printers")
EasyEntity("zig_printer_amethyst", 5000, "amethystprinter", "Printers")
EasyEntity("zig_printer_emerald", 7500, "emeraldprinter", "Printers")
EasyEntity("zig_printer_ruby", 10000, "rubyprinter", "Printers")
EasyEntity("zig_printer_sapphire", 12500, "sapphireprinter", "Printers")
EasyEntity("zig_printer_diamond", 15000, "diamondprinter", "Printers")

EasyEntity("zig_battery", 2000, "battery", "Printer Accessories")
EasyEntity("zig_ink", 1000, "ink", "Printer Accessories")

EasyEntity("rp_oil_miner", 5000, "oilminer", "Oil Mining")
EasyEntity("rp_oil_miner_pro", 10000, "oilminerpro", "Oil Mining")
EasyEntity("rp_oil_refinery", 8000, "oilrefinery", "Oil Mining")

EasyEntity("rp_keg", 2500, "keg", "Alcohol Distilling")
EasyEntity("rp_banana", 600, "banana", "Alcohol Distilling")
EasyEntity("rp_potato", 800, "potato", "Alcohol Distilling")
EasyEntity("rp_orange", 200, "orange", "Alcohol Distilling")
EasyEntity("rp_melon", 400, "melon", "Alcohol Distilling")

EasyEntity("rp_stove", 6000, "stove", "Meth Cooking")
EasyEntity("rp_gas", 800, "gas", "Meth Cooking")
EasyEntity("rp_sodium", 600, "sodium", "Meth Cooking")
EasyEntity("rp_chloride", 600, "chloride", "Meth Cooking")
EasyEntity("rp_pot", 2000, "pot", "Meth Cooking")

EasyEntity("rp_coca", 4000, "cocaplant", "Cocaine Making")
EasyEntity("rp_barrel", 2000, "barrel", "Cocaine Making")
EasyEntity("rp_caustic", 800, "caustic", "Cocaine Making")

EasyEntity("book_bible", 2000, "bible", "Holy Books")
EasyEntity("book_torah", 3000, "torah", "Holy Books")
EasyEntity("book_quran", 4000, "quran", "Holy Books")

EasyEntity("ent_kevlar", 12000, "kevlar", "Black Market")

EasyEntity("ent_medkit", 2000, "medkit", "Medical")
EasyEntity("ent_painkillers", 1600, "painkillers", "Medical")
EasyEntity("ent_stdmeds", 400, "stdmeds", "Medical")
EasyEntity("ent_steroids", 6000, "steroids", "Medical")

EasyEntity("ent_water", 100, "water", "Beverages")
EasyEntity("ent_beer", 200, "beer", "Beverages")
