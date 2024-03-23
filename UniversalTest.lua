local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/NewUITest.lua", true))()

Library:CreateCore()
wait(1)
CreateNotification("Universal", "sigma5 successfully loaded", 3, true)

local Tab1 = Library:CreateTab("S")
local Buttons1 = Tab1:CreateToggle("Sigmeme", "Sigma reworked", false, function(callback)
    if callback then
        print("Yessir")
    else
        print("zonk")
    end
end)

local Tab2 = Library:CreateTab("i")
local Tab3 = Library:CreateTab("g")
local Tab4 = Library:CreateTab("m")
local Tab5 = Library:CreateTab("a")
