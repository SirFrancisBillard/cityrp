
GS = GS or {}

function GS.TableIter( var, str )

	for _, index in pairs( string.Explode( ".", str ) ) do

		var = var[index]

	end

	return var
end

function GS.DrawText( txt, f, x, y, c, a )

	local a = a or TEXT_ALIGN_LEFT
    draw.DrawText( txt, f, x +1, y +1, Color( 0, 0, 0, c.a *( 250/255 ) ), a )
    draw.DrawText( txt, f, x +2, y +2, Color( 0, 0, 0, c.a *( 50/255 ) ), a )
    draw.DrawText( txt, f, x, y, c, a )

end

function GS.GetTextSize( f, txt )

	surface.SetFont( f )
	local w, h = surface.GetTextSize( txt )

	return w, h
end

function GS.SetColorAlpha( color, alpha )

	return Color( color.r, color.g, color.b, alpha )
end

function GS.FormStats( wep )

	local lines = {}
	local stats = GS.Stats[ GS.GetGunClass( wep ) ] or GS.Stats.Default

	for _, tab in pairs( stats ) do

		local var = GS.TableIter( wep, tab.var )

		if ( type( var ) == "number" and var < 0 ) or var == nil then return {} end

		if type( tab.format ) == "function" then

			var, col = tab.format( var, wep )

		elseif type( tab.format ) == "string" then

			var = string.format( tab.format, type( var ) == "table" and unpack( var ) or var )

		end

		table.insert( lines, {
			left = tab.name,
			right = var,
			lcolor = IsColor( GS.Colors[tab.name] ) and GS.Colors[tab.name] or GS.TextColor,
			rcolor = IsColor( col ) and col or GS.TextColor,
		} )

	end

	return lines
end

function GS.FormPanel( wep )

	local name = GS.GetGunName( wep )
	local w, h = GS.GetTextSize( "GS_Large", name )
	w = w +GS.Padding *2
	w = w < GS.Width and GS.Width or w

	local _, h2 = GS.GetTextSize( "GS_Medium", "|" )

	local tab = {}
	tab.created = CurTime()
	tab.name = name
	tab.color = GS.TableIter( wep, GS.ColorVar ) or GS.GetNameColor( wep )
	tab.stats = GS.FormStats( wep )

	tab.width = w
	tab.height = GS.Padding +h +( h2/1.2 ) *( tab.stats and #tab.stats or 1 )
	tab.alpha = 0
	tab.textalpha = 0
	tab.offset = tab.height *GS.Scale +GS.Float

	return tab
end

function GS.RemovePanel( wep )

	GS.Panels[wep] = nil

end