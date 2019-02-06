
-- #NoSimplerr#

do return end -- fuck this shit

local function AmmoCheck(ply, wep)
	if wep:Clip1() > 0 then
		ply:GiveAmmo(wep:Clip1(), wep:GetPrimaryAmmoType())
		wep:SetClip1(0)
	end
	if wep:Clip2() > 0 then
		ply:GiveAmmo(wep:Clip2(), wep:GetSecondaryAmmoType())
		wep:SetClip2(0)
	end
end

hook.Add("PlayerCanPickupWeapon", "TakeAmmoDoublePickup", function(ply, wep)
	if not ply:HasWeapon(wep:GetClass()) then return end
	AmmoCheck(ply, wep)
	return false
end)

hook.Add("PlayerPickupDarkRPWeapon", "TakeAmmoDoublePickup", function(ply, ent, wep)
	if not ply:HasWeapon(wep:GetClass()) then return end
	AmmoCheck(ply, wep)
	return true
end)

hook.Add("DoPlayerDeath", "DropAllWeapons", function(ply, atk, dmg)
	local weps = {}
	local classweps = ply:getJobTable().weapons
	for k, v in pairs(ply:GetWeapons()) do
		local wep = v:GetClass()
		if GAMEMODE.Config.DisallowDrop[wep] or table.HasValue(GAMEMODE.Config.DefaultWeapons, wep) then continue end
		if istable(classweps) and table.HasValue(classweps, wep) then continue end
		table.insert(weps, wep)
		-- temp solution
		ply:dropDRPWeapon(v)
		return
		--[[
		local ship = ents.Create("spawned_weapon")
		ship:Setamount(1)
		ship:SetWeaponClass(wep)
		ship:SetPos(ply:GetPos())
		local model = (v:GetModel() == "models/weapons/v_physcannon.mdl" and "models/weapons/w_physics.mdl") or v:GetModel()
		model = util.IsValidModel(model) and model or "models/weapons/w_rif_ak47.mdl"
		ship:SetModel(model)
		ship:Spawn()
		]]
	end
	if #weps < 1 then return end
end)
