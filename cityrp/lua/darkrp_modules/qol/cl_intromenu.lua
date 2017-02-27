INTROMENU = {}

surface.CreateFont("IntroMenu_ServerTitleFont", {
	size = (type(ScrH) == "function" and ScrH() or 1080) / 24,
	weight = 800,
	antialias = true,
	shadow = false,
	font = "Arial"
})

function INTROMENU:Build()
	self:Destroy()

	self.Panel = vgui.Create("DPanel")
	self.Panel:SetSize(ScrW(), ScrH())
	self.Panel:Center()
	self.Panel:MakePopup()
	self.Panel.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
	end

	local ServerTitle = vgui.Create("DLabel", self.Panel)
	ServerTitle:SetFont("IntroMenu_ServerTitleFont")
	ServerTitle:SetSize(ScrW(), ScrH() / 5)
	
	local text = "Welcome to " .. GetHostName() .. ", " .. LocalPlayer():Nick() .. "."
	surface.SetFont("IntroMenu_ServerTitleFont")
	local offset = surface.GetTextSize(text) / 2
	ServerTitle:SetText(text)
	ServerTitle:SetPos(ScrW() / 2 - offset, (ScrH() / 2) * 0.3)

	local CloseButton = vgui.Create("DButton", self.Panel)
	CloseButton:SetText("Close")
	CloseButton:SetPos(ScrW() / 2 - ScrW() * 0.1, (ScrH() / 2) * 1.5)
	CloseButton:SetSize(ScrW() * 0.2, ScrH() * 0.1)
	CloseButton.DoClick = function()
		self:Destroy()
	end
end

function INTROMENU:Destroy()
	if IsValid(INTROMENU.Panel) and type(INTROMENU.Panel.Remove) == "function" then
		INTROMENU.Panel:Remove()
	end
end

concommand.Add("rp_intromenu", function(ply, cmd, args, argsStr)
	INTROMENU:Build()
end)
