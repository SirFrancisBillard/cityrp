AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "dealer_base"

ENT.PrintName = "Scratch Card Dealer"
ENT.Category = "NPCs"
ENT.Spawnable = true

ENT.Model = "models/player/guerilla.mdl"
ENT.Description = "Cheap, low-effort gambling!"
ENT.TextColor = Color(0, 200, 200)
ENT.Animation = "idle_all_01"

local sayings = {
	"Hello, my friend.",
	"I can give you quality cards.",
	"You can win very much money!",
	"Straight from Mother Russia.",
	"Would you like to gamble?",
}

local amounts = {
	[1] = 100,
	[2] = 10000,
	[3] = 1000000,
}

if SERVER then
	util.AddNetworkString("ScratchCards")

	net.Receive("ScratchCards", function(len, ply)
		local num = math.Clamp(net.ReadInt(4), 1, 3)
		local amount = amounts[num]
		if not ply:canAfford(amount) then
			ply:ChatPrint("You can't afford that!")
			return
		end
		local winnings = math.random(amount * 2)
		ply:addMoney(winnings - amount)
		ply:ChatPrint("You won " .. DarkRP.formatMoney(winnings) .. "!")
	end)

	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			caller:ChatPrint(sayings[math.random(#sayings)])
			net.Start("ScratchCards")
			net.Send(caller)
		end
	end
else
	net.Receive("ScratchCards_OpenClientMenu", function(len)
		local DermaPanel = vgui.Create("DFrame")
		DermaPanel:SetSize(300, 200)
		DermaPanel:SetTitle("Scratch Cards")
		DermaPanel:SetDraggable(true)
		DermaPanel:MakePopup()
		local Button1 = vgui.Create("DButton", DermaPanel)
		Button1:SetText("Low Roller - $100")
		Button1:SetPos(25, 45)
		Button1:SetSize(250, 30)
		Button1.DoClick = function()
			net.Start("ScratchCards_UseScratchCard")
				net.WriteInt(1, 4)
			net.SendToServer()
			DermaPanel:Close()
		end
		local Button2 = vgui.Create("DButton", DermaPanel)
		Button2:SetText("Medium Roller - $10,000")
		Button2:SetPos(25, 95)
		Button2:SetSize(250, 30)
		Button2.DoClick = function()
			net.Start("ScratchCards_UseScratchCard")
				net.WriteInt(2, 4)
			net.SendToServer()
			DermaPanel:Close()
		end
		local Button3 = vgui.Create("DButton", DermaPanel)
		Button3:SetText("High Roller - $1,000,000")
		Button3:SetPos(25, 145)
		Button3:SetSize(250, 30)
		Button3.DoClick = function()
			net.Start("ScratchCards_UseScratchCard")
				net.WriteInt(3, 4)
			net.SendToServer()
			DermaPanel:Close()
		end
		DermaPanel:Center()
	end)
end
