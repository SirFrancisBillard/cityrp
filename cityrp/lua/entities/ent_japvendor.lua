AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Japanese Vending Machine"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/props_interiors/VendingMachineSoda01a.mdl"

local CoinSound = Sound("ambient/office/coinslot1.wav")
local Price = 20
local WepList = {
	"weapon_jap_pant",
	"weapon_jap_chips",
	"weapon_jap_cola",
	"weapon_jap_milk"
}

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:PhysWake()
	end

	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			if not caller:canAfford(Price) then
				caller:ChatPrint("You're piss poor!")
				return
			end

			local HasAll = true
			for k, v in pairs(WepList) do
				HasAll = HasAll and caller:HasWeapon(v)
			end

			if HasAll then
				caller:ChatPrint("You already have everything from this machine!")
				return
			end

			local wep = WepList[math.random(#WepList)]
			while not caller:HasWeapon(wep) do
				wep = WepList[math.random(#WepList)]
			end

			caller:Give(wep)
			caller:addMoney(-Price)
			self:EmitSound(CoinSound)
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end
