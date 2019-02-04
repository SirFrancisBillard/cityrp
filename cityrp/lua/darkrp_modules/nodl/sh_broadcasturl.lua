
----------------------------------------------------
------------------- BroadcastURL -------------------
---- Serverside implementation of sound.PlayURL ----
-------------- By Sir Francis Billard --------------
----------------------------------------------------

local prefix = "[BroadcastURL] "
local bits = 16
local CachedURLs = {}
local CachedIDs = {}
local CacheIndex = 1

BroadcastURL = {}

BroadcastURL.CacheURL = function(url)
	if CachedURLs[url] then
		print(prefix .. "Repeated cache of " .. url .. "! Ignoring...")
	end
	print(prefix .. " Cached sound " .. url .. " with id " .. CacheIndex)
	CachedURLs[url] = CacheIndex
	CachedIDs[CacheIndex] = url
	CacheIndex = CacheIndex + 1
	if CLIENT then
		BroadcastURL.InitializeChannel(url)
	end
end
	
BroadcastURL.GetCachedURL = function(id)
	if CachedIDs[id] then
		return CachedIDs[id]
	end
	print(prefix .. "Attempted to retrieve URL of invalid ID " .. id .. "!")
end

if SERVER then
	util.AddNetworkString("BroadcastURL")
	util.AddNetworkString("CachedBroadcastURL")

	function EmitSoundURL(url, pos)
		if not CachedURLs[url] then
			print(prefix .. "Uncached play of " .. url .. "! Please cache your URLs!")
			net.Start("BroadcastURL")
			net.WriteString(url)
			net.WriteVector(pos)
			net.Broadcast()
			return
		end

		net.Start("CachedBroadcastURL")
		net.WriteInt(CachedURLs[url], bits)
		net.WriteVector(pos)
		net.Broadcast()
	end

	local ENTITY = FindMetaTable("Entity")

	function ENTITY:EmitSoundURL(url)
		EmitSoundURL(url, self:GetPos())
	end
else
	BroadcastURL.Channels = BroadcastURL.Channels or {}

	local function try_url(url, i)
		if i > 10 then
			MsgC(Color(255, 0, 0), prefix .. "Failed to create audio channel for " .. url .. "\n")
			return
		end
		sound.PlayURL(url, "3d noblock noplay", function(station)
			if IsValid(station) then
				MsgC(Color(0, 255, 0), prefix .. "Succesfully created audio channel for " .. url .. "\n")
				BroadcastURL.Channels[url] = station
			else
				return try_url(url, i + 1)
			end
		end)
	end

	BroadcastURL.InitializeChannel = function(url)
		try_url(url, 0)
	end

	BroadcastURL.PlayURL = function(url, pos)
		local channel = BroadcastURL.Channels[url]
		if not IsValid(channel) then return end
		channel:SetTime(0)
		channel:SetPos(pos)
		channel:Play()
	end

	net.Receive("BroadcastURL", function(len)
		local url = net.ReadString()
		local pos = net.ReadVector()
		BroadcastURL.PlayURL(url, pos)
	end)

	net.Receive("CachedBroadcastURL", function(len)
		local id = net.ReadInt(bits)
		local url = BroadcastURL.GetCachedURL(id)
		local pos = net.ReadVector()
		BroadcastURL.PlayURL(url, pos)
	end)
end
