local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/Sigma5LibraryRework.lua", true))()

Library:CreateCore()

local TestOne = Library:CreateTabs("Abror")
local TestTwo = Library:CreateTabs("Ebrer")
local TestThree = Library:CreateTabs("Bebek")

local wth = TestOne:ToggleButton({
    name = "ee",
    info = "wth",
    callback = function(enabled)
        print("ello")
    end
})
