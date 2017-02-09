/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile();

ENT.Type			= "anim";
ENT.Base			= "drug_base";

ENT.Category		= "Drugs";
ENT.PrintName		= "Cigarettes";
ENT.Author			= "The D3vine";
ENT.Spawnable		= true;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = true

ENT.Model			= "models/boxopencigshib.mdl";
ENT.ID				= "Cigarettes";

local DRUG = {};
DRUG.Name = "Cigarettes";
DRUG.Duration = 60;

function DRUG:StartHighServer(pl)
	local smoke = EffectData();
	smoke:SetOrigin(pl:EyePos());
	util.Effect("durgz_weed_smoke", smoke);
	
	if (math.random(0, 10) == 0) then
		pl:Ignite(5, 0);
		pl:ConCommand("say FUUUUUUUUUUUUUUUUUUUUUUUUUU");
	else
		pl:ConCommand("say I am COOL.");
	end
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
	local a = math.sin(SysTime() / math.pi) * 255;
			
	local say = "You smoke. Therefore you are cool."
	draw.DrawText(say, "Trebuchet24", ScrW() / 2+1 , ScrH()*0.6+1, Color(255,255,255,a), TEXT_ALIGN_CENTER);
	draw.DrawText(say, "Trebuchet24", ScrW() / 2-1 , ScrH()*0.6-1, Color(255,255,255,a), TEXT_ALIGN_CENTER);
	draw.DrawText(say, "Trebuchet24", ScrW() / 2-1 , ScrH()*0.6+1, Color(255,255,255,a), TEXT_ALIGN_CENTER);
	draw.DrawText(say, "Trebuchet24", ScrW() / 2+1 , ScrH()*0.6-1, Color(255,255,255,a), TEXT_ALIGN_CENTER);
	draw.DrawText(say, "Trebuchet24", ScrW() / 2 , ScrH()*0.6, Color(255,9,9,255), TEXT_ALIGN_CENTER);
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	DrawSharpen(1, 1);
end

RegisterDrug(DRUG);