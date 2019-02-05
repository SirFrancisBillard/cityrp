AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "dealer_base"

ENT.PrintName = "ISIS Recruiter"
ENT.Category = "NPCs"
ENT.Spawnable = true

ENT.Model = "models/player/guerilla.mdl"
ENT.Description = "Take the quiz today!"
ENT.TextColor = Color(255, 0, 0)
ENT.Animation = "menu_combine"

if SERVER then
	function ENT:Use(activator, caller)
		caller:SendLua("TakeTerroristQuiz()")
	end
end
