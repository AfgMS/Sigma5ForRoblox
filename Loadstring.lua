local SkywarsGithub = "https://raw.githubusercontent.com/AfgMS/Simga345/main/Skywars.lua"
local BedwarsGithub = "https://raw.githubusercontent.com/AfgMS/Simga345/main/Bedwars.lua"
local UniversalGithub = "https://raw.githubusercontent.com/AfgMS/Simga345/main/Universal.lua"

if not isfolder("Sigma5") then
    makefolder("Sigma5")
end

if not isfile("Sigma5/Universal.lua") then
    local UniversalSource = game:HttpGet(UniversalGithub)
    writefile("Sigma5/Universal.lua", UniversalSource)
end

if not isfile("Sigma5/Skywars.lua") then
    local SkywarsSource = game:HttpGet(SkywarsGithub)
    writefile("Sigma5/Skywars.lua", SkywarsSource)
end

if not isfile("Sigma5/Bedwars.lua") then
    local BedwarsSource = game:HttpGet(BedwarsGithub)
    writefile("Sigma5/Bedwars.lua", BedwarsSource)
end

wait(1)

if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
    loadfile("Sigma5/Bedwars.lua")()
elseif game.PlaceId == 8542275097 or game.PlaceId == 8768229691 then
    loadfile("Sigma5/Skywars.lua")()
else
    loadfile("Sigma5/Universal.lua")()
end
