
print("g_DarkRPEntData = {")

for k, v in pairs(scripted_ents.GetList()) do
	if gDarkRPCustomEntList[k] and not g_DarkRPEntData[k] then
		print("[\"" .. k .. "\"] = {PrintName = \"" .. (v.t.PrintName or "ERROR_NAME") .. "\", Model = \"" .. (v.t.Model or v.t.WorldModel or "ERROR_MODEL") .. "\"},")
	end
end

for k, v in pairs(weapons.GetList()) do
	if gDarkRPCustomEntList[v.ClassName] and not g_DarkRPEntData[v.ClassName]  then
		print("[\"" .. v.ClassName .. "\"] = {PrintName = \"" .. (v.PrintName or "ERROR_NAME") .. "\", Model = \"" .. (v.Model or v.WorldModel or "ERROR_MODEL") .. "\"},")
	end
end

print("}")
