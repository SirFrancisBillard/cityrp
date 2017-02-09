/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile();

ENT.Type			= "anim";
ENT.Base			= "drug_base";

ENT.Category		= "Drugs";
ENT.PrintName		= "Alcohol";
ENT.Author			= "The D3vine";
ENT.Spawnable		= true;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = true

ENT.Model			= "models/drug_mod/alcohol_can.mdl";
ENT.ID				= "Alcohol";

local DRUG = {};
DRUG.Name = "Alcohol";
DRUG.Duration = 45;

function DRUG:StartHighServer(pl)
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
end

function DRUG:StartHighClient(pl)
	pl:ConCommand("say waitt, wait. guysss. i need to tells u abuot micrsfoft excel!11!");
	
	local commands = {"left", "right", "moveleft", "moveright", "attack"};
	local numcommands = math.random(1, 5);

	for i = 0, numcommands-1 do
		timer.Simple(i * 7 + math.Rand(2, 7), function()
			local cmd = commands[math.random(1, #commands)];
			
			pl:ConCommand("+" .. cmd);
			
			timer.Simple(1, function()
				pl:ConCommand("-" .. cmd);
			end);
		end);
	end
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	DrawMotionBlur(0.03, 1, 0);
end

RegisterDrug(DRUG);