
if SERVER then
	util.AddNetworkString("SendVideoTest")
	file.CreateDir("savedvids_sv")

	net.Receive("SendVideoTest", function(len, ply)
		local bytes = net.ReadUInt(32)
		print("getting " .. bytes .. " bytes")
		local vid = net.ReadData(bytes)
		print("getting " .. #vid .. " bytes")
		file.Write("savedvids_sv/sv_vid.txt", vid)
	end)
else
	file.CreateDir("savedvids_cl")

	local vid = file.Read("videos/muh.webm", "MOD")
	local cvid = util.Compress(vid)
	print(tostring(cvid))
	local size = file.Size("videos/muh.webm", "MOD")
	if size < 0 then print("yikes!") return end
	file.Write("savedvids_cl/cl_vid.txt", vid)
	print("sending " .. #vid .. " bytes")
	net.Start("SendVideoTest")
	net.WriteUInt(#vid, 32)
	net.WriteData(vid, #vid)
	print(tostring(net.BytesWritten()))
	net.SendToServer()
end
