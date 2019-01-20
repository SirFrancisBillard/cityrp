
if SERVER then
	util.AddNetworkString("Ele_TimeoutPing")

	net.Receive("Ele_TimeoutPing",function()
		net.Start("Ele_TimeoutPing")
			net.WriteBit(true)
		net.Send(ply)
	end)
else
	local Themes = {}
	Themes["Black"] = {Body = Color(0,0,0,225), Text = Color(255,255,255,255), URL = Color(150,255,150,255), Reconnect = Color(255,150,150,255)}
	Themes["Red"] = {Body = Color(255,80,80,225), Text = Color(255,255,255,255), URL = Color(150,255,150,255), Reconnect = Color(255,200,200,255)}
	Themes["Blue"] = {Body = Color(150,150,255,225), Text = Color(255,255,255,255), URL = Color(150,255,150,255), Reconnect = Color(255,150,150,255)}
	Themes["Green"] = {Body = Color(80,255,80,225), Text = Color(50,50,50,255), URL = Color(50,100,50,255), Reconnect = Color(200,20,20,255)}
	Themes["Orange"] = {Body = Color(229,126,22,225), Text = Color(255,255,255,255), URL = Color(150,255,150,255), Reconnect = Color(255,150,150,255)}
	Themes["Purple"] = {Body = Color(143,22,229,225), Text = Color(255,255,255,255), URL = Color(150,255,150,255), Reconnect = Color(255,150,150,255)}
	-- Themes["Theme Name"] = {Body = Background Color, Text = Text Color, URL = URL Color, Reconnect = Reconnect text color}

	local Logo = ""
	local LogoWidth = 400
	local LogoHeight = 150
	local WebsiteURL = ""
	local ServerLostConnection = "Uh oh! Looks like our code monkeys took a little shittie!"
	local Theme = "Red"

	local pingFrequency = 5
	local timeout = 5
	local reconnectDelay = 20

	local requestSent = -1
	local lastPing = 0

	local LogoTexture = nil
	if Logo != "" then
		LogoTexture = Material(Logo)
	end

	local function sendPing()
		net.Start("Ele_TimeoutPing")
			net.WriteBit(true)
		net.SendToServer()

		requestSent = CurTime()
	end

	net.Receive("Ele_TimeoutPing", function(len)
		requestSent = -1
	end)

	surface.CreateFont("_TimeoutFont", {
		font = "Comic Sans MS",
		size = 30,
		weight = 500,
		blursize = 1,
		blurcolor = Color(0, 0, 0, 255),
		passes = 3,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

	surface.CreateFont("TimeoutFont", {
		font = "Comic Sans MS",
		size = 30,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

	surface.CreateFont("_TimeoutFontLarge", {
		font = "Comic Sans MS",
		size = 50,
		weight = 500,
		blursize = 0,
		blurcolor = Color(0, 0, 0, 255),
		passes = 3,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

	surface.CreateFont("TimeoutFontLarge", {
		font = "Comic Sans MS",
		size = 50,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

	local matBlurScreen = Material( "pp/blurscreen" )
	local function RenderBlur()
		local Fraction = 1

		local x, y = 0, 0

		DisableClipping( true )
		
		surface.SetMaterial( matBlurScreen )	
		surface.SetDrawColor( 255, 255, 255, 255 )
			
		for i=0.33, 1, 0.33 do
			matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
			matBlurScreen:Recompute()
			if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		end
		
		surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
		surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
		
		DisableClipping( false )
	end

	hook.Add("PostRenderVGUI", "ServerTimeout_HUDPaint", function()
		if (requestSent == -1) then 

			if (CurTime() - lastPing > pingFrequency) then
				
				lastPing = CurTime()
				sendPing() -- { user_id }
			end

			return
		end
		if (CurTime() - requestSent < timeout) then return end

		RenderBlur()

		local untilReconnect = reconnectDelay - math.Round(CurTime() - requestSent) + timeout

		surface.SetDrawColor(Themes[Theme].Body.r, Themes[Theme].Body.g, Themes[Theme].Body.b, Themes[Theme].Body.a)
		surface.DrawRect(0,0,ScrW(),ScrH())

		if Logo != "" then
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(LogoTexture)
			surface.DrawTexturedRect(ScrW()/2-LogoWidth/2, 20,LogoWidth,LogoHeight)
		end

		draw.SimpleText(ServerLostConnection, "_TimeoutFontLarge", ScrW()/2, ScrH()/2 - 100, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(ServerLostConnection, "TimeoutFontLarge", ScrW()/2, ScrH()/2 - 100, Themes[Theme].Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText("Server lost timeout about " .. math.Round(CurTime() - requestSent) .. " seconds ago!", "_TimeoutFont", ScrW()/2, ScrH()/2 - 25, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Server lost timeout about " .. math.Round(CurTime() - requestSent) .. " seconds ago!", "TimeoutFont", ScrW()/2, ScrH()/2 - 25, Themes[Theme].Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if (untilReconnect > 0) then
			draw.SimpleText("We will try reconnecting you in " .. untilReconnect .. " second(s).", "_TimeoutFont", ScrW()/2, ScrH()/2 + 25, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("We will try reconnecting you in " .. untilReconnect .. " second(s).", "TimeoutFont", ScrW()/2, ScrH()/2 + 25, Themes[Theme].Reconnect, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			RunConsoleCommand("retry")
		end

		draw.SimpleText(WebsiteURL, "_TimeoutFont", ScrW()/2, ScrH()/2 + 75, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(WebsiteURL, "TimeoutFont", ScrW()/2, ScrH()/2 + 75, Themes[Theme].URL, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)

	timer.Create("ServerTimeout_AutoPing", pingFrequency, 0, sendPing)
end
