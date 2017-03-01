AddCSLuaFile()

SWEP.PrintName = "Jihad Bomb"
SWEP.Slot = 4
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Instructions = "Primary fire to explode almost instantly."
SWEP.Purpose = "Sacrifice yourself for Allah."

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false

SWEP.Spawnable = true
SWEP.Category = "RP"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

if SERVER then
	-- darkrp disables taunts by default, allow that here for now
	-- todo: put this somewhere more appropriate
	function GAMEMODE:PlayerShouldTaunt(ply, actid)
		return true
	end
end

function SWEP:Initialize()
	self:SetHoldType("slam")

	util.PrecacheModel("models/Humans/Charple01.mdl")
	util.PrecacheModel("models/Humans/Charple02.mdl")
	util.PrecacheModel("models/Humans/Charple03.mdl")
	util.PrecacheModel("models/Humans/Charple04.mdl")
end

function SWEP:PrimaryAttack()
	if SERVER then
		self.Owner:ConCommand("act zombie")
		self.Owner:EmitSound("Jihad.Scream")

		timer.Simple(1, function()
			if not IsValid(self) or not IsValid(self.Owner) or not self.Owner:Alive() then return end

			local explosion = ents.Create("env_explosion")
			explosion:SetPos(self:GetPos())
			explosion:SetOwner(self.Owner)
			explosion:SetKeyValue("iMagnitude", "200")
			explosion:Spawn()
			explosion:Fire("Explode", 0, 0)
			explosion:EmitSound(Sound("ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", 200, math.random(100, 150)))

			self.Owner:SetModel("models/Humans/Charple0" .. math.random(1, 4) .. ".mdl")
			self.Owner:SetColor(COLOR_WHITE)

			util.BlastDamage(self, self.Owner, self:GetPos(), 800, 300)

			self:Remove()
		end)
	end
end

function SWEP:SecondaryAttack() end
