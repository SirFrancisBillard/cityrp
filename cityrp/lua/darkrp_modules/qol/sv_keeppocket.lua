
local addon_name = "darkrp_keep_pocket"

local forever = false
CreateConVar( addon_name.."_forever", "1", FCVAR_ARCHIVE, "Should pockets be saved in database?" )
cvars.AddChangeCallback( addon_name.."_forever", function( convar, oldValue, newValue )
	forever = ( tonumber( newValue )~=0 )
end, addon_name )
forever = ( GetConVar( addon_name.."_forever" ):GetInt()~=0 )

local function loadCustomDarkRPItems()
	darkrp_keep_pocket = darkrp_keep_pocket or {}
	
	-- Copy of garrysmod\gamemodes\DarkRP\entities\weapons\pocket\sv_init.lua
	local function sendPocketItems( ply )
		net.Start( "DarkRP_Pocket" )
			net.WriteTable( ply:getPocketItems() )
		net.Send( ply )
	end
	
	--- TODO: Protection contre la récursion.
	local copyTable
	do
		local processedTables -- cache for sub-tables in case they are referenced more than once
		function copyTable( t, destination, transformFunction )
			local newCopyProcess = false
			if not processedTables then -- beginning
				newCopyProcess = true
				processedTables = {}
			end
			local t2 = destination or {}
			for k,v in pairs( t ) do
				local k2 = k
				if istable( k ) then
					if not processedTables[k] and k~=_G then -- avoid _G (anti-DoS)
						processedTables[k] = {}
						pcall( copyTable, k, processedTables[k], transformFunction ) -- ensure happy ending
					end
					k2 = processedTables[k]
				elseif transformFunction then
					k2 = transformFunction( k )
				end
				local v2 = v
				if istable( v ) then
					if not processedTables[v] and v~=_G then
						processedTables[v] = {}
						pcall( copyTable, v, processedTables[v], transformFunction )
					end
					v2 = processedTables[v]
				elseif transformFunction then
					v2 = transformFunction( v )
				end
				if k2~=nil and v2~=nil then
					t2[k2] = v2
				end
			end
			if newCopyProcess then -- finished
				processedTables = nil
			end
			return t2
		end
	end
	
	
	local function unserializeNonSerializable( data )
		if isstring( data ) then
			local ending = string.sub( data, -1, -1 )
			if ending==")" then
				local serializedType
				serializedType = string.sub( data, 1, 8 )
				if serializedType=="@Vector(" then
					return Vector( string.sub( data, 9, -2 ) )
				elseif serializedType=="@Player(" then
					local result = player.GetBySteamID( string.sub( data, 9, -2 ) )
					if result then
						return result
					else
						return nil
					end
				end
				serializedType = string.sub( data, 1, 7 )
				if serializedType=="@Angle(" then
					return Angle( string.sub( data, 8, -2 ) )
				end
			end
		end
		return data
	end
	hook.Add( "PlayerLoadout", addon_name, function( ply )
		if ply.RestoredSavedPocket then return end
		timer.Simple( 0., function()
			if not IsValid( ply ) then return end
			local steamid = ply:SteamID()
			local contents = darkrp_keep_pocket[steamid]
			if not contents and forever then
				contents = ply:GetPData( addon_name, nil )
				if contents then
					contents = util.JSONToTable( contents )
				end
			end
			if contents then
				-- print( "PlayerLoadout, contents = " ) PrintTable( contents ) -- debug
				ply.darkRPPocket = ply.darkRPPocket or {} -- from meta:addPocketItem(ent)
				local darkRPPocket = ply.darkRPPocket
				darkrp_keep_pocket[steamid] = nil -- cleanup
				for _,itemSerialized in ipairs( contents ) do
					local item = copyTable( itemSerialized, nil, unserializeNonSerializable )
					table.insert( darkRPPocket, item ) -- from meta:addPocketItem(ent)
				end
				-- print( "PlayerLoadout, darkRPPocket = " ) PrintTable( darkRPPocket ) -- debug
				sendPocketItems( ply )
			end
		end )
		ply.RestoredSavedPocket = true -- do not restore on next PlayerLoadouts
	end )
	
	
	local function serializeNonSerializable( data )
		if isnumber( data ) or isstring( data ) or istable( data ) or isbool( data ) then
			return data -- serializable
		elseif isvector( data ) then
			return "@Vector("..data.x.." "..data.y.." "..data.z..")"
		elseif isangle( data ) then
			return "@Angle("..data.p.." "..data.y.." "..data.r..")"
		elseif isentity( data ) then
			if IsValid( data ) and data:IsPlayer() then
				return "@Player("..data:SteamID()..")"
			else
				return nil
			end
		end
		return nil
	end
	local function HoldContentForPlayer( ply, connected )
		local darkRPPocket = ply.darkRPPocket
		if darkRPPocket then
			if #darkRPPocket>0 then
				-- print( "HoldContentForPlayer, darkRPPocket = " ) PrintTable( darkRPPocket ) -- debug
				local contents = {}
				for _,item in ipairs( darkRPPocket ) do
					local itemSerialized = copyTable( item, nil, serializeNonSerializable )
					table.insert( contents, itemSerialized )
				end
				-- print( "HoldContentForPlayer, contents = " ) PrintTable( contents ) -- debug
				if not connected then
					darkrp_keep_pocket[ply:SteamID()] = contents
				end
				if forever then
					ply:SetPData( addon_name, util.TableToJSON( contents ) )
				end
			else
				if not connected then
					darkrp_keep_pocket[ply:SteamID()] = nil
				end
				ply:RemovePData( addon_name )
			end
		end
	end
	local function HoldContentForConnectedPlayer( ply )
		timer.Simple( 0., function()
			if not IsValid( ply ) then return end
			HoldContentForPlayer( ply, true )
		end )
	end
	hook.Add( "onPocketItemAdded", addon_name, HoldContentForConnectedPlayer )
	hook.Add( "onPocketItemRemoved", addon_name, HoldContentForConnectedPlayer )
	-- hook.Add( "onPocketItemDropped", addon_name, HoldContentForConnectedPlayer ) -- not needed: this calls onPocketItemRemoved
	local function HoldContentForDisconnectedPlayer( ply )
		HoldContentForPlayer( ply, false )
	end
	hook.Add( "PlayerDisconnected", addon_name, HoldContentForDisconnectedPlayer )
end
hook.Add( "loadCustomDarkRPItems", addon_name, loadCustomDarkRPItems ) -- guarantee that the gamemode is DarkRP
if darkrp_keep_pocket then
	loadCustomDarkRPItems() -- Lua refresh
end
