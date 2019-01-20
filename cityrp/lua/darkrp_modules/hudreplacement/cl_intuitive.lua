



do return end




/*---------------------------------------------------------------------------
Which default HUD elements should be hidden?
---------------------------------------------------------------------------*/

local hideHUDElements = {
	-- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
	-- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
	["DarkRP_HUD"] = true,

	-- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
	["DarkRP_EntityDisplay"] = false,

	-- DarkRP_ZombieInfo draws information about zombies for admins who use /showzombie.
	["DarkRP_ZombieInfo"] = false,

	-- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
	["DarkRP_LocalPlayerHUD"] = false,

	-- If you have hungermod enabled, you will see a hunger bar in the DarkRP_LocalPlayerHUD
	["DarkRP_Hungermod"] = false,

	-- Drawing the DarkRP agenda
	["DarkRP_Agenda"] = false
}

-- this is the code that actually disables the drawing.
hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
	if hideHUDElements[name] then return false end
end)

/*---------------------------------------------------------------------------
The Custom HUD
only draws health
---------------------------------------------------------------------------*/

surface.CreateFont("HUDFont20", {
	font 	= "Default",
	size	= 20,
	weight	= 300
})

surface.CreateFont("HUDFont15", {
	font 	= "Default",
	size	= 15,
	weight	= 300
})

surface.CreateFont("HUDFont10", {
	font 	= "Default",
	size	= 10,
	weight	= 300
})

surface.CreateFont("DevFont", {
	font 	= "BudgetLabel",
	size	= 13,
	weight	= 300
})

local matName 		= Material("icon16/user.png")
local matMoney 		= Material("icon16/money.png")
local matSalary 	= Material("icon16/coins.png")
local matHeart 		= Material("icon16/heart.png")
local matArmor		= Material("icon16/shield.png")

hook.Add( "HUDPaint", "PolyTest", function( )
	local _ply 		= LocalPlayer()
	local Hp 		= _ply:Health() or 1
	local Ar 		= _ply:Armor() or 1
	
	local job = _ply.DarkRPVars.job 	or "Unemployed";
	local sal = _ply.DarkRPVars.salary 	or "0";
	local mon = _ply.DarkRPVars.money 	or "0";
	
	draw.RoundedBox(6, 20, ScrH() - 120, 250, 100, Color(0, 0, 0, 150))
	
	-- Information
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(matName)
	surface.DrawTexturedRect(30, ScrH() - 110, 16, 16)
	
	draw.SimpleText(job, "HUDFont15", 50, ScrH() - 110, Color(255, 255, 255))
	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(matSalary)
	surface.DrawTexturedRect(30, ScrH() - 90, 16, 16)
	
	draw.SimpleText("$"..sal, "HUDFont15", 50, ScrH() - 90, Color(255, 255, 255))
	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(matMoney)
	surface.DrawTexturedRect(30, ScrH() - 70, 16, 16)
	
	draw.SimpleText("$"..mon, "HUDFont15", 50, ScrH() - 70, Color(255, 255, 255))
	
	-- Health
	draw.RoundedBox(4, 30, ScrH() - 45, 230, 20, Color(0, 0, 0, 255))
	draw.RoundedBox(4, 30, ScrH() - 45, math.Clamp(Hp, 0, 100) * 2.3, 20, Color(231, 76, 60, 255))
	draw.SimpleText(Hp, "HUDFont15", 230, ScrH() - 42, Color(255, 255, 255))
	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(matHeart)
	surface.DrawTexturedRect(40, ScrH() - 42, 16, 16)
	
	-- Armor
	draw.RoundedBox(4, 240, ScrH() - 110, 20, 55, Color(0, 0, 0, 255))
	draw.RoundedBox(4, 240, ScrH() - 110, 20, math.Clamp(Ar, 0, 100) * 0.55, Color(52, 152, 219))
	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(matArmor)
	surface.DrawTexturedRect(242, ScrH() - 107, 16, 16)

	if GetHostName() then
		draw.SimpleText(GetHostName(), "DevFont", 23, ScrH() - 135, Color(255, 255, 255))
	end
end)
