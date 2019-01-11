
/*
Stungun SWEP Created by Donkie (http://steamcommunity.com/id/Donkie/)
For personal/server usage only, do not resell or distribute!
*/

AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

//Assets
resource.AddFile("materials/stungun/lightningbolt.png")
resource.AddFile("materials/stungun/lightningbolt_glow.png")
resource.AddFile("materials/stungun/lightningbolt_outline.png")
resource.AddFile("materials/stungun/lightningbolt2.png")
resource.AddFile("sound/stungun/tazer.wav")
if STUNGUN.IsTTT then
	resource.AddFile("materials/stungun/icon_stungun.vmt")
end

//Stores the players weaponclasses and ammo in a table.
local function PlyStoreWeapons(ply)
	ply.storeweps = {}
	for k,v in pairs(ply:GetWeapons()) do
		table.insert(ply.storeweps, {cl = v:GetClass(), c1 = v:Clip1(), c2 = v:Clip2()})
	end
end

//Retrieves the stored weapons.
local function PlyRetrieveWeapons(ply)
	for k,v in pairs(ply.storeweps or {}) do
		ply:Give(v.cl)
		local wep = ply:GetWeapon(v.cl)
		if IsValid(wep) then
			wep:SetClip1(v.c1)
			wep:SetClip2(v.c2)
		end
	end
end

//Transforms a (1,1,1,1) color table to (255,255,255,255)
local function FromPlyColor(v)
	v:Mul(255)
	return Color(v.x,v.y,v.z,255)
end

function SWEP:Equip( ply )
	self.BaseClass.Equip(self,ply)
	self.lastowner = ply
end

util.AddNetworkString("tazerondrop")
function SWEP:OnDrop()
	self.BaseClass.OnDrop(self)
	if IsValid(self.lastowner) then
		net.Start("tazerondrop")
			net.WriteEntity(self)
		net.Send(self.lastowner)
	end
end


/*
Makes a hull trace the size of a player.
*/
local data = {}
function STUNGUN.PlayerHullTrace(pos, ply, filter)
	data.start = pos
	data.endpos = pos
	data.filter = filter
	
	return util.TraceEntity( data, ply )
end

/*
Attemps to place the player at this position or as close as possible.
*/
// Directions to check
local directions = {
	Vector(0,0,0), Vector(0,0,1), //Center and up
	Vector(1,0,0), Vector(-1,0,0), Vector(0,1,0), Vector(0,-1,0) //All cardinals
	}
for deg=45,315,90 do //Diagonals
	local r = math.rad(deg)
	table.insert(directions, Vector(math.Round(math.cos(r)), math.Round(math.sin(r)), 0))
end

local magn = 15 // How much increment for each iteration
local iterations = 2 // How many iterations
function STUNGUN.PlayerSetPosNoBlock( ply, pos, filter )
	local tr
	
	local dirvec
	local m = magn
	local i = 1
	local its = 1
	repeat
		dirvec = directions[i] * m
		i = i + 1
		if i > #directions then
			its = its + 1
			i = 1
			m = m + magn
			if its > iterations then
				ply:SetPos(pos) // We've done as many checks as we wanted, lets just force him to get stuck then.
				return false
			end
		end
		
		tr = STUNGUN.PlayerHullTrace(dirvec + pos, ply, filter)
	until tr.Hit == false
	
	ply:SetPos(pos + dirvec)
	return true
end

/*
Sets the player invisible/visible
*/
function STUNGUN.PlayerInvis( ply, bool )
	ply:SetNoDraw(bool)
	ply:DrawShadow( not bool )
	/*
	ply:SetMaterial( bool and "models/effects/vol_light001" or "" )
	ply:SetRenderMode( bool and RENDERMODE_TRANSALPHA or RENDERMODE_NORMAL )
	ply:Fire( "alpha", bool and 0 or 255, 0 )
	*/
end

/*
Deploy player ragdoll
*/
function STUNGUN.Ragdoll( ply, pushdir )
	local plyphys = ply:GetPhysicsObject()
	local plyvel = Vector(0,0,0)
	if plyphys:IsValid() then
		plyvel = plyphys:GetVelocity()
	end
	
	ply.tazedpos = ply:GetPos() // Store pos incase the ragdoll is missing when we're to unrag him.
	
	local rag = ents.Create("prop_ragdoll")
		rag:SetModel(ply:GetModel())
		rag:SetPos(ply:GetPos())
		rag:SetAngles(Angle(0,ply:GetAngles().y,0))
		//FromPlyColor(ply:GetPlayerColor())) //Clothes get correct color, but the head gets pitchblack. :(
		rag:SetColor(ply:GetColor())
		rag:SetMaterial(ply:GetMaterial())
		rag:Spawn()
		rag:Activate()
	
	if not IsValid(rag:GetPhysicsObject()) then
		MsgN("A tazed player didn't get a valid ragdoll. Model ("..ply:GetModel()..")!")
		SafeRemoveEntity(rag)
		return false
	end
	
	rag.tazesnd = CreateSound(rag, "stungun/tazer.wav")
	rag.tazesnd:PlayEx(1, 80)
	
	//Lower inertia makes the ragdoll have trouble rolling. Citizens have 1,1,1 as default, while combines have 0.2,0.2,0.2.
	rag:GetPhysicsObject():SetInertia(Vector(1,1,1)) 
	
	//Push him back abit
	plyvel = plyvel + pushdir*200
	rag:GetPhysicsObject():SetVelocity(plyvel)
		
	//Stop firing of weapons
	PlyStoreWeapons(ply)
	ply:StripWeapons()
	
	//Makes him not collide with anything, including traces.
	ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	
	//Make him follow the ragdoll, if the player gets away from the ragdoll he won't get stuff rendered properly.
	ply:SetParent(rag)
	
	//Make the player invisible.
	STUNGUN.PlayerInvis(ply, true)

	ply.tazeragdoll = rag
	rag.tazeplayer = ply
	
	if STUNGUN.IsDarkRP then
		STUNGUN.InitDarkRPFunctions(rag)
	end
	
	ply:SetNWEntity("tazerviewrag", rag)
	rag:SetNWEntity("plyowner", ply)
	
	ply.lasthp = ply:Health()
	net.Start("tazersendhealth")
		net.WriteEntity(ply)
		net.WriteInt(ply:Health(),32)
	net.Broadcast()
	
	return true
end

function STUNGUN.UnRagdoll( ply )
	local ragvalid = IsValid(ply.tazeragdoll)
	local pos
	if ragvalid then // Sometimes the ragdoll is missing when we want to unrag, not good!
		if ply.tazeragdoll.hasremoved then return end // It has already been removed.
		
		pos = ply.tazeragdoll:GetPos()
		ply:SetModel(ply.tazeragdoll:GetModel())
		if ply.tazeragdoll.tazesnd then
			ply.tazeragdoll.tazesnd:Stop()
			ply.tazeragdoll.tazesnd = nil
		end
		ply.tazeragdoll.hasremoved = true
	else
		pos = ply.tazedpos // Put him at the place he got tazed, works great.
	end
	ply:SetParent()
	
	STUNGUN.PlayerSetPosNoBlock(ply, pos, {ply, ply.tazeragdoll})
	
	ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	
	timer.Simple(0,function()
		SafeRemoveEntity(ply.tazeragdoll)
		STUNGUN.PlayerInvis(ply, false)
	end)
	
	timer.Simple(.5, function()
		PlyRetrieveWeapons(ply)
	end)
	
	net.Start("tazeendview")
	net.Send(ply)
end


util.AddNetworkString("tazestartview")
util.AddNetworkString("tazeendview")
	
function STUNGUN.Electrolute( ply, pushdir )
	if ply.tazeimmune then return end
	
	//Ragdoll
	STUNGUN.Ragdoll(ply, pushdir)
	
	//Gag
	ply.tazeismuted = true
	
	local id = ply:UserID()
	timer.Create("Unelectrolute"..id, STUNGUN.ParalyzedTime, 1, function()
		if IsValid(ply) then STUNGUN.Unelectrolute( ply ) end
	end)
	timer.Create("tazeUngag"..id, STUNGUN.MuteTime, 1, function()
		if IsValid(ply) then STUNGUN.UnMute( ply ) end
	end)
	
	timer.Create("HurtingTimer"..id,2,0,function()
		if not IsValid(ply) or not IsValid(ply.tazeragdoll) then timer.Destroy("HurtingTimer"..id) return end
		ply.tazeragdoll:EmitSound(STUNGUN.PlayHurtSound(ply), 100, 100)
	end)
end

function STUNGUN.UnMute( ply )
	ply.tazeismuted = false
end

function STUNGUN.Unelectrolute( ply )
	STUNGUN.UnRagdoll( ply )
	timer.Destroy("HurtingTimer"..ply:UserID())
	
	if STUNGUN.Immunity > 0 then
		ply.tazeimmune = true
		timer.Simple(STUNGUN.Immunity, function()
			if IsValid(ply) then
				ply.tazeimmune = false
			end
		end)
	end
end

hook.Add("PlayerSay", "Tazer", function(ply, str)
	if ply.tazeismuted then return "" end
end)

util.AddNetworkString("tazersendhealth")
hook.Add("Think", "Tazer", function()
	for k,v in pairs(player.GetAll()) do
		if IsValid(v.tazeragdoll) then
			//Send new health. The normal health sending is somehow broken when ragdolled.
			if v:Health() != v.lasthp then
				net.Start("tazersendhealth")
					net.WriteEntity(v)
					net.WriteInt(v:Health(),32)
				net.Broadcast()
				v.lasthp = v:Health()
			end
			
			local rag = v.tazeragdoll
			local phys = rag:GetPhysicsObjectNum(0)
			if phys:IsValid() then
				phys:AddAngleVelocity(Vector(0,math.sin(CurTime()) * 250,0))
			end
		end
	end
end)

hook.Add("EntityTakeDamage", "Tazer", function(ent, dmginfo)
	if ent:IsPlayer() and IsValid(ent.tazeragdoll) and not ent.ragdolldamage then // If we're hitting the player somehow we won't let, the ragdoll should take the damage.
		dmginfo:SetDamage(0)
		return
	end
	
	if STUNGUN.AllowDamage and IsValid(ent.tazeplayer) and (dmginfo:GetAttacker() != game.GetWorld()) then //Worldspawn appears to be very eager to damage ragdolls. Don't!
		if STUNGUN.IsDarkRP and IsValid(dmginfo:GetAttacker():GetActiveWeapon()) and dmginfo:GetAttacker():GetActiveWeapon().ClassName == "stunstick" then // Negate stunstick damage
			return
		end
		
		local ply = ent.tazeplayer
		//To prevent infiniteloop and other trickery, we need to know if it was ragdamage.
		ply.ragdolldamage = true
		ply:TakeDamageInfo(dmginfo) // Apply all ragdoll damage directly to the player.
		ply.ragdolldamage = false
	end
end)

function STUNGUN.CleanupParalyze(ply)
	if IsValid(ply.tazeragdoll) then
		ply.tazeragdoll.tazesnd:Stop()
		ply.tazeragdoll.tazesnd = nil
		timer.Simple(0,function()
			SafeRemoveEntity(ply.tazeragdoll)
		end)
		
		timer.Destroy("HurtingTimer"..ply:UserID())
		timer.Destroy("Unelectrolute"..ply:UserID())
		timer.Destroy("tazeUngag"..ply:UserID())
		net.Start("tazeendview")
		net.Send(ply)
		
		//While he'll respawn and get this reset, his deadbody won't be visible so we need to reset it here.
		STUNGUN.PlayerInvis(ply, false)
		
		//If he's respawning the immediate un-invisible won't have any effect. We need some delay.
		timer.Simple(.5,function()
			STUNGUN.PlayerInvis(ply, false)
		end)
	end
	
	ply.tazeismuted = false
end

//If someone removes the ragdoll, untaze the player.
hook.Add("EntityRemoved", "Tazer", function(ent)
	if IsValid(ent.tazeplayer) then
		STUNGUN.UnRagdoll(ent.tazeplayer)
	end
end)

//Some code directly respawns the player using :Spawn() without even killing him. We need to remove shit then.
hook.Add("PlayerSpawn", "Tazer", function(ply)
	STUNGUN.CleanupParalyze(ply)
end)
//If he dies, clean up.
hook.Add("DoPlayerDeath", "Tazer", function(ply, inf, atk)
	STUNGUN.CleanupParalyze(ply)
end)

hook.Add("PlayerCanSeePlayersChat", "Tazer", function(text, teamOnly, listener, talker)
	if (not STUNGUN.IsTTT or GetRoundState() == ROUND_ACTIVE) and talker.tazeismuted then
		return false
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "Tazer", function(listener, talker)
	if (not STUNGUN.IsTTT or GetRoundState() == ROUND_ACTIVE) and talker.tazeismuted then
		return false,false
	end
end)

hook.Add("CanPlayerSuicide", "Tazer", function(ply)
	if not STUNGUN.ParalyzeAllowSuicide and IsValid(ply.tazeragdoll) then return false end
	if not STUNGUN.MuteAllowSuicide and ply.tazeismuted then return false end
end)

hook.Add("PlayerCanPickupWeapon", "Tazer", function(ply, wep)
	if IsValid(ply.tazeragdoll) then return false end
end)

local function DoFallDmg(ply, vel, veldir, umph)
	local dmg = math.floor(hook.Call("GetFallDamage", GAMEMODE, ply, vel))
	if dmg != 0 then
		local dmginfo = DamageInfo()
			dmginfo:SetDamageType(DMG_FALL)
			dmginfo:SetDamage(dmg)
			dmginfo:SetDamageForce(vel * veldir)
			dmginfo:SetDamagePosition(ply.tazeragdoll:GetPos())
			dmginfo:SetAttacker(game.GetWorld())
			dmginfo:SetInflictor(game.GetWorld())
			
		ply.ragdolldamage = true
		ply:TakeDamageInfo(dmginfo)
		ply.ragdolldamage = false
	end
end

hook.Add("Think", "TazerDoRagDmg", function()
	if not STUNGUN.Falldamage then return end
	
	for k,v in pairs(ents.FindByClass("prop_ragdoll")) do
		if IsValid(v.tazeplayer) then
			local phys = v:GetPhysicsObject()
			local vel = phys:GetVelocity():Length()
			
			if not v.lastfallvel then
				v.lastfallvel = vel
			end
			
			if vel >= v.lastfallvel then
				v.lastfallvel = vel
			else
				local deltavel = (v.lastfallvel - vel)
				local umph = deltavel * FrameTime() // Retardation
				umph = umph * umph // More realistic when squared
				if umph > 50 then
					DoFallDmg(v.tazeplayer, deltavel, phys:GetVelocity():GetNormal(), umph)
					v.lastfallvel = 0
				end
			end
		end
	end
end)

/*
DarkRP specifics
*/
//I'm not sure of the differences between these but one of them lets me put a nice message, while the other takes account in all cases. So I use both.
hook.Add("canChangeJob", "Tazer", function(ply, job)
	if IsValid(ply.tazeragdoll) then
		return false, "You can't change job while paralyzed!"
	end
end)
hook.Add("playerCanChangeTeam", "Tazer", function(ply)
	if IsValid(ply.tazeragdoll) then
		return false
	end
end)

/*
Arrestfunc
*/
local arrestfunc = function(rag, cop)
	local ply = rag.tazeplayer
	if not IsValid(ply) then return end
	if cop:EyePos():Distance(rag:GetPos()) > 90 then return end
	
	//The onArrestStickUsed is called before all validity checks are done, so I need to do them myself.
	if STUNGUN.IsDarkRP25 then
		//DarkRP 2.5
		if ply:isCP() and not GAMEMODE.Config.cpcanarrestcp then
			DarkRP.notify(cop, 1, 5, DarkRP.getPhrase("cant_arrest_other_cp"))
			return
		end

		if GAMEMODE.Config.needwantedforarrest and not ply:getDarkRPVar("wanted") then
			DarkRP.notify(cop, 1, 5, DarkRP.getPhrase("must_be_wanted_for_arrest"))
			return
		end

		if FAdmin and ply:FAdmin_GetGlobal("fadmin_jailed") then
			DarkRP.notify(cop, 1, 5, DarkRP.getPhrase("cant_arrest_fadmin_jailed"))
			return
		end
		
		local jpc = DarkRP.jailPosCount()
		if not jpc or jpc == 0 then
			DarkRP.notify(cop, 1, 4, DarkRP.getPhrase("cant_arrest_no_jail_pos"))
			return
		end
		
		//Arresting
		ply:arrest(nil, cop)
		DarkRP.notify(ply, 0, 20, DarkRP.getPhrase("youre_arrested_by", cop:Nick()))

		if cop.SteamName then
			DarkRP.log(cop:Nick().." ("..cop:SteamID()..") arrested "..ply:Nick().." (victim was stungun-ragdolled)", Color(0, 255, 255))
		end
	else
		//Backwards compatibility (2.4.3)
		if ply:IsCP() and not GAMEMODE.Config.cpcanarrestcp then
			GAMEMODE:Notify(cop, 1, 5, "You can not arrest other CPs!")
			return
		end
		
		if GAMEMODE.Config.needwantedforarrest and not ply.DarkRPVars.wanted then
			GAMEMODE:Notify(cop, 1, 5, "The player must be wanted in order to be able to arrest them.")
			return
		end

		if FAdmin and ply:FAdmin_GetGlobal("fadmin_jailed") then
			GAMEMODE:Notify(cop, 1, 5, "You cannot arrest a player who has been jailed by an admin.")
			return
		end
		
		local jpc = DB.CountJailPos()
		if not jpc or jpc == 0 then
			GAMEMODE:Notify(cop, 1, 4, "You cannot arrest people since there are no jail positions set!")
			return
		end
		
		ply:Arrest()
		GAMEMODE:Notify(ply, 0, 20, "You've been arrested by " .. cop:Nick())

		if cop.SteamName then
			DB.Log(cop:SteamName().." ("..cop:SteamID()..") arrested "..ply:Nick().." (victim was stungun-ragdolled)", nil, Color(0, 255, 255))
		end
	end
end

/*
Unarrestfunc
*/
local unarrestfunc = function(rag, cop)
	local ply = rag.tazeplayer
	if not IsValid(ply) then return end
	if cop:EyePos():Distance(rag:GetPos()) > 115 then return end
	
	//The onUnArrestStickUsed is called before all validity checks are done, so I need to do them myself.
	if STUNGUN.IsDarkRP25 then
		//DarkRP 2.5
		
		if not ply:getDarkRPVar("Arrested") then return end

		STUNGUN.UnRagdoll(ply)
		timer.Simple(0.1,function()
			ply:unArrest(cop)
			DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("youre_unarrested_by", cop:Nick()))

			if cop.SteamName then
				DarkRP.log(cop:Nick().." ("..cop:SteamID()..") unarrested "..ply:Nick().." (victim was stungun-ragdolled)", Color(0, 255, 255))
			end
		end)
	else
		//Backwards compatibility (2.4.3)
		
		if not ply.DarkRPVars.Arrested then return end
		
		STUNGUN.UnRagdoll(ply)
		timer.Simple(0.1,function()
			ply:Unarrest()
			GAMEMODE:Notify(ply, 0, 4, "You were unarrested by " .. cop:Nick())

			if cop.SteamName then
				DB.Log(cop:SteamName().." ("..cop:SteamID()..") unarrested "..ply:Nick().." (victim was stungun-ragdolled)", nil, Color(0, 255, 255))
			end
		end)
	end
end

/*
Call on a ragdoll to set it up with the arrest and unarrest functions required
*/
function STUNGUN.InitDarkRPFunctions(rag)
	rag.onArrestStickUsed = arrestfunc
	rag.onUnArrestStickUsed = unarrestfunc
end

/*
TTT Specifics
*/
function SWEP:WasBought(buyer)
	if not self.InfiniteAmmo then
		buyer:GiveAmmo(math.max(0, self.Ammo - 1), "ammo_stungun")
	end
end


