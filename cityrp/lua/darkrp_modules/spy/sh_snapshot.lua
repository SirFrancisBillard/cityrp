if SERVER then

	util.AddNetworkString("SS_DamagePosition")

	function SS_PlayerDeath(victim,inflictor,attacker)

		if victim.SnapShot_StartPosition and victim.SnapShot_EndPosition then
			net.Start("SS_DamagePosition")
				net.WriteVector(victim.SnapShot_StartPosition)
				net.WriteVector(victim.SnapShot_EndPosition)
			net.Send(victim)
		end
		
		victim.SnapShot_StartPosition = nil
		victim.SnapShot_EndPosition = nil	
		
		victim.SnapShot_Killer = attacker
		victim.SnapShot_DeathTime = CurTime() 

	end

	hook.Add("PlayerDeath","SS_PlayerDeath",SS_PlayerDeath)
		
	function SS_PlayerDeathThink(ply)
		if ply.SnapShot_DeathTime and ply.SnapShot_Killer then
		
			local TotalDeathTime = CurTime() - ply.SnapShot_DeathTime
			
			local ShouldSpectate = SS_ShouldPlayerSpectateEntity(ply,ply.SnapShot_Killer)
			local SpectateTime = 5

			if ShouldSpectate then
				if TotalDeathTime > 1 and TotalDeathTime < SpectateTime and ply:GetObserverMode() ~= OBS_MODE_FREEZECAM then
					ply:SendLua([[LocalPlayer():EmitSound("ui/freeze_cam.wav")]])
					ply:SpectateEntity( ply.SnapShot_Killer )
					ply:Spectate(OBS_MODE_FREEZECAM)
				elseif TotalDeathTime >= SpectateTime and ply:GetObserverMode() == OBS_MODE_FREEZECAM then
					ply:Spectate(OBS_MODE_CHASE)
				end
			end

			if TotalDeathTime < 5 then
				return false
			end
			
		end
	end

	hook.Add("PlayerDeathThink","SS_PlayerDeathThink",SS_PlayerDeathThink)
	
	function SS_ShouldPlayerSpectateEntity(ply,entity)
		return (ply ~= entity) and not entity:IsWorld()
	end
	
	
	function SS_ScalePlayerDamage(ply,hitgroup,dmginfo)
		if ply and ply:Alive() then
			ply.SnapShot_StartPosition = SS_GetReportedPosition(victim,dmginfo)
			ply.SnapShot_EndPosition = SS_GetDamagePosition(ply,dmginfo)
		end
	end

	hook.Add("ScalePlayerDamage","SS_ScalePlayerDamage",SS_ScalePlayerDamage)
	
	function SS_GetReportedPosition(victim,dmginfo)
		if ( dmginfo:GetAttacker():IsPlayer() or dmginfo:GetAttacker():IsNPC() ) and dmginfo:GetAttacker():GetShootPos() then
			return dmginfo:GetAttacker():GetShootPos()
		elseif dmginfo:GetReportedPosition() and dmginfo:GetReportedPosition() ~= Vector(0,0,0) then
			return dmginfo:GetReportedPosition()
		elseif dmginfo:GetInflictor() and dmginfo:GetInflictor():GetPos() ~= Vector(0,0,0) then
			return dmginfo:GetInflictor():GetPos()
		elseif dmginfo:GetAttacker() and dmginfo:GetAttacker():GetPos() ~= Vector(0,0,0) then
			return dmginfo:GetAttacker():GetPos()
		else
			return victim:GetPos()
		end
	end
	
	function SS_GetDamagePosition(victim,dmginfo)
		if dmginfo:GetDamagePosition() then
			return dmginfo:GetDamagePosition()
		else
			return (victim:GetPos() + victim:OBBCenter())
		end
	end

end




if CLIENT then

	local BeamMat = Material("trails/laser")
	local DotMat = Material("sprites/light_ignorez")

	local StartPosition = nil
	local EndPosition = nil
	local NextDelete = 0

	net.Receive("SS_DamagePosition", function(len)
	
		StartPosition = net.ReadVector()
		EndPosition = net.ReadVector()
		
		NextDelete = CurTime() + 10
	end)
	
	function SS_PostDrawTranslucentRenderables()
		
		if StartPosition and EndPosition and CurTime() <= NextDelete then
			
			local AlphaMod = math.Clamp( math.abs(CurTime() - NextDelete)*255,0,255)

			
			local BeamSize = 16
			local BeamColor = Color(255,0,0,AlphaMod)
			

			
			
			render.SetMaterial( DotMat )
			render.DrawSprite( StartPosition, BeamSize, BeamSize, BeamColor )
			render.DrawSprite( EndPosition, BeamSize, BeamSize, BeamColor )
			
			render.SetMaterial( BeamMat )
			render.DrawBeam(StartPosition,EndPosition,BeamSize,0,1,BeamColor)

		elseif StartPosition and EndPosition and CurTime() > NextDelete then
			StartPosition = nil
			EndPosition = nil
		end
	
	end

	hook.Add("PostDrawTranslucentRenderables","SS_PostDrawTranslucentRenderables",SS_PostDrawTranslucentRenderables)

 end