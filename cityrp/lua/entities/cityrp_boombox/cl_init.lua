include("shared.lua")
local Translate = {}
Translate["\\u0430"] = "а"
Translate["\\u0431"] = "б"
Translate["\\u0432"] = "в"
Translate["\\u0433"] = "г"
Translate["\\u0434"] = "д"
Translate["\\u0435"] = "е"
Translate["\\u0451"] = "ё"
Translate["\\u0436"] = "ж"
Translate["\\u0437"] = "з"
Translate["\\u0438"] = "и"
Translate["\\u0439"] = "й"
Translate["\\u043a"] = "к"
Translate["\\u043b"] = "л"
Translate["\\u043c"] = "м"
Translate["\\u043d"] = "н"
Translate["\\u043e"] = "о"
Translate["\\u043f"] = "п"
Translate["\\u0440"] = "р"
Translate["\\u0441"] = "с"
Translate["\\u0442"] = "т"
Translate["\\u0443"] = "у"
Translate["\\u0444"] = "ф"
Translate["\\u0445"] = "х"
Translate["\\u0446"] = "ц"
Translate["\\u0447"] = "ч"
Translate["\\u0448"] = "ш"
Translate["\\u0449"] = "щ"
Translate["\\u044a"] = "ъ"
Translate["\\u044b"] = "ы"
Translate["\\u044c"] = "ь"
Translate["\\u044d"] = "э"
Translate["\\u044e"] = "ю"
Translate["\\u044f"] = "я"
Translate["\\u0410"] = "А"
Translate["\\u0411"] = "Б"
Translate["\\u0412"] = "В"
Translate["\\u0413"] = "Г"
Translate["\\u0414"] = "Д"
Translate["\\u0415"] = "Е"
Translate["\\u0401"] = "Ё"
Translate["\\u0416"] = "Ж"
Translate["\\u0417"] = "З"
Translate["\\u0418"] = "И"
Translate["\\u0419"] = "Й"
Translate["\\u041a"] = "К"
Translate["\\u041b"] = "Л"
Translate["\\u041c"] = "М"
Translate["\\u041d"] = "Н"
Translate["\\u041e"] = "О"
Translate["\\u041f"] = "П"
Translate["\\u0420"] = "Р"
Translate["\\u0421"] = "С"
Translate["\\u0422"] = "Т"
Translate["\\u0423"] = "У"
Translate["\\u0424"] = "Ф"
Translate["\\u0425"] = "Х"
Translate["\\u0426"] = "Ц"
Translate["\\u0427"] = "Ч"
Translate["\\u0428"] = "Ш"
Translate["\\u0429"] = "Щ"
Translate["\\u042a"] = "Ъ"
Translate["\\u042b"] = "Ы"
Translate["\\u042c"] = "Ь"
Translate["\\u042d"] = "Э"
Translate["\\u042e"] = "Ю"
Translate["\\u042f"] = "Я"

surface.CreateFont("MeBasta", {
    size = 42,
    weight = 1337,
    antialias = true,
    shadow = false,
    font = "TabLarge"
})

surface.CreateFont("MeBastaS", {
    size = 13,
    weight = 1337,
    --antialias = true,
    shadow = false,
    font = "Tahoma"
})

surface.CreateFont("MeBasta2", {
    size = 34,
    weight = 1337,
    antialias = true,
    shadow = false,
    font = "TabLarge"
})

if Stations == nil then
    Stations = {}
end

local function PlayMP3(id, url, channel)
    if url == nil or url == "" then return end
    if not IsValid(Entity(id)) then return end

    if Stations[channel] ~= nil and IsValid(Stations[channel].Channel) then
        Stations[channel].Channel:Stop()
    end

    sound.PlayURL(url, "3d", function(station)
        if (IsValid(station)) then
            station:SetPos(LocalPlayer():GetPos())
            station:Play()
            Stations[channel] = nil
            Stations[channel] = {}
            Stations[channel].Ent = Entity(id)
            Stations[channel].Channel = station
            --LocalPlayer():ChatPrint( "Invalid URL!" )
        else
        end
    end)
end

local function NextGetMP3(id, url, bacup, channel)
    --print(url)
    if string.find(url, 'success":false') then
        print("So much query")

        return
    end

    --	if string.find(url,"<h2>Слишком часто</h2>") then timer.Simple(6,function() http.Post( "http://pleer.com/site_api/files/get_url",{["action"]="play",["id"]=bacup}, function(responseText) print(responseText) NextGetMP3(id,responseText,url) end ) end) end
    if string.find(url, '<h1><a href="http://pleer.com/">') then
        print("So much query")
        --timer.Simple(6,function() http.Post( "http://pleer.com/site_api/files/get_url",{["action"]="play",["id"]=bacup}, function(responseText) print(responseText) NextGetMP3(id,responseText,url) end ) end) 
    end

    local mp3 = ""
    mp3 = string.sub(url, 1, #url - 2)
    mp3 = string.Explode('"track_link":"', mp3)[2]
    PlayMP3(id, mp3, channel)
end

local function GetMP3(url, id, channel)
    http.Post("http://pleer.com/site_api/files/get_url", {
        ["action"] = "play",
        ["id"] = url
    }, function(responseText)
        if IsValid(Entity(id)) and string.find(Entity(id):GetClass(), "boombox") then
            NextGetMP3(id, responseText, url, channel)
        end
    end)
end

net.Receive('apb_boombox_send', function()
    GetMP3(net.ReadString(), net.ReadDouble(), net.ReadString())
end)

function ENT:Initialize()
end

hook.Add("Think", "RadioThink", function()
    for i, v in pairs(Stations) do
        --print(Entity(i):GetClass())
        if not IsValid(v.Ent) then
            v.Channel:Pause()
        elseif v.Channel ~= nil then
            if not string.find(v.Ent:GetClass(), "boombox") then
                v.Channel:Pause()

                return
            end

            if v.Ent then
                v.Channel:SetPos(v.Ent:GitPos())

                if IsValid(v.Channel) and v.Ent:GitPos():Distance(LocalPlayer():GetPos()) > 500 then
                    v.Channel:SetVolume(0)
                elseif v.Channel ~= nil and v.Channel ~= NULL and IsValid(v.Channel) then
                    v.Channel:SetVolume(1)
                end
            else
                v.Channel:Pause()
            end
        end
    end
end)

net.Receive('apb_boombox_stop', function()
    local channel = net.ReadString()

    if Stations[channel] ~= nil and IsValid(Stations[channel].Channel) then
        Stations[channel].Channel:Pause()
    end
end)

local function UpdateStation(lastID, newID, channel)
    --if not Entity(newID)!=NULL or not Entity(newID):GetClass() or not string.find(Entity(newID):GetClass(),"boombox") then timer.Simple(1,function() UpdateStation(lastID,newID) end) return end
    --print("AE")
    if not IsValid(Entity(newID)) then
        timer.Simple(0.1, function()
            UpdateStation(lastID, newID, channel)
        end)

        return
    end

    if (Stations[channel]) then
        Stations[channel].Ent = Entity(newID)
        Stations[channel].Channel:Play()
    else
    end
    --if IsValid(Stations[newID]) then Stations[newID]:Play() end
    --Stations[lastID] = nil
end

net.Receive('apb_boombox_update', function()
    local lastID = net.ReadDouble()
    local newID = net.ReadDouble()
    local channel = net.ReadString()

    --if not Entity(newID)!=NULL or not Entity(newID):GetClass() or not string.find(Entity(newID):GetClass(),"boombox") then timer.Simple(1,function() UpdateStation(lastID,newID) end) return end
    timer.Simple(0.1, function()
        UpdateStation(lastID, newID, channel)
    end)
end)

-- menu	------------- 
local function ParsResult(str, DermaPanelText, entID)
    if not IsValid(DermaPanelText) then return end

    for i, v in pairs(Translate) do
        str = string.Replace(str, i, v)
    end

    --print(str)
    local ExplodeId = string.Explode('"id":"', str)

    for i = 2, #ExplodeId do
        local idAr = string.Explode('","artist":"', ExplodeId[i])
        local artistAr = string.Explode('","track":"', idAr[2])
        local nameAr = string.Explode('","lenght":"', artistAr[2])
        local id = idAr[1]
        local artist = artistAr[1]
        local name = nameAr[1]
        local Dbut = vgui.Create("DButton", DermaPanelText)
        Dbut:SetSize(350, 20)
        Dbut:SetPos(32, 90 + 25 * i - 1)
        Dbut:SetText(artist .. " : " .. name)

        Dbut.DoClick = function()
            --GetMP3(id,entID) 
            net.Start('apb_boombox_get')
            net.WriteString(id)
            net.WriteDouble(entID)
            net.SendToServer()
            DermaPanelText:Remove()
        end
    end
end

local AcessToken = nil
local DermaPanelText

local function MusicBox(entID)
    if IsValid(DermaPanelText) then
        DermaPanelText:Remove()

        return
    end

    DermaPanelText = vgui.Create("DFrame")
    DermaPanelText:SetSize(420, 500)
    DermaPanelText:SetPos(ScrW() / 2 - 210, ScrH() / 2 - 250)
    DermaPanelText:SetTitle("")
    DermaPanelText:SetVisible(true)
    DermaPanelText:SetDraggable(false)
    DermaPanelText:ShowCloseButton(true)
    DermaPanelText:MakePopup()
    ---	DermaPanelText:SetKeyboardInputEnabled(false)
    local DText1 = vgui.Create("DTextEntry", DermaPanelText)
    DText1:SetPos(10, 65)
    DText1:SetEnterAllowed(true)
    DText1:SetTall(20)
    DText1:SetWide(240)
    DText1:SetTextColor(Color(220, 220, 200, 255))
    DText1:SetText("")
    DText1:SetSkin(GAMEMODE.Config.DarkRPSkin)
    --	AcessToken = string.Explode('","',AcessToken)[1]
    --	AcessToken = string.sub(AcessToken,18,#AcessToken)
    --	print(AcessToken)
    local Dbut = vgui.Create("DButton", DermaPanelText)
    Dbut:SetSize(150, 20)
    Dbut:SetPos(10, 475)
    Dbut:SetText("Stop")
    Dbut:SetSkin(GAMEMODE.Config.DarkRPSkin)

    Dbut.DoClick = function()
        net.Start('apb_boombox_sendstop')
        net.WriteDouble(entID)
        net.SendToServer()
        DermaPanelText:Remove()
    end

    Dbut = vgui.Create("DButton", DermaPanelText)
    Dbut:SetSize(150, 20)
    Dbut:SetPos(260, 65)
    Dbut:SetText("Search")
    Dbut:SetSkin(GAMEMODE.Config.DarkRPSkin)

    Dbut.DoClick = function()
        http.Post("http://api.pleer.com/index.php", {
            ['access_token'] = AcessToken,
            ['method'] = 'tracks_search',
            ['query'] = DText1:GetValue()
        }, function(responseText)
            ParsResult(responseText, DermaPanelText, entID)
        end)
    end --[[print(responseText)]]

    if Entity(entID):GetClass() == "apb_boombox" then
        local Dbut = vgui.Create("DButton", DermaPanelText)
        Dbut:SetSize(150, 20)
        Dbut:SetPos(265, 475)
        Dbut:SetText("Pickup")
        Dbut:SetSkin(GAMEMODE.Config.DarkRPSkin)

        Dbut.DoClick = function()
            net.Start('apb_boombox_up')
            net.WriteDouble(entID)
            net.SendToServer()
            DermaPanelText:Remove()
        end
    end

    DermaPanelText.Paint = function()
        if not LocalPlayer():Alive() then
            DermaPanelText:Remove()
        end

        draw.RoundedBox(0, 0, 0, DermaPanelText:GetWide(), DermaPanelText:GetTall(), Color(35, 35, 35, 250))
        draw.RoundedBox(0, 0, 0, DermaPanelText:GetWide(), 35, Color(5, 5, 5, 255))
        draw.RoundedBox(0, 0, 40, 410, 20, Color(5, 5, 5, 255))
        draw.RoundedBox(0, 0, 90, 410, 20, Color(5, 5, 5, 255))
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(15, -5)
        surface.SetFont("MeBasta")
        surface.DrawText("Jokker")
        surface.SetFont("ChatFont")
        surface.SetTextPos(138, 5)
        surface.DrawText("Boom")
        surface.SetTextPos(138, 18)
        surface.DrawText("Box")
        surface.SetTextPos(16, 43)
        surface.DrawText("Search")
        surface.SetTextPos(16, 93)
        surface.DrawText("Result")
    end
end

concommand.Add('OpenMusicBox', function(ply, cmd, args)
    if AcessToken == nil then
        http.Post("http://api.pleer.com/token.php", {
            ['grant_type'] = 'client_credentials',
            ['client_id'] = '612305',
            ['client_secret'] = 'phqkKaZV0TWc8oUR7XTU'
        }, function(responseText)
            AcessToken = responseText
            AcessToken = string.Explode('","', AcessToken)[1]
            AcessToken = string.sub(AcessToken, 18, #AcessToken)
            MusicBox(tonumber(args[1]))
        end)

        timer.Simple(1200, function()
            AcessToken = nil
        end)
        --print(AcessToken)
    else
        MusicBox(tonumber(args[1]))
    end
end)

--------------- draw
function ENT:Draw()
    self:DrawModel()
end