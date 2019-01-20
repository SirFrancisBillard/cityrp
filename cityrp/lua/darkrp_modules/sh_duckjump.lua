
local crouch_delay = CreateConVar("mg_adj_crouchdelay", 0.3, FCVAR_ARCHIVE, "Delay between two crouch jumps in a row.")
local dmg_time
hook.Add("StartCommand", "MG_FixCrouching", function(ply, cmd)
	if ply:OnGround() then
		ply:SetNW2Bool("MG_PressedDuck", false)
		ply:SetNW2Float("MG_NextDuckTime", 0)
	elseif cmd:KeyDown(IN_DUCK) then
		if !ply:GetNW2Bool("MG_PressedDuck") then
			local cur_time = CurTime()
			if ply:GetNW2Float("MG_NextDuckTime") > cur_time then
				cmd:RemoveKey(IN_DUCK)
				if SERVER then
					ply.MG_DamageTime = cur_time + dmg_time:GetFloat()
				end
			else
				ply:SetNW2Bool("MG_PressedDuck", true)
				ply:SetNW2Float("MG_NextDuckTime", cur_time + crouch_delay:GetFloat())
			end
		end
	else
		ply:SetNW2Bool("MG_PressedDuck", false)
	end
end)

if not SERVER then return end

local dmg_mult = CreateConVar("mg_adj_dmg_mult", 0, FCVAR_ARCHIVE, "Damage multiplicator for players abusing the crouch jump mechanic (0 = Disabled).")
dmg_time = CreateConVar("mg_adj_dmg_time", 0.5, FCVAR_ARCHIVE, "Amount of time people abusing crouch jumping should take more damage for")
hook.Add("EntityTakeDamage", "MG_FixCrouching", function(ply, dmg)
	if !ply:IsPlayer() then return end
	local dmg_mult = dmg_mult:GetFloat()
	if dmg_mult <= 0 then return end
	local dmg_time = ply.MG_DamageTime
	if !isnumber(dmg_time) or dmg_time <= CurTime() then return end
	local attacker = dmg:GetAttacker()
	if !attacker:IsValid() or attacker == ply then return end
	dmg:ScaleDamage(dmg_mult)
end)
