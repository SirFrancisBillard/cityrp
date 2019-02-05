
local function EasyCategory(kind, nm, clr, sort_order_override)
	DarkRP.createCategory{
		name = nm,
		categorises = kind,
		startExpanded = true,
		color = clr,
		canSee = function(ply) return true end,
		sortOrder = sort_order_override or 100,
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

local DefaultCategoryColor = Color(0, 107, 0)

EasyCategory("jobs", "Citizens", Color(0, 255, 0))
EasyCategory("jobs", "Killers", Color(255, 0, 0))
EasyCategory("jobs", "Criminals", Color(75, 75, 75))
EasyCategory("jobs", "Merchants", Color(30, 190, 120))
EasyCategory("jobs", "Government", Color(0, 0, 255))
EasyCategory("jobs", "Homeless", Color(100, 60, 20))
EasyCategory("jobs", "Special", Color(255, 0, 255))

EasyCategory("entities", "Printers", DefaultCategoryColor)
EasyCategory("entities", "Bitminers", DefaultCategoryColor)
EasyCategory("entities", "Fun", DefaultCategoryColor)
EasyCategory("entities", "Printer Accessories", DefaultCategoryColor)
EasyCategory("entities", "Black Market", DefaultCategoryColor)
EasyCategory("entities", "Police Supplies", DefaultCategoryColor)
EasyCategory("entities", "Cocaine Making", DefaultCategoryColor)
EasyCategory("entities", "Meth Cooking", DefaultCategoryColor)
EasyCategory("entities", "Weed Growing", DefaultCategoryColor)
EasyCategory("entities", "Alcohol Distilling", DefaultCategoryColor)
EasyCategory("entities", "Drug Growing", DefaultCategoryColor)
EasyCategory("entities", "Weapon Crafting", DefaultCategoryColor)
EasyCategory("entities", "Drugs", DefaultCategoryColor)
EasyCategory("entities", "Oil Mining", DefaultCategoryColor)
EasyCategory("entities", "Chemicals", DefaultCategoryColor)
EasyCategory("entities", "Medical", DefaultCategoryColor)
EasyCategory("entities", "Beverages", DefaultCategoryColor)
EasyCategory("entities", "Food", DefaultCategoryColor)
EasyCategory("entities", "Fruit", DefaultCategoryColor)
EasyCategory("entities", "Explosives", DefaultCategoryColor)
EasyCategory("entities", "Holy Books", DefaultCategoryColor)
EasyCategory("entities", "Bombs", DefaultCategoryColor)

EasyCategory("shipments", "Drugs", DefaultCategoryColor)
EasyCategory("shipments", "Chemicals", DefaultCategoryColor)
EasyCategory("shipments", "Beverages", DefaultCategoryColor)
EasyCategory("shipments", "Pistols", DefaultCategoryColor)
EasyCategory("shipments", "Submachine Guns", DefaultCategoryColor)
EasyCategory("shipments", "Machine Guns", DefaultCategoryColor)
EasyCategory("shipments", "Assault Rifles", DefaultCategoryColor)
EasyCategory("shipments", "Sniper Rifles", DefaultCategoryColor)
EasyCategory("shipments", "Black Market", DefaultCategoryColor)
EasyCategory("shipments", "Police Supplies", DefaultCategoryColor)
EasyCategory("shipments", "Fun", DefaultCategoryColor, 1) -- yeah baby
EasyCategory("shipments", "Fruit", DefaultCategoryColor)
EasyCategory("shipments", "Explosives", DefaultCategoryColor)
EasyCategory("shipments", "Self Defense", DefaultCategoryColor)
EasyCategory("shipments", "Grenades", DefaultCategoryColor)
EasyCategory("shipments", "Scrap Weapons", DefaultCategoryColor)

EasyCategory("weapons", "Pistols", DefaultCategoryColor)
EasyCategory("weapons", "Submachine Guns", DefaultCategoryColor)
EasyCategory("weapons", "Machine Guns", DefaultCategoryColor)
EasyCategory("weapons", "Assault Rifles", DefaultCategoryColor)
EasyCategory("weapons", "Sniper Rifles", DefaultCategoryColor)
EasyCategory("weapons", "Black Market", DefaultCategoryColor)
EasyCategory("weapons", "Explosives", DefaultCategoryColor)
EasyCategory("weapons", "Drugs", DefaultCategoryColor)
EasyCategory("weapons", "Fun", DefaultCategoryColor, 1) -- yeah baby
EasyCategory("weapons", "Self Defense", DefaultCategoryColor)
EasyCategory("weapons", "Grenades", DefaultCategoryColor)
EasyCategory("weapons", "Scrap Weapons", DefaultCategoryColor)
