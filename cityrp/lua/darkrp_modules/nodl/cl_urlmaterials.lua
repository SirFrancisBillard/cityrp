
-- modified for ttt, now used in cityrp #NoSimplerr#

local dir = "downloaded_assets"

file.CreateDir(dir)

local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local crc = util.CRC

function TextureURL(url)
	if not url then return "error.png" end

	local path = dir .. "/" .. crc(url) .. ".png"

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

	if exists(dir .. "/" .. crc .. ".png", "DATA") then
		mats[url] = Material("data/" .. dir .. "/" .. crc .. ".png")

		return mats[url]
	end

	mats[url] = _error

	fetch(url, function(data)
		write(dir .. "/" .. crc .. ".png", data)
		mats[url] = Material("data/" .. dir .. "/" .. crc .. ".png")
	end)

	return mats[url]
end
