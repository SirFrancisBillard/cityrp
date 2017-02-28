
local m_Max = 4

local function EasyEntity(cls, cost, com, cat, who)
	if who == nil then
		DarkRP.createEntity(g_DarkRPEntData[cls].PrintName or "ERROR NAME", {
			ent = cls,
			model = g_DarkRPEntData[cls].Model or "models/props_junk/watermelon01.mdl",
			price = cost,
			max = m_Max,
			cmd = "buy" .. com,
			category = cat
		})
	else
		DarkRP.createEntity(g_DarkRPEntData[cls].PrintName or "ERROR NAME", {
			ent = cls,
			model = g_DarkRPEntData[cls].Model or "models/props_junk/watermelon01.mdl",
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

EasyEntity("ent_bleach", 600, "bleach", "Other")
EasyEntity("ent_kevlar", 12000, "kevlar", "Black Market", TEAM_BLACKMARKET)
