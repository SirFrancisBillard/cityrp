AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crafting Bench"
ENT.Category = "Weapon Crafting"
ENT.Spawnable = true
ENT.Model = "models/props_combine/breendesk.mdl"

local RECIPE_PISTOL = {scrap = 4, springs = 1}
local RECIPE_SMG = {scrap = 8, springs = 2, illegal_parts = 1}
local RECIPE_SHOTGUN = {scrap = 10, springs = 1}
local RECIPE_RIFLE = {scrap = 10, springs = 4, illegal_parts = 2}
local RECIPE_SNIPER = {scrap = 20, springs = 4, illegal_parts = 4}

local Recipes = {
	["lite_ak47"] = RECIPE_RIFLE
}

if CLIENT then
	surface.CreateFont("LargeWeaponFont", {font = "Arial", size = 75, weight = 500, antialias = true, shadow = true})
	surface.CreateFont("SmallWeaponFont", {font = "Arial", size = 50, weight = 500, antialias = true, shadow = true})
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	end

	self:PhysWake()
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Scrap")
	self:NetworkVar("Int", 1, "Springs")
	self:NetworkVar("Int", 2, "IllegalParts")
	self:NetworkVar("Int", 3, "CraftingStatus")
	self:NetworkVar("String", 3, "CraftWeapon")
end

if SERVER then
	function ENT:StartTouch(cosby)
		if IsValid(cosby) and cosby.CraftingIngredient then
			if cosby.CraftingIngredient == "scrap" then
				self:SetScrap(self:GetScrap() + 1)
				SafeRemoveEntity(cosby)
			end
			if cosby.CraftingIngredient == "spring" then
				self:SetSprings(self:GetSprings() + 1)
				SafeRemoveEntity(cosby)
			end
			if cosby.CraftingIngredient == "illegal_parts" then
				self:SetIllegalParts(self:GetIllegalParts() + 1)
				SafeRemoveEntity(cosby)
			end
		end
	end

	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			local wep = caller:GetActiveWeapon()

			if self:GetCraftWeapon() and IsValid(wep) then
				if not caller:HasWeapon(self:GetCraftWeapon()) then
					self:SetCraftWeapon("")
					caller:Give(self:GetCraftWeapon(), true)
				end
				if Recipes[wep:GetClass()] and not self:GetCraftWeapon() then
					self:SetCraftWeapon(wep:GetClass())
					caller:StripWeapon(wep:GetClass())
				end
			elseif IsValid(wep) and Recipes[wep:GetClass()] then
				self:SetCraftWeapon(wep:GetClass())
				caller:StripWeapon(wep:GetClass())
			end
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local Ang = self:GetAngles()
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), -90)

		local is_queued = LocalPlayer():GetBRStatus() == BR_STATUS_QUEUED

		cam.Start3D2D(self:GetPos() + (self:GetUp() * 100), Ang, 0.35)
			draw.SimpleTextOutlined("Battle Royale", "Trebuchet24", 0, 0, Color(255, 0,0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
			draw.SimpleTextOutlined(is_queued and "In queue" or "Queue up to play", "Trebuchet24", 0, 40, Color(255, 0,0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(25, 25, 25))
		cam.End3D2D()
	end
end
