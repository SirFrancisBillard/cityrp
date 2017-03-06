
local UseHintOverrides = {
	["spawned_money"] = "Take"
}

local HintColor = Color(255, 255, 255, 0)
local OutlineColor = Color(0, 0, 0, 0)

hook.Add("HUDPaint", "DrawUseHints", function()
	local tr = LocalPlayer():GetEyeTrace()
	local halfScrH = ScrH() / 2
	local halfScrW = ScrW() / 2
	local trent = tr.Entity
	if IsValid(trent) and trent:GetPos():Distance(LocalPlayer():EyePos()) <= 200 and (istable(scripted_ents.Get(trent:GetClass())) or not isstring(trent.Base)) then
		local a = Lerp(FrameTime(), HintColor.a, 255)
		HintColor.a = a
		OutlineColor.a = a
		local key = input.LookupBinding("+use"):upper() or "E"
		local action = UseHintOverrides[trent:GetClass()] or trent.Action or "Use"

		draw.SimpleTextOutlined(key .. ": " .. action, "F4MenuFont01", halfScrW, halfScrH - (halfScrH / 10), HintColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, OutlineColor)
	else
		HintColor.a = 0
		OutlineColor.a = 0
	end
end)
