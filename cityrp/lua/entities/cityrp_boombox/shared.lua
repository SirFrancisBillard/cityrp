ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Radio"
ENT.Category = "CityRP"
ENT.Spawnable = true
ENT.Model = "models/props_lab/citizenradio.mdl"

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "price")
    self:NetworkVar("Entity", 1, "owning_ent")
end

function ENT:GitPos()
    return self:GetPos()
end