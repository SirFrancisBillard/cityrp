ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Pepper Spray Particle"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false 
ENT.RenderGroup = RENDERGROUP_BOTH

AddCSLuaFile()

if SERVER then
	util.AddNetworkString("PepperSpray_StopPepper")

	net.Receive("PepperSpray_StopPepper", function(length, ply)
		ply:SetNWBool("IsPeppered", false)
		ply:SetNWInt("PepperAmount", 0)
	end)
else
	hook.Add("RenderScreenspaceEffects", "PepperSprayBlindHandler", function()
		local ply = LocalPlayer()
		
		if ply:GetNWBool("IsPeppered") then

			if ply:GetNWInt("PepperAmount") > 0 then

				local Mod = math.Clamp(ply:GetNWInt("PepperAmount"), 0, 1)

				local Settings = {
					[ "$pp_colour_brightness" ] = Mod,
					[ "$pp_colour_contrast" ] = 1,
					[ "$pp_colour_colour" ] = 1,
					[ "$pp_colour_addr" ] = 0,
					[ "$pp_colour_addg" ] = 0,
					[ "$pp_colour_addb" ] = 0,
					[ "$pp_colour_mulr" ] = 0,
					[ "$pp_colour_mulg" ] = 0,
					[ "$pp_colour_mulb" ] = 0
				}

				DrawColorModify(Settings)

				ply:SetNWInt("PepperAmount", ply:GetNWInt("PepperAmount") - FrameTime() * 0.5)
			else
				net.Start("PepperSpray_StopPepper")
				net.SendToServer()
			end
		end
	end)
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Shooter")
end

function ENT:Initialize()
	if SERVER then
	
		local size = 1
		self:SetModel("models/Items/AR2_Grenade.mdl") 
		self:PhysicsInitSphere( size, "wood" )
		self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

		local phys = self:GetPhysicsObject()
		
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
			phys:EnableGravity(false)
			phys:EnableDrag(true)
			phys:SetMass(1)
		end
		
		SafeRemoveEntityDelayed(self, 1)
		
	end
	
	self.SpawnTime = CurTime()
	
end


function ENT:Think()
	local Players = player.GetAll()
		
	for k,v in pairs(Players) do
		if v:GetPos():Distance(self:GetPos()) <= 100 and v:EntIndex() ~= self:GetShooter():EntIndex() then
			v:ViewPunch(Angle(math.random(0, 50), math.random(-30, 30), 0))
			v.LastCough = v.LastCough or CurTime() - 3
			if CurTime() - v.LastCough > 2 then
				v.LastCough = CurTime()
				v:EmitSound(Sound("ambient/voices/cough" .. math.random(1, 4) .. ".wav"))
			end
			v:SetNWBool("IsPeppered", true)
			v:SetNWInt("PepperAmount", 1)
		end
	end

	self:NextThink(CurTime() + 0.5)

	return true
end

local mat1 = Material( "particle/particle_smokegrenade" )

function ENT:Draw()
	if CLIENT then
		self:DrawShadow(false)
	end
end

function ENT:DrawTranslucent()
	if CLIENT then
	
		local bonus = CurTime() - self.SpawnTime
		
		local r = 255
		local g = 120
		local b = 20
		local a = 255 - (bonus)*0.5*25.5
		
		cam.Start3D(EyePos(),EyeAngles()) -- Start the 3D function so we can draw onto the screen.
			render.SetMaterial( mat1 ) -- Tell render what material we want, in this case the flash from the gravgun
			render.DrawSprite( self:GetPos(), 50 * bonus, 50 * bonus, Color(r,g,b,a)) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
		cam.End3D()
	end
end
