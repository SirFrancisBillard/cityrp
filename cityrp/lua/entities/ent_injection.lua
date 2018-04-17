AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "cityrp_base"
ENT.PrintName = "Injection"
ENT.Category = "Black Market"
ENT.Spawnable = true
ENT.Model = "models/props_c17/TrapPropeller_Lever.mdl"

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if caller:Health() >= caller:GetMaxHealth() * 4 then
				caller:ChatPrint("You already have " .. caller:Health() .. " health!")
			else
				caller:SetHealth(caller:GetMaxHealth() * 4)
				caller:SetNWBool("tripping_balls", true)
				self:EmitSound(Sound("items/medshot4.wav"))
				SafeRemoveEntity(self)
			end
		end
	end
end

local tripping_shader = Material("pp/texturize/rainbow.png")
local shader_scale = 1

if CLIENT then
	hook.Add("RenderScreenspaceEffects", "TrippingBallsEffects", function()
		if LocalPlayer():GetNWBool("tripping_balls") then
			DrawTexturize(shader_scale, tripping_shader)
		end
	end)
end
