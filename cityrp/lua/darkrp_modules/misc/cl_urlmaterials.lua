
-- modified for ttt, now used in cityrp #NoSimplerr#

file.CreateDir("downloaded_assets")

local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local crc = util.CRC

function TextureURL(url)
	if not url then return "error.png" end

	local path = "downloaded_assets/" .. crc(url) .. ".png"

	if not exists(path, "DATA") then
		fetch(url, function(data)
			write(path, data)
		end)
	end

	return "data/" .. path
end

local _error = Material("error")
local mats = {}

function MaterialURL(url)
	if not url then return _error end

	if mats[url] then
		return mats[url]
	end

	local crc = crc(url)

	if exists("downloaded_assets/" .. crc .. ".png", "DATA") then
		mats[url] = Material("data/downloaded_assets/" .. crc .. ".png")

		return mats[url]
	end

	mats[url] = _error

	fetch(url, function(data)
		write("downloaded_assets/" .. crc .. ".png", data)
		mats[url] = Material("data/downloaded_assets/" .. crc .. ".png")
	end)

	return mats[url]
end
