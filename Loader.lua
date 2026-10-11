local BaseUrl = "https://raw.githubusercontent.com/arezofficalyt/AnoHub/main/"
local SCP_PLACE = 103506116893376

if game.PlaceId ~= SCP_PLACE then
    local plr = game:GetService("Players").LocalPlayer
    if plr then
        pcall(function()
            plr:Kick("This Script is for SCP: Anomaly Site!")
        end)
    end
    while true do task.wait(10) end
end

loadstring(game:HttpGet(BaseUrl .. "Games/SCP/Main.lua"))()
