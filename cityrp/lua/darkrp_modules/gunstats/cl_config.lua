
GS = GS or {}

GS.Distance = 200
-- Maximum units a player can be away from the weapon for the panel to appear

GS.Font = "Tahoma"
-- Font used by the addon

GS.Padding = 20
-- Space between the text and edge of the background

GS.Width = 500
-- Width of the background. You may need to modify this if you change the font, padding or scale

GS.Scale = 0.1
-- Scale of the stats panel, the bigger the scale, the bigger the panel, but the text will become blurry
-- You will have to change positioning to suit your changes

GS.Float = 10
-- The units above the weapon that the panel will float

GS.BGFadeIn = 500
GS.BGFadeOut = 500
GS.TextFadeIn = 750
GS.TextFadeOut = 750
-- The speeds at which the background and text fade in/out, the higher the number, the faster the fade
-- They're arbitrary and don't actually mean seconds, just mess around with them until you get what you like
-- I recommend that you make the text fade in/out faster than the background to prevent the text being shown alone

GS.NameColor = Color( 207, 0, 15 )
-- Default color of the name of the weapon - will typically be used for special (Traitor/Detective) weapons

GS.TextColor = Color( 236, 240, 241 )
-- Default color for all of the stats

GS.BGColor = Color( 34, 49, 63, 180 )
-- Background color (last number is opacity, max-min = 255-0)

GS.ColorVar = "GS_Color"
-- You can set the unique color for each weapon if you want, go into the weapon file and set a variable with the name above
-- EG: SWEP.GI_Color = Color( 255, 0, 0 )
-- If you want that particular weapon to have a red name

GS.StatColors = {
	["VERY LOW"] 	= Color( 5, 178, 51 ),
	["LOW"] 		= Color( 151, 255, 179 ),
	["HIGH"]		= Color( 255, 101, 7 ),
	["VERY HIGH"]	= Color( 178, 3, 9 ),

	["AVERAGE"]		= Color( 237, 174, 16 ),

	["VERY GOOD"] 	= Color( 5, 178, 51 ),
	["GOOD"] 		= Color( 151, 255, 179 ),
	["BAD"] 		= Color( 255, 101, 7 ),
	["VERY BAD"]	= Color( 178, 3, 9 ),
}
-- Accuracy/recoil rating color translations


-- If you want a specific stat to have a particular color, follow the example below, put the name of the color
-- in square brackets (including spaces etc.) EG: If I wanted the recoil text to be red

-- GS.Colors[ "Recoil" ] = Color( 255, 0, 0 )


--== I suggest you only mess with these if you know Lua proficiently ==--

GS.GetGunName = function( wep )
	return wep.PrintName or "???"
end
-- Function to return the name of the weapon, in case you have any special formatting

GS.GetGunTable = function( ent )
	if ent:IsWeapon() then return ent end

	if ent:GetClass() == "spawned_weapon" then
		return weapons.Get( ent:GetWeaponClass() )
	end
end
-- This function retuns the weapon table. Because DarkRP is special.

GS.ShouldShowStats = function( ent )
	if not IsValid( ent ) then return false end

	if ( not GS.Panels[ent] or type( GS.Panels[ent].textalpha ) == "table" ) and ent:GetClass() == "spawned_weapon" then
		return true
	end

	if not ent:IsWeapon() or not ent:IsScripted() then return false end

	if not GS.Panels[ent] or type( GS.Panels[ent].textalpha ) == "table"
		and LocalPlayer():GetPos():Distance( ent:GetPos() ) < GS.Distance
		then
		return true
	end

	return false
end

GS.WEAPON_PRIMARY 	= 0 -- Don't change these
GS.WEAPON_SECONDARY = 1 -- They're just enumerations
GS.WEAPON_GRENADE 	= 2
GS.WEAPON_OTHER 	= 3

GS.GetGunType = function( wep )
	return ( wep.Primary.Ammo == "pistol" and GS.WEAPON_SECONDARY ) or ( wep.Primary.ClipSize > -1 and GS.WEAPON_PRIMARY )
end
-- Function to return the type of weapon. Some pretty hacky methods are required, but you should be able to understand how it works (if you heeded the warning above)

GS.GetNameColor = function( wep )

	local tab = {
		[GS.WEAPON_PRIMARY] 	= Color( 52, 152, 219 ), 	-- Primary
		[GS.WEAPON_SECONDARY] 	= Color( 241, 196, 15 ), 	-- Secondary
		[GS.WEAPON_GRENADE] 	= Color( 211, 84, 0 ),		-- Grenade
	}

	return tab[ GS.GetGunType( wep ) ] or GS.NameColor
end
-- Edit the default colors of specific classes of weapons, decided by their slot, remember your commas!

GS.GetGunClass = function( wep )
	if wep.Author == "Spy" then return "FAS" end -- Example
end
-- This function decides the table of values that should be shown, it indexes the table GS.Stats with the value you return to allow you to show different stats for different types of weapons

-- I suggest you only mess with these if you know what you're doing
-- the "var" is the variable of the weapon, if your weapon file says SWEP.Primary.Damage = 12 for damage, the var should be:
-- "Primary.Damage" - remove the "SWEP."
GS.Stats.Default = {
	{ name = "Damage", var = "Primary.Damage", },
	{ name = "Clip", var = "Primary.ClipSize",
		format = function( var, wep )

		local per, color
		if wep.Clip1 and wep:Clip1() >= 0 then

			per = wep:Clip1() /var
			if per <= .25 then

				color = Color( 178, 3, 9 )

			elseif per <= .5 then

				color = Color( 237, 174, 16 )

			end

		end

		return ( ( wep.Clip1 and wep:Clip1() >= 0 ) and wep:Clip1() .. "/" or "" ) .. var, color or GS.TextColor
	end },
	{ name = "Accuracy", var = "Primary.Cone",
		format = function( var )
			local tab = {
				[0.005] = "VERY GOOD",
				[0.01]	= "GOOD",
				[0.025]	= "AVERAGE",
				[0.05]	= "BAD",
				[0.075]	= "VERY BAD",
			}

			for value, state in SortedPairs( tab, true ) do
				if var >= value then return state, GS.StatColors[ state ] or GS.TextColor end
			end

			return "VERY GOOD", GS.StatColors[ "VERY GOOD" ] or GS.TextColor
	end },
	{ name = "Recoil", var = "Primary.Recoil",
		format = function( var )
			local tab = {
				[1] 	= "VERY LOW",
				[2]		= "LOW",
				[3.5]	= "AVERAGE",
				[5]		= "HIGH",
				[7]		= "VERY HIGH",
			}

			for value, state in SortedPairs( tab, true ) do
				if var >= value then return state, GS.StatColors[ state ] or GS.TextColor end
			end

			return "VERY LOW", GS.StatColors[ "VERY LOW" ] or GS.TextColor
	end },
	{ name = "Automatic", var = "Primary.Automatic",
		format = function( var )

			return var == true and "YES" or "NO"
	end	},
	{ name = "Fire Rate", var = "Primary.Delay",
		format = function( var )

			return math.Round( 60/var ) .. " RPM"
	end }
}