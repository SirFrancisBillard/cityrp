INTROMENU = {}

surface.CreateFont("IntroMenu_ServerTitleFont", {
	size = (type(ScrH) == "function" and ScrH() or 1080) / 18,
	weight = 800,
	antialias = true,
	shadow = false,
	font = "Arial"
})

function INTROMENU:Build()
	self:Init()
	self:Destroy()

	self.Panel = vgui.Create("DPanel")
	self.Panel:SetSize(ScrW(), ScrH())
	self.Panel:Center()
	self.Panel:MakePopup()
	self.Panel.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 150, 100))
	end

	local ServerTitle = vgui.Create("DLabel", self.Panel)
	ServerTitle:SetFont("IntroMenu_ServerTitleFont")
	ServerTitle:SetPos(ScrW() / 2, (ScrH() / 2) * 0.5)
	ServerTitle:SetText("Welcome to " .. GetHostName() .. ", " .. LocalPlayer():Nick() .. ".")

	local CloseButton = vgui.Create("DButton", self.Panel)
	CloseButton:SetText("Close")
	CloseButton:SetPos(ScrW() / 2, (ScrH() / 2) * 1.5)
	CloseButton:SetSize(ScrH() * 0.1, ScrW() * 0.2)
	CloseButton.DoClick = function()
		self:Destroy()
	end
end

function INTROMENU:Destroy()
	if IsValid(INTROMENU.Panel) and type(INTROMENU.Panel.Remove) == "function" then]
		INTROMENU.Panel:Remove()
	end
end

concommand.Add("rp_intromenu", function(ply, cmd, args, argsStr)
	INTROMENU:Build()
end)
