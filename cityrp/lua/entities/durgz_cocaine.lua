/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile();

ENT.Type			= "anim";
ENT.Base			= "drug_base";

ENT.Category		= "Drugs";
ENT.Author			= "The D3vine";
ENT.PrintName		= "Cocaine";
ENT.Spawnable		= true;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = true

ENT.Model			= "models/cocn.mdl";
ENT.ID				= "Cocaine";

local DRUG = {};
DRUG.Name = "Cocaine";
DRUG.Duration = 15;

function DRUG:StartHighServer(pl)
	if (pl:Health() > 1) then
		pl:ConCommand("say MY NOSE IS DRIBBLING IS ANYONE ELSES NOSE DRIBBLING THATS REALLY WEIRD I HOPE I DONT HAVE A COLD");
		
		pl:SetHealth(pl:Health() / 2);
		
		pl.CocaineOldWalkSpeed = pl.CocaineOldRunSpeed or pl:GetWalkSpeed();
		pl.CocaineOldRunSpeed = pl.CocaineOldRunSpeed or pl:GetRunSpeed();
		
		pl:SetWalkSpeed(pl.CocaineOldRunSpeed * 2);
		pl:SetRunSpeed(pl.CocaineOldRunSpeed * 2);
	else
		pl:SetWalkSpeed(50);
		pl:SetRunSpeed(100);
		
		timer.Simple(1, function()
			if (pl:IsValid()) then
				pl:ConCommand("say My heart isn't beating..");
				
				timer.Simple(2, function()
					if (pl:IsValid()) then
						pl:Kill();
					end
				end);
			end
		end);
	end
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	if (pl.CocaineOldWalkSpeed) then
		pl:SetWalkSpeed(pl.CocaineOldWalkSpeed);
		pl.CocaineOldWalkSpeed = nil;
	end
	
	if (pl.CocaineOldRunSpeed) then
		pl:SetRunSpeed(pl.CocaineOldRunSpeed);
		pl.CocaineOldRunSpeed = nil;
	end
end

function DRUG:StartHighClient(pl)
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
	pl.cdw = nil;
	pl.cdw2 = nil;
	pl.cdw3 = nil;
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	pl.cdw2 = -1;
	
	local pf = 0.8;
		
	local tab = {};
	tab[ "$pp_colour_addr" ] = 0;
	tab[ "$pp_colour_addg" ] = 0;
	tab[ "$pp_colour_addb" ] = 0;
	tab[ "$pp_colour_brightness" ] = 0;
	tab[ "$pp_colour_contrast" ] = 1;
	tab[ "$pp_colour_mulr" ] = 0;
	tab[ "$pp_colour_mulg" ] = 0;
	tab[ "$pp_colour_mulb" ] = 0;
		
	if (!pl.cdw or pl.cdw < CurTime()) then
		pl.cdw = CurTime() + 1;
		pl.cdw2 = pl.cdw2*-1;
	end
	
	if (pl.cdw2 == -1) then
		pl.cdw3 = 2;
	else
		pl.cdw3 = 0;
	end
	
	local ich = (pl.cdw2*((pl.cdw - CurTime())*(2)))+pl.cdw3 - 1;
	
	DrawMaterialOverlay("highs/shader3", pf*ich*0.05);
	DrawSharpen(pf*ich*5, 2) ;
end

RegisterDrug(DRUG);