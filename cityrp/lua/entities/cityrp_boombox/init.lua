AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--ENT.SeizeReward = 350
function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()
    phys:SetMass(100)
    self.sparking = false
    self.damage = 500
    local ply = self:Getowning_ent()
    self.SID = ply.SID
    self.Owner = ply
    self.Channel = ply:SteamID()
    print(self.Channel)
    --	self:Setprice(math.Clamp((GAMEMODE.Config.pricemin ~= 0 and GAMEMODE.Config.pricemin) or 100, (GAMEMODE.Config.pricecap ~= 0 and GAMEMODE.Config.pricecap) or 100))
    self.CanUse = CurTime()
    self.LastTrack = CurTime() - 20
    self.ShareGravgun = true
    --self.food = 3
end

function ENT:Destruct()
end

function ENT:Use(activator, caller)
    if self.CanUse + 1.5 > CurTime() then return false end

    if not IsValid(self.Owner) then
        self:Remove()

        return
    end

    if self.Channel == nil then
        self:Remove()

        return
    end

    self.CanUse = CurTime()

    if self.LastTrack + 10 > CurTime() then
        caller:ChatPrint("Can be used in " .. tostring(math.floor(self.LastTrack + 10 - CurTime())) .. " sec.")

        return false
    end

    activator:ConCommand('OpenMusicBox ' .. tostring(self.Entity:EntIndex()))
end

util.AddNetworkString('apb_boombox_get')
util.AddNetworkString('apb_boombox_send')
util.AddNetworkString('apb_boombox_update')
util.AddNetworkString('apb_boombox_up')
util.AddNetworkString('apb_boombox_stop')
util.AddNetworkString('apb_boombox_sendstop')

net.Receive('apb_boombox_sendstop', function(leng, ply)
    local ent = Entity(net.ReadDouble())

    if IsValid(ent) and ent.Channel then
        net.Start('apb_boombox_stop')
        net.WriteString(ent.Channel)
        net.Broadcast()
    end
end)

net.Receive('apb_boombox_up', function(leng, ply)
    local ent = Entity(net.ReadDouble())

    if IsValid(ent) and ply:Alive() then
        if ent.Secondary then return end

        if ent:Getowning_ent() ~= ply then
            ply:ChatPrint("You do not own this")

            return
        end

        local ent2 = ply:Give('weapon_boombox')
        ent2.Channel = ent.Channel
        print(ent2.Channel)
        print(ent2:GetClass())
        ply:SelectWeapon("weapon_boombox")
        net.Start('apb_boombox_update')
        net.WriteDouble(ent:EntIndex())
        net.WriteDouble(ent2:EntIndex())
        net.WriteString(ent.Channel)
        net.Broadcast()
        ent:Remove()
    end
end)

net.Receive('apb_boombox_get', function(len, ply)
    local id = net.ReadString()
    local entID = net.ReadDouble()

    if IsValid(Entity(entID)) then
        Entity(entID):NewMusic(id, entID)
        Entity(entID).LastTrack = CurTime()
    end
end)

function ENT:NewMusic(id, entID)
    net.Start('apb_boombox_send')
    net.WriteString(id)
    net.WriteDouble(entID)
    net.WriteString(self.Channel)
    net.Broadcast()
end

function ENT:OnRemove()
    if not IsValid(self) then return end
    self:Destruct()
end