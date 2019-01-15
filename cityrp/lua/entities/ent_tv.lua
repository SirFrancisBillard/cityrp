AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "TV Screen"
ENT.Spawnable = true

ENT.Model = "models/props_phx/rt_screen.mdl"

if CLIENT then
	ENT.Mat = nil
	ENT.Panel = nil
end

function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:Freeze()
	else
		self.Mat = nil
		self.Panel = nil
		self:OpenPage()
	end
end

function ENT:Freeze()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end

function ENT:OpenPage()
	if self.Panel then
		self.Panel:Remove()
		self.Panel = nil
	end

	self.Panel = vgui.Create("DHTML")
	self.Panel:Dock(FILL)

	-- temp
	local url = "https://taytes-website.github.io/taytes-website/"

	self.Panel:OpenURL(url)

	-- Hide the panel
	self.Panel:SetAlpha(0)
	self.Panel:SetMouseInputEnabled(false)

	-- Disable HTML messages
	function self.Panel:ConsoleMessage(msg) end
end

function ENT:Draw()
	if self.Mat then
		if render.MaterialOverrideByIndex then
			render.MaterialOverrideByIndex(1, self.Mat)
		else
			render.ModelMaterialOverride(self.Mat)
		end

	elseif self.Panel && self.Panel:GetHTMLMaterial() then
		local html_mat = self.Panel:GetHTMLMaterial()

		-- Used to make the material fit the model screen
		-- May need to be changed if using a different model
		-- For the multiplication number it goes in segments of 512
		-- Based off the players screen resolution
		local scale_x, scale_y = ScrW()/2048, ScrH()/1024

		-- Create a new material with the proper scaling and shader
		local matdata = {
			["$basetexture"] = html_mat:GetName(),
			["$basetexturetransform"] = "center 0 0 scale " .. scale_x .. " " .. scale_y .. " rotate 0 translate 0 0",
			["$model"] = 1
		}

		-- Unique ID used for material name
		local uid = string.Replace(html_mat:GetName(), "__vgui_texture_", "")

		-- Create the model material
		self.Mat = CreateMaterial("WebMaterial_" .. uid, "VertexLitGeneric", matdata)
	end

	-- Render the model
	self:DrawModel()

	-- Reset the material override or else everything will have a HTML material!
	render.ModelMaterialOverride(nil)
end

function ENT:OnRemove()
	-- Make sure the panel is removed too
	if self.Panel then self.Panel:Remove() end
end