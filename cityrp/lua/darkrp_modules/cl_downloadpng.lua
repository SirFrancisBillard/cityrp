
if not file.Exists("materials", "DATA") then
	file.CreateDir("materials")
end

//Downloads a material to the client's data/materials folder.
function DownloadMaterial(dlurl, savedir, onSuccess)

	local request = {
		success = function(code,body,headers)
			-- print(code,table.ToString(headers))
			
			local oldf_out = GetConVar("con_filter_text_out"):GetString()
			local oldf_enable = GetConVar("con_filter_enable"):GetInt()
			RunConsoleCommand("con_filter_text_out", "mat_")
			RunConsoleCommand("con_filter_enable", 1)
			
			file.CreateDir("materials/"..string.GetPathFromFilename(savedir))
			
			local img = file.Open("materials/"..savedir, "wb", "DATA")
			img:Write(body)
			img:Close()
			
			onSuccess("../data/materials/"..savedir)
			
			timer.Simple(.01,function()
				RunConsoleCommand("con_filter_enable", oldf_enable)
				RunConsoleCommand("con_filter_text_out", oldf_out)
			end)
			
		end,
		failed = function(reason)
			ErrorNoHalt("Could not download material: "..reason.."\n")
		end,
		method="get",
		url=dlurl,
		type="image/png"
	}
	HTTP(request)
end

//WebMaterial() is meant for streaming the file. It should be called every frame, or at least once on initialize and once when the material is finished downloading.
local downloading = {}
local icontex = Material("vgui/spawnmenu/generating")
function WebMaterial(url, args, forceDownload)
	
	local filename = string.match(url, "/(.+%.png)$")
	assert(isstring(filename), "Web url file must end in '.png'")
	
	local mat = Material("../data/materials/mat_web"..filename,args)
	
	if (forceDownload or not file.Exists("materials/mat_web"..filename, "DATA")) and (not downloading[filename]) then
		
		downloading[filename] = true
		
		mat:SetTexture("$basetexture", icontex:GetTexture("$basetexture"))
		
		DownloadMaterial(url,"mat_web"..filename, function(filepath)
			local newmat = Material(filepath, args)
			mat:SetTexture("$basetexture", newmat:GetTexture("$basetexture"))
			downloading[filename] = false
		end)
		
	end
	
	return mat
	
end

--[[
//Example here:
hook.Add("Initialize", "WebMaterials",function()
	hook.Run("WebMaterials")
end)
local list = {}
//Precache them:
hook.Add("WebMaterials","Test Downloads", function()
	list[1] = WebMaterial("http://wiki.garrysmod.com/images/1/11/gmod-logo-big.png", "smooth")
	list[2] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png")
	list[3] = WebMaterial("http://3.bp.blogspot.com/_rtMlwCpL8jQ/TPOM5OWRzYI/AAAAAAAAAig/rohw2ytEAe8/s1600/colorstoneswirl1.png", "smooth")
	list[4] = WebMaterial("http://orig08.deviantart.net/f3ea/f/2009/225/1/6/blue_dragon_png_file_by_deathblooddelirium.png", "smooth")
	list[5] = WebMaterial("http://armsandbadges.com/Sample/Sample.png", "smooth")
	list[6] = WebMaterial("http://icons.iconarchive.com/icons/aha-soft/torrent/512/linux-icon.png", "smooth")
	list[7] = WebMaterial("http://s3.amazonaws.com/everystockphoto/fspid30/17/94/76/6/flor-fleurs-fleur-1794766-o.png", "smooth")
	list[8] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/b/b2/Download_Files_4_You_Logo.png", "smooth")
	list[9] = WebMaterial("http://www.clipartbest.com/cliparts/4Tb/byj/4TbbyjETg.png", "smooth")
	list[10] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/1/1f/Rings.png", "smooth")
	list[11] = WebMaterial("http://png-1.findicons.com/files/icons/88/mac/512/intranet.png", "smooth")
	list[12] = WebMaterial("http://png-2.findicons.com/files/icons/1014/ivista/256/png_file.png", "smooth")
	list[13] = WebMaterial("http://www.veryicon.com/icon/png/System/Radium/Png%20file.png", "smooth")
	list[14] = WebMaterial("http://png-5.findicons.com/files/icons/1168/simplexity_file/256/png.png", "smooth")
	list[15] = WebMaterial("http://img11.deviantart.net/d6f2/i/2012/190/b/e/png_files_3_by_ranya_desing-d56jzh1.png", "smooth")
	list[16] = WebMaterial("http://www.veryicon.com/icon/png/File%20Type/Sinem/File%20PNG.png", "smooth")
	list[17] = WebMaterial("http://findicons.com/files/icons/1926/soft/128/file.png", "smooth")
	list[18] = WebMaterial("http://pre11.deviantart.net/5566/th/pre/f/2010/171/4/0/paint_splash_png_by_absurdwordpreferred.png", "smooth")
	list[19] = WebMaterial("http://i.stack.imgur.com/kS9Kf.png", "smooth")
	list[20] = WebMaterial("http://icons.iconseeker.com/png/fullsize/black-pearl-files/png-file.png", "smooth")
	list[21] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/9/97/Esperanto_star.png", "smooth")
	list[22] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/5/51/Google.png", "smooth")
	list[23] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/5/56/Computer_icon.png", "smooth")
	list[24] = WebMaterial("http://1.bp.blogspot.com/_PKQybBYp32c/TSgdjZiOFLI/AAAAAAAACto/LDlMv4LLsFg/s1600/dogwood+flower.png", "smooth")
	list[25] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/7/7a/Bueno-verde.png", "smooth")
	list[26] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/5/59/Empty.png", "smooth")
	list[27] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/2/2a/Redheart.png", "smooth")
	list[28] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/3/3c/Recursive_camera_icon-(02-3_4-2))-.png", "smooth")
	list[29] = WebMaterial("http://2.bp.blogspot.com/-iqx1G9PMU7o/TbBWhgqWPYI/AAAAAAAAAZw/SbPX9HzcVLQ/s1600/plant01.png", "smooth")
	list[30] = WebMaterial("http://f.tqn.com/y/graphicssoft/1/S/h/N/5/psptubez_dot_com_008.png", "smooth")
	list[31] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/e/e5/Post-it-note-transparent.png", "smooth")
	list[32] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/8/8d/Flower_selfmade.png", "smooth")
end)
//Use them:
concommand.Add("test_webmats", function()
	hook.Add("HUDPaint", "gmodlogo", function()
		list[1] = WebMaterial("http://wiki.garrysmod.com/images/1/11/gmod-logo-big.png", "smooth")
		list[2] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png")
		list[3] = WebMaterial("http://3.bp.blogspot.com/_rtMlwCpL8jQ/TPOM5OWRzYI/AAAAAAAAAig/rohw2ytEAe8/s1600/colorstoneswirl1.png", "smooth")
		list[4] = WebMaterial("http://orig08.deviantart.net/f3ea/f/2009/225/1/6/blue_dragon_png_file_by_deathblooddelirium.png", "smooth")
		list[5] = WebMaterial("http://armsandbadges.com/Sample/Sample.png", "smooth")
		list[6] = WebMaterial("http://icons.iconarchive.com/icons/aha-soft/torrent/512/linux-icon.png", "smooth")
		list[7] = WebMaterial("http://s3.amazonaws.com/everystockphoto/fspid30/17/94/76/6/flor-fleurs-fleur-1794766-o.png", "smooth")
		list[8] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/b/b2/Download_Files_4_You_Logo.png", "smooth")
		list[9] = WebMaterial("http://www.clipartbest.com/cliparts/4Tb/byj/4TbbyjETg.png", "smooth")
		list[10] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/1/1f/Rings.png", "smooth")
		list[11] = WebMaterial("http://png-1.findicons.com/files/icons/88/mac/512/intranet.png", "smooth")
		list[12] = WebMaterial("http://png-2.findicons.com/files/icons/1014/ivista/256/png_file.png", "smooth")
		list[13] = WebMaterial("http://www.veryicon.com/icon/png/System/Radium/Png%20file.png", "smooth")
		list[14] = WebMaterial("http://png-5.findicons.com/files/icons/1168/simplexity_file/256/png.png", "smooth")
		list[15] = WebMaterial("http://img11.deviantart.net/d6f2/i/2012/190/b/e/png_files_3_by_ranya_desing-d56jzh1.png", "smooth")
		list[16] = WebMaterial("http://www.veryicon.com/icon/png/File%20Type/Sinem/File%20PNG.png", "smooth")
		list[17] = WebMaterial("http://findicons.com/files/icons/1926/soft/128/file.png", "smooth")
		list[18] = WebMaterial("http://pre11.deviantart.net/5566/th/pre/f/2010/171/4/0/paint_splash_png_by_absurdwordpreferred.png", "smooth")
		list[19] = WebMaterial("http://i.stack.imgur.com/kS9Kf.png", "smooth")
		list[20] = WebMaterial("http://icons.iconseeker.com/png/fullsize/black-pearl-files/png-file.png", "smooth")
		list[21] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/9/97/Esperanto_star.png", "smooth")
		list[22] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/5/51/Google.png", "smooth")
		list[23] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/5/56/Computer_icon.png", "smooth")
		list[24] = WebMaterial("http://1.bp.blogspot.com/_PKQybBYp32c/TSgdjZiOFLI/AAAAAAAACto/LDlMv4LLsFg/s1600/dogwood+flower.png", "smooth")
		list[25] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/7/7a/Bueno-verde.png", "smooth")
		list[26] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/5/59/Empty.png", "smooth")
		list[27] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/2/2a/Redheart.png", "smooth")
		list[28] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/3/3c/Recursive_camera_icon-(02-3_4-2))-.png", "smooth")
		list[29] = WebMaterial("http://2.bp.blogspot.com/-iqx1G9PMU7o/TbBWhgqWPYI/AAAAAAAAAZw/SbPX9HzcVLQ/s1600/plant01.png", "smooth")
		list[30] = WebMaterial("http://f.tqn.com/y/graphicssoft/1/S/h/N/5/psptubez_dot_com_008.png", "smooth")
		list[31] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/e/e5/Post-it-note-transparent.png", "smooth")
		list[32] = WebMaterial("https://upload.wikimedia.org/wikipedia/commons/8/8d/Flower_selfmade.png", "smooth")
		
		
		for i=1, #list do
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(list[i])
			surface.DrawTexturedRect(((i-1)%8)*100,math.floor((i-1)/8)*100,100,100)
		end
	end)
end)
]]
