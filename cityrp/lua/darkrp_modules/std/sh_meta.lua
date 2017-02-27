local META = FindMetaTable("Player")

function META:HasSTD()
	return self:GetNWBool("has_std", false)
end
