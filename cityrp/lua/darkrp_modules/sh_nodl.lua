
/////////////////////////////
/////////// NoDL ////////////
//// No downloads module ////
///// For all gamemodes /////
/// By Sir Francis Billard //
/////////////////////////////

NoDL = {}

NoDL.Repos = {
	"https://github.com/SirFrancisBillard/cityrp/tree/master/cityrp/sound"
}

local ENTITY = FindMetaTable("Entity")

local old_EmitSound = ENTITY.EmitSound

function ENTITY:EmitSound(soundName, soundLevel, pitchPercent, volume, channel)
    old_SetTeam(self, team)
end