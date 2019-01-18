AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Scrap Metal"
ENT.Category = "Weapon Crafting"
ENT.Spawnable = true

ENT.Models = {
	"models/props_vehicles/carparts_axel01a.mdl",
	"models/props_vehicles/carparts_door01a.mdl",
	"models/props_vehicles/carparts_muffler01a.mdl",
}
ENT.CraftingIngredient = "scrap"

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Models[math.random(#self.Models)])
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:PhysWake()
	end
end
