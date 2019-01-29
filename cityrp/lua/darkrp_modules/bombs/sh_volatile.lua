
-- #NoSimplerr#

local PLAYER = FindMetaTable("Player")

function PLAYER:GetVolatile()
	print(self:GetNWInt("volatile_waste", 0))
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
			if IsValid(v) and v:GetVolatile() and v:Alive() then
				if v:Health() <= 10 then
					v.CauseOfDeath = "volatile_waste"
					v:SuicideBombDelayed(1, 200 + (40 * v:GetVolatile()), 120 + (40 * v:GetVolatile()))
				else
					v:SetHealth(math.Clamp(v:Health() - 5, 0, v:GetMaxHealth()))
				end
			end
		end
	end)

	-- important: must be called AFTER death so we don't infinitely kill ourselves with the explosion
	-- also don't explode here if the timer already did it for us
	hook.Add("PostPlayerDeath", "VolatileWasteDeathBoom", function(ply)
		if v.CauseOfDeath and v.CauseOfDeath == "volatile_waste" then
			v.CauseOfDeath = nil
			return
		end
		if IsValid(ply) and ply:GetVolatile() > 0 then
			LargeExplosion(ply:GetPos(), 200 + (40 * ply:GetVolatile()), 120 + (40 * ply:GetVolatile()))
			ply:SetVolatile(0)
		end
	end)
end
