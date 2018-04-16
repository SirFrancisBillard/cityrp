AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Stickybomb"

ENT.Spawnable = false
ENT.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"

ENT.IsStickyBomb = true

local SplodeDamage = 60
local SplodeRadius = 250
local SplodeDelay = 0.8

local color_white = color_white or Color(255, 255, 255)
local color_red = Color(255, 0, 0)

local SpriteMat = Material("sprites/light_glow02_add")
local BeepSound = Sound("c4.click")

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetModelScale(0.2)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysicsInitSphere(1, "metal")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysWake()

		util.SpriteTrail(self, 0, color_white, false, 4, 1, 0.3, 0.1, "trails/smoke.vmt")

		self.prime_time = CurTime() + SplodeDelay
	end

	function ENT:Detonate()
		local boom = EffectData()
		boom:SetOrigin(self:GetPos())
		boom:SetFlags(4)
		util.Effect("Explosion", boom, true, true)

		self:EmitSound(Sound("Arena.Explosion"))

		util.BlastDamage(self, self.Owner, self:GetPos(), SplodeRadius, SplodeDamage)

		self:Remove()
	end

	function ENT:Fizzle()
		local spark = EffectData()
		spark:SetOrigin(self:GetPos())
		util.Effect("CrossbowLoad", spark, true, true)

		self:Remove()
	end

	function ENT:PhysicsCollide(data, phys)
		if not IsValid(data.HitEntity) then
			self:SetMoveType(MOVETYPE_NONE)
		end
	end

	function ENT:OnTakeDamage(dmg)
		if dmg:GetInflictor().IsStickyBomb then return end
		self:Fizzle()
	end

	function ENT:Think()
		local ply = self:GetOwner()
		if not IsValid(ply) then
			self:Fizzle()
		end
		if not ply:Alive() then
			self:Fizzle()
		end
		if ply:KeyDown(IN_ATTACK2) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().IsStickyLauncher then
			ply:EmitSound(BeepSound)
			self:Detonate()
		end
		self:NextThink(CurTime() + 0.04)
		return true
	end
else -- CLIENT
	function ENT:Draw()
		render.SetMaterial(SpriteMat)
		render.DrawSprite(self:GetPos(), 24, 24, self:GetOwner() == LocalPlayer() and color_white or color_red)

		self:DrawModel()
	end
end
