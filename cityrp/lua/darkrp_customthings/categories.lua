
local function EasyCategory(kind, nm, clr)
	DarkRP.createCategory{
		name = nm,
		categorises = kind,
		startExpanded = true,
		color = clr,
		canSee = function(ply) return true end,
		sortOrder = 100,
	}
end

--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
http://wiki.darkrp.com/index.php/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]

EasyCategory("jobs", "Citizens", Color(0, 255, 0))
EasyCategory("jobs", "Killers", Color(255, 0, 0))
EasyCategory("jobs", "Criminals", Color(75, 75, 75))
EasyCategory("jobs", "Salesmen", Color(30, 190, 120))
EasyCategory("jobs", "Police", Color(0, 0, 255))
EasyCategory("jobs", "Homeless", Color(100, 60, 20))
EasyCategory("jobs", "Special", Color(255, 0, 255))

EasyCategory("entities", "Printers", Color(0, 107, 0))
EasyCategory("entities", "Printer Accessories", Color(0, 107, 0))
EasyCategory("entities", "Black Market", Color(0, 107, 0))
EasyCategory("entities", "Government Issue Supplies", Color(0, 107, 0))

EasyCategory("entities", "Drugs", Color(0, 107, 0))
EasyCategory("entities", "Medical", Color(0, 107, 0))
EasyCategory("entities", "Beverages", Color(0, 107, 0))

EasyCategory("shipments", "Drugs", Color(0, 107, 0))
EasyCategory("shipments", "Medical", Color(0, 107, 0))
EasyCategory("shipments", "Beverages", Color(0, 107, 0))
EasyCategory("shipments", "Pistols", Color(0, 107, 0))
EasyCategory("shipments", "Submachine Guns", Color(0, 107, 0))
EasyCategory("shipments", "Machine Guns", Color(0, 107, 0))
EasyCategory("shipments", "Assault Rifles", Color(0, 107, 0))
EasyCategory("shipments", "Sniper Rifles", Color(0, 107, 0))
EasyCategory("shipments", "Black Market", Color(0, 107, 0))
EasyCategory("shipments", "Government Issue Supplies", Color(0, 107, 0))
EasyCategory("shipments", "Vapes", Color(0, 107, 0))
EasyCategory("shipments", "Badass Weapons", Color(0, 107, 0))
