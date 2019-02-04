
local bombCount = 4
local radius = 25
local velMax = 300

local function bombs(ply, amt)
	for i = 1, amt do
		local ent = ents.Create("ent_clustertnt")
		local x = math.cos(math.rad(i/bombCount * 360)) * radius
		local y = math.sin(math.rad(i/bombCount * 360)) * radius
		
		ent:SetPos(ply:GetPos() + Vector(0, 0, 50) + Vector(x, y, 0))
		ent:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
		ent:Spawn()
		ent:GetPhysicsObject():SetVelocity(ply:GetVelocity() + Vector(math.random(-velMax, velMax), math.random(-velMax, velMax), math.random(velMax, velMax * 1.5)))
	end
end

hook.Add("PlayerDeath", "ClusterBombPlayerDeath", function(ply)
	if ply:GetNWInt("quran_amount") > 0 then
		bombs(ply, ply:GetNWInt("quran_amount"))
		ply:SetNWInt("quran_amount", 0)
	end
end)
