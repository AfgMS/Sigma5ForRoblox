local SkywarsGithub = "https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/Skywars.lua"

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

GithubUpdateCheck(SkywarsGithub, "Sigma5/Skywars.lua")
if game.PlaceId == 8542275097 or game.PlaceId == 8768229691 then
    print("Loaded Skywars.lua...")
    loadfile("profiles/Skywars.lua")()
end
