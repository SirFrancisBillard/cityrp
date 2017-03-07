AddCSLuaFile()

game.AddAmmoType({name = "C4"})
if CLIENT then
	language.Add("C4_ammo", "Plastic Explosives")
end

SWEP.PrintName = "C4"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Instructions = "<color=green>[PRIMARY FIRE]</color> Plant C4 on a nearby surface."
SWEP.Purpose = "Destruction"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false

SWEP.Spawnable = true
SWEP.Category = "RP"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "C4"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType("slam")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.6)
	if SERVER then
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector(),
			filter = {self.Owner}
		})

		local c4 = ents.Create("ent_c4")
		c4:SetPos(tr.HitPos)
		c4:SetAngles(tr.HitNormal:Angle() - Angle(90, 180, 0))
		c4:Spawn()

		c4.ItemOwner = self.Owner

		if tr.Entity and IsValid(tr.Entity) then
			if tr.Entity:GetPhysicsObject():IsValid() then
				c4:SetParent(tr.Entity)
			elseif not tr.Entity:IsNPC() and not tr.Entity:IsPlayer() and tr.Entity:GetPhysicsObject():IsValid() then
				constraint.Weld(c4, tr.Entity)
			end
		else
			c4:SetMoveType(MOVETYPE_NONE)
		end

		hook.Call("PlayerPlaceC4", nil, self.Owner, tr.Entity)

		if not tr.Hit then
			c4:SetMoveType(MOVETYPE_VPHYSICS)
		end

		self.Owner:EmitSound("C4.PlantSound")

		self.Owner:RemoveAmmo(1, self.Primary.Ammo)
		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self:SendWeaponAnim(ACT_VM_DRAW)
		else
			self.Owner:ConCommand("lastinv")
			self.Owner:StripWeapon(self.ClassName)
		end
	end
end

function SWEP:SecondaryAttack() end
