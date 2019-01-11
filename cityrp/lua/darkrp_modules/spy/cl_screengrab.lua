print("Clientside loaded")

	function Box(w, h, col)
		surface.SetDrawColor(col)
		surface.DrawRect(0, 0 , w, h)
		surface.SetDrawColor(255,255,255,5)
		surface.DrawRect(5, 2 , w - 10, h * 0.3)
		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	net.Receive("ClientMenu", function()
		/* OPENS A MENU OF ALL CLIENTS */
		local MenuFrame = vgui.Create("DFrame")
			MenuFrame:SetSize(170, 20 + (#player.GetAll() * 31))
			MenuFrame:MakePopup()
			MenuFrame:SetTitle("Player List")
			MenuFrame:SetPos(2, ScrH() / 2 - MenuFrame:GetTall()  / 2)
			MenuFrame.Paint = function()
				Box(MenuFrame:GetWide(), MenuFrame:GetTall(), Color(30,30,30,255))
			end
		local Panel = vgui.Create("DPanelList", MenuFrame)
			Panel:SetSize(165, MenuFrame:GetTall() - 28)
			Panel:SetPos(3,25)
			--Panel:SetText("Player List")
			Panel:SetPadding( 5 )
			Panel:SetSpacing( 5 )
		for k, v in pairs(player.GetAll()) do
			local button = Panel:Add("DButton")
			button:SetSize(120,30)
			button:Dock( 4 )
			button:SetText(v:Name())
			button.Paint = function()
				Box(button:GetWide(), button:GetTall(), Color(0,0,255,255))
			end
			button.DoClick = function()
				if LocalPlayer():IsAdmin() or LocalPlayer():IsUserGroup("admin") or LocalPlayer():IsUserGroup("superadmin") or LocalPlayer():IsSuperAdmin() then
				net.Start("WarrantRequest")
					net.WriteEntity(LocalPlayer())
					net.WriteEntity(v)
				net.SendToServer()
				end
			end
		end
	end)

	net.Receive("RequestScreen", function()
		local screen = {}
		screen.format = "jpeg"
		screen.h = ScrH()
		screen.w = ScrW()
		screen.quality = 0.1
		screen.x = 0
		screen.y = 0

		local data = render.Capture( screen )
		local Requestee = net.ReadEntity()
		LocalPlayer():ChatPrint(Requestee:Name().." has requested your screen!")

		net.Start("GetScreen")
			net.WriteEntity(Requestee)
			net.WriteString( util.Base64Encode(data) )
		net.SendToServer()
	end)

	net.Receive("SendToCaller", function()
		local data = net.ReadString()

		local frame = vgui.Create("DFrame")
			frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
			frame:Center()
			frame:SetTitle("Screenshot")
			frame.Paint = function()
				Box(frame:GetWide(), frame:GetTall(), Color(30,30,30,255))
			end

		local html = frame:Add("HTML")
			html:SetHTML([[
			<style type="text/css">
				body {
					margin: 0;
					padding: 0;
					overflow: hidden;
				}
				img {
					width: 100%;
					height: 100%;
				}
			</style>
			<img src="data:image/jpg;base64,]] .. data .. [[">]])
	html:Dock( FILL )
	end)
