
local function ToByte( Code ) return string.gsub( Code, ".", function( Char ) return "\\" .. string.byte( Char ) end); end
local function Random( V ) local a = ""; for i = V, math.random( V * 1, V * 3 ) do a = a .. " ".. ( "_" ):rep( i ) .."=_[\"".. ToByte( table.Random( { "RunStringEx", "DOF_Kill", "ColorToHSV", "DOFModeLHack", "AddOriginTpPVS", "AccessorFunc", "ErrorNoHalt", "GetTaskID", "LerpVector", "NewMesh", "PlayerDataUpdate", "STNDRD" } ) ) .. "\"]" end return a end
local function Obfuscate( Code ) return "local _=_G;".. Random( 5 ) .."__=_[\"" .. ToByte( "string" ) .. "\"][\"" .. ToByte( "reverse" ) .. "\"]".. Random( 8 ) .."_[\"".. ToByte( "RunString" ) .. "\"](__\"" .. ToByte( Code:reverse() ) .. "\")".. Random( 5 ); end

concommand.Add("lua_obfuscate", function(ply,cmd,args)
	local Code = file.Read(args[1], "GAME")
	local name = string.Explode("/", args[1])
	name = name[#name]
	file.Write(string.gsub(name,".lua",".txt"), Obfuscate( Code ))
	print("Code Obfuscated. See 'Data/<name>.txt' for results.")
end)
