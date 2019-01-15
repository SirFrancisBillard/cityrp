
/////////////////////////////
/////////// NoDL ////////////
//// No downloads module ////
///// For all gamemodes /////
/// By Sir Francis Billard //
/////////////////////////////

NoDL = {}

NoDL.Repo = "https://github.com/SirFrancisBillard/cityrp/tree/master/cityrp/sound"

if SERVER then
	util.AddNetworkString("nodl_emitsound")
else
	net.Receive("nodl_emitsound", function()
		local SoundName = net.ReadString()

		sound.PlayURL(NoDL.Repo .. soundName .. ".wav", "3d", function callback(station)
			if IsValid(station) then
				station:SetPos(self:GetPos())
				station:Play()
			end
		end)
	end)
end

local ENTITY = FindMetaTable("Entity")

local old_EmitSound = ENTITY.EmitSound

function ENTITY:EmitSound(soundName, soundLevel, pitchPercent, volume, channel)
	if CLIENT then
		sound.PlayURL(NoDL.Repo .. soundName .. ".wav", "3d", function callback(station)
			if IsValid(station) then
				station:SetPos(self:GetPos())
				station:Play()
			end
		end)
	end
end

-- should i call this module "noodle" ?
