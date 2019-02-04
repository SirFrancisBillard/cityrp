
local url = "https://2static1.fjcdn.com/comments/Blank+_0f27c59a7fe0b719bf641f43325a096a.png"
local mat = MaterialURL(url)

timer.Simple(4, function()
	print("Dim from IMat: " .. tostring(mat:Width()) .. ", " .. tostring(mat:Height()))
end)
