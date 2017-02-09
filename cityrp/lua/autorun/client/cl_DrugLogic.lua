/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

DRUGS = DRUGS or {};
CURRENTHIGHS = CURRENTHIGHS or {};

function RegisterDrug(DRUG)
	DRUG.TickClient = DRUG.TickClient or function(this, pl, stacks, startTime, endTime) end;
	DRUG.StartHighClient = DRUG.StartHighClient or function(this, pl) end;
	DRUG.EndHighClient = DRUG.EndHighClient or function(this, pl) end;
	
	DRUG.HUDPaint = DRUG.HUDPaint or function(this, pl, stacks, startTime, endTime) end;
	DRUG.RenderSSEffects = DRUG.RenderSSEffects or function(this, pl, stacks, startTime, endTime) end;
	
	DRUGS[DRUG.Name] = DRUG;
end

-- Structure
-- CURRENTHIGHS = {
--	"Cocaine" = {
--		stacks = <number>
--	}
-- }

-- This is just for the visual/auditory effects.

net.Receive("DrugStatus", function(length)
	local drug = net.ReadString();
		drug = DRUGS[drug];
		
	if (!drug) then
		return;
	end
	
	local enable = tobool(net.ReadBit());
	
	local highs = CURRENTHIGHS;
	
	if (enable) then
		if (highs[drug.Name]) then
			highs[drug.Name].stacks = highs[drug.Name].stacks + 1;
			
			-- Trash startTime
			net.ReadFloat();
			--
			
			highs[drug.Name].endTime = net.ReadFloat();
		else
			highs[drug.Name] = {
				stacks = 1,
				startTime = CurTime(),
				realStartTime = net.ReadFloat(),
				endTime = net.ReadFloat()
			};
			
			drug:StartHighClient(LocalPlayer());
		end
	else
		drug:EndHighClient(LocalPlayer());
	
		highs[drug.Name] = nil;
	end
end);

net.Receive("ClearDrugs", function(length)
	for k, v in pairs(CURRENTHIGHS) do
		local refDrug = DRUGS[k];
		
		refDrug:EndHighClient(LocalPlayer());
	end
	
	CURRENTHIGHS = {};
end);

function TickDrugs()
	local highs = CURRENTHIGHS;
	
	for k, v in pairs(highs) do
		local drugRef = DRUGS[k];
		
		drugRef:TickClient(LocalPlayer(), v.stacks, v.startTime, v.endTime);
	end
end
hook.Add("Tick", "TickDrugs", TickDrugs);

function HUDPaintDrugs()
	local highs = CURRENTHIGHS;
	
	for k, v in pairs(highs) do
		local drugRef = DRUGS[k];
		
		drugRef:HUDPaint(LocalPlayer(), v.stacks, v.startTime, v.endTime);
	end
end
hook.Add("HUDPaint", "HUDPaintDrugs", HUDPaintDrugs);

function RenderSSEffectsDrugs()
	local highs = CURRENTHIGHS;
	
	for k, v in pairs(highs) do
		local drugRef = DRUGS[k];
		
		drugRef:RenderSSEffects(LocalPlayer(), v.stacks, v.startTime, v.endTime);
	end
end
hook.Add("RenderScreenspaceEffects", "RenderSSEffectsDrugs", RenderSSEffectsDrugs);