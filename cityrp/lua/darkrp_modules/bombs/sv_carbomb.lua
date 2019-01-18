hook.Add("PlayerEnteredVehicle", "CarBombDetonate", function(ply, veh, role)
	if veh.HasCarBombPlanted then
		timer.Simple(1, function()
			if IsValid(ply) then
				ply:Kill()
			end
			local boom = EffectData()
			boom:SetOrigin(veh:GetPos())
			util.Effect("HelicopterMegaBomb", boom)
			veh:EmitSound(Sound("weapons/awp/awp1.wav"))
			veh:TakeDamage(1337, ply, ply)
			veh.HasCarBombPlanted = nil
		end)
	end
end)

hook.Add("PlayerUse", "CarBombDetonateSCars", function(ply, ent)
	if ent.HasCarBombPlanted and string.Left(ent:GetClass(), 18) == "sent_sakarias_car_"  then
		timer.Simple(1, function()
			if IsValid(ply) then
				ply:Kill()
			end
			local boom = EffectData()
			boom:SetOrigin(ent:GetPos())
			util.Effect("HelicopterMegaBomb", boom)
			ent:EmitSound(Sound("weapons/awp/awp1.wav"))
			ent:TakeDamage(1337, ply, ply)
			ent.HasCarBombPlanted = nil
		end)
	end
end)