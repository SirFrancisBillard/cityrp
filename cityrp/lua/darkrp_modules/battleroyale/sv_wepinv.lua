
local PLAYER = FindMetaTable("Player")

function PLAYER:SaveWeaponInventory(strip)
	local weps = {}

	for k, v in pairs(self:GetWeapons()) do
		if IsValid(v) then
			table.insert(weps, v:GetClass())
		end
	end

	local ammo = {}

	for k, v in pairs(game.BuildAmmoTypes()) do
		if self:GetAmmoCount(v.name) then
			ammo[v.name] = self:GetAmmoCount(v.name)
		end
	end

	self.SavedWeapons = weps
	self.SavedAmmo = ammo

	if strip then
		self:StripWeapons()
	end
end

function PLAYER:LoadWeaponInventory(strip)
	if not (self.SavedWeapons and self.SavedAmmo) then return end

	if strip then
		self:StripWeapons()
	end

	for k, v in pairs(self.SavedWeapons) do
		self:Give(v, true) -- no reserve ammo
	end

	for k, v in pairs(self.SavedAmmo) do
		self:GiveAmmo(v, k, true) -- hide popup
	end
end
