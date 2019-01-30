
-- #NoSimplerr#

local PLAYER = FindMetaTable("Player")

function PLAYER:GetVolatile()
	return self:GetNWInt("volatile_waste", 0)
end

if SERVER then
	local function ExplosionData(ply)
		return 200 + (40 * ply:GetVolatile()), 120 + (40 * ply:GetVolatile())
	end

	function PLAYER:SetVolatile(num)
		self:SetNWInt("volatile_waste", num)
		local TimerName = "VolatileWaste_" .. self:SteamID()
		if num > 0 and not timer.Exists(TimerName) then
			timer.Create(TimerName, 1, 0, function()
				if not IsValid(self) or not self:IsPlayer() or not self:Alive() or self:GetVolatile() < 1 then
					timer.Remove(TimerName)
					return
				end
				if self:Health() <= 10 and self.CauseOfDeath ~= "volatile_waste" then
					self.CauseOfDeath = "volatile_waste"
					self:SuicideBombDelayed(1, ExplosionData(self))
				else
					self:SetHealth(math.Clamp(self:Health() - 5, 0, self:GetMaxHealth()))
				end
			end)
		else
			timer.Remove(TimerName)
		end
	end

	function PLAYER:AddVolatile(num)
		if type(num) ~= "number" then
			num = 1
		end

		self:SetVolatile(self:GetVolatile() + num)
	end

	-- important: must be called AFTER death so we don't infinitely kill ourselves with the explosion
	-- also don't explode here if the timer already did it for us
	hook.Add("PostPlayerDeath", "VolatileWasteDeathBoom", function(ply)
		if ply.CauseOfDeath and ply.CauseOfDeath == "volatile_waste" then
			ply.CauseOfDeath = nil
			return
		end
		if IsValid(ply) and ply:GetVolatile() > 0 then
			LargeExplosion(ply:GetPos(), ExplosionData(ply))
			ply:SetVolatile(0)
		end
	end)
end
