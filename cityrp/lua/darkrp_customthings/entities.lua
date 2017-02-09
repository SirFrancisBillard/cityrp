
local m_Max = 4

local function EasyEntity(cls, cost, com, cat, who)
	if type(scripted_ents.Get(cls)) ~= "table" then
		ErrorNoHalt("[DarkRP] Entity class " .. cls .. " is invalid!")
		return
	end
	if who == nil then
		DarkRP.createEntity(scripted_ents.Get(cls).PrintName or "ERROR NAME", {
			ent = cls,
			model = scripted_ents.Get(cls).Model or "models/props_junk/watermelon01.mdl",
			price = cost,
			max = m_Max,
			cmd = "buy" .. com,
			category = cat,
		})
	else
		DarkRP.createEntity(scripted_ents.Get(cls).PrintName or "ERROR NAME", {
			ent = cls,
			model = scripted_ents.Get(cls).Model or "models/props_junk/watermelon01.mdl",
			price = cost,
			max = m_Max,
			cmd = "buy" .. com,
			allowed = who,
			category = cat,
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

local function DoEntities()

EasyEntity("zig_printer_topaz", 2500, "topazprinter", "Printers")
EasyEntity("zig_printer_amethyst", 5000, "amethystprinter", "Printers")
EasyEntity("zig_printer_emerald", 7500, "emeraldprinter", "Printers")
EasyEntity("zig_printer_ruby", 10000, "rubyprinter", "Printers")
EasyEntity("zig_printer_sapphire", 12500, "sapphireprinter", "Printers")
EasyEntity("zig_printer_diamond", 15000, "diamondprinter", "Printers")

EasyEntity("zig_battery", 2000, "battery", "Printer Accessories")
EasyEntity("zig_ink", 1000, "ink", "Printer Accessories")

m_Max = 1

EasyEntity("cityrp_spraycan", 12, "spraycan", "Other")
EasyEntity("cityrp_battery", 24, "flashlightbattery", "Other")
EasyEntity("cityrp_radio", 1200, "radio", "Other")

m_Max = 4

EasyEntity("ent_bleach", 600, "bleach", "Other")

EasyEntity("ent_kevlar", 12000, "kevlar", "Black Market", TEAM_BLACKMARKET)

end

if g_DarkRPExtraEntitiesRefreshed ~= nil then
	DoEntities()
else
	hook.Add("InitPostEntity", "RegisterMoreDarkRPEntities", DoEntities)
	g_DarkRPExtraEntitiesRefreshed = true
end
