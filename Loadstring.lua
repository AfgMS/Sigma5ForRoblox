local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaLibrary.lua", true))()

local screenGui = library:LoadScreenGUI()

local tab1 = library:createTabs(screenGui, "Test")

tab1:Modules({
    ModulesName = "Module1",
    HoverText = "This is Module 1",
    callback = function(enabled)
        print("Module1 is", enabled and "enabled" or "disabled")
    end
})
