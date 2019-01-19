
-- #NoSimplerr#

local repo = "https://api.codetabs.com/v1/loc?github=sirfrancisbillard/cityrp"
local delay = 600
local LastShownLOC = 0

local Green = Color(100, 255, 100)
local Blue = Color(100, 100, 255)

hook.Add("Think", "TellPeopleHowMuchWorkIPutIntoThisShit", function()
	if CurTime() - LastShownLOC > delay then
		LastShownLOC = CurTime()
		http.Fetch(repo, function(body, len, headers, code)
			local tab = util.JSONToTable(body)
			PrintTable(tab) -- debug
			chat.AddText(Blue, "Right now, our server is running ", Green, string.Comma(tab[#tab].lines), Blue, " lines of custom code.")
		end)
	end
end)
