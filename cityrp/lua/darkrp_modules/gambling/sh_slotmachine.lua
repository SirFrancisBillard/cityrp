local GMD = SlotMachine_Adjust.Gamemode or 1
local meta = FindMetaTable("Player");

function meta:SM_IsAdmin()
	local UG = self:GetNWString("usergroup")
	UG = string.lower(UG)
	
	if table.HasValue(SlotMachine_Adjust.SaveableULXGroup,UG) then 
		return true
	else
		return false
	end
end

function meta:SM_GetPlayerMoneyM()
	return self:getDarkRPVar("money")
end
if SERVER then
	function meta:SM_AddPlayerMoneyM(int)
		if GMD == 1 then  -- 1 for DarkRP
			if !self.AddMoney then
				self:ChatPrint("Slot machine error : i think you are running darkrp 2.5.0 , goto slotmachine addon/lua/autorun/SlotMachine_Customizer.lua  and set gamemode code to 2. then please restart your server.")
			end
			self:AddMoney(int)
		end
		if GMD == 2 then -- 2 for DarkRP2.5.0
			if !self.addMoney then
				self:ChatPrint("Slot machine error : i think you are running darkrp 2.4.3 , goto slotmachine addon/lua/autorun/SlotMachine_Customizer.lua  and set gamemode code to 1. then please restart your server.")
			end
			self:addMoney(int)
		end
	end
	function meta:SM_Notify(text)
		if GMD == 1 then  -- 1 for DarkRP
			GAMEMODE:Notify(self, 1, 4, text)
		end
		if GMD == 2 then -- 2 for DarkRP2.5.0
			DarkRP.notify( self, 1, 4, text)
		end
	end
end
