



do return end




/*---------------------------------------------------------------------------
Which default HUD elements should be hidden?
---------------------------------------------------------------------------*/

local hideHUDElements = {
	-- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
	-- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
	["DarkRP_HUD"] = true,

	-- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
	-- This also draws the information on doors and vehicles
	["DarkRP_EntityDisplay"] = false,

	-- DarkRP_ZombieInfo draws information about zombies for admins who use /showzombie.
	["DarkRP_ZombieInfo"] = false,

	-- This is the one you're most likely to replace first
	-- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
	-- It shows your health, job, salary and wallet, but NOT hunger (if you have hungermod enabled)
	["DarkRP_LocalPlayerHUD"] = false,

	-- If you have hungermod enabled, you will see a hunger bar in the DarkRP_LocalPlayerHUD
	-- This does not get disabled with DarkRP_LocalPlayerHUD so you will need to disable DarkRP_Hungermod too
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
local _h = ScrH( ) - 50;
local _w = ScrW( ) / 2;
local _poly = { };

// Simple helper-function to ensure the poly can be re-evaluated when resolution changes
local function UpdatePoly( _w, _h )
    _poly = {
        { x = 5, 			y = _h - 100, u = 0, v = 0 };                	// This is 1
        { x = _w / 2 + 15, 	y = _h - 100, u = 0, v = 0 };   				// 2
        { x = _w / 2 + 80, 	y = _h - 13, u = 0, v = 0 };       				// 3
        { x = _w / 2 + 80, 	y = _h + 35 + 10, u = 0, v = 0 };   		 	// 4
        { x = 5,		 	y = _h + 35 + 10, u = 0, v = 0 };    			// 5
    };
end
UpdatePoly( _w, _h );

surface.CreateFont("HUDFont", {
	font = "Evogria",
	size = 20,
	weight = 300
})

hook.Add( "HUDPaint", "PolyTest", function( )
    if ( _h != ScrH( ) - 50 || _w != ScrW( ) / 2 ) then
        _h = ScrH( ) - 50;
        _w = ScrW( ) / 2;
        UpdatePoly( _w, _h );
    end
	
	local Job = LocalPlayer().DarkRPVars.job
	local Mon = LocalPlayer().DarkRPVars.money
	local Sal = LocalPlayer().DarkRPVars.salary
	
	local textX = 165

    surface.SetMaterial( Material( "vgui/alpha-back.vtf" ) )
    surface.SetDrawColor( Color( 0, 0, 0, 220 ) )
    surface.DrawPoly( _poly )
	
	
	-- Name Icon & Text
	surface.SetMaterial( Material("icon16/user_red.png") )
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(140, _h - 90, 16, 16)
	
	surface.SetFont("HUDFont")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(textX, _h - 92)
	surface.DrawText(LocalPlayer():Nick())
	
	
	-- Salary Icon & Text
	surface.SetMaterial(Material("icon16/money_add.png"))
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(140, _h - 70, 16, 16)
	
	surface.SetFont("HUDFont")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(textX, _h - 72)
	surface.DrawText("$"..Mon.." | $"..Sal)
	
	-- Job Icon & Text
	surface.SetMaterial(Material("icon16/flag_green.png"))
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(140, _h - 50, 16, 16)
	
	surface.SetFont("HUDFont")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(textX, _h - 52)
	surface.DrawText(Job)
	
	-- Level Icon & Text
	surface.SetMaterial(Material("icon16/ruby.png"))
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(140, _h - 30, 16, 16)
	
	surface.SetFont("HUDFont")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(textX, _h - 32)
	surface.DrawText("Level: ")
	
	-- Health Bar & Hunger Bar
	local w = 60 * 6 - 30
	draw.RoundedBox(0, 140, _h - 8, 330, 20, Color(0, 0, 0, 220))
	draw.RoundedBox(0, 140, _h - 8, math.max(w * (LocalPlayer():Health() / 100), 1), 20, Color(255, 0, 0, 255))
	draw.SimpleText("Health: "..LocalPlayer():Health(), "Default", 160, _h - 4, Color(255, 255, 255, 255))
	
	local w = 60 * 6 - 30
	draw.RoundedBox(0, 140, _h + 18, 330, 20, Color(0, 0, 0, 220))
	draw.RoundedBox(0, 140, _h + 18, math.max(w * (LocalPlayer():Health() / 100), 1), 20, Color(150, 60, 27, 255))
	draw.SimpleText("Hunger: "..LocalPlayer():Health(), "Default", 160, _h + 21, Color(255, 255, 255, 255))
	
	-- Logo
	draw.RoundedBox(0, 10, _h - 95, 128, 135, Color(0, 0, 0, 150))
	
	surface.SetMaterial(Material("logos/fl/logo.png"))
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(18, _h - 90, 128, 135)
	
end );