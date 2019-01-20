



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
local matJob 		= Material("icon16/vcard.png")
local matMoney 		= Material("icon16/money.png")
local matSalary 	= Material("icon16/money_add.png")

hook.Add( "HUDPaint", "PolyTest", function( )
	local _ply 		= LocalPlayer()
	local Hp, Ar 	= _ply:Health(), _ply:Armor()
	
	local job = _ply.DarkRPVars.job 	or "Unemployed";
	local sal = _ply.DarkRPVars.salary 	or "0";
	local mon = _ply.DarkRPVars.money 	or "0";
	
	-- Background
	surface.SetDrawColor(0, 0, 0, 215)
	surface.DrawRect( 10, ScrH() - 105, 203, 100)
	
	-- Outline
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawOutlinedRect( 10, ScrH() - 105, 203, 100)
	
	surface.SetDrawColor(0, 0, 0, 225)
	surface.DrawRect( 10, ScrH() - 105, 203, 19)
	
	draw.RoundedBox(0, 12, ScrH() - 103, 195, 15, Color(0, 0, 0, 255))
	draw.RoundedBox(0, 12, ScrH() - 103, math.Clamp(Hp, 0, 100) * 1.99, 15, Color(255, 0, 0, 255))
	draw.SimpleText(Hp.."%", "HUDFont15", 99, ScrH() - 103, Color(255, 255, 255))
	
	surface.SetMaterial(matName)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(18, ScrH() - 80, 16, 16)
	
	surface.SetMaterial(matJob)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(18, ScrH() - 60, 16, 16)
	
	surface.SetMaterial(matMoney)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(18, ScrH() - 40, 16, 16)
	
	draw.SimpleText(_ply:Nick().. " (".._ply:GetNWString('usergroup')..")", "HUDFont15", 40, ScrH() - 80, Color(255, 255, 255))
	draw.SimpleText(job, "HUDFont15", 40, ScrH() - 60, Color(255, 255, 255))
	draw.SimpleText("$"..mon.." + $"..sal, "HUDFont15", 40, ScrH() - 40, Color(255, 255, 255))

	if GetHostName() then
		draw.SimpleText(GetHostName(), 12, ScrH() - 120, Color(255, 255, 255))
	end
end)
