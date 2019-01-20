
-- YOU WOULDN'T STEAL A CAR #NoSimplerr#

function SearchAndPlaySong(query)
	local serialized = string.Replace(query, "", "+")
	http.Fetch("https://musicpleeer.com/#!" .. serialized,
	function(body, len, headers, code)
		print(body)
	end,
	function(error)
	end)
end
