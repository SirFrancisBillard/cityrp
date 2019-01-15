local META = FindMetaTable("Player")

local Curable = {
	"Chlamydia",
	"Gonorrhea",
	"Syphilis",
	"Crabs",
	"Chancroid",
	"Scabies"
}

local Incurable = {
	"AIDS",
	"Herpes"
}

local Damage = 5

function META:GiveSTD()
	local tab = math.random(8) == 1 and Incurable or Curable
	self:ChatPrint("Oh no! You got " .. tab[math.random(#tab)] .. "!")
	if tab == Curable then
		self:ChatPrint("You will die soon unless you seek treatment.")
	else
		self:ChatPrint("It's incurable... might as well kys.")
		self:SetNWBool("std_incurable", true)
	end
	if not timer.Exists(self:SteamID() .. "_PlayerHasSTD") then
		timer.Create(self:SteamID() .. "_PlayerHasSTD", 1.5, 0, function()
			if self:Health() - Damage <= 0 then 
				self:Kill()
				self:SetNWBool("std_incurable", false)
				timer.Remove(self:SteamID() .. "_PlayerHasSTD")
			else
				self:SetHealth(self:Health() - Damage)
				self:EmitSound("STD.Moan")
			end
		end)
	end
end

function META:CureSTD()
	if not timer.Exists(self:SteamID() .. "_PlayerHasSTD") then
		self:ChatPrint("Good news, you're clean!")
		return false
	end
	if self:GetNWBool("std_incurable", false) then
		self:ChatPrint("I'm afraid you cannot be cured!")
		return false
	end
	timer.Remove(self:SteamID() .. "_PlayerHasSTD")
	return true
end
