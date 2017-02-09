/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile();

ENT.Type			= "anim";
ENT.Base			= "drug_base";

ENT.Category		= "Drugs";
ENT.PrintName		= "LSD";
ENT.Author			= "The D3vine";
ENT.Spawnable		= true;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = true

ENT.Model			= "models/smile/smile.mdl";
ENT.ID				= "LSD";

local DRUG = {};
DRUG.Name = "LSD";
DRUG.Duration = 60;

function DRUG:StartHighServer(pl)
	local sayings = {
		"OH MY GOD I JUST DEFLATED",
		"I WONDER WHAT HAPPENS WHEN I POUR GASOLINE ALL OVER MYSELF? THAT MUST BE THE CURE FOR CANCER, DUDE"
	};
	
	pl:ConCommand("say " .. sayings[math.random(1,#sayings)]);
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
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
	local tab = {}
	tab[ "$pp_colour_addr" ] = 0;
	tab[ "$pp_colour_addg" ] = 0;
	tab[ "$pp_colour_addb" ] = 0;
	tab[ "$pp_colour_mulr" ] = 0;
	tab[ "$pp_colour_mulg" ] = 0;
	tab[ "$pp_colour_mulb" ] = 0;
	tab[ "$pp_colour_colour" ] =   1 + 3;
	tab[ "$pp_colour_brightness" ] = -0.19;
	tab[ "$pp_colour_contrast" ] = 1 + 5.31;
	
	DrawBloom(0.65, 0.1, 9, 9, 4, 7.7, 255, 255, 255)
	DrawColorModify(tab);
	
end

RegisterDrug(DRUG);