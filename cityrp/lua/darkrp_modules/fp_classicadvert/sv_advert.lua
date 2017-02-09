#NoSimplerr#

function playerAdvert( ply, args )

	if args == "" then

		ply:SendLua( string.format( [[notification.AddLegacy( "%s", 1, 5 )
			surface.PlaySound( "buttons/button15.wav" )]], CLASSICADVERT.failMessage ) )

	else

		for k,pl in pairs( player.GetAll() ) do

			local senderColor = team.GetColor( ply:Team() )
			DarkRP.talkToPerson( pl, senderColor, CLASSICADVERT.chatPrefix.." "..ply:Nick(), CLASSICADVERT.advertTextColor, args, ply )

		end

		return ""

	end

end
DarkRP.defineChatCommand( CLASSICADVERT.chatCommand, playerAdvert )