local SkywarsGithub = "https://raw.githubusercontent.com/AfgMS/Simga345/main/Skywars.lua"
local BedwarsGithub = "https://raw.githubusercontent.com/AfgMS/Simga345/main/Bedwars.lua"
local UniversalGithub = "https://raw.githubusercontent.com/AfgMS/Simga345/main/Universal.lua"

local function GithubUpdateCheck(url, filePath)
    local content = game:HttpGet(url)
    if content then
        writefile(filePath, content)
        print("Downloaded " .. filePath .. " from GitHub.")
    else
        warn("Failed to download " .. filePath .. " from GitHub.")
    end
end

if not isfolder("Sigma5") then
    makefolder("Sigma5")
end

GithubUpdateCheck(UniversalGithub, "Sigma5/Universal.lua")
GithubUpdateCheck(SkywarsGithub, "Sigma5/Skywars.lua")
GithubUpdateCheck(BedwarsGithub, "Sigma5/Bedwars.lua")

wait(1)
print("Debug Logs")
if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
    print("Loaded Bedwars.lua")
    loadfile("Sigma5/Bedwars.lua")()
elseif game.PlaceId == 8542275097 or game.PlaceId == 8768229691 then
    print("Loaded Skywars.lua...")
    loadfile("Sigma5/Skywars.lua")()
else
    print("Loaded Universal.lua...")
    loadfile("Sigma5/Universal.lua")()
end
