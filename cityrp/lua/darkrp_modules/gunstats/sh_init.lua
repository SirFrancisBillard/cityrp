
-- should probably just make this cl_init

if CLIENT then

	local tab = {
		__newindex = function( self, key, var )

			if istable( var ) and table.Count( var ) == 0 then

				setmetatable( var, getmetatable( self ) )
				rawset( self, key, var )

			else

				rawset( self, key, var )

			end

			return var
		end,
		__index = function( self, key )

			if not key then return end

			local tab = {}
			if not rawget( self, key ) then

				setmetatable( tab, getmetatable( self ) )
				rawset( self, key, tab )

			end

			return tab
		end
	}
	GS = {}
	setmetatable( GS, tab )

	GS.ShouldDraw = CreateClientConVar( "gs_show", 1, true )

	hook.Add( "InitPostEntity", "GS_Startup", function()

		GS.Gamemode = ( GM or GAMEMODE ).FolderName

	end )

	include( "gunstats/cl_config.lua" )
	include( "gunstats/cl_util.lua")
	include( "gunstats/cl_display.lua" )

	MsgC( Color( 241, 196, 15 ), "Gun Stats initialized...\n" )

end