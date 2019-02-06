
hook.Add("PostPlayerDeath", "BattleRoyale.CheckForEndGame", function(ply)
	if IsValid(ply) and ply:IsBRStatus(BR_STATUS_PLAYING) then
		ply:SetBRStatus(BR_STATUS_NONE)
		ply.WillResetBR = true

		if BattleRoyale.GetActivePlayerCount() == 1 then
			local victor = BattleRoyale.GetSurvivor()
			victor:ChatPrint("VICTORY ROYALE!")
			-- and to the victor go the spoils
			victor:WinBR()
			timer.Simple(5, function()
				if IsValid(victor) and victor:IsPlayer() and victor:Alive() and victor:IsBRStatus(BR_STATUS_PLAYING) then
					victor:Kill() -- just fucking kill them lmao
				end
				timer.Simple(10, function()
					for k, v in pairs(player.GetAll()) do
						if v:IsBRStatus(BR_STATUS_QUEUE) then
							v:ChatPrint("Battle Royale is starting in 20 seconds!")
						end
					end
					timer.Simple(20, function()
						BattleRoyale.Start()
					end)
				end)
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
