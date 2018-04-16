
local PLAYER = FindMetaTable("Player")

function PLAYER:SuicideBombDelayed(delay, radius, damage)
	if type(delay) ~= "number" then
		delay = 1
	end

	if type(radius) ~= "number" then
		radius = 400
	end

	if type(damage) ~= "number" then
		damage = 200
	end

	if delay > 0 then
		self:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
		BroadcastLua([[Entity(]] .. self:EntIndex() .. [[):AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)]])
	end

	self:EmitSound("Jihad.Scream")

	timer.Simple(delay, function()
		if not IsValid(self) or not self:Alive() then return end
		local pos = self:GetPos()

		ParticleEffect("explosion_huge", pos, vector_up:Angle())
		self:EmitSound(Sound("Jihad.Explode"))

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
		radius = 400
	end

	if type(damage) ~= "number" then
		damage = 200
	end

	ParticleEffect("explosion_huge", pos, vector_up:Angle())
	sound.Play(Sound("Generic.Explode"), pos)

	util.Decal("Rollermine.Crater", pos, pos - Vector(0, 0, 500))
	util.Decal("Scorch", pos, pos - Vector(0, 0, 500))

	util.BlastDamage(game.GetWorld(), game.GetWorld(), pos, radius, damage)

	timer.Simple(1.2, function()
		if not pos then return end

		sound.Play(Sound("Jihad.Islam"), pos)
	end)
end
