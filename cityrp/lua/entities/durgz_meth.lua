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
ENT.PrintName		= "Meth";
ENT.Spawnable		= true;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = true

ENT.Model			= "models/cocn.mdl";
ENT.ID				= "Meth";

function ENT:Initialize()
	self:SetModel(self.Model);
	
	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetSolid(SOLID_VPHYSICS);
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER);

		self:PhysWake();
		
		self:GetPhysicsObject():SetMass(2);
	end

	self:SetColor(Color(75,128,255))
end

local DRUG = {};
DRUG.Name = "Meth";
DRUG.Duration = 30;

function DRUG:StartHighServer(pl)
	if (pl:Health() > 1) then
		pl:ConCommand("say ARE THOSE BUGS ON MY ARM I THINK THERE'S BUGS ON MY ARM");
		
		pl:SetHealth(pl:Health() / 2);
		
		pl.CocaineOldWalkSpeed = pl.CocaineOldRunSpeed or pl:GetWalkSpeed();
		pl.CocaineOldRunSpeed = pl.CocaineOldRunSpeed or pl:GetRunSpeed();
		
		pl:SetWalkSpeed(pl.CocaineOldRunSpeed * 3);
		pl:SetRunSpeed(pl.CocaineOldRunSpeed * 3);
		pl:ManipulateBoneScale(6, Vector(4, 4, 4))

		pl:SetHunger(200, true)
	else
		pl:SetWalkSpeed(50);
		pl:SetRunSpeed(100);
		
		timer.Simple(1, function()
			if (pl:IsValid()) then
				pl:ConCommand("say My heart isn't beating..");
				
				timer.Simple(2, function()
					if (pl:IsValid()) then
						pl:Kill();
						pl:ManipulateBoneScale(6, Vector(1, 1, 1))
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
	pl:ManipulateBoneScale(6, Vector(1, 1, 1))
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
	
	DrawMaterialOverlay("highs/shader3", 1*ich*0.05);
	DrawSharpen(1*ich*5, 2) ;

-- borrow this from shrooms and call it meth
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
	DrawMotionBlur( 0.82, 1, 0);
	DrawColorModify(shroom_tab);
	DrawSharpen(8.32, 1.03);


end

RegisterDrug(DRUG);