--[[
    SaveManager.lua
    Obsidian Library Addon
    Made by deividcomsono
    https://github.com/deividcomsono/Obsidian
]]

local SaveManager = {}
SaveManager.__index = SaveManager

local Library = nil
local ConfigFolder = "Obsidian"
local SubFolder = ""
local IgnoreIndexes = {}
local IgnoreThemeSettings = false
local AutoloadConfig = nil

local function getConfigPath(name)
    local path = ConfigFolder
    if SubFolder ~= "" then
        path = path .. "/" .. SubFolder
    end
    path = path .. "/" .. name .. ".json"
    return path
end

local function ensureFolders()
    if makefolder then
        if not isfolder(ConfigFolder) then
            pcall(makefolder, ConfigFolder)
        end
        if SubFolder ~= "" then
            local subPath = ConfigFolder .. "/" .. SubFolder
            if not isfolder(subPath) then
                pcall(makefolder, subPath)
            end
        end
    end
end

local function isIgnored(key)
    for _, ignored in ipairs(IgnoreIndexes) do
        if ignored == key then return true end
    end
    return false
end

function SaveManager:SetLibrary(lib)
    Library = lib
end

function SaveManager:SetFolder(folder)
    ConfigFolder = folder
end

function SaveManager:SetSubFolder(sub)
    SubFolder = sub
end

function SaveManager:IgnoreThemeSettings()
    IgnoreThemeSettings = true
end

function SaveManager:SetIgnoreIndexes(indexes)
    if type(indexes) == "table" then
        IgnoreIndexes = indexes
    end
end

local function getThemeSettings()
    if IgnoreThemeSettings or not Library then return nil end
    if not Library.Scheme then return nil end
    return {
        FontColor = tostring(Library.Scheme.FontColor),
        MainColor = tostring(Library.Scheme.MainColor),
        AccentColor = tostring(Library.Scheme.AccentColor),
        BackgroundColor = tostring(Library.Scheme.BackgroundColor),
        OutlineColor = tostring(Library.Scheme.OutlineColor),
    }
end

local function applyThemeSettings(theme)
    if IgnoreThemeSettings or not Library or not theme then return end
    if not Library.Scheme then return end

    local function hexToColor(hex)
        if type(hex) ~= "string" then return nil end
        hex = hex:gsub("#", "")
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        if r and g and b then
            return Color3.fromRGB(r, g, b)
        end
        return nil
    end

    local fc = hexToColor(theme.FontColor)
    if fc then Library.Scheme.FontColor = fc end

    local mc = hexToColor(theme.MainColor)
    if mc then Library.Scheme.MainColor = mc end

    local ac = hexToColor(theme.AccentColor)
    if ac then Library.Scheme.AccentColor = ac end

    local bc = hexToColor(theme.BackgroundColor)
    if bc then Library.Scheme.BackgroundColor = bc end

    local oc = hexToColor(theme.OutlineColor)
    if oc then Library.Scheme.OutlineColor = oc end

    if Library.UpdateColorsUsingRegistry then
        Library:UpdateColorsUsingRegistry()
    end
end

function SaveManager:Save(name)
    if not name or name == "" then
        name = "default"
    end
    if not Library then
        warn("[SaveManager] Library not set!")
        return false
    end

    ensureFolders()

    local config = {
        Toggles = {},
        Sliders = {},
        Dropdowns = {},
        Inputs = {},
        Keybinds = {},
        Theme = getThemeSettings(),
        SavedAt = os.time(),
    }

    if Library.Toggles then
        for key, toggle in pairs(Library.Toggles) do
            if not isIgnored(key) then
                config.Toggles[key] = toggle.Value
            end
        end
    end

    if Library.Sliders then
        for key, slider in pairs(Library.Sliders) do
            if not isIgnored(key) then
                config.Sliders[key] = slider.Value
            end
        end
    end

    if Library.Dropdowns then
        for key, dropdown in pairs(Library.Dropdowns) do
            if not isIgnored(key) then
                config.Dropdowns[key] = dropdown.Value
            end
        end
    end

    if Library.Inputs then
        for key, input in pairs(Library.Inputs) do
            if not isIgnored(key) then
                config.Inputs[key] = input.Value
            end
        end
    end

    if Library.Keybinds then
        for key, keybind in pairs(Library.Keybinds) do
            if not isIgnored(key) then
                local keyCode = nil
                pcall(function()
                    keyCode = keybind.Value and keybind.Value.Name or nil
                end)
                config.Keybinds[key] = keyCode
            end
        end
    end

    local path = getConfigPath(name)
    if writefile then
        local encodeOk, encoded = pcall(function()
            return game:GetService("HttpService"):JSONEncode(config)
        end)
        if encodeOk and encoded then
            local writeOk = pcall(writefile, path, encoded)
            if writeOk then
                if Library.Notify then
                    Library:Notify("Config saved: " .. name, 3)
                end
                return true
            end
        end
    end

    if Library.Notify then
        Library:Notify("Failed to save config", 3)
    end
    return false
end

function SaveManager:Load(name)
    if not name or name == "" then
        name = "default"
    end
    if not Library then
        warn("[SaveManager] Library not set!")
        return false
    end

    local path = getConfigPath(name)
    if not (isfile and isfile(path)) then
        if Library.Notify then
            Library:Notify("Config not found: " .. name, 3)
        end
        return false
    end

    local readOk, data = pcall(readfile, path)
    if not readOk or not data then
        return false
    end

    local decodeOk, config = pcall(function()
        return game:GetService("HttpService"):JSONDecode(data)
    end)
    if not decodeOk or type(config) ~= "table" then
        return false
    end

    if config.Toggles and Library.Toggles then
        for key, value in pairs(config.Toggles) do
            local toggle = Library.Toggles[key]
            if toggle and not isIgnored(key) then
                pcall(function()
                    toggle:SetValue(value)
                end)
            end
        end
    end

    if config.Sliders and Library.Sliders then
        for key, value in pairs(config.Sliders) do
            local slider = Library.Sliders[key]
            if slider and not isIgnored(key) then
                pcall(function()
                    slider:SetValue(value)
                end)
            end
        end
    end

    if config.Dropdowns and Library.Dropdowns then
        for key, value in pairs(config.Dropdowns) do
            local dropdown = Library.Dropdowns[key]
            if dropdown and not isIgnored(key) then
                pcall(function()
                    dropdown:SetValue(value)
                end)
            end
        end
    end

    if config.Inputs and Library.Inputs then
        for key, value in pairs(config.Inputs) do
            local input = Library.Inputs[key]
            if input and not isIgnored(key) then
                pcall(function()
                    input:SetValue(value)
                end)
            end
        end
    end

    if config.Keybinds and Library.Keybinds then
        for key, value in pairs(config.Keybinds) do
            local keybind = Library.Keybinds[key]
            if keybind and value and not isIgnored(key) then
                pcall(function()
                    keybind:SetValue(Enum.KeyCode[value])
                end)
            end
        end
    end

    if config.Theme then
        applyThemeSettings(config.Theme)
    end

    if Library.Notify then
        Library:Notify("Config loaded: " .. name, 3)
    end
    return true
end

function SaveManager:Delete(name)
    if not name or name == "" then
        name = "default"
    end
    local path = getConfigPath(name)
    if delfile and isfile and isfile(path) then
        pcall(delfile, path)
        if Library and Library.Notify then
            Library:Notify("Config deleted: " .. name, 3)
        end
        return true
    end
    return false
end

function SaveManager:ListConfigs()
    local list = {}
    if not (listfiles and isfolder) then return list end

    local folder = ConfigFolder
    if SubFolder ~= "" then
        folder = folder .. "/" .. SubFolder
    end

    if isfolder(folder) then
        local ok, files = pcall(listfiles, folder)
        if ok and files then
            for _, file in ipairs(files) do
                local name = file:match("([^/\\]+)%.json$")
                if name then
                    table.insert(list, name)
                end
            end
        end
    end

    table.sort(list)
    return list
end

function SaveManager:LoadAutoloadConfig()
    local path = ConfigFolder .. "/autoload.txt"
    if not (isfile and isfile(path)) then return false end
    local readOk, name = pcall(readfile, path)
    if not readOk or not name then return false end
    name = name:gsub("%s", "")
    if name == "" then return false end
    AutoloadConfig = name
    return self:Load(name)
end

function SaveManager:SetAutoloadConfig(name)
    ensureFolders()
    local path = ConfigFolder .. "/autoload.txt"
    if writefile then
        pcall(writefile, path, name or "")
        AutoloadConfig = name
    end
end

function SaveManager:BuildConfigSection(tab)
    if not Library or not tab then return end

    local groupbox = tab:AddRightGroupbox("Config Manager")

    local configName = "default"
    local configList = self:ListConfigs()
    if #configList == 0 then
        configList = {"default"}
    end

    groupbox:AddInput("ConfigName", {
        Text = "Config Name",
        Default = "default",
        Placeholder = "default",
        Numeric = false,
        Finished = false,
        Tooltip = "Name of the config",
        Callback = function(value)
            if value and value ~= "" then
                configName = value
            end
        end,
    })

    local dropdown = nil
    local function refreshDropdown()
        local list = self:ListConfigs()
        if #list == 0 then list = {"default"} end
        if dropdown then
            pcall(function()
                dropdown:Refresh(list, true)
            end)
        else
            dropdown = groupbox:AddDropdown("ConfigSelect", {
                Text = "Select Config",
                Values = list,
                Default = list[1],
                Tooltip = "Choose a saved config",
                Callback = function(value)
                    configName = value
                end,
            })
        end
    end
    refreshDropdown()

    groupbox:AddDivider()

    groupbox:AddButton({
        Text = "Save Config",
        Tooltip = "Save current settings to config",
        Func = function()
            self:Save(configName)
            refreshDropdown()
        end,
    })

    groupbox:AddButton({
        Text = "Load Config",
        Tooltip = "Load selected config",
        Func = function()
            self:Load(configName)
        end,
    })

    groupbox:AddButton({
        Text = "Delete Config",
        Tooltip = "Delete selected config",
        Func = function()
            self:Delete(configName)
            refreshDropdown()
        end,
    })

    groupbox:AddDivider()

    groupbox:AddButton({
        Text = "Refresh List",
        Tooltip = "Refresh config list",
        Func = function()
            refreshDropdown()
            Library:Notify("Config list refreshed", 3)
        end,
    })

    groupbox:AddButton({
        Text = "Set Autoload",
        Tooltip = "Load this config on start",
        Func = function()
            self:SetAutoloadConfig(configName)
            Library:Notify("Autoload set: " .. configName, 3)
        end,
    })

    groupbox:AddButton({
        Text = "Clear Autoload",
        Tooltip = "Remove autoload config",
        Func = function()
            self:SetAutoloadConfig("")
            Library:Notify("Autoload cleared", 3)
        end,
    })
end

return SaveManager
