
-- easy workaround because im way too lazy to edit every single weapon file

function WeaponIconURL(icon)
	if SERVER then return end
	local url = "https://sirfrancisbillard.github.io/billard-radio/images/cityrp/" .. icon .. ".png"
	MaterialURL(url) -- cache it
	return url
end
