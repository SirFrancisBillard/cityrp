
local PLAYER = FindMetaTable("Player")

function PLAYER:GetVolatile()
	return self:GetNWInt("volatile_waste", 0)
end

function PLAYER:SetVolatile(num)
	self:SetNWInt("volatile_waste", num)
end

function PLAYER:AddVolatile(num)
	if type(num) ~= "number" then
		num = 1
	end

	self:SetVolatile(self:GetVolatile() + num)
end

if SERVER then
	timer.Create("VolatileWasteCountdown", 1, 0, function()
		for k, v in pairs(player.GetAll()) do
			if IsValid(v) and v:IsVolatile() and v:Alive() then
				if v:Health() <= 10 then
					v:SuicideBombDelayed(0, 200 + (40 * self:GetVolatile()), 120 + (40 * self:GetVolatile()))
				else
					v:SetHealth(math.Clamp(v:Health() - 5, 0, v:GetMaxHealth()))
				end
			end
		end
	end)

	hook.Add("DoPlayerDeath", "VolatileWasteDeathBoom", function(ply)
		if IsValid(ply) and ply:GetVolatile() then
			ply:SetVolatile(0)
			LargeExplosion(ply:GetPos(), 200 + (40 * self:GetVolatile()), 120 + (40 * self:GetVolatile()))
		end
	end)
end
