local fetch = http.Fetch
local idto64 = util.SteamIDTo64
local idtoid = util.SteamIDFrom64
local countrycodes = util.JSONToTable(([[{"Grenada":"gd","Honduras":"hn","Guatemala":"gt","Japan":"jp","Liberia":"lr","Indonesia":"id","Barbados":"bb","Denmark":"dk","Afghanistan":"af","Colombia":"co","French Polynesia":"pf","British Indian Ocean Territory":"io","Yemen":"ye","French Southern Territories":"tf","Singapore":"sg","Gibraltar":"gi","Zambia":"zm","Rwanda":"rw","Mozambique":"mz","Western Sahara":"eh","Micronesia (Federated States of)":"fm","Virgin Islands (U.S.)":"vi","Ecuador":"ec","Virgin Islands (British)":"vg","Guyana":"gy","Paraguay":"py","Viet Nam":"vn","Nicaragua":"ni","Bosnia and Herzegovina":"ba","Turks and Caicos Islands":"tc","Vanuatu":"vu","Guam":"gu","El Salvador":"sv","Aruba":"aw","Monaco":"mc","Turkmenistan":"tm","Slovakia":"sk","Somalia":"so","Uruguay":"uy","Czech Republic":"cz","Macao":"mo","United States Minor Outlying Islands":"um","United States of America":"us","Burundi":"bi","New Caledonia":"nc","Cabo Verde":"cv","Cameroon":"cm","United Kingdom of Great Britain and Northern Ireland":"gb","Egypt":"eg","Angola":"ao","Korea (Republic of)":"kr","United Arab Emirates":"ae","Romania":"ro","Åland Islands":"ax","Saint Barthélemy":"bl","Saint Lucia":"lc","Falkland Islands (Malvinas)":"fk","Pakistan":"pk","Uganda":"ug","Switzerland":"ch","Gabon":"ga","Tuvalu":"tv","Benin":"bj","Uzbekistan":"uz","American Samoa":"as","Kazakhstan":"kz","Turkey":"tr","Mali":"ml","Trinidad and Tobago":"tt","Anguilla":"ai","Tokelau":"tk","Nauru":"nr","Latvia":"lv","Palau":"pw","Thailand":"th","Belarus":"by","Mauritius":"mu","Congo (Democratic Republic of the)":"cd","Estonia":"ee","Tanzania, United Republic of":"tz","Tajikistan":"tj","Taiwan, Province of China":"tw","India":"in","Isle of Man":"im","Guinea-Bissau":"gw","Bulgaria":"bg","Lao People's Democratic Republic":"la","Iran (Islamic Republic of)":"ir","Marshall Islands":"mh","Finland":"fi","Palestine, State of":"ps","Mexico":"mx","Saint Martin (French part)":"mf","Norway":"no","Jersey":"je","Swaziland":"sz","Ireland":"ie","Svalbard and Jan Mayen":"sj","Sierra Leone":"sl","Mauritania":"mr","Kiribati":"ki","Solomon Islands":"sb","Spain":"es","Niger":"ne","Armenia":"am","Iraq":"iq","Guadeloupe":"gp","Comoros":"km","Malaysia":"my","South Africa":"za","Sri Lanka":"lk","Dominican Republic":"do","Greenland":"gl","Portugal":"pt","Sint Maarten (Dutch part)":"sx","Nigeria":"ng","Kyrgyzstan":"kg","Suriname":"sr","Seychelles":"sc","New Zealand":"nz","Netherlands":"nl","Croatia":"hr","Serbia":"rs","Malta":"mt","Jamaica":"jm","Bouvet Island":"bv","Norfolk Island":"nf","Chile":"cl","Fiji":"fj","Burkina Faso":"bf","Sao Tome and Principe":"st","San Marino":"sm","Italy":"it","Poland":"pl","Réunion":"re","Russian Federation":"ru","Saint Vincent and the Grenadines":"vc","Heard Island and McDonald Islands":"hm","Djibouti":"dj","Cook Islands":"ck","Iceland":"is","Saint Pierre and Miquelon":"pm","Myanmar":"mm","Antigua and Barbuda":"ag","Guinea":"gn","Montserrat":"ms","Liechtenstein":"li","Bonaire, Sint Eustatius and Saba":"bq","Saint Helena, Ascension and Tristan da Cunha":"sh","Cuba":"cu","Congo":"cg","Israel":"il","Bolivia (Plurinational State of)":"bo","Lithuania":"lt","Ukraine":"ua","Northern Mariana Islands":"mp","Cayman Islands":"ky","Bermuda":"bm","China":"cn","Kenya":"ke","Qatar":"qa","Puerto Rico":"pr","Slovenia":"si","Kuwait":"kw","Maldives":"mv","Martinique":"mq","Samoa":"ws","Panama":"pa","Australia":"au","Cambodia":"kh","Philippines":"ph","Jordan":"jo","South Sudan":"ss","Moldova (Republic of)":"md","Austria":"at","Pitcairn":"pn","Belgium":"be","Timor-Leste":"tl","Oman":"om","Niue":"nu","Peru":"pe","Venezuela (Bolivarian Republic of)":"ve","Saudi Arabia":"sa","Brazil":"br","Togo":"tg","Costa Rica":"cr","Saint Kitts and Nevis":"kn","Korea (Democratic People's Republic of)":"kp","Mayotte":"yt","Botswana":"bw","Morocco":"ma","Papua New Guinea":"pg","Ghana":"gh","Argentina":"ar","Haiti":"ht","Mongolia":"mn","Wallis and Futuna":"wf","Sweden":"se","Sudan":"sd","Syrian Arab Republic":"sy","Senegal":"sn","Lesotho":"ls","Tunisia":"tn","Libya":"ly","Côte d'Ivoire":"ci","Ethiopia":"et","Madagascar":"mg","Montenegro":"me","Central African Republic":"cf","Luxembourg":"lu","Hungary":"hu","Cocos (Keeling) Islands":"cc","Cyprus":"cy","Chad":"td","Georgia":"ge","Bahrain":"bh","Andorra":"ad","Greece":"gr","Macedonia (the former Yugoslav Republic of)":"mk","Bangladesh":"bd","Belize":"bz","South Georgia and the South Sandwich Islands":"gs","Eritrea":"er","Azerbaijan":"az","Brunei Darussalam":"bn","Bahamas":"bs","Albania":"al","France":"fr","Bhutan":"bt","Namibia":"na","Faroe Islands":"fo","Canada":"ca","Equatorial Guinea":"gq","Germany":"de","Malawi":"mw","Antarctica":"aq","Dominica":"dm","Tonga":"to","French Guiana":"gf","Lebanon":"lb","Zimbabwe":"zw","Curaçao":"cw","Holy See":"va","Nepal":"np","Guernsey":"gg","Algeria":"dz","Hong Kong":"hk","Gambia":"gm","Christmas Island":"cx"}]]):lower())

local function validatesteam(ste)
	if ste:match("76%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d") then
		return ste
	elseif ste:match("STEAM_%d.%d:%d%A+") then
		return idto64(ste)
	end

	return false
end

--[[
	returned Table structure:
			Base Data:
			         Name: <>
			  	    State: <>
			         ID64: <>
			      SteamID: <>
			    CustomURL: <>
			   AvatarMini: <>
			 AvatarMedium: <>
			  AvatarLarge: <>
			
			if NotPrivate:
				if inGameInfo and State:ingame :
						gameName:
					  gameBanner:
				if Location:
					locationString:
						   Country:
				   CountryFlagLink:
				  
]]
function util.SteamProfileFetch(steamid, func )
	local steamid = validatesteam(steamid)

	if not steamid then return false end
	fetch("http://steamcommunity.com/profiles/" .. steamid .. "/?xml=1", function(body)
		local tab = {}

		if storeraw then
			tab.RawData = body
		end

		tab.Name = body:match("<steamID><!%[CDATA%[.+%]%]></steamID>"):sub(19, -14)
		tab.ID64 = steamid
		tab.SteamID = idtoid(steamid)
		tab.State = body:match("<onlineState>.+</onlineState>"):sub(14, -15)
		local av = body:match("http://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/.-jpg"):sub(1, -5)
		tab.AvatarMini = av .. ".jpg"
		tab.AvatarMedium = av .. "_medium.jpg"
		tab.AvatarLarge = av .. "_large.jpg"

		local GAME = body:match("<inGameInfo>.+</inGameInfo>")
		if GAME then
			tab.GameInfo = {}
			tab.GameInfo.gameName = GAME:match("<gameName><!%[CDATA%[.-]]></gameName>"):sub( 20, -15 )
			tab.GameInfo.gameBanner = GAME:match("<gameIcon><!%[CDATA%[.-]]></gameIcon>"):sub( 20,-15 )
		end

		local LCT = body:match("<location>.+</location>")
		if LCT then
			tab.Location = {}
			tab.Location.str = LCT:match("<location><!%[CDATA%[.-]]></location>"):sub( 20, -15 )

			local str = tab.Location.str

			for i = #str, 1, -1 do
				if str:sub( i, i ) == " " and str:sub( i - 1, i - 1 ) == "," then
					tab.Location.Country = str:sub( i + 1 )
					break
				end
			end

			tab.Location.FlagDog = "http://steamcommunity-a.akamaihd.net/public/images/countryflags/" .. ( countrycodes[ (tab.Location.Country):lower() ] or "us" ) .. ".gif"
		end

		func( tab, body )
	end)
end
