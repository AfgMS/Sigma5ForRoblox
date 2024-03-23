local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/NewUITest.lua", true))()

CreateNotification("Universal", "sigma5 successfully loaded", 3, true)
task.wait()
lib:CreateCore(true)

local Tab1 = lib:CreateTab("S")
local Buttons1 = Tab1:CreateToggle("Sigmeme", "Sigma reworked", false, function(callback)
    if callback then
        print("Yessir")
    else
        print("zonk")
    end
end)

local Tab2 = lib:CreateTab("i")
local Tab3 = lib:CreateTab("g")
local Tab4 = lib:CreateTab("m")
local Tab5 = lib:CreateTab("a")
