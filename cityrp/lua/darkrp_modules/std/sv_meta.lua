local META = FindMetaTable("Player")

function META:GiveSTD()
	timer.Create(self:SteamID() .. "_PlayerHasSTD", 1.5, 0, function()
		player:SetHealth(player:Health() - 5)
		player:EmitSound("STD.Moan")
		if player:Health() <= 0 then 
			player:Kill()
			self:CureSTD()
		end
	end)
end

function META:CureSTD()
	if timer.Exists(self:SteamID() .. "_PlayerHasSTD") then
		timer.Remove(self:SteamID() .. "_PlayerHasSTD")
	end
end
