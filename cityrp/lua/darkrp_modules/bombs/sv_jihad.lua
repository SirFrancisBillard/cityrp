
-- #NoSimplerr#

util.AddNetworkString("JihadAnimation")

local function SendJihadAnim(ent)
	net.Start("JihadAnimation")
	net.WriteEntity(ent)
	net.Broadcast()
end

local DefaultDelay = 1
local DefaultRadius = 400
local DefaultDamage = 200

local PLAYER = FindMetaTable("Player")

function PLAYER:SuicideBombDelayed(delay, radius, damage)
	if type(delay) ~= "number" then
		delay = DefaultDelay
	end

	if type(radius) ~= "number" then
		radius = DefaultRadius
	end

	if type(damage) ~= "number" then
		damage = DefaultDamage
	end

	if delay > 0 then
		-- do it on the server so we update the hitboxes
		self:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
		SendJihadAnim()
	end

	self:EmitSound("Jihad.Scream")

	timer.Simple(delay, function()
		if not IsValid(self) or not self:Alive() then return end
		local pos = self:GetPos()

		ParticleEffect("explosion_huge", pos, vector_up:Angle())
		util.ScreenShake(pos, 5, 5, 1, 4000)
		self:EmitSound(Sound("Arena.Explosion"))

		util.Decal("Rollermine.Crater", pos, pos - Vector(0, 0, 500), self)
		util.Decal("Scorch", pos, pos - Vector(0, 0, 500), self)

		self:SetModel("models/Humans/Charple0" .. math.random(1, 4) .. ".mdl")
		self:SetColor(color_white)

		util.BlastDamage(self, self, pos, radius, damage)

		timer.Simple(1.2, function()
			if not pos then return end

			sound.Play(Sound("Jihad.Islam"), pos)
		end)
	end)
end

function LargeExplosion(pos, radius, damage)
	if not pos then return end

	if type(radius) ~= "number" then
		radius = DefaultRadius
	end

	if type(damage) ~= "number" then
		damage = DefaultDamage
	end

	ParticleEffect("explosion_huge", pos, vector_up:Angle())
	util.ScreenShake(pos, 5, 5, 1, 4000)
	sound.Play(Sound("Arena.Explosion"), pos)

	util.Decal("Rollermine.Crater", pos, pos - Vector(0, 0, 500))
	util.Decal("Scorch", pos, pos - Vector(0, 0, 500))

	util.BlastDamage(game.GetWorld(), game.GetWorld(), pos, radius, damage)

	timer.Simple(1.2, function()
		if not pos then return end

		sound.Play(Sound("Jihad.Islam"), pos)
	end)
end
