AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Radio"
ENT.Spawnable = true
ENT.Model = "models/props/cs_office/radio.mdl"

local RadioSongs = {
	[1] = "https://sirfrancisbillard.github.io/billard-radio/music/california_love.mp3",
	[2] = "https://sirfrancisbillard.github.io/billard-radio/music/going_back_to_cali.mp3",
	[3] = "https://sirfrancisbillard.github.io/billard-radio/music/hit_em_up.mp3",
	[4] = "https://sirfrancisbillard.github.io/billard-radio/music/next_episode.mp3",
	[5] = "https://sirfrancisbillard.github.io/billard-radio/music/san_andreas.mp3",
	[6] = "https://sirfrancisbillard.github.io/billard-radio/music/crazy_rap.mp3",
	[7] = "https://sirfrancisbillard.github.io/billard-radio/music/baby_cookie.mp3",
}

if SERVER then
	util.AddNetworkString("PlayRadioSong")

	function ENT:PlayRandomSong()
		local randy = math.random(#RadioSongs)

		net.Start("PlayRadioSong")
			net.WriteEntity(self)
			net.WriteInt(randy, 6)
		net.SendPAS(self:GetPos())
	end
else -- CLIENT
	net.Receive("PlayRadioSong", function(len)
		local ent = net.ReadEntity()
		local id = math.Clamp(net.ReadInt(6), 1, #RadioSongs)
		local station = ent.Stations[id]
		if not IsValid(station) then return end
		for k, v in pairs(ent.Stations) do
			if IsValid(v) then
				v:Pause()
			end
		end
		ent.radio = station
		station:SetTime(0)
		station:Play()
	end)
end

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysWake()
	else
		self.Stations = {}
		for k, v in pairs(RadioSongs) do
			sound.PlayURL(v, "3d noblock noplay", function(station)
				if not IsValid(station) then return end
				table.insert(self.Stations, station)
			end)
		end
	end
end

if SERVER then
	function ENT:Use(activator, caller)
		if IsValid(caller) and caller:IsPlayer() then
			self:PlayRandomSong()
		end
	end
else
	function ENT:Think()
		if IsValid(self.radio) then
			self.radio:SetPos(self:GetPos())
		end
	end

	function ENT:Draw()
		self:DrawModel()
	end
end
