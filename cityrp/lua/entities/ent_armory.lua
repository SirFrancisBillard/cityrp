// -- Designed and written by http://steamcommunity.com/id/stealthpaw -- \\
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Type = "anim"
ENT.PrintName = "Weapon Armoury"
ENT.Author = "StealthPaw"
ENT.Spawnable = true
ENT.Category = "DarkRP"

local DefaultCooldown = 5
local DefaultMagazines = 1
local DefaultLoadouts = {
	{Name = "Patrol", Weapons = {"weapon_mp5", "lite_glock"}},
	{Name = "Assault", Weapons = {"lite_m4a1", "lite_glock"}},
	{Name = "Breach", Weapons = {"lite_m3", "lite_glock"}}
}

local ArmouryLanguage = {
	weapon_armoury = "Weapon Armoury",
	need_be_cp = "You need to be a Police Officer to use the %s",
	need_be_chief = "You need to be a Police Chief to equip %s",
	loadout_exists = "The loadout '%s' already exists.",
	loadout_equip = "You have equipped %s.",
	far_away = "You are too far away to use %s.",
	denied_loadout = "The mayor denied your loadout request.",
	lockdown_only = "This loadout is only avalible during a lockdown."
}

if DarkRP then DarkRP.addLanguage("en", ArmouryLanguage) end

local WeaponArmoury = {}
WeaponArmoury.Version = 0.9

if SERVER then
	function WeaponArmoury:HasPermision(ply)
		if !IsValid(ply) then return false end
		if (DarkRP and (!ply:isCP() or ply:isMayor())) then return false end
		return true
	end
	function WeaponArmoury:Setup()
		self.table = DefaultLoadouts
	end
	function WeaponArmoury:ChangeLoadout(ply, loadout)
		if !loadout then return false end
		local cost = tonumber(loadout.Cost or 0)
		if cost > 0 then
			if !ply:canAfford(cost) then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("cant_afford","")) return end
			ply:addMoney(-cost)
		end
		if tobool(loadout.Chief) then
			if !ply:isChief() then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("need_be_chief",loadout.Name)) return end
		end
		if tobool(loadout.Lockdown) then
			if !tobool(GetGlobalBool("DarkRP_Lockdown")) then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("lockdown_only")) return end
		end
		local cooldown = tonumber(loadout.CoolDown or 0)
		if cooldown > 0 then
			ply.ArmouryCoolDowns = ply.ArmouryCoolDowns or {}
			if ply.ArmouryCoolDowns[loadout.Name] then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("have_to_wait",ply.ArmouryCoolDowns[loadout.Name]-CurTime(),loadout.Name)) return false end
			ply.ArmouryCoolDowns[loadout.Name] = CurTime() + cooldown
			timer.Simple( cooldown, function() if IsValid(ply) then ply.ArmouryCoolDowns[loadout.Name] = nil end end)
		end
		ply:EmitSound( "items/ammo_pickup.wav" )
		DarkRP.notify(ply, 2, 2, DarkRP.getPhrase("loadout_equip",loadout.Name))
		ply.WeaponArmouryLoadout =ply.WeaponArmouryLoadout or {}
		for k, v in pairs(ply.WeaponArmouryLoadout) do
			if ply:HasWeapon( v ) and !table.HasValue(loadout.Weapons, v) then ply:GetWeapon( v ):Remove() end
		end
		if ply:GetWeapons() and ply:GetWeapons()[1] and ply:GetWeapons()[1]:GetClass() then ply:SelectWeapon( ply:GetWeapons()[1]:GetClass() ) end
		ply.WeaponArmouryLoadout = table.Copy(loadout.Weapons)
		local extraAmmo = tonumber(loadout.Ammo or 0)
		timer.Simple( 0.1, function()
			if IsValid(ply) then
				for k, v in pairs(loadout.Weapons) do
					if !ply:HasWeapon( v ) then ply:Give(v) end
					local Weapon, AmmoType, MagSize = false
					Weapon = ply:GetWeapon( v ) or false
					if Weapon then
						Weapon.FromWeaponArmoury = true
						if Weapon.GetPrimaryAmmoType then AmmoType = Weapon:GetPrimaryAmmoType() end
						if Weapon.GetMaxClip1 then MagSize = Weapon:GetMaxClip1() end
					end
					if Weapon and AmmoType and MagSize then ply:GiveAmmo( (MagSize*(DefaultMagazines or 1))+(extraAmmo*MagSize), AmmoType, true ) end
				end
				if loadout.Weapons[1] and ply:HasWeapon( loadout.Weapons[1] ) then ply:SelectWeapon( loadout.Weapons[1] ) end
			end
		end)
	end
	function WeaponArmoury:Open(ply, armoury)
		if !IsValid(ply) then return false end
		net.Start( "WeaponArmoury" )
			net.WriteEntity( armoury )
			net.WriteTable( self.table or {} )
		net.Send(ply)
	end
	function WeaponArmoury:GetLoadout(name)
		if !name or name=="" or name==" " then return false end
		self.table = self.table or {}
		for k, v in pairs(self.table) do
			if v.Name == name then return k end
		end
		return false
	end
	util.AddNetworkString( "WeaponArmoury" )
	net.Receive( "WeaponArmoury", function( len, ply )
		if ( !IsValid( ply ) or !ply:IsPlayer() ) then return end
		if !WeaponArmoury:HasPermision(ply) then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("need_be_cp",DarkRP.getPhrase("weapon_armoury"))) return end
		local ArmouryEntity = net.ReadEntity()
		if !IsValid(ArmouryEntity) then return end
		if ArmouryEntity:GetPos():Distance( ply:GetPos() ) > 100 then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("far_away",DarkRP.getPhrase("weapon_armoury"))) return end
		local switch = net.ReadInt( 3 ) or 0
		if switch == 1 then
			if ply.LoadoutCoolDown then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("have_to_wait",ply.LoadoutCoolDown-CurTime(),DarkRP.getPhrase("weapon_armoury"))) return false end
			ply.LoadoutCoolDown = CurTime() + (DefaultCooldown or 2)
			timer.Simple( DefaultCooldown or 2, function() if IsValid(ply) then ply.LoadoutCoolDown = nil end end)
			local key = WeaponArmoury:GetLoadout(net.ReadString())
			if !key then return end
			local loadout = WeaponArmoury.table[key]
			if !loadout or !loadout.Weapons or #loadout.Weapons < 1 then return end
			if tobool(loadout.Mayor) then
				local NotMayors = {}
				for k, v in pairs(player.GetAll()) do if !v:isMayor() then NotMayors[v] = k end end
				DarkRP.createVote("Allow "..ply:Nick().." to access the "..loadout.Name.." weapon loadout?", "WeaponArmouryVote", ply, 15, function(s,can)
					if (can and can >= 1) and IsValid(ply) then WeaponArmoury:ChangeLoadout(ply, loadout) else DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("denied_loadout")) end
				end, NotMayors)
			else
				WeaponArmoury:ChangeLoadout(ply, loadout)
			end return
		end
		if switch > 1 and !ply:IsSuperAdmin() then return end
		if switch == 2 then
			local Weapons = net.ReadTable() or false
			local Info = net.ReadTable() or false
			if WeaponArmoury:GetLoadout(Info.Name) then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("loadout_exists",Info.Name)) return end
			WeaponArmoury:AddLoadout(Weapons, Info)
			WeaponArmoury:Open(ply, ArmouryEntity)
		end
		if switch == 3 then
			WeaponArmoury:DeleteLoadout(net.ReadString())
			WeaponArmoury:Open(ply, ArmouryEntity)
		end
	end )
	hook.Add( "canDropWeapon", "WeaponArmoury_canDropWeapon", function ( ply, weapon )
		if weapon.FromWeaponArmoury then return false end
	end )
	hook.Add( "canPocket", "WeaponArmoury_canPocket", function ( ply, item )
		if item.FromWeaponArmoury then return false end
	end )
	hook.Add( "PlayerDeath", "WeaponArmoury_PlayerDeath", function ( ply ) ply.WeaponArmouryLoadout = false end )
	hook.Add( "Initialize", "WeaponArmoury_Initialize", function () WeaponArmoury:Setup() end )
	function ENT:SpawnFunction( ply, tr, ClassName )
		if ( !tr.Hit ) then return end
		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 36 )
		ent:Spawn()
		ent:Activate()
		return ent
	end
	function ENT:Initialize()
		if !DarkRP then PrintMessage( HUD_PRINTTALK, "This entity is for DarkRP only." ) if ( IsValid( self ) ) then self:Remove() end return end
		self:SetModel( "models/props_c17/lockers001a.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end
	end
	function ENT:Use( activator, caller )
		local ply = activator or caller
		if !ply:IsPlayer() then return end
		if (self.LastUse or 0) >= CurTime() then return end
		self.LastUse = CurTime() + 2
		if !WeaponArmoury:HasPermision(ply) then DarkRP.notify(ply, 1, 2, DarkRP.getPhrase("need_be_cp",DarkRP.getPhrase("weapon_armoury"))) return end
		WeaponArmoury.table = WeaponArmoury.table or {}
		if !WeaponArmoury.table or #WeaponArmoury.table < 1 then WeaponArmoury:Setup() end
		WeaponArmoury:Open(ply, self)
	end
end

if CLIENT then
	concommand.Add( "WeaponArmoury_Version", function() if WeaponArmoury then print("WeaponArmoury Version",WeaponArmoury.Version or "error") end end )
	local function MakeButton(x, y, h, w, parent, text, color, font, func)
		local Button = vgui.Create( "DButton", parent or nil )
		if func then Button.OnClick = func end
		Button:SetPos( x or 0, y or 0 )
		Button:SetSize( h or 0, w or 0 )
		Button:SetText("")
		Button.Text = text or ""
		Button.Font = font or "DermaDefault"
		Button.Color = color or Color(0,0,0,255)
		Button.Paint = function(s, w, h) draw.SimpleText( s.Text, s.Font, w/2, h/2, s.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) end
		Button.DoClick = function(s)
			if s.OnClick then s:OnClick() end
		end
		return Button
	end
	local function MakeCheckBox(x, y, h, w, parent, text, color, font, func)
		local CheckBox = vgui.Create( "DCheckBoxLabel", parent or nil )
		if func then CheckBox.OnEdit = func end
		CheckBox:SetPos( x or 0, y or 0 )
		CheckBox:SetSize( h or 0, w or 0 )
		CheckBox:SetText( text or "" )
		if color then CheckBox:SetTextColor( color ) end
		if font then CheckBox:SetFont( font ) end
		CheckBox:SetValue( 0 )
		CheckBox.OnChange = function(s, v)
			if s.OnEdit then s:OnEdit(v) end
			if IsValid(s.CheckBox) then
				s.CheckBox:SetDisabled(not v)
			end
		end
		return CheckBox
	end
	local function MakeScratch(x, y, h, w, parent, value, max, parentCheckBox, disabled)
		local Scratch = vgui.Create( "DNumberWang", parent or nil )
		if parentCheckBox then
			parentCheckBox.CheckBox = Scratch
			Scratch.parentCheckBox = parentCheckBox
		end
		Scratch:SetDisabled(disabled or false)
		Scratch:SetPos( x or 0, y or 0 )
		Scratch:SetSize( h or 0, w or 0 )
		Scratch:SetValue( value or 0 )
		Scratch.Default = value or 0
		Scratch:SetMin( 0 )
		Scratch:SetMax( max or 99999 )
		Scratch.GetValueIfChecked = function(s, default)
			if s.parentCheckBox then
				if s.parentCheckBox:GetChecked() then return (s:GetValue() or s.Default) end
				return (default or false)
			end
			return (s:GetValue() or s.Default)
		end
		return Scratch
	end
	surface.CreateFont("ArmouryGUITitle", {font = "DermaDefault", size = 45, weight = 250, antialias = true, shadow = false})
	surface.CreateFont("ArmouryGUIButton", {font = "DermaDefault", size = 22, weight = 50, antialias = true, shadow = false})
	function WeaponArmoury:Close()
		if !IsValid(self.Frame) then return false end
		surface.PlaySound( "items/ammocrate_close.wav" )
		self.Frame:AlphaTo( 0, 0.1, 0, function(tab, this)
			if IsValid(this) then this:Remove() end
		end	)
		timer.Simple( 0.2, function() if self and IsValid(self.Frame) then self.Frame:Remove() end end)
	end
	function WeaponArmoury:Add(ArmouryEntity)
		if !IsValid(self.Content) then return false end
		if IsValid(self.PopUp) then self.PopUp:Remove() end
		local Background = vgui.Create( "DButton", self.Content )
		self.PopUp = Background
		Background:SetText("")
		Background:SetSize( self.Content:GetWide(), self.Content:GetTall() )
		Background:SetCursor( "arrow" )
		Background.Paint = function(s, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) )
		end
		Background.DoClick = function(s)
			if IsValid(s) then s:Remove() end
		end
		local Panel = vgui.Create( "DPanel", Background )
		Panel:SetSize( Background:GetWide()-50, Background:GetTall()-50 )
		Panel:Center()
		local WeaponList
		local InList = vgui.Create( "DListView", Panel )
		InList:SetSize( Panel:GetWide()/4, Panel:GetTall() )
		InList:SetMultiSelect( false )
		InList:AddColumn( "Weapons In Loadout" )
		InList.OnRowSelected = function(s, i, row)
			local line = WeaponList:AddLine( row.Name, row.Class )
			line.Name = row.Name
			line.Class = row.Class
			s:RemoveLine( i )
		end
		WeaponList = vgui.Create( "DListView", Panel )
		WeaponList:SetPos( Panel:GetWide()/4, 0 )
		WeaponList:SetSize( Panel:GetWide()/2, Panel:GetTall() )
		WeaponList:SetMultiSelect( false )
		WeaponList:AddColumn( "Weapon Name" )
		WeaponList:AddColumn( "Class" )
		WeaponList.OnRowSelected = function(s, i, row)
			local line = InList:AddLine( row.Name )
			line.Name = row.Name
			line.Class = row.Class
			s:RemoveLine( i )
		end
		for k,v in pairs(weapons.GetList()) do
			if !v.PrintName or v.PrintName == "" or !v.ClassName or v.ClassName == "" or !v.WorldModel or v.WorldModel == "" then continue end
			local line = WeaponList:AddLine( v.PrintName, v.ClassName )
			line.Name = v.PrintName
			line.Class = v.ClassName
		end

		local Options = vgui.Create( "DIconLayout", Panel )
		Options:SetPos( Panel:GetWide()-(Panel:GetWide()/4)+10, 10 )
		Options:SetSize( (Panel:GetWide()/4)-20, Panel:GetTall()-20 )
		Options:SetSpaceY( 5 )
		Options:SetSpaceX( 0 )

		local DLabel = vgui.Create( "DLabel", Panel )
		DLabel:SetSize( Options:GetWide(), 25 )
		DLabel:SetText( "Loadout Name:" )
		DLabel:SetTextColor( color_black )
		Options:Add( DLabel )

		local LoadoutName = vgui.Create( "DTextEntry", Panel )
		LoadoutName:SetSize( Options:GetWide(), 25 )
		LoadoutName:SetText( "DefaultLoadout" )
		LoadoutName.OnFocusChanged = function( s, focus )
			if !focus then s:OnEnter() end
		end
		LoadoutName.OnEnter = function( s )
			local text = s:GetValue() or false
			if !text or text=="" or text==" " or string.len(text) < 3 then s:SetTextColor( Color(150,0,0) ) return end
			self.Loadouts = self.Loadouts or {}
			for k, v in pairs(self.Loadouts) do if v.Name == text then s:SetTextColor( Color(150,0,0) ) return end end
			s:SetTextColor( Color(0,150,0) )
		end
		Options:Add( LoadoutName )

		local CheckBox = MakeCheckBox(0, 0, Options:GetWide(), 20, Panel, "Loadout Costs Money", color_black)
		Options:Add( CheckBox )
		local Costs = MakeScratch(0, 0, Options:GetWide(), 20, Panel, 50, 99999, CheckBox, true)
		Options:Add( Costs )

		local CheckBox = MakeCheckBox(0, 0, Options:GetWide(), 20, Panel, "Ammo Clips", color_black)
		Options:Add( CheckBox )
		local Ammo = MakeScratch(0, 0, Options:GetWide(), 20, Panel, 2, 50, CheckBox, true)
		Options:Add( Ammo )

		local mayor = MakeCheckBox(0, 0, Options:GetWide(), 20, Panel, "Requires Mayor Permission", color_black)
		Options:Add( mayor )
		local chief = MakeCheckBox(0, 0, Options:GetWide(), 20, Panel, "Police Chief Only", color_black)
		Options:Add( chief )

		local Lock = MakeCheckBox(0, 0, Options:GetWide(), 20, Panel, "Only avalible during lockdown", color_black)
		Options:Add( Lock )

		local CheckBox = MakeCheckBox(0, 0, Options:GetWide(), 20, Panel, "Limit to Every x Seconds", color_black)
		Options:Add( CheckBox )
		local Time = MakeScratch(0, 0, Options:GetWide(), 20, Panel, 120, 99999, CheckBox, true)
		Options:Add( Time )

		local Back = MakeButton(Panel:GetWide()-170, Panel:GetTall()-40, 70, 25, Panel, "BACK", Color(100,100,100,255), "ArmouryGUIButton", function(s)
			surface.PlaySound( "ui/buttonclick.wav" )
			if IsValid(Background) then Background:Remove() end
		end)

		local Finished = MakeButton(Panel:GetWide()-90, Panel:GetTall()-40, 80, 25, Panel, "", Color(100,100,100,255), "ArmouryGUIButton", function(s)
			local lines = InList:GetLines() or {}
			if !lines or #lines < 1 then return end
			local text = LoadoutName:GetValue() or false
			if !text or text=="" or text==" " or string.len(text) < 3 then return end
			local send = {}
			for k,v in pairs(lines) do table.insert(send, v.Class) end
			net.Start( "WeaponArmoury" )
				net.WriteEntity(ArmouryEntity)
				net.WriteInt( 2, 3 )
				net.WriteTable( send )
				net.WriteTable( {
					Name = text,
					Cost = Costs:GetValueIfChecked(),
					Ammo = Ammo:GetValueIfChecked(),
					Mayor = mayor:GetChecked(),
					Chief = chief:GetChecked(),
					CoolDown = Time:GetValueIfChecked(),
					Lockdown = Lock:GetChecked()
				})
			net.SendToServer()
		end)
		Finished.Paint = function(s, w, h) if !InList:GetLines() or #InList:GetLines() < 1 then s.Color = Color(100,100,100,255) else s.Color = Color(97,149,224,255) end  draw.SimpleText( "FINISH", "ArmouryGUIButton", w/2, h/2, s.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) end
	end
	function WeaponArmoury:Init(ArmouryEntity)
		if IsValid(self.Frame) then self.Frame:Remove() end
		local Frame	= vgui.Create( "DFrame" )
		self.Frame = Frame
		self.Selected = nil
		Frame:SetSize( ScrW(), ScrH() )
		Frame:SetTitle("")
		Frame:ShowCloseButton( false )
		Frame:MakePopup()
		Frame.Paint = function(s, w, h) end
		local Background = vgui.Create( "DButton", Frame )
		Background:SetSize( Frame:GetWide(), Frame:GetTall() )
		Background:SetText("")
		Background:SetCursor( "arrow" )
		Background.Paint = function(s, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) )
		end
		Background:SetAlpha( 0 )
		Background:AlphaTo( 255, 0.1 )
		Background.DoClick = function(s)
			self:Close()
		end
		local Content = vgui.Create( "DPanel", Background )
		self.Content = Content
		Content:SetSize( Background:GetWide()/2, Background:GetTall()/2 )
		Content:Center()
		local x, y = Content:GetPos()
		Content:SetPos(x,y+(Content:GetTall()/4))
		Content:SetAlpha( 0 )
		Content:AlphaTo( 255, 0.3 )
		Content:MoveTo( x, y, 0.3, 0, -1)
		Content.Paint = function(s, w, h)
			draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
			draw.RoundedBox( 8, 0, 0, w-2, h-2, Color( 220, 220, 220, 255 ) )
			draw.SimpleText( "Armoury", "ArmouryGUITitle", 10, 0, Color(100,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "Select the loadout you want to use.", "DermaDefault", 150, 25, Color(100,100,100,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
		if LocalPlayer():IsSuperAdmin() then
			local Add = MakeButton(10, Content:GetTall()-40, 70, 25, Content, "ADD", Color(110,166,79,255), "ArmouryGUIButton", function(s)
				surface.PlaySound( "ui/buttonclick.wav" )
				self.Selected = nil
				self:Add(ArmouryEntity)
			end)
		end
		local Cancel = MakeButton(Content:GetWide()-170, Content:GetTall()-40, 70, 25, Content, "CANCEL", Color(100,100,100,255), "ArmouryGUIButton", function(s)
			self:Close()
		end)
		local Accept = MakeButton(Content:GetWide()-90, Content:GetTall()-40, 80, 25, Content, "", Color(100,100,100,255), "ArmouryGUIButton", function(s)
			if !self.Selected or !self.Selected.Name then return end
			net.Start( "WeaponArmoury" )
				net.WriteEntity( ArmouryEntity )
				net.WriteInt( 1, 3 )
				net.WriteString( self.Selected.Name )
			net.SendToServer()
			self:Close()
		end)
		Accept.Paint = function(s, w, h) if !self.Selected then s.Color = Color(100,100,100,255) else s.Color = Color(97,149,224,255) end  draw.SimpleText( "ACCEPT", "ArmouryGUIButton", w/2, h/2, s.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) end
		local Scroll = vgui.Create( "DHorizontalScroller", Content )
		Scroll:SetPos( 5, 50 )
		Scroll:SetSize( Content:GetWide()-5, Content:GetTall()-100 )
		Scroll:SetOverlap(-5)
		self.Loadouts = self.Loadouts or {}
		for k, v in pairs(self.Loadouts) do
			local Panel = vgui.Create( "DPanel", Scroll )
			Panel.Name = v.Name
			Panel:SetSize( Scroll:GetWide()/math.Clamp(#self.Loadouts,0,5)-5, Scroll:GetTall() )
			Panel.Paint = function(s, w, h)
				draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 50 ) )
				if s.Hovered then
					draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 150, 50 ) )
					draw.SimpleText( v.Name, "DermaLarge", 5, 0, Color(50,50,50,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				else
					draw.SimpleText( v.Name, "DermaLarge", 5, 0, Color(120,120,120,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				end
				local i=0
				if tobool(v.Lockdown) and (s.Hovered or self.Selected == s) then i=i+1 draw.SimpleText( "Lockdown only.", "DermaDefault", 10, h-(i*15), Color(50,50,50,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP ) end
				if tobool(v.Mayor) and (s.Hovered or self.Selected == s) then i=i+1 draw.SimpleText( "Mayors permission required.", "DermaDefault", 10, h-(i*15), Color(50,50,50,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP ) end
				if tobool(v.Chief) and (s.Hovered or self.Selected == s) then i=i+1 draw.SimpleText( "Police chief only.", "DermaDefault", 10, h-(i*15), Color(50,50,50,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP ) end
				if (s.Hovered or self.Selected == s) and (v.Cost and tonumber(v.Cost) > 0) then i=i+1 draw.SimpleText( "$"..tonumber(v.Cost), "DermaDefault", 10, h-(i*15), Color(50,50,50,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP ) end
				if self.Selected == s then draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 200, 0, 50 ) ) end
			end
			Scroll:AddPanel(Panel)
			local List	= vgui.Create( "DIconLayout", Panel )
			List:SetPos( 0, 0 )
			List:SetSize( Panel:GetWide(), Panel:GetTall() )
			List:SetSpaceY( 0 )
			List:SetSpaceX( 0 )
			for k, i in pairs(v.Weapons) do
				local Weapon = weapons.GetStored( i )
				if !Weapon or !Weapon.WorldModel then continue end
				local ListPanel = List:Add( "DPanel" )
				ListPanel:SetSize( Panel:GetWide(), Panel:GetTall()/#v.Weapons )
				ListPanel.Paint = function(s, w, h) end
				local size = 100
				if #v.Weapons > 3 then size = 80 end
				if #v.Weapons > 5 then size = 50 end
				local ListItem = vgui.Create( "SpawnIcon", ListPanel )
				ListItem:SetPos( ListPanel:GetWide()/2-(size/2), ListPanel:GetTall()/2-(size/2) )
				ListItem:SetSize( size, size )
				ListItem:SetModel( Weapon.WorldModel )
			end
			local Overlay = vgui.Create( "DButton", Panel )
			Overlay:SetSize( Panel:GetWide(), Panel:GetTall() )
			Overlay:SetText("")
			Overlay.OnCursorEntered = function(s) surface.PlaySound( "ui/buttonrollover.wav" ) Panel.Hovered = true end
			Overlay.OnCursorExited = function(s) Panel.Hovered = false end
			Overlay.Paint = function(s, w, h) end
			Overlay.DoClick = function(s) surface.PlaySound( "npc/combine_soldier/gear4.wav" ) self.Selected = Panel end
			if LocalPlayer():IsSuperAdmin() then
				Overlay.DoRightClick = function(s)
					local Menu = DermaMenu()
					Menu:AddOption( "Remove Loadout", function()
						net.Start( "WeaponArmoury" )
							net.WriteEntity( ArmouryEntity )
							net.WriteInt( 3, 3 )
							net.WriteString( v.Name )
						net.SendToServer()
					end ):SetIcon( "icon16/cross.png" )
					Menu:Open()
				end
			end
		end
	end
	net.Receive( "WeaponArmoury", function()
		surface.PlaySound( "items/ammocrate_open.wav" )
		local ArmouryEntity = net.ReadEntity() or false
		if !IsValid(ArmouryEntity) then return end
		local WeaponTable = net.ReadTable() or {}
		WeaponArmoury.Loadouts = WeaponTable or {}
		WeaponArmoury:Init(ArmouryEntity)
	end )
	surface.CreateFont("Armoury3D", {font = "DermaDefault", size = 140, weight = 550, antialias = true, shadow = false})
	function ENT:Draw()
		self:DrawModel()
		local dist = self:GetPos():Distance(LocalPlayer():GetPos())
		if IsValid(LocalPlayer()) and IsValid(self) and dist < 300 then
			local Pos = self:GetPos()
			local Ang = self:GetAngles()
			Ang:RotateAroundAxis(Ang:Up(), 90)
			Ang:RotateAroundAxis(Ang:Forward(), 90)
			local Forward = 8.6
			local Up = -24
			cam.Start3D2D(Pos + (Ang:Up() * Forward) + (Ang:Right() * Up), Ang, 0.1)
				draw.SimpleTextOutlined( "Armoury", "Armoury3D", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,100) )
				draw.SimpleTextOutlined( "Use to select a loadout", "DermaLarge", 0, 120, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,100) )
			cam.End3D2D()
		end
	end
end
