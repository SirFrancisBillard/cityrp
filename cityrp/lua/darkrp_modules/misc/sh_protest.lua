
-- burn a book, save a tree!
-- sign text used in weapon_protest.lua
-- #NoSimplerr#

local PLAYER = FindMetaTable("Player")

function PLAYER:GetProtestText()
	return self:GetNWString("protest_text", "Burn a Book,\nSave a Tree!")
end

if SERVER then
	util.AddNetworkString("UpdateProtestSign")

	function PLAYER:SetProtestText(text)
		self:SetNWString("protest_text", text)
	end

	-- note: ply.LastProtestUpdate are completely different variables on the client and
	-- server, but they should be similar enough to not cause problems
	net.Receive("UpdateProtestSign", function(len, ply)
		local text = net.ReadString()
		if string.len(text) > 64 then return end
		if CurTime() - ply.LastProtestUpdate < 10 then return end
		ply.LastProtestUpdate = CurTime()
		ply:SetProtestText(text)
	end)
else
	function SendProtestText(ply, text)
		if ply ~= LocalPlayer() then return end
		if string.len(text) > 64 then return end
		if CurTime() - LocalPlayer().LastProtestUpdate < 10 then return end
		LocalPlayer().LastProtestUpdate = CurTime()
		net.Start("UpdateProtestSign")
		net.WriteString(text)
		net.SendToServer()
	end

	surface.CreateFont("Protest", {
		font = "Comic Sans MS",
		size = 80,
		weight = 500,
		antialias = true,
		outline = true,
	})

	local offset = Vector(0, 0, 20)
	local red = Color(255, 0, 0)
	hook.Add("PostPlayerDraw", "DrawProtestSign", function(ply)
		if not IsValid(ply) or not ply:Alive() or not isfunction(ply.GetProtestText) then return end
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or not wep.IsProtestSign then return end

		local dist = LocalPlayer():GetPos():DistToSqr(ply:GetPos())

		if dist < 1000000 then
			local offset = Vector(0, 0, 85)
			local pos, ang = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Hand"))

			ang:RotateAroundAxis(ang:Forward(), 270)
			ang:RotateAroundAxis(ang:Right(), 275)
			ang:RotateAroundAxis(ang:Up(), 12)

			cam.Start3D2D(pos + (ang:Right() * -26) + (ang:Up() * 5), ang, 0.1)
				draw.DrawText(ply:GetProtestText(), "Protest", 2, 2, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end)
end


