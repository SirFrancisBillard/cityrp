hook.Add( "PostDrawOpaqueRenderables", "Scoreboard", function( ply )

colors={}
red = Color( 210, 100, 100, 255 )
green = Color( 100, 210, 100, 255 )
blue = Color( 100, 100, 210, 255 )
pink = Color( 250, 100, 250, 255 )
orange = Color( 250, 150, 50, 255 )
yellow = Color( 250, 220, 0, 255 )
grey = Color( 100, 100, 100, 255 )
black = Color( 0, 0, 0, 255 )


--Don't change anything above this line unless you're a competent Lua developer.


--Config
	local font = "ChatFont"
	--What font does the scoreboard use?
	local pos = Vector( -1050, -1020, 100 )
	--Where does the scoreboard spawn?
	local ang = Angle(  0, 180, 90 )
	--What angles to the scoreboard spawn with?
	local usematerial = false
	--Should the scoreboard use a material for the background?
	local material = Material( "" )
	--What material does the scoreboard use if enabled?
	local color = pink
	--What color should the top bar be? red, green, blue, pink, orange, yellow, grey, black

--Don't change anything below this line unless you're a competent Lua developer.

--Old variables from when this thing was a baby.
--[[
	local ply = Entity( 1 ):Nick()
	local hlt = Entity( 1 ):Health()
	local mxh = Entity( 1 ):GetMaxHealth()
	local tem = team.GetName( Entity( 1 ):Team() )
	local tcm = team.GetColor( Entity( 1 ):Team() )
	local png = Entity( 1 ):Ping()
]]--

	local maxplayer = game.MaxPlayers()

		cam.Start3D2D( pos, ang, 0.5 ) -- Start 3D2D

			--Boxes
			if usematerial == false then
			draw.RoundedBox( 6, 50, 50, 600, 35, Color( 0, 0, 0, 175 ))
			draw.RoundedBox( 6, 50, 85, 600, 30*maxplayer, Color( 0, 0, 0, 175 ))--Use untextured box
			else
			surface.SetMaterial( material ) --Set texture
			surface.DrawTexturedRect( 50, 50, 600, 400) --Use texture
			end
			draw.RoundedBox( 6, 50, 50, 600, 30, color) --Draw colored box

			--Text
			draw.SimpleText( "Player", font, 80, 55, Color( 255, 255, 255, 255 ))
			draw.SimpleText( "Job", font, 250, 55, Color( 255, 255, 255, 255 ))
			draw.SimpleText( "K/D", font, 385, 55, Color( 255, 255, 255, 255 ))
			draw.SimpleText( "Ping", font, 545, 55, Color( 255, 255, 255, 255 ))

			cam.Start3D2D( pos, ang, .5 )

							for k,v in pairs( player.GetAll() ) do -- k = Key, v = Value. Here k would be number and v would be player.

								--Nickname
								draw.SimpleText( v:Nick(), font, 80, 60 + (k*30), Color(255,255,255,255) )

								--Team
								draw.SimpleText( team.GetName( v:Team() ), font, 250, 60 + (k*30), team.GetColor( v:Team() ))

								--Health
						--[[
							if per == "false" then
								draw.SimpleText( ""..v:Health().."/"..v:GetMaxHealth().."", sbfont, 385, 60 + (k*30), Color( 255, 255, 255, 255 ))
							else
								draw.SimpleText( ""..v:Health().."%", sbfont, 385, 60 + (k*30), Color( 255, 255, 255, 255) )
							end
							]]--

								--Kills/Deaths
								draw.SimpleText( ""..v:Frags().."/"..v:Deaths().."", font, 385, 60 + (k*30), Color( 255, 255, 255, 255 ))

								--Ping
								draw.SimpleText( v:Ping(), font, 545, 60 + (k*30), Color( 255, 255, 255, 255 ))

							end

						cam.End3D2D()

end )