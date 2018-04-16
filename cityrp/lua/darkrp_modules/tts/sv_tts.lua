
util.AddNetworkString("TTS.Parse")

function TTS(ply, text)
	net.Start("TTS.Parse")
	net.WriteString(text)
	net.WriteEntity(ply)
	net.Broadcast()

	return ""
end

DarkRP.defineChatCommand("tts", TTS)
