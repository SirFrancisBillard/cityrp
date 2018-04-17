
hook.Add("EntityFireBullets", "SharpenWhenShotNear", function(ent, bul)
	if SERVER then
		function ApplySuppressionEffect(bhit)
			for _,v in pairs(ents.FindInSphere(bhit, 70)) do
				if v:IsPlayer() and v:Alive() then
					v:SetNWInt("SharpenAMT", math.Clamp(v:GetNWInt("SharpenAMT"), 0, 2) + 0.1)
					sound.Play(Sound("weapons/fx/rics/ric" .. math.random(1, 5) .. ".wav", bhit, 75, 100, 1))
					timer.Destroy(v:Name() .. "sharpenreset")
					timer.Create(v:Name() .. "sharpenreset", 2, 1, function()
						for i = 1,(v:GetNWInt("SharpenAMT") / 0.05) + 1 do
							timer.Simple(0.1 * i, function()
								v:SetNWInt("SharpenAMT", math.Clamp(v:GetNWInt("SharpenAMT") - 0.1, 0, 100000))
							end)
						end
						v:EmitSound(Sound("player/suit_sprint.wav"))
					end)
				end
			end
		end
	
		if ent:IsPlayer() then
			ApplySuppressionEffect(ent:GetEyeTrace().HitPos)
		elseif ent:IsNPC() then
			function bul:Callback(at, tr, dm)
				ApplySuppressionEffect(tr:GetDamagePosition())
			end -- what a load of ass
		end
		
	end
end)

hook.Add("RenderScreenspaceEffects", "ApplySuppression", function()
	DrawSharpen(5, LocalPlayer():GetNWInt("SharpenAMT"))
end)

hook.Add("PlayerInitialSpawn", "SetUpSharpenNWInt", function(ply)
	ply:SetNWInt("SharpenAMT", 0)
end)

hook.Add("PlayerDeath", "RemoveSharpenOnDeath", function(ply, i, a)
	ply:SetNWInt("SharpenAMT", 0)
end)
