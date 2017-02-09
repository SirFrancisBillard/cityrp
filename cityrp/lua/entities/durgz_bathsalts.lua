/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'Drugs'
ENT.PrintName		= 'Bath Salts'
ENT.Author			= 'aStonedPenguin'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.HighLagRisk = true

ENT.Model			= 'models/props_lab/jar01a.mdl'
ENT.ID				= 'Bath'

local DRUG = {}
DRUG.Name = 'Bath'
DRUG.Duration = 60

function DRUG:StartHighServer(pl)
	pl:SetGravity(0.25)
	pl:SetHealth(pl:Health() + 200)
	pl:ConCommand('say YOUR FACE JUST LOOKS DELICIOUS')
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:SetGravity(1)
	if pl:Health() <= 200 then
		pl:Kill()
	else
		pl:SetHealth(pl:Health() - 200)
	end
end

function DRUG:StartHighClient(pl)
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	DrawSharpen(-1, 2)
	DrawMaterialOverlay('models/props_lab/Tank_Glass001', 0)
	DrawMotionBlur(0.13, 1, 0.00)
end

RegisterDrug(DRUG)