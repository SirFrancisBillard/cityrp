
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

Note: If you want to edit a default DarkRP entity, first disable it in darkent_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

EasyEntity("zig_printer_topaz", 25000, "topazprinter", "Printers")
EasyEntity("zig_printer_amethyst", 50000, "amethystprinter", "Printers")
EasyEntity("zig_printer_emerald", 75000, "emeraldprinter", "Printers")
EasyEntity("zig_printer_ruby", 100000, "rubyprinter", "Printers")
EasyEntity("zig_printer_sapphire", 125000, "sapphireprinter", "Printers")
EasyEntity("zig_printer_diamond", 150000, "diamondprinter", "Printers")

EasyEntity("zig_battery", 2000, "battery", "Printer Accessories")
EasyEntity("zig_ink", 1000, "ink", "Printer Accessories")

EasyEntity("ent_oilminer", 5000, "oilminer", "Oil Mining")
EasyEntity("ent_oilminerpro", 10000, "oilminerpro", "Oil Mining")
EasyEntity("ent_oilrefinery", 8000, "oilrefinery", "Oil Mining")

EasyEntity("ent_keg", 800, "keg", "Alcohol Distilling")
EasyEntity("ent_banana", 30, "banana", "Alcohol Distilling")
EasyEntity("ent_potato", 40, "potato", "Alcohol Distilling")
EasyEntity("ent_orange", 10, "orange", "Alcohol Distilling")
EasyEntity("ent_melon", 20, "melon", "Alcohol Distilling")

EasyEntity("ent_stove", 6000, "stove", "Meth Cooking")
EasyEntity("ent_gas", 800, "gas", "Meth Cooking")
EasyEntity("ent_sodium", 600, "sodium", "Meth Cooking")
EasyEntity("ent_chloride", 600, "chloride", "Meth Cooking")
EasyEntity("ent_pot", 2000, "pot", "Meth Cooking")

EasyEntity("ent_coca", 4000, "cocaplant", "Cocaine Making")
EasyEntity("ent_barrel", 2000, "barrel", "Cocaine Making")
EasyEntity("ent_caustic", 800, "caustic", "Cocaine Making")

EasyEntity("book_bible", 2000, "bible", "Holy Books")
EasyEntity("book_torah", 3000, "torah", "Holy Books")
EasyEntity("book_quran", 4000, "quran", "Holy Books")

EasyEntity("ent_kevlar", 8000, "kevlar", "Black Market")
EasyEntity("ent_injection", 12000, "injection", "Black Market")

EasyEntity("ent_medkit", 2000, "medkit", "Medical")
EasyEntity("ent_painkillers", 1600, "painkillers", "Medical")
EasyEntity("ent_stdmeds", 400, "stdmeds", "Medical")
EasyEntity("ent_steroids", 6000, "steroids", "Medical")
EasyEntity("ent_stabilizer", 1200, "stabilizer", "Medical")

EasyEntity("ent_water", 100, "water", "Beverages")
EasyEntity("ent_beer", 200, "beer", "Beverages")
EasyEntity("ent_moonshine", 600, "moonshine", "Beverages")
EasyEntity("ent_pruno", 400, "pruno", "Beverages")
EasyEntity("ent_vodka", 1000, "vodka", "Beverages")
EasyEntity("ent_rum", 600, "rum", "Beverages")
EasyEntity("ent_milk", 400, "milk", "Beverages")

EasyEntity("ent_fertilizer", 1200, "fertilizer", "Drug Growing")
EasyEntity("ent_growthlamp", 1200, "growthlamp", "Drug Growing")

EasyEntity("ent_ied", 12500, "ied", "Bombs")
