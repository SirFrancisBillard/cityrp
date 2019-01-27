
local repo = "https://api.codetabs.com/v1/loc?github=sirfrancisbillard/cityrp"
local delay = 600 * 4
local LastShownLOC = 0

local Green = Color(100, 255, 100)
local White = Color(255, 255, 255)

hook.Add("Think", "ShowLoC", function()
	if CurTime() - LastShownLOC > delay then
		LastShownLOC = CurTime()
		http.Fetch(repo, function(body, len, headers, code)
			local tab = util.JSONToTable(body)
			chat.AddText(White, "Right now, our server is running ", Green, string.Comma(tab[#tab].lines), White, " lines of custom code.")
		end)
	end
end)
