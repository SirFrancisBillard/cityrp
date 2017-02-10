DarkRP.createEntity("BoomBox", {
	ent = "apb_boombox",
	model = "models/items/cs_gift.mdl",
	price = 600,
	max = 1,
	cmd = "buyboombox"
})


if SERVER then
  AddCSLuaFile( "shared.lua" )
  resource.AddWorkshop("339246018")
end


if CLIENT then
   SWEP.PrintName = "BoomBox"			
   SWEP.Author = "CustomHQ"
   SWEP.Slot      = 2
   SWEP.SlotPos		= 1

end

function SWEP:Initialize()
self:SetWeaponHoldType("melee")
--	self:SetHoldType("melee")--
	self.CanUse = CurTime()
	self.LastTrack = CurTime()-20
	if CLIENT then
	--	self:SetWeaponHoldType("melee")
	end
end


SWEP.Instructions = "Left click select track\nRight click to drop"
--SWEP.Base = "weapon_cs_base2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"
SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 1.1
SWEP.Primary.Ammo       = "none"

SWEP.Primary.ClipSize  = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic  = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"



SWEP.WorldModel = "" 
SWEP.ViewModel = Model("models/weapons/v_hands.mdl")


function SWEP:Recalc(bool)
	if  IsValid(self.ent) then self.ent:Remove()  end 

			self.ent = ents.Create("prop_physics")
			self.ent:SetModel("models/custom/boombox.mdl")
			--	self.Owner:SetEyeAngles(Angle(0,self.Owner:EyeAngles().y,self.Owner:EyeAngles().r))
			self.ent:SetPos(self.Owner:GetPos() + Vector(0,0,57)+self.Owner:GetRight()*17 + (self.Owner:GetForward()*-8))
			self.ent:SetAngles(Angle(self.Owner:EyeAngles().p-20,self.Owner:EyeAngles().y+40,self.Owner:EyeAngles().r))
			self.ent:SetParent(self.Owner)
			self.ent:Fire("SetParentAttachmentMaintainOffset", "chest", 0.001) // Garry fucked up the parenting on players in latest patch..
			
			self.ent:SetCollisionGroup( COLLISION_GROUP_WORLD ) 
			self.ent:Spawn()
			self.ent:SetModelScale(0.6,0)
			self.ent:Activate()
end

function SWEP:Deploy()
--	self:SendWeaponAnim( ACT_VM_DRAW )
self:SetWeaponHoldType("melee")
	if CLIENT then self:SetWeaponHoldType("melee") end
	if SERVER then
		if IsValid(self.ent) then return end
		self.Owner:SetEyeAngles(Angle(0,self.Owner:GetAngles().y,self.Owner:GetAngles().r))
	--	self:SetHoldType("melee")
		self:SetNoDraw(true)
		self:Recalc(false)
	end
	return true
end


function SWEP:Holster()
	if SERVER then
		net.Start('apb_boombox_stop') net.WriteString(self.Channel) net.Broadcast()
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
	return true
end
 
function SWEP:OnDrop()
	if SERVER then
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end

function SWEP:OnRemove()
	if SERVER then
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end




function SWEP:GitPos()
	return self:GetPos() + self:GetForward()*20
end

function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
	if SERVER then
		if self.Channel == nil then self:Remove() return end
	--	if self.CanUse +1.5 >CurTime() then return false end
	--	self.CanUse = CurTime()
		if self.LastTrack +10 >CurTime() then self.Owner:ChatPrint("Can be usen in "..tostring(math.floor(self.LastTrack+10-CurTime())).." sec.") return false end
		self.Owner:ConCommand('OpenMusicBox '..tostring(self:EntIndex()))
	end
	
		


end

function SWEP:NewMusic(id,entID)
	net.Start('apb_boombox_send') net.WriteString(id) net.WriteDouble(entID) net.WriteString(self.Channel) net.Broadcast() 
end

function SWEP:SecondaryAttack()
	if SERVER then
		
		if not IsValid(self.Owner) then self:Remove() return end
		if self.Channel == nil then self:Remove() return end
		
		self.Weapon:SetNextSecondaryFire(CurTime() + 2)
		local ent = ents.Create("APB_boombox")
		ent:SetPos(self.Owner:GetPos()+self.Owner:GetForward()*20+Vector(0,0,40))
		ent:Setowning_ent(self.Owner)
		ent:Spawn()
		local lastID = self:EntIndex()
		local newID = ent:EntIndex()
		//timer.Simple(1,function()
		net.Start('apb_boombox_update') net.WriteDouble(lastID) net.WriteDouble(newID) net.WriteString(self.Channel) net.Broadcast()
		self:Remove()
		self.Owner:SelectWeapon('keys') 
	//	end)
	end
end

SWEP.OnceReload = false
function SWEP:Reload()

end





