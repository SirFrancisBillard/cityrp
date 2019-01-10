AddCSLuaFile()

if SERVER then
	resource.AddFile("sound/tennis/bounce.wav")
end

sound.Add({
	name = "Tennis.Bounce",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = "tennis/bounce.wav"
})

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Tennis Ball"

ENT.Spawnable = true
ENT.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"

ENT.IsTennisBall = true

local BounceSound = Sound("Tennis.Bounce")
local color_green = Color(0, 255, 0)

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetModelScale(0.2)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:PhysicsInitSphere(3, "metal_bouncy")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysWake()
		self:SetMaterial("models/props_c17/FurnitureMetal001a")
		self:SetColor(color_green)

		util.SpriteTrail(self, 0, color_white, false, 4, 1, 0.3, 0.1, "trails/smoke.vmt")
	end

	function ENT:PhysicsCollide(data, phys)
		if data.Speed > 50 then
			self:EmitSound(BounceSound)
		end

		-- bounce like a crazy bitch
		local LastSpeed = math.max(data.OurOldVelocity:Length(), data.Speed)
		local NewVelocity = phys:GetVelocity()
		NewVelocity:Normalize()

		LastSpeed = math.max(NewVelocity:Length(), LastSpeed)

		local TargetVelocity = NewVelocity * LastSpeed * 0.8

		phys:SetVelocity(TargetVelocity)
	end
else -- CLIENT
	function ENT:Draw()
		self:DrawModel()
	end
end
