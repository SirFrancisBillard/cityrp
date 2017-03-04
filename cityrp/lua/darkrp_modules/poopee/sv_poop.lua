-- Now THIS is maturity

local function MakePoo(player)
	local turd = ents.Create("ent_poop")
	turd:SetPos(player:GetPos() + Vector(0,0,32))
	turd:Spawn()
	player:EmitSound("ambient/levels/canals/swamp_bird2.wav", 50, 80)
	timer.Simple(30, function() if turd:IsValid() then turd:Remove() end end)
end

local function DoPoo(ply)
	if not ply:Alive() then
		ply:ChatPrint("You are dead!")
		return ""
	end
	if ply.NextPoo != nil && ply.NextPoo >= CurTime() then
			if math.random(1, 5) == 5 then
				MakePoo(ply)
				ply:Kill()
				ply:ChatPrint("You have died from an anal prolapse!")
				return ""
			end
			ply:ChatPrint("Your bowels are empty!")
		return ""
	end
	ply.NextPoo = CurTime() + 10
	MakePoo(ply)
	return ""
end

DarkRP.defineChatCommand("poo", DoPoo)
DarkRP.defineChatCommand("poop", DoPoo)
