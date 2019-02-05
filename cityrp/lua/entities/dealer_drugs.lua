AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "dealer_base"

ENT.PrintName = "Drug Dealer"
ENT.Category = "NPCs"
ENT.Spawnable = true

ENT.Model = "models/player/guerilla.mdl"
ENT.Description = "Bring me drugs for cash."
ENT.TextColor = Color(200, 200, 200)
ENT.Animation = "menu_combine"
ENT.SellItems = {
	["meth"] = true,
	["heroin"] = true,
	["cocaine"] = true,
	["weed"] = true,
	["lsd"] = true,
}
