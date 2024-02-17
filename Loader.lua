local BedwarsGithub = "https://raw.githubusercontent.com/AfgMS/Simga345/main/Bedwars.lua"
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

GithubUpdateCheck(BedwarsGithub, "Sigma5/Bedwars.lua")
wait(1)
print("Debug Logs")
if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
    print("Loaded Bedwars.lua")
    loadfile("Sigma5/Bedwars.lua")()
end
