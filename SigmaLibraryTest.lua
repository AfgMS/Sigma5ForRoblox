local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/Sigma5LibraryRework.lua", true))()

Library:CreateCore()

local TestOne = Library:CreateTabs("Abror")
local TestTwo = Library:CreateTabs("Ebrer")
local TestThree = Library:CreateTabs("Bebek")

local TestButton1 = TestOne:CreateToggles({
    Name = "AbrurBebek",
    Description = "Quack",
    callback = function(enabled)
        if enabled then
            print("hello")
        else
            print("Bye")
        end
    end
})
