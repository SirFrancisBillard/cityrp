AddCSLuaFile()

-- this code has so much fuckin spaghetti in it
-- i wrote this when i was 12 years old...

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

SWEP.WepSelectIcon = WeaponIconURL("carbomb")

local BeepSound = Sound("weapons/c4/c4_beep1.wav")
local PlantSound = Sound("weapons/c4/c4_plant.wav")
local BombSound = Sound("Arena.Explosion")

if SERVER then
	function ExplodeVehicle(car, delay)
		if not IsValid(car) or not car:IsVehicle() or not car.RiggedToBlow then return end

		local pos = car:GetPos()

		if type(delay) ~= "number" then
			delay = 0
		end

		timer.Simple(delay, function()
			if IsValid(car) then
				local dmg = DamageInfo()
				dmg:SetDamage(500)
				dmg:SetDamageForce(Vector(0, 0, 1000)) -- yeet them upwards
				dmg:SetDamageType(DMG_BLAST)
				if IsValid(car.CarBombPlanter) and car.CarBombPlanter:IsPlayer() then
					dmg:SetAttacker(car.CarBombPlanter)
					car.CarBombPlanter = nil
				end
				for _, v in ipairs(player.GetAll()) do
					if pos:DistToSqr(v:GetPos()) < 90000 then
						v:TakeDamageInfo(dmg)
					end
				end
			end

			local boom = EffectData()
			boom:SetOrigin(car:GetPos())
			util.Effect("Explode", boom)

			if not IsValid(car) then return end

			car:EmitSound(BombSound)
			car.RiggedToBlow = nil
		end)
	end

	hook.Add("PlayerEnteredVehicle", "CarBombDetonate", function(ply, car)
		ExplodeVehicle(car, 1)
	end)
end

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
	return (not self:GetDeploying()) and (not trent.RiggedToBlow) and IsValid(trent) and trent:IsVehicle() and (self.Owner:GetPos():Distance(trent:GetPos()) < 512)
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
		self:EmitSound(BeepSound)
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
	self:EmitSound(PlantSound)
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
			self:EmitSound(PlantSound)
			if SERVER then
				self.Owner:LagCompensation(true)
				local car = self.Owner:GetEyeTrace().Entity
				self.Owner:LagCompensation(false)

				self.Owner:StripWeapon(self.ClassName)

				car.CarBombPlanter = self.Owner
				if self:GetBombType() then
					if self:GetDetonateTime() < 1 then
						self:SetDetonateTime(5)
					end
					ExplodeVehicle(car, self:GetDetonateTime())
				else
					-- get out of there, she's gonna blow!
					car.RiggedToBlow = true
				end
			end
		end
	end)
end

if CLIENT then
	function SWEP:DrawHUD()
		if self:GetPlanting() then
			local color_r = math.ceil(((self:GetPlantingProgress() / 100) * -255) + 255)
			local color_g = math.ceil((self:GetPlantingProgress() / 100) * 255)
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
