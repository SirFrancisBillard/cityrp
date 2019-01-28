
-- #NoSimplerr#

if SERVER then
	util.AddNetworkString("ShowRandomCrit")

	local DefaultCritScale = 3
	local CritDamages = {
		[DMG_BLAST] = 5
	}

	hook.Add("EntityTakeDamage", "RandomCrits", function(ply, dmg)
		local atk = dmg:GetAttacker()
		if IsValid(atk) and atk:IsPlayer() and ply:IsPlayer() and (atk.AlwaysCrit or (math.random(30) == 1)) then
			dmg:ScaleDamage(CritDamages[dmg:GetDamageType()] or DefaultCritScale)
			net.Start("ShowRandomCrit")
			net.WriteEntity(ply)
			net.WriteEntity(atk)
			net.Broadcast()
		end
	end)

	concommand.Add("debug_alwayscrit",function(ply, cmd, args)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		if ply.AlwaysCrit == nil then
			ply.AlwaysCrit = false
		end

		ply.AlwaysCrit = not ply.AlwaysCrit
		ply:ChatPrint("Always crit " .. (ply.AlwaysCrit and "ENABLED." or "DISABLED."))
	end)
else
	local ShowCritTime = 2
	local CritSound = Sound("player/crit_hit.wav")
	local ReceieveSound = Sound("player/crit_received1.wav")

	surface.CreateFont("RandomCrit", {
		font = "Comic Sans MS", -- lmao
		size = 32,
		weight = 1000,
		antialias = true,
	})

	net.Receive("ShowRandomCrit", function(len)
		local ply = net.ReadEntity()
		local atk = net.ReadEntity()
		if ply == LocalPlayer() then
			surface.PlaySound(ReceieveSound)
		elseif atk == LocalPlayer() then
			surface.PlaySound(CritSound)
		else
			ply:EmitSound(CritSound, 75, math.random(80, 120))
		end
		ply.GotCrit = CurTime()
	end)

	local offset = Vector(0, 0, 85)
	hook.Add("PostPlayerDraw", "DrawRandomCrit", function(ply)
		if not IsValid(ply) then return end
		if not ply:Alive() then return end
		ply.GotCrit = ply.GotCrit or 0
		if CurTime() - ply.GotCrit > ShowCritTime then return end

		local Distance = LocalPlayer():GetPos():Distance(ply:GetPos())

		if Distance < 1000 then
			local frac = (CurTime() - ply.GotCrit) / ShowCritTime
			local offset = Vector( 0, 0, 85 )
			local ang = LocalPlayer():EyeAngles()
			local pos = ply:GetPos() + offset + ang:Up() + Vector(0, 0, frac * 12)

			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )

			cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
				draw.DrawText("CRITICAL HIT", "RandomCrit", 2, 2, Color(frac * 255, 255 - (frac * 255), 0, 255 - (frac * 255)), TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end)
end
