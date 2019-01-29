AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Loot"
ENT.Category = "Battle Royale"
ENT.Spawnable = true
ENT.Model = "models/Items/item_item_crate.mdl"

local COMMON = 1
local RARE = 2
local EPIC = 3

local Loot = {
	[COMMON] = {
		"lite_beretta",
		"lite_deagle",
		"lite_mac10",
		"lite_hegrenade",
	},
	[RARE] = {
		"lite_ak47",
		"lite_m4a1",
		"lite_m3",
		"lite_xm1014",
		"lite_p90",
		"lite_scout"
	},
	[EPIC] = { -- ok now this is epic
		"lite_m249",
		"lite_awp",
		"lite_g3sg1",
		"lite_sg550",
		"weapon_flamethrower",
		"weapon_grenadelauncher",
		"weapon_stickylauncher",
		"weapon_rocketlauncher"
	}
}

local RarityColors = {
	[COMMON] = Color(20, 180, 80),
	[RARE] = Color(30, 30, 150),
	[EPIC] = Color(255, 195, 0)
}

local function RandomRarity()
	local randy = math.random(10)
	if randy > 9 then
		return EPIC
	elseif randy > 6 then
		return RARE
	end
	return COMMON
end

local function RandomLoot(rarity)
	return Loot[rarity][math.random(#Loot[rarity])]
end

local function GiveWepAmmo(ply, wep)
	local tab = weapons.GetStored(wep)
	if not istable(wep) then return end
	local ammo = tab.Primary.Ammo
	if not ammo or string.lower(ammo) == "none" then return end
	ply:GiveAmmo(30, ammo, true)
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetRarity(RandomRarity()) -- only do random stuff on the server
	end

	self:PhysWake()
	self:SetColor(RarityColors[self:GetRarity()])
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Rarity")
end

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			local wep = RandomLoot(self:GetRarity())
			caller:Give(wep)
			GiveWepAmmo(caller, wep)
			SafeRemoveEntity(self)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
