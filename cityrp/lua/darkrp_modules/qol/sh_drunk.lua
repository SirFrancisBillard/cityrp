
local PLAYER = FindMetaTable("Player")

function PLAYER:SetDrunkenness(amt)
	return self:SetNWInt("drunkenness", amt)
end

function PLAYER:GetDrunkenness()
	return self:GetNWInt("drunkenness", 0)
end

function PLAYER:AddDrunkenness(amt)
	return self:SetDrunkenness(self:GetDrunkenness() + amt)
end

function PLAYER:SoberUp()
	return self:SetDrunkenness(0)
end

if CLIENT then
	hook.Add("RenderScreenspaceEffects", "DrunkenMotionBlur", function()
		local drunk = LocalPlayer():GetDrunkenness()
		if drunk > 0 then
			local frac = math.Clamp(drunk, 0, 100) / 500
			DrawMotionBlur(0.1, 0.7, frac)
		end
	end)
end
