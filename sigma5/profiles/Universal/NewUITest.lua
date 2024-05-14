local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/BetaLibrary.lua", true))()

Library:CreateCore()
Library:CreateNotification("UI", "New Notification Test", 2, true)

local Tab1 = Library:CreateTabs("GoodNight")
local Tab2 = Library:CreateTabs("GoodDay")

local test1 = Tab1:CreateToggles({
    Name = "Yes Yes",
    Description = "New year new me!",
    callback = function(enabled)
        if enabled then
            print("e")
        else
            print("bad nig")
        end
    end
})

local test2 = Tab1:CreateToggles({
    Name = "No No",
    Description = "New year old me!",
    callback = function(enabled)
        if enabled then
            print("eaes")
        else
            print("synapsex")
        end
    end
})

local test5 = Tab2:CreateToggles({
    Name = "Ahh~",
    Description = "Fill me up daddy",
    callback = function(enabled)
        if enabled then
            print("yusaw")
        else
            print("asdewa")
        end
    end
})
