AddCSLuaFile()

SWEP.PrintName = "Ziptied"
SWEP.Instructions = "Primary fire to struggle."

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Spawnable = true	
SWEP.AdminSpawnable = true
SWEP.Category = "RP"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""

SWEP.UseHands = true

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "Struggle")
end

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DEPLOY)
end

function SWEP:Holster()
	if SERVER then
		self.Owner:ChatPrint("You are ziptied!")
	end
	return false
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	self:SetStruggle(self:GetStruggle() + math.random(2, 14))
	if self:GetStruggle() >= 100 then
		local ply = self.Owner
		ply:StripWeapon(self.ClassName)
		ply:EmitSound("physics/cardboard/cardboard_box_impact_hard" .. math.random(7) .. ".wav")
		ply:ConCommand("lastinv")
	end
end

function SWEP:SecondaryAttack() end

if CLIENT then
	function SWEP:DrawHUD()
		local w = ScrW()
		local h = ScrH()
		local x, y, width, height = w / 2 - w / 10, h / 2 - 60, w / 5, h / 15
		draw.RoundedBox(8, x, y, width, height, Color(10, 10, 10, 120))

		local status = math.Clamp(self:GetStruggle() / 100, 0, 1)
		local BarWidth = status * (width - 16)
		local cornerRadius = math.Min(8, BarWidth / 3 * 2 - BarWidth / 3 * 2 % 2)
		draw.RoundedBox(cornerRadius, x + 8, y + 8, BarWidth, height - 16, Color(255 - (status * 255), 0 + (status * 255), 0, 255))
		if isfunction(draw.DrawNonParsedSimpleText) then
			draw.DrawNonParsedSimpleText("Struggle", "Trebuchet24", w / 2, y + height / 2, color_white, 1, 1)
		end
	end

	return
end

function SWEP:Think()
	self:SetStruggle(math.max(self:GetStruggle() - 1, 0))
	self:NextThink(CurTime() + 1)
	return true
end
