
-- YOU WOULDN'T STEAL A CAR #NoSimplerr#

function SearchAndPlaySong(query)
	local serialized = string.Replace(query, " ", "+")
	print("https://musicpleeer.com/#!" .. serialized)
	http.Fetch("https://musicpleeer.com/#!" .. serialized, function(body, len, headers, code)
		print(body)
	end)
end
