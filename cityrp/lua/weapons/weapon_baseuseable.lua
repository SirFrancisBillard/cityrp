AddCSLuaFile()

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Base Useable Item"

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.Spawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.TargetIsPlayer = true
SWEP.RangeSquared = 10000
SWEP.UseSound = Sound("physics/metal/chain_impact_hard1.wav")
SWEP.UseText = "USE ITEM"
SWEP.UseColor = Color(255, 0, 0)
SWEP.ConsumeOnUse = false

-- to be overriden (or not)
function SWEP:CanUse(target)
	return true
end

function SWEP:OnUse(target)
	self.Owner:ChatPrint("Used item on " .. target:Nick() .. ".")
end

-- helper function
local function BaseCanUse(ent)
	if SERVER then ent.Owner:LagCompensation(true) end
	local trace = ent.Owner:GetEyeTrace()
	if SERVER then ent.Owner:LagCompensation(false) end
	local target = trace.Entity
	if not IsValid(target) or (ent.TargetIsPLayer and not target:IsPlayer()) or target:GetPos():DistToSqr(ent.Owner:GetPos()) > ent.RangeSquared then
		return false
	end
	return ent:CanUse(target)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.5)

	if not BaseCanUse(self) then return end

	if SERVER then
		self.Owner:EmitSound(self.UseSound)
		self:OnUse(ent)
		if self.ConsumeOnUse then
			self.Owner:StripWeapon(self.ClassName)
		end
	end
end

function SWEP:SecondaryAttack() end
function SWEP:Think() end

function SWEP:DrawHUD()
	local tr = self.Owner:GetEyeTrace()
	if BaseCanUse(self) then
		local x = ScrW() / 2
		local y = ScrH() / 2

		surface.SetDrawColor(self.UseColor)

		local outer = 20
		local inner = 10
		surface.DrawLine(x - outer, y - outer, x - inner, y - inner)
		surface.DrawLine(x + outer, y + outer, x + inner, y + inner)

		surface.DrawLine(x - outer, y + outer, x - inner, y + inner)
		surface.DrawLine(x + outer, y - outer, x + inner, y - inner)

		draw.SimpleText(self.UseText, "TabLarge", x, y - 30, self.UseColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
end
