AddCSLuaFile()

SWEP.PrintName = "Zipties"
SWEP.Author = "DarkRP Developers"
SWEP.Instructions = "Click on a player to tie them up."
SWEP.Purpose = "Kidnapping"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1      
SWEP.Primary.DefaultClip = 0        
SWEP.Primary.Automatic = false      
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

CreateConVar("rp_ziptie_tiecount", 5, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("rp_ziptie_tievariation", 2, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})

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
	SWEP.istying = false
	SWEP.pickent = nil
	SWEP.picksleft = 0
	SWEP.lastpicktimer = 0
	SWEP.picktimer = 2.5

	function SWEP:Deploy()
		self.Owner:DrawWorldModel(false)
		self.Owner:DrawViewModel(false)
	end

	function SWEP:PrimaryAttack()	
		if self.istying then
			if self.picksleft > 1 then
				if self.lastpicktimer < CurTime() then
					self.picksleft = self.picksleft - 1
					self.Owner:SetNWInt("picksleft", self.picksleft)
					self.Owner:SetNWBool("cantie", false)
					self.Owner:EmitSound("ambient/machines/keyboard" .. tostring(math.random(1, 6)) .. "_clicks.wav", 70, 40)
					self.lastpicktimer = CurTime() + math.random( 1, 3 )
				else
					self.istying = false
					self.pickent = nil			
					self.Owner:SetNWInt("picksleft", 0)
					self.Owner:SetNWBool("cantie", false)
					self:NewSetWeaponHoldType("normal")
					DarkRP.notify(self.Owner, 1, 4, "Pickpocket failed!")
					return
				end
			else
				if IsValid(self.pickent) then
					self.pickent:Give("weapon_ziptied")
					self.pickent:SelectWeapon("weapon_ziptied")
					DarkRP.notify(self.pickent, 1, 4, "You have been ziptied!")
					DarkRP.notify(self.Owner, 1, 4, "You have ziptied " .. self.pickent:Nick() .. "!")
					self.Owner:StripWeapon(self.ClassName)
				end
			end
		end
		
		if CurTime() >= self.lastpick and not self.istying then
			if not( IsValid( self.Owner ) and IsValid( self.Owner:GetEyeTrace().Entity ) and self.Owner:GetEyeTrace().Entity:IsPlayer() ) then return end
			local Ent = self.Owner:GetEyeTrace().Entity
			if not( Ent:GetPos():Distance( self.Owner:GetPos() ) < 512 ) then return end
			local PickMiddle = GetConVarNumber( "rp_ziptie_tiecount" )
			local PickVariation = GetConVarNumber( "rp_ziptie_tievariation" )
			self.picksleft = math.random( PickMiddle - PickVariation, PickMiddle + PickVariation )
			self.pickent = Ent
			self.istying = true
			self.lastpick = CurTime() + 3
			self:NewSetWeaponHoldType( "pistol" )
			self.Owner:SetNWInt( "picksleft", self.picksleft )

		end
	end	

	function SWEP:Holster()
		self.istying = false
		self.Owner:DrawWorldModel(true)
		self.Owner:DrawViewModel(true)
		return true
	end

	function SWEP:Think()
		self.Owner:SetNWBool( "tying", self.istying )
		if self.istying then
			if not (IsValid(self.pickent) and IsValid(self.Owner) and IsValid(self.Owner:GetEyeTrace().Entity) and self.Owner:GetEyeTrace().Entity == self.pickent and self.Owner:GetEyeTrace().Entity:GetPos():Distance( self.Owner:GetPos() ) < 512 ) then
				self:NewSetWeaponHoldType("normal")
				self.istying = false
				self.pickent = nil
				self.lastpick = CurTime() + 3
				DarkRP.notify(self.Owner, 1, 4, "Tying failed!")
			end
			
			if self.picksleft > 0 and self.lastpicktimer < CurTime() then
				self.Owner:SetNWBool("cantie", true)
			else
				self.Owner:SetNWBool("cantie", false)
			end
		else
			if self.Owner:GetNWBool("cantie") then
				self.Owner:SetNWBool("cantie", false)
			end
		end
	end
else -- CLIENT
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	function SWEP:DrawHUD()
		if LocalPlayer():GetNWBool("tying") then
			draw.SimpleText( "Tying... " .. LocalPlayer():GetNWInt( "picksleft" ) .. " picks left...", "Trebuchet24", ScrW() / 2, ScrH() / 2, Color( 200, 200, 200, 255 ), 1, 1 )
			if LocalPlayer():GetNWBool( "cantie" ) then
				draw.SimpleText( "Pick now!", "Trebuchet24", ScrW() / 2, ScrH() / 2 + 30, Color( 200, 200, 200, 255 ), 1, 1 )
			else
				draw.SimpleText( "Wait...", "Trebuchet24", ScrW() / 2, ScrH() / 2 + 30, Color( 200, 200, 200, 255 ), 1, 1 )
			end
		end
	end
end
