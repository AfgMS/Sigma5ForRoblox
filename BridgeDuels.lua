local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()

Library:createScreenGui()

createnotification("Sigma", "Welcome to Sigma, Press V", 1, true)

local tab1 = Library:createTabs(CoreGui.Sigma, "Gui")
local tab2 = Library:createTabs(CoreGui.Sigma, "Combat")

local toggleButton1 = tab1:ToggleButton({
    name = "ActiveMods",
    info = "Arraylist goes brrr",
    callback = function(enabled)
        HolderArrayList.Visible = not HolderArrayList.Visible
    end
})

local sliderStuff = toggleButton1:Slider({
    title = "Dugong",
    min = 5,
    max = 10,
    default = 5,
    callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
})

local toggleInsideUI1 = toggleButton1:ToggleButtonInsideUI({
    name = "MyFirne",
    callback = function(enabled)
        if enabled then
            print("hello")
        end
    end
})

local dropdown = toggleButton1:Dropdown({
    name = "Testing",
    default = "Test",
    list = {"Walk", "Run", "Sprint"},
    callback = function(selectedItem)
        print("Movement type set to:", selectedItem)
    end
})

local tabGUIButton = tab1:ToggleButton({
    name = "TabGUI",
    info = "Wtf even is this lmao",
    callback = function(enabled)
        print("cum")
    end
})

local killauraButton = tab1:ToggleButton({
    name = "Killaura",
    info = "QuACK Quack",
    callback = function(enabled)
        print("cum")
    end
})

local anticheatResetButton = tab1:ToggleButton({
    name = "AnticheatResetVL",
    info = "QuACK Quack",
    callback = function(enabled)
        print("cum")
    end
})

local uninjectButton = tab2:ToggleButton({
    name = "UninjectShit",
    info = "Click to uninject the Sigma hack.",
    callback = function(enabled)
        if enabled then
            CoreGui.Sigma:Destroy()
            print("Destroyed Main")
            CoreGui.SigmaVisualStuff:Destroy()
            print("Destroyed Notif")
        end
    end
})