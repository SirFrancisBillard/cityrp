AddCSLuaFile()

SWEP.PrintName = "Pickpocket"
SWEP.Instructions = [[
<color=green>[PRIMARY FIRE]</color> Steal money.]]

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1      
SWEP.Primary.DefaultClip = 0        
SWEP.Primary.Automatic = false      
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WepSelectIcon = WeaponIconURL("pickpocket")

CreateConVar("rp_pickpocket_minimumamt", 200, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("rp_pickpocket_maximumamt", 800, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("rp_pickpocket_pickcount", 2, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("rp_pickpocket_pickvariation", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	nextFire = CurTime()
end

function SWEP:NewSetWeaponHoldType(holdtype)
	if SERVER then
		umsg.Start("DRP_HoldType")
			umsg.Entity(self)
			umsg.String(holdtype)
		umsg.End()
	end
	self:SetWeaponHoldType(holdtype)
end

if SERVER then
	SWEP.lastpick = 0
	SWEP.ispicking = false
	SWEP.pickent = nil
	SWEP.picksleft = 0
	SWEP.lastpicktimer = 0
	SWEP.picktimer = 2.5

	function SWEP:Deploy()
		self.Owner:DrawWorldModel(false)
		self.Owner:DrawViewModel(false)
	end

	function SWEP:PrimaryAttack()	
		if self.ispicking then
			if self.picksleft > 1 then
				if self.lastpicktimer < CurTime() then
					self.picksleft = self.picksleft - 1
					self.Owner:SetNWInt("picksleft", self.picksleft)
					self.Owner:SetNWBool("canpick", false)
					self.Owner:EmitSound("ambient/machines/keyboard" .. tostring(math.random(1, 6)) .. "_clicks.wav", 70, 40)
					self.lastpicktimer = CurTime() + math.random( 1, 3 )
				else
					self.ispicking = false
					self.pickent = nil			
					self.Owner:SetNWInt("picksleft", 0)
					self.Owner:SetNWBool("canpick", false)
					self:NewSetWeaponHoldType("normal")
					DarkRP.notify(self.Owner, 1, 4, "Pickpocket failed!")
					return
				end
			else
				local amount = math.random( GetConVarNumber( "rp_pickpocket_minimumamt" ), GetConVarNumber( "rp_pickpocket_maximumamt" ) )
				if IsValid( self.pickent ) then
					if( self.pickent:canAfford( amount ) ) then
						self.pickent:addMoney( -amount )
						self.Owner:addMoney( amount )
					else
						amount = self.pickent.DarkRPVars.money
						self.pickent:addMoney( -amount )
						self.Owner:addMoney( amount )
					end
					DarkRP.notify( self.pickent, 1, 4, "$" .. amount .. " has been pickpocketed from you!" )
					DarkRP.notify( self.Owner, 1, 4, "You have pickpocketed $" .. amount .. "!" )			
				end
				self:NewSetWeaponHoldType( "normal" )
				self.ispicking = false
				self.lastpick = CurTime() + 3
			end
		end
		
		if CurTime() >= self.lastpick and not self.ispicking then
			if not( IsValid( self.Owner ) and IsValid( self.Owner:GetEyeTrace().Entity ) and self.Owner:GetEyeTrace().Entity:IsPlayer() ) then return end
			local Ent = self.Owner:GetEyeTrace().Entity
			if not( Ent:GetPos():Distance( self.Owner:GetPos() ) < 512 ) then return end
			local PickMiddle = GetConVarNumber( "rp_pickpocket_pickcount" )
			local PickVariation = GetConVarNumber( "rp_pickpocket_pickvariation" )
			self.picksleft = math.random( PickMiddle - PickVariation, PickMiddle + PickVariation )
			self.pickent = Ent
			self.ispicking = true
			self.lastpick = CurTime() + 3
			self:NewSetWeaponHoldType( "pistol" )
			self.Owner:SetNWInt( "picksleft", self.picksleft )

		end
	end	

	function SWEP:Holster()
		self.ispicking = false
		self.Owner:DrawWorldModel(true)
		self.Owner:DrawViewModel(true)
		return true
	end

	function SWEP:Think()
		self.Owner:SetNWBool( "picking", self.ispicking )
		if self.ispicking then
			if not ( IsValid(self.pickent) and IsValid( self.Owner ) and IsValid( self.Owner:GetEyeTrace().Entity ) and self.Owner:GetEyeTrace().Entity == self.pickent and self.Owner:GetEyeTrace().Entity:GetPos():Distance( self.Owner:GetPos() ) < 512 ) then
				self:NewSetWeaponHoldType( "normal" )
				self.ispicking = false
				self.pickent = nil
				self.lastpick = CurTime() + 3
				DarkRP.notify( self.Owner, 1, 4, "Pickpocket failed" )
			end
			
			if self.picksleft > 0 and self.lastpicktimer < CurTime() then
				self.Owner:SetNWBool( "canpick", true )
			else
				self.Owner:SetNWBool( "canpick", false )
			end
		else
			if self.Owner:GetNWBool( "canpick" ) then
				self.Owner:SetNWBool( "canpick", false )
			end
		end
	end
else -- CLIENT
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	function SWEP:DrawHUD()
		if LocalPlayer():GetNWBool("picking") then
			draw.SimpleText( "Pickpocketing... " .. LocalPlayer():GetNWInt( "picksleft" ) .. " picks left...", "Trebuchet24", ScrW() / 2, ScrH() / 2, Color( 200, 200, 200, 255 ), 1, 1 )
			if LocalPlayer():GetNWBool( "canpick" ) then
				draw.SimpleText( "Pick now!", "Trebuchet24", ScrW() / 2, ScrH() / 2 + 30, Color( 200, 200, 200, 255 ), 1, 1 )
			else
				draw.SimpleText( "Wait...", "Trebuchet24", ScrW() / 2, ScrH() / 2 + 30, Color( 200, 200, 200, 255 ), 1, 1 )
			end
		end
	end
end
