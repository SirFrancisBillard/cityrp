AddCSLuaFile()

SWEP.PrintName = "Car Bomb"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Plant bomb.
<color=green>[SECONDARY FIRE]</color> Change bomb type.
<color=green>[RELOAD]</color> Change bomb timer.]]
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.UseHands = true
SWEP.ViewModelFOV = 60

SWEP.SwayScale = 1
SWEP.DrawAmmo = false
SWEP.Slot = 4

SWEP.Primary.Ammo = "None"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "None"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "DetonateTime")
	self:NetworkVar("Int", 1, "ReloadSpamTime")
	self:NetworkVar("Int", 2, "PlantingProgress")
	self:NetworkVar("Bool", 0, "BombType")
	self:NetworkVar("Bool", 1, "Deploying")
	self:NetworkVar("Bool", 2, "Planting")
end

function SWEP:CanSecondaryAttack()
	return (self:GetNextSecondaryFire() < CurTime()) and (not self:GetDeploying())
end

function SWEP:CanPrimaryAttack()
	self.Owner:LagCompensation(true)
	local trent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)
	return (not self:GetDeploying()) and (not trent.HasCarBombPlanted) and IsValid(trent) and trent:IsVehicle() and (self.Owner:GetPos():Distance(trent:GetPos()) < 512)
end

function SWEP:Deploy()
	self:SetDeploying(true)
	self:SetHoldType("slam")
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	timer.Simple(self:SequenceDuration() + 0.1, function()
		if IsValid(self) then
			self:SetDeploying(false)
		end
	end)
	return true
end

function SWEP:Holster()
	self:SetPlanting(false)
	self:SetPlantingProgress(0)
	return true
end

function SWEP:Reload()
	if (self:GetReloadSpamTime() < CurTime()) then
		self:SetReloadSpamTime(CurTime() + 1)
		self:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
		if self:GetDetonateTime() < 26 then
			self:SetDetonateTime(self:GetDetonateTime() + 5)
		else
			self:SetDetonateTime(5)
		end
		if SERVER then
			self.Owner:ChatPrint("Timer has been set to "..self:GetDetonateTime().." seconds.")
		end
	end
end

function SWEP:SecondaryAttack()
	if (not self:CanSecondaryAttack()) then return end
	self:SetNextSecondaryFire(CurTime() + 0.5)
	self:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
	self:SetBombType(not self:GetBombType())
	if SERVER then
		self.Owner:ChatPrint(self:GetBombType() and "Bomb type switched to timed." or "Bomb type switched to ignition.")
	end
end

function SWEP:PrimaryAttack()
	if (not self:CanPrimaryAttack()) or self:GetPlanting() then return end
	self:SetPlanting(true)
	self:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	for i = ((self:SequenceDuration() + 0.1) / 100), (self:SequenceDuration() + 0.1), ((self:SequenceDuration() + 0.1) / 100) do
		timer.Simple(i, function()
			if IsValid(self) and IsValid(self.Owner) then
				self:SetPlantingProgress(self:GetPlantingProgress() + 1)
			end
		end)
	end
	timer.Simple(self:SequenceDuration() + 0.1, function()
		if IsValid(self) and (not self:CanPrimaryAttack()) then
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			self:SetPlanting(false)
			self:SetPlantingProgress(0)
			return
		end
		if (not IsValid(self)) then return end
		if IsValid(self.Owner) and IsValid(self.Owner:GetActiveWeapon()) and (self.Owner:GetActiveWeapon():GetClass() == self.ClassName) then
			self:EmitSound(Sound("weapons/c4/c4_plant.wav"))
			if self.Owner:IsPlayer() then
				self.Owner:LagCompensation(true)
			end
			local veh = util.TraceLine(util.GetPlayerTrace(self.Owner)).Entity
			if self.Owner:IsPlayer() then
				self.Owner:LagCompensation(false)
			end
			if SERVER then
				self.Owner:StripWeapon(self.ClassName)
			end
			if self:GetBombType() then
				if self:GetDetonateTime() < 1 then
					self:SetDetonateTime(5)
				end
				timer.Simple(self:GetDetonateTime(), function()
					if (not IsValid(veh)) or (not SERVER) then return end
					if IsValid(veh:GetDriver()) then
						veh:GetDriver():Kill()
					end
					local boom = EffectData()
					boom:SetOrigin(veh:GetPos())
					util.Effect("Explosion", boom)
					veh:EmitSound(Sound("weapons/awp/awp1.wav"))
					veh:TakeDamage(1337, self, self)
				end)
			else
			veh.HasCarBombPlanted = true
			end
		end
	end)
end

if CLIENT then
	function SWEP:DrawHUD()
		if self:GetPlanting() then
			local color_r = math.ceil(((self:GetPlantingProgress() / 100) * -255) + 255)
			local color_g = math.ceil((self:GetPlantingProgress() / 100) * 255)
			print(color_r.." - "..color_g)
			local width = 200
			local height = 60
			local border = 5
			local master_h = (ScrH() / 2) - 200
			local master_w = (ScrW() / 2) - (width / 2)
			draw.RoundedBox(8, master_w - border, master_h - border, width + (border * 2), height + (border * 2), Color(0, 0, 0))
			draw.RoundedBox(8, master_w, master_h, (width / 100) * self:GetPlantingProgress(), height, Color(0, 0, 255))
			draw.SimpleText("Planting...", "Trebuchet24", master_w + 55, master_h + 20, Color(255, 255, 255))
		end
	end
end
