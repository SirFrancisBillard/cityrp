AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Thrown Flame"

ENT.Spawnable = false
ENT.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"

local StickTime = 5
local BurnRadius = 32

local color_white = color_white or Color(255, 255, 255)
local color_orange = Color(255, 128, 0)

local SpriteMat = Material("sprites/light_glow02_add")

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetModelScale(0.2)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysicsInitSphere(1, "gmod_silent")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysWake()
		self:DrawShadow(false)

		self:Ignite(9999)
	end

	local UnfreezeProps = {
		["prop_physics"] = true,
		["prop_physics_multiplayer"] = true,
		["prop_physics_override"] = true,
	}

	local OpenDoor = {
		["func_door"] = true,
		["func_door_rotating"] = true,
		["prop_door"] = true,
		["prop_door_rotating"] = true,
	}

	local BurnTime = 12

	function ENT:PhysicsCollide(data, phys)
		if IsValid(data.HitEntity) then
			local ent = data.HitEntity
			local dmg = DamageInfo()
			dmg:SetDamage(15)
			dmg:SetAttacker(self:GetOwner())
			dmg:SetInflictor(self)
			dmg:SetDamageType(DMG_BURN)
			ent:TakeDamageInfo(dmg)
			ent:Ignite(BurnTime)
			local cls = ent:GetClass()
			if UnfreezeProps[cls] or OpenDoor[cls] then
				timer.Simple(BurnTime, function()
					if not IsValid(ent) then return end
					if ent.BurnDownHealth == nil then ent.BurnDownHealth = 60 end
					ent.BurnDownHealth = ent.BurnDownHealth - 1
					if ent.BurnDownHealth < 0 then
						ent.BurnDownHealth = 60
						if UnfreezeProps[cls] then
							local phys = ent:GetPhysicsObject()
							if IsValid(phys) then
								phys:EnableMotion(true)
							end
						elseif OpenDoor[cls] then
							ent:Fire("unlock")
							ent:Fire("open")
						end
					end
				end)
			end
			SafeRemoveEntity(self)
		elseif not self.landed then
			self:GetPhysicsObject():EnableMotion(false)
			self:Extinguish()
			self:Ignite(StickTime, BurnRadius)
			self.landed = CurTime()
		end
	end

	function ENT:Think()
		if self.landed and CurTime() - self.landed > StickTime then
			SafeRemoveEntity(self)
		end
		self:NextThink(CurTime() + 0.1)
		return true
	end
end
