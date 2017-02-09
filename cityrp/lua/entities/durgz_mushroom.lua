/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile();

ENT.Type			= "anim";
ENT.Base			= "drug_base";

ENT.Category		= "Drugs";
ENT.PrintName		= "Mushrooms";
ENT.Author			= "The D3vine";
ENT.Spawnable		= true;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = true

ENT.Model			= "models/ipha/mushroom_small.mdl";
ENT.ID				= "Mushroom";

local DRUG = {};
DRUG.Name = "Mushroom";
DRUG.Duration = 60;

function DRUG:StartHighServer(pl)
	if (math.random(0, 22) == 0) then
		pl:Ignite(5, 0);
		pl:ConCommand("say FFFFFFUUUUUUUUUUUUUUUUUU");
	else
		local Armor = pl:Armor();
		if (Armor * 3 / 2 < 500) then
			pl:SetArmor(math.floor(Armor + 20));
		else
			pl:SetArmor(Armor + 20);
		end
		
		pl:SetGravity(0.135);
	end
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:SetGravity(1);
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
	local shroom_tab = {};
	shroom_tab[ "$pp_colour_addr" ] = 0;
	shroom_tab[ "$pp_colour_addg" ] = 0;
	shroom_tab[ "$pp_colour_addb" ] = 0;
	shroom_tab[ "$pp_colour_mulr" ] = 0;
	shroom_tab[ "$pp_colour_mulg" ] = 0;
	shroom_tab[ "$pp_colour_mulb" ] = 0;
	
	shroom_tab[ "$pp_colour_colour" ] = 0.63;
	shroom_tab[ "$pp_colour_brightness" ] = -0.15;
	shroom_tab[ "$pp_colour_contrast" ] = 2.57;
	//DrawMotionBlur( 0.82, 1, 0);
	DrawColorModify(shroom_tab);
	DrawSharpen(8.32, 1.03);
end

RegisterDrug(DRUG);