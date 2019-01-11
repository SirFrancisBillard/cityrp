SlotMachine_Adjust = {}
SlotMachine_Adjust.Slots = {}

-- Gamemode code.
	-- 1 : DarkRP ( lower than 2.5.0 )
	-- 2 : DarkRP 2.5.0 or higher
	SlotMachine_Adjust.Gamemode = 2
	
	-- Saveable ULX Group
	SlotMachine_Adjust.SaveableULXGroup = { "superadmin" , "owner", "admin" } -- < KEEP THESE LOWERCASE >
	
	-- How can i know my ulx group?
	-- -> type ' sv_allowcslua 1 ' to server. then, type ' lua_run_cl MsgN(LocalPlayer():GetNWString("usergroup")) ' to your gmod console .
	-- -> you may got some message from your gmod console. if not, im pretty sure that you are not using ulx. you need ulx to save slotmachine
	

	-- Betting Price
	SlotMachine_Adjust.BetPrice = 1000

	-- Win Rate
		-- if you set this to 100, player always wins.
		SlotMachine_Adjust.WinRate = 5 -- 5% chance to win
	
	
	
	-- Adding Elements
	/* Customizing TIP 
		local TB2Insert = {}   <- Do not Touch!!
		TB2Insert.PrintText = "7"   <- This is some text prints slotmachine.
		TB2Insert.PrintColor = Color(255,255,0,255)  <- text color
		TB2Insert.Rate = 10    <- Selection Rate. / Once you win. system will serch for elements.
		TB2Insert.Price = 7000    <- The Price winner get.
		table.insert(SlotMachine_Adjust.Slots,TB2Insert)     <- Do not Touch!!
	*/
	
	
	local TB2Insert = {}
	TB2Insert.PrintText = "$"
	TB2Insert.PrintColor = Color(255,255,0,255)
	TB2Insert.Rate = 5
	TB2Insert.Price = 2000
	table.insert(SlotMachine_Adjust.Slots,TB2Insert)
	
	local TB2Insert = {}
	TB2Insert.PrintText = "7"
	TB2Insert.PrintColor = Color(255,120,0,255)
	TB2Insert.Rate = 10
	TB2Insert.Price = 1200
	table.insert(SlotMachine_Adjust.Slots,TB2Insert)
	
	local TB2Insert = {}
	TB2Insert.PrintText = "♪"
	TB2Insert.PrintColor = Color(0,255,0,255)
	TB2Insert.Rate = 20
	TB2Insert.Price = 950
	table.insert(SlotMachine_Adjust.Slots,TB2Insert)
	
	local TB2Insert = {}
	TB2Insert.PrintText = "★"
	TB2Insert.PrintColor = Color(0,255,255,255)
	TB2Insert.Rate = 30
	TB2Insert.Price = 700
	table.insert(SlotMachine_Adjust.Slots,TB2Insert)
	
	local TB2Insert = {}
	TB2Insert.PrintText = "♣"
	TB2Insert.PrintColor = Color(0,0,255,255)
	TB2Insert.Rate = 50
	TB2Insert.Price = 500
	table.insert(SlotMachine_Adjust.Slots,TB2Insert)
	
	