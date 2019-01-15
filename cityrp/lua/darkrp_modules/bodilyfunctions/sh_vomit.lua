
local PLAYER = FindMetaTable("Player")

function PLAYER:Vomit()
	local edata = EffectData()
	edata:SetEntity(self)
	util.Effect("vomit", edata)
end

PLAYER.ThrowUp = PLAYER.Vomit
