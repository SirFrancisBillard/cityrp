AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Nasty Pickles"
ENT.Category = "Food"
ENT.Spawnable = true
ENT.Model = "models/props_lab/jar01a.mdl"
ENT.Desc = "Jarred by an amateur. Eat at your own risk."

if SERVER then
	function ENT:Use(ply)
		if IsValid(ply) and ply:IsPlayer() then
			local randy = math.random(20)
			if randy > 16 then
				ply:SetHealth(math.Clamp(ply:Health() + math.random(4, 6), 1, ply:GetMaxHealth()))
				ply:ChatPrint("That wasn't so bad...")
			elseif randy > 5 then
				ply:Vomit()
				ply:ViewPunch(Angle(10))
				local dmg = math.random(10, 20)
				if ply:Health() - dmg <= 0 then
					ply:Kill()
				else
					ply:SetHealth(ply:Health() - dmg)
				end
			elseif randy > 1 then
				ply:Kill()
			else
				ply:Say("/y AAAAAAAAAAAAAAAAAAAA HELP IT BURNS")
				ply:Ignite(30)
			end
			ply:EmitSound(Sound("npc/barnacle/barnacle_gulp" .. math.random(1, 2) .. ".wav"))
			SafeRemoveEntity(self)
		end
	end
end
