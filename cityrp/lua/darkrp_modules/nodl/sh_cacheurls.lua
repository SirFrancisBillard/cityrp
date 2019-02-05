
-- Put links of sounds to cache in here
-- All URLs *MUST* be cached on both client AND server!

local prefix = "https://sirfrancisbillard.github.io/billard-radio/sound/"
local suffix = ".mp3"

local SoundURLs = {
	"jihad/jihad_1",
	"jihad/jihad_2",
	"jihad/islam", -- salil a sawarim
	"misc/headshot",
	"misc/heil",
	"misc/taser",
	"memes/roblox",
	"zoo_of_idiots/ligma",
	"bullet_time/slowmo_start",
	"bullet_time/slowmo_end",
	"gross/vomit1",
	"gross/vomit2",
	"russian_music/boyohboy",
	"tennis/bounce",
	"tennis/hit",
}

-- Actual code below this line

local function PrecacheURLs()
	for _, v in ipairs(SoundURLs) do
		BroadcastURL.CacheURL(prefix .. v .. suffix)
	end
end

hook.Add("Initialize", "BroadcastURL.PrecacheURLS", PrecacheURLs)
hook.Add("OnReloaded", "BroadcastURL.PrecacheURLS", PrecacheURLs)
