



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

surface.CreateFont("HUDFont", {
	font 	= "Default",
	size	= 15,
	weight	= 300
})

local name = Material("icon16/user.png")
local job2 = Material("icon16/vcard.png")
local money2 = Material("icon16/money.png")
local salar2 = Material("icon16/money_add.png")

hook.Add( "HUDPaint", "PolyTest", function( )
	local _ply 		= LocalPlayer()
	local Hp, Ar 	= _ply:Health(), _ply:Armor()

	local job = _ply.DarkRPVars.job 	or "Unemployed";
	local sal = _ply.DarkRPVars.salary 	or "0";
	local mon = _ply.DarkRPVars.money 	or "0";
	
	draw.RoundedBox(10, 10, ScrH() - 90, 350, 80, Color(70, 70, 70, 210))
	
	draw.RoundedBox(0, 90, ScrH() - 80, 260, 20, Color(0, 0, 0, 255))
	draw.RoundedBox(0, 92, ScrH() - 78, math.Clamp(Hp, 0, 100) * 2.55, 15, Color(50, 170, 70, 255))
	draw.SimpleText(Hp.."%", "HUDFont", 210, ScrH() - 78)
	
	if Ar > 0 then
		draw.RoundedBox(0, 90, ScrH() - 59, 260, 14, Color(0, 0, 0, 255))
		draw.RoundedBox(0, 92, ScrH() - 57, math.Clamp(Ar, 0, 100) * 2.55, 10,Color(8, 116, 225, 255))
		draw.SimpleText(Ar.."%", "HUDFont", 210, ScrH() - 60)
	end
	
	surface.SetMaterial(name)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(90, ScrH() - 45, 16, 16)
	draw.SimpleText(_ply:Nick(), "HUDFont", 110, ScrH() - 45)	
		
	surface.SetMaterial(money2)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(250,ScrH() - 45,16,16)
	draw.SimpleText("$"..mon, "HUDFont", 270, ScrH() - 45)	
		
	surface.SetMaterial(salar2)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(250,ScrH() - 30,16,16)
	draw.SimpleText("$"..sal, "HUDFont", 270, ScrH() - 30)
	
	surface.SetMaterial(job2)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(90,ScrH() - 30,16,16)
	draw.SimpleText(job, "HUDFont",110,ScrH() - 30)
end );


function Avatar()
	local avatar = vgui.Create("AvatarImage")
	avatar:SetPos(20,ScrH() - 80)
	avatar:SetSize(64,64)
	avatar:SetPlayer( LocalPlayer(), 64 )
	avatar:ParentToHUD()
	AvatarShouldDraw = 0
end
Avatar()
