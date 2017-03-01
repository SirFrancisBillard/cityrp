AddCSLuaFile()

if SERVER then
	resource.AddFile("sound/cityrp/jihad_1.wav")
	resource.AddFile("sound/cityrp/jihad_2.wav")

	-- darkrp disables taunts by default, allow that here for now
	-- todo: put this somewhere more appropriate
	function GAMEMODE:PlayerShouldTaunt(ply, actid)
		return true
	end
end

sound.Add({
	name = "Jihad.Scream",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = {"cityrp/jihad_1.wav", "cityrp/jihad_2.wav"}
})

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

function SWEP:Initialize()
	self:SetHoldType("slam")

	util.PrecacheModel("models/Humans/Charple01.mdl")
	util.PrecacheModel("models/Humans/Charple02.mdl")
	util.PrecacheModel("models/Humans/Charple03.mdl")
	util.PrecacheModel("models/Humans/Charple04.mdl")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 3)
	self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
	if SERVER then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:EmitSound("Jihad.Scream")

		SafeRemoveEntityDelayed(self, 0.99)
		local ply = self.Owner
		timer.Simple(1, function()
			if not IsValid(ply) or not ply:Alive() then return end

			local explosion = ents.Create("env_explosion")
			explosion:SetPos(ply:GetPos())
			explosion:SetOwner(ply)
			explosion:SetKeyValue("iMagnitude", "200")
			explosion:Spawn()
			explosion:Fire("Explode", 0, 0)
			explosion:EmitSound(Sound("ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", 200, math.random(100, 150)))

			ply:SetModel("models/Humans/Charple0" .. math.random(1, 4) .. ".mdl")
			ply:SetColor(COLOR_WHITE)

			util.BlastDamage(ply, ply, ply:GetPos(), 800, 300)

			--self.Owner:Kill()
		end)
	end
end

function SWEP:SecondaryAttack() end

if SERVER then
	function SWEP:OnDrop()
		self:Remove()
	end
end
