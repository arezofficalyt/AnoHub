local MAIN_URL = "https://raw.githubusercontent.com/arezofficalyt/AnoHub/refs/heads/main/main.lua"

local ok, body = pcall(function()
    return game:HttpGet(MAIN_URL .. "?t=" .. tostring(os.time()))
end)

if not ok or not body or body == "" then
    return
end

local fn, err = loadstring(body)
if not fn then
    return
end

pcall(fn)
