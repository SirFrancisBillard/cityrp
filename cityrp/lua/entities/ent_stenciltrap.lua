AddCSLuaFile()
 
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Trap"
ENT.Author = "Garry Newman"
ENT.Information = "An edible bouncy ball"
ENT.Category = "Fun + Games"
 
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false
 
 
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Time = 0
 
function ENT:Initialize()
    self:SetModel("models/props_junk/garbage_carboard002a.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
    self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
    self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
    self.Time = CurTime()
end
 
function ENT:Think()
    if (self.Time)+3 < CurTime() && (self.Time)+5 > CurTime() then
        local ang =self:GetAngles()
        ang:RotateAroundAxis(ang:Right(),90)
        local bullet    = {}
        bullet.Num      = 1
        bullet.Src      = self:GetPos()
        bullet.Dir      = (ang:Forward())
        bullet.Spread   = Vector(0, 0, 0)
        bullet.Tracer   = 1
        bullet.Force    = 0.5
        bullet.Damage   = 10
        self:FireBullets(bullet)
        local effectdata = EffectData()
        effectdata:SetScale(3)
        angle = self:GetAngles()
        angle:RotateAroundAxis(angle:Right(),90)
        effectdata:SetOrigin(self:GetPos()+self:GetAngles():Up()*10)
        effectdata:SetAngles(angle)
        util.Effect("MuzzleEffect",effectdata)
    end
end
 
function ENT:Use( activator, caller )
    return
end
 
if SERVER then return end
 
hook.Add( "PostDrawOpaqueRenderables", "Test2", function()
    for key, prop in pairs(ents.FindByClass( "sent_trap" )) do
        local pos = prop:GetPos()
        local angle = prop:GetAngles()
        local scale = 45
        local doorangle = 0
        if prop.Time+1.6 > CurTime() then
            doorangle = -(prop.Time - CurTime())*100
        elseif prop.Time < CurTime()-5 && prop.Time > CurTime()-6.6 then
            doorangle = (160+(prop.Time+5 - CurTime())*100)%360
        elseif prop.Time > CurTime()-6.6 then
            doorangle = 160
        end
 
        prop:SetRenderMode(RENDERMODE_TRANSALPHA)
        prop:SetColor(Color(255,255,255,0))
       
        pos = prop:GetPos()
        angle = prop:GetAngles()
       
        render.SetStencilEnable( true )
            render.SetStencilWriteMask( 255 )
            render.SetStencilTestMask( 255 )
           
            /*-------------------------------------------------------
                            Draw hole for the effect
            -------------------------------------------------------*/
 
            render.SetStencilReferenceValue( 43 )
            render.SetStencilCompareFunction( STENCIL_ALWAYS )
            render.SetStencilPassOperation( STENCIL_REPLACE )
 
            cam.Start3D2D( pos+angle:Forward()*-scale/2+angle:Right()*-scale/2, angle, scale )
                surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
                surface.DrawRect( 0, 0, 1, 1 ) -- a 1 x 1 square
            cam.End3D2D()
   
            /*-------------------------------------------------------
                            Draw items in the hole
            -------------------------------------------------------*/
 
            render.SetStencilCompareFunction( STENCIL_EQUAL )
            cam.IgnoreZ( true )
                render.Model( {model="models/props_phx/construct/metal_tube.mdl",pos=pos+angle:Up()*-48,angle=angle} )
                render.Model( {model="models/props_phx/construct/metal_plate1.mdl",pos=pos+angle:Up()*-50,angle=angle})
                angle:RotateAroundAxis(angle:Right(), 90)
                render.Model( {model="models/weapons/w_mach_m249para.mdl",pos=pos+angle:Forward()*-30+angle:Up()*-5,angle=angle})
            cam.IgnoreZ( false )
            angle = prop:GetAngles()
           
           
            render.SetStencilCompareFunction( STENCIL_GREATEREQUAL )
            cam.IgnoreZ( true )
                render.SetMaterial(Material("models/misc/dirtfloor001a"))
                pos = pos+angle:Right()*scale/2
                angle:RotateAroundAxis(angle:Forward(), doorangle)
                render.DrawBox( pos,angle,Vector(-scale/2,0,-1),Vector(scale/2,scale/2,1),Color(255,255,255,255),true)
               
                angle = prop:GetAngles()
                pos = pos-angle:Right()*scale
               
                angle:RotateAroundAxis(angle:Forward(), -doorangle+180)
                render.DrawBox( pos,angle,Vector(-scale/2,0,-1),Vector(scale/2,scale/2,1),Color(255,255,255,255),true)
            cam.IgnoreZ( false )
           
   
            /*-------------------------------------------------------
                            redraw the videwmodel
            -------------------------------------------------------*/
 
            render.SetStencilCompareFunction( STENCIL_ALWAYS )
            local fov = LocalPlayer():GetActiveWeapon().ViewModelFOV or (LocalPlayer():GetFOV() - 21.5)
            cam.Start3D( EyePos(), EyeAngles(), fov + 15)
                cam.IgnoreZ( true )
                    LocalPlayer():GetViewModel():DrawModel()
                cam.IgnoreZ( false )
            cam.End3D()
        render.SetStencilEnable( false )
       
    end
end)
