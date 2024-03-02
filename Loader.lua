local BedwarsGithub = "https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/Bedwars.lua"

local function GithubUpdateCheck(url, filePath)
    local content = game:HttpGet(url)
    if content then
        local currentContent = readfile(filePath)
        if currentContent ~= content then
            writefile(filePath, content)
            print("Downloaded " .. filePath .. " from GitHub.")
        else
            print(filePath .. " is already up to date.")
        end
    else
        warn("Failed to download " .. filePath .. " from GitHub.")
    end
end

if not isfolder("sigma5") and not isfolder("sigma5/profiles") then
    makefolder("sigma5")
    task.wait()
    makefolder("sigma5/profiles")
end


GithubUpdateCheck(BedwarsGithub, "sigma5/profiles/Bedwars.lua")
if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
    loadfile("sigma5/profiles/Bedwars.lua")()
end
