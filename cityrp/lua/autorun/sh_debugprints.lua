
-- find out where the fuck those fucking stupid fucking prints are coming from

local OldPrint = OldPrint or print

function print(...)
	return OldPrint("[" .. debug.getinfo(2).short_src .. "]", ...)
end 
