function SWB_AddAmmoType(name)
	game.AddAmmoType({name = name,
	dmgtype = DMG_BULLET})
	
	if CLIENT then
		language.Add(name .. "_ammo", name .. " Ammo")
	end
end

SWB_AddAmmoType("Rifle")
SWB_AddAmmoType("Sniper Rifle")