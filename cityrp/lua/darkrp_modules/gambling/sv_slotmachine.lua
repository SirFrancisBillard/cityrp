hook.Add("Initialize", "SlotMachine Dir Check", function()
	file.CreateDir("slotmachine")
	file.CreateDir("slotmachine/mapsave")
end)

	concommand.Add("Slotmachine_Save",function(ply,cmd,args)
		ply:ChatPrint("Slot Machine :: Saving Start...")
		if !ply:SM_IsAdmin() then 
			ply:ChatPrint("Slot Machine :: Warning. you can't save. you are not admin.")
			return 
		end
		
		MsgN("SlotMachines - Saving all SlotMachines")
		local TB2Save = {}
		for k,v in pairs(ents.FindByClass("rx_slotmachine")) do
			local TB2Insert = {}
			TB2Insert.Pos = v:GetPos()
			TB2Insert.Angle = v:GetAngles()
			table.insert(TB2Save,TB2Insert)
		end
		
		local Map = string.lower(game.GetMap())
		file.Write("slotmachine/mapsave/" .. Map .. ".txt", util.TableToJSON(TB2Save))
		
		ply:ChatPrint("Slot Machine :: Entities are saved.")
	end)
	
	hook.Add( "InitPostEntity", "SlotMachines Entity Post", function()
	local Map = string.lower(game.GetMap())
		local Data = {}
		if file.Exists( "slotmachine/mapsave/" .. Map .. ".txt" ,"DATA") then
			Data = util.JSONToTable(file.Read( "slotmachine/mapsave/" .. Map .. ".txt" ))
		end
		MsgN("SlotMachines - Spawning all SlotMachines")
		for k,v in pairs(Data) do
			local SlotMachine = ents.Create("rx_slotmachine")
			SlotMachine:SetPos(v.Pos)
			SlotMachine:SetAngles(v.Angle)
			SlotMachine:Spawn()
		end
		MsgN("SlotMachines - Spawning Complete. [ " .. #Data .. " ] ")
	end )