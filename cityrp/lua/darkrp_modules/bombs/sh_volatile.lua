
local PLAYER = FindMetaTable("Player")

function PLAYER:IsVolatile()
	return self:GetNWBool("volatile_waste", false)
end

function PLAYER:SetVolatile(bool)
	self:SetNWBool("volatile_waste", bool)
end

if SERVER then
	timer.Create("VolatileWasteCountdown", 1, 0, function()
		for k, v in pairs(player.GetAll()) do
			if IsValid(v) and v:IsVolatile() and v:Alive() then
				if v:Health() <= 10 then
					v:SuicideBombDelayed(0, 200, 120)
				else
					v:SetHealth(math.Clamp(v:Health() - 5, 0, v:GetMaxHealth()))
				end
			end
		end
	end)
end

if SERVER then
	hook.Add("DoPlayerDeath", "VolatileWasteDeathBoom", function(ply)
		if IsValid(ply) and ply:IsVolatile() then
			ply:SetVolatile(false)
			LargeExplosion(ply:GetPos(), 200, 120)
		end
	end)
end
