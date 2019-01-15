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

function ENT:Initialize()
	local srand = util.SharedRandom("billard", 0, #self.Models)
	self:SetModel(self.Models[srand])
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:PhysicsInit(SOLID_VPHYSICS)
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

	self:PhysWake()
end
