AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

concommand.Add("slotmachine_roll",function(ply,cmd,args)
	local Entity = ents.GetByIndex(args[1])
	if !Entity or !Entity:IsValid() then return end
	Entity:Bet(ply)
end)

function ENT:Initialize( )
	self.Entity:SetModel("models/props_borealis/bluebarrel001.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local Model = ents.Create("prop_physics")
	Model:SetPos(self:GetPos()+self:GetUp()*-27)
	Model:SetModel("models/props_lab/eyescanner.mdl")
	Model:SetAngles(self:GetAngles())
	Model:SetParent(self)
	Model:SetModelScale( self:GetModelScale() * 4,0)
	Model:Spawn()
	
	self.Entity:SetDTEntity(1,Model)
	self:DrawShadow(false)
	
	self:SetUseType( SIMPLE_USE )
	
	self:SetDTInt(1,1)
	self:SetDTInt(2,1)
	self:SetDTInt(3,1)
	
	self.RPOriginalMass = 1000
	
	------ KEEP THIS SHIT
	timer.Simple(1,function()
		if self and self:IsValid() then
			self.SID = nil
			self.FPPOwnerID = nil
		end
	end)
	-------------------------------------------------------------
end

local coinslot_sound = Sound("ambient/levels/labs/coinslot1.wav")

	function ENT:Bet(ply)
		if self.Betting then return end
		if ply:SM_GetPlayerMoneyM() < SlotMachine_Adjust.BetPrice then return end
		ply:SM_AddPlayerMoneyM(-SlotMachine_Adjust.BetPrice)
		
		self.Betting = ply
		self:EmitSound(coinslot_sound)
		
		self:SetDTInt(1,0)
		self:SetDTInt(2,0)
		self:SetDTInt(3,0)
		
		// Check Result.
			self.Success = false
			-- Success.
			if math.random(1,100) <= SlotMachine_Adjust.WinRate then
				self.Success = true
			else -- fail
			
			end
		
			local function GetPriceNum()
				for Num,DB in pairs(SlotMachine_Adjust.Slots) do
					if math.random(1,100) <= DB.Rate then
						return Num
					end
				end
				return GetPriceNum()
			end
			
			local function Generate_non_win_value()
				local V1 = math.random(1,#SlotMachine_Adjust.Slots)
				local V2 = math.random(1,#SlotMachine_Adjust.Slots)
				local V3 = math.random(1,#SlotMachine_Adjust.Slots)
				if V1 == V2 and V2 == V3 then
					return Generate_non_win_value()
				else
					return V1,V2,V3
				end
			end
		
			local Result = {}
			if self.Success then
				local ResultK = GetPriceNum()
				Result[1] = ResultK
				Result[2] = ResultK
				Result[3] = ResultK
			else
				local V1,V2,V3 = Generate_non_win_value()
				Result[1] = V1
				Result[2] = V2
				Result[3] = V3
			end
		for k=1,3 do
			timer.Simple(k,function()
				if self and self:IsValid() then
					self:SetDTInt(k,Result[k])
					if k == 3 then
						self:CheckResult()
					end
				end
			end)
		end
	end
	function ENT:CheckResult()
		local V1,V2,V3 = self:GetDTInt(1),self:GetDTInt(2),self:GetDTInt(3)
		if V1 == V2 and V2 == V3 then
			if self.Betting and self.Betting:IsValid() then
				self.Betting:SM_AddPlayerMoneyM(SlotMachine_Adjust.Slots[V1].Price)
				self.Betting:SM_Notify("You win! you got $".. SlotMachine_Adjust.Slots[V1].Price.. " dollar!")
			end
		end
		self.Betting = false
	end

function ENT:PhysgunPickup(ply) -- for DarkRP : Allows Owner can move ATM
	if ply:SM_IsAdmin() then 
		return true
	end
end

function ENT:CanTool(ply, trace, mode) -- for DarkRP : Allows Only Owner to remove ATM. 
	if ply:SM_IsAdmin() then 
		return true 
	else
		return false
	end
end



hook.Add("OnPlayerChangedTeam","stest",function(ply,prevTeam,t)
	ply:ChatPrint("TEAM CHANGED")
	ply:ChatPrint("Checking slots..")
	if prevTeam == TEAM_CASINOMANAGER then
		for k,v in pairs(ents.FindByClass("rx_slotmachine")) do
			if v.SID == ply.SID then
				ply:ChatPrint("Found. Removing")
				v:Remove()
			end 
		end
	end
end)