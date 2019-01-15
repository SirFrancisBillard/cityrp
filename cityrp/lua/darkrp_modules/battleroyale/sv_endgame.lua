
hook.Add("DoPlayerDeath", "BattleRoyale.CheckForEndGame", function(ply, attacker, dmg)
	if IsValid(ply) and ply:GetBRStatus() == BR_STATUS_PLAYING then
		ply:SetBRStatus(BR_STATUS_NONE)
		ply.WillResetBR = true

		if BattleRoyale.GetActivePlayerCount() == 1 then
			local victor = BattleRoyale.GetSurvivor()
			victor:ChatPrint("VICTORY ROYALE!")
			-- and to the victor go the spoils
			victor:WinBR()
			timer.Simple(5, function()
				if IsValid(victor) and victor:IsPlayer() and victor:Alive() and victor:GetBRStatus() == BR_STATUS_PLAYING then
					victor:Kill() -- just fucking kill them lmao
				end
			end)
		end
	end
end)

hook.Add("PlayerSpawn", "BattleRoyale.Assimilate", function(ply)
	if IsValid(ply) then
		-- single tick delay because every other hook overrides weapons
		timer.Simple(0, function()
			if IsValid(ply) and ply:IsPlayer() and ply.WillResetBR then
				-- reset their weapons and ammo and shit
				ply:FinishBR()
				ply.WillResetBR = false
			end
		end)
	end
end)
