AddCSLuaFile()

game.AddAmmoType({name = "zipties"})
if CLIENT then
	language.Add("zipties_ammo", "Zipties")
end

SWEP.Base = "weapon_sck_base"

SWEP.PrintName = "Zipties"
SWEP.Instructions = "<color=green>[PRIMARY FIRE]</color> Tie someone up."

SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.Spawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "zipties"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.HoldType = "normal"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = ""
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
}

SWEP.VElements = {
	["ties"] = {type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.844, 2.755, 0.797), angle = Angle(-97.581, -61.209, 56.716), size = Vector(0.912, 1.029, 0.953), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["ties"] = {type = "Model", model = "models/Items/CrossbowRounds.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.151, 1.075, -2.597), angle = Angle(106.364, 66.593, -1.293), size = Vector(0.912, 1.029, 0.953), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WepSelectIcon = WeaponIconURL("zipties")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsTying")
	self:NetworkVar("Float", 0, "StartTie")
	self:NetworkVar("Float", 1, "EndTie")
	self:NetworkVar("Float", 2, "NextSoundTime")
	self:NetworkVar("Int", 0, "TotalTies")
end

function SWEP:PrimaryAttack()
	if self:GetIsTying() then return end
	self:SetNextPrimaryFire(CurTime() + 0.3)

	self:GetOwner():LagCompensation(true)
	local trace = self:GetOwner():GetEyeTrace()
	self:GetOwner():LagCompensation(false)

	if not IsValid(trace.Entity) or not trace.Entity:IsPlayer() or trace.Entity:GetPos():DistToSqr(self:GetOwner():GetPos()) > 10000 then
		return
	end

	self:SetIsTying(true)
	self:SetStartTie(CurTime())
	self:SetEndTie(CurTime() + 4)

	self:SetNextSoundTime(CurTime() + 0.5)

	if CLIENT then
		self.Dots = ""
		self.NextDotsTime = CurTime() + 0.5
	end
end

function SWEP:Holster()
	self:SetIsTying(false)
	self:SetNextSoundTime(0)
	return self.BaseClass.Holster(self)
end

function SWEP:Succeed(ply)
	if not IsValid(self.Owner) then return end
	self:SetIsTying(false)

	if CLIENT then return end

	ply:Give("weapon_ziptied")
	ply:SelectWeapon("weapon_ziptied")

	self.Owner:RemoveAmmo(1, self.Primary.Ammo)
	if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self:SendWeaponAnim(ACT_VM_DRAW)
	else
		self.Owner:ConCommand("lastinv")
		self.Owner:StripWeapon(self.ClassName)
	end

	DarkRP.notify(self.Owner, 1, 4, "You have tied " .. ply:Nick() .. "!")
end

function SWEP:Fail()
	self:SetHoldType("normal")
	if CLIENT then return end
	self:SetIsTying(false)
	self:SetNextSoundTime(0)
	DarkRP.notify(self.Owner, 1, 4, "Tying failed!")
end

function SWEP:Think()
	if self:GetIsTying() and self:GetEndTie() ~= 0 then
		self:GetOwner():LagCompensation(true)
		local trace = self:GetOwner():GetEyeTrace()
		self:GetOwner():LagCompensation(false)
		if not IsValid(trace.Entity) or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 or not trace.Entity:IsPlayer() then
			self:Fail()
		end
		if self:GetEndTie() <= CurTime() then
			self:Succeed(trace.Entity)
		end
	end
    if self:GetNextSoundTime() ~= 0 and CurTime() >= self:GetNextSoundTime() then
		if self:GetIsTying() then
			self:SetNextSoundTime(CurTime() + 0.5)
			self:EmitSound("npc/combine_soldier/gear5.wav", 100, 100)
		else
			self:SetNextSoundTime(0)
			self:EmitSound("npc/combine_soldier/gear5.wav", 50, 100)
		end
	end
	if CLIENT and self.NextDotsTime and CurTime() >= self.NextDotsTime then
		self.NextDotsTime = CurTime() + 0.5
		self.Dots = self.Dots or ""
		local len = string.len(self.Dots)
		local dots = {
			[0] = ".",
			[1] = "..",
			[2] = "...",
			[3] = ""
		}
		self.Dots = dots[len]
	end
end

function SWEP:DrawHUD()
	if self:GetIsTying() and self:GetEndTie() ~= 0 then
		self.Dots = self.Dots or ""
		local w = ScrW()
		local h = ScrH()
		local x, y, width, height = w / 2 - w / 10, h / 2, w / 5, h / 15
		local time = self:GetEndTie() - self:GetStartTie()
		local curtime = CurTime() - self:GetStartTie()
		local status = math.Clamp(curtime / time, 0, 1)
		local BarWidth = status * (width - 16)
		local cornerRadius = math.Min(8, BarWidth / 3 * 2 - BarWidth / 3 * 2 % 2)

		draw.RoundedBox(8, x, y, width, height, Color(10, 10, 10, 120))
		draw.RoundedBox(cornerRadius, x + 8, y + 8, BarWidth, height - 16, Color(0, 0 + (status * 255), 255 - (status * 255), 255))
		draw.DrawNonParsedSimpleText("Tying" .. self.Dots, "Trebuchet24", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
	end
end
