AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "dealer_base"

ENT.PrintName = "Lumberjack"
ENT.Category = "NPCs"
ENT.Spawnable = true

ENT.Model = "models/player/guerilla.mdl"
ENT.Description = "Bring me lumber for cash."
ENT.TextColor = Color(200, 200, 0)
ENT.Animation = "menu_combine"
ENT.SellItems = {
	["lumber"] = true,
}
