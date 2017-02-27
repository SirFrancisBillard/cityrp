local META = FindMetaTable("Player")

function META:GiveSTD()
	self:SetNWBool("has_std", true)
end

function META:CureSTD()
	self:SetNWBool("has_std", false)
end
