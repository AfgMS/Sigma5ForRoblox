local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")

local function LibraryCheck()
    local SigmaCheck = CoreGui:FindFirstChild("Sigma")
    local SigmaVisualCheck = CoreGui:FindFirstChild("SigmaVisualStuff")
    
    if not SigmaCheck then
        print("Error: Sigma ScreenGui not found in CoreGui.")
    elseif SigmaCheck then
        print("Debug: SigmaCheck Found")
    elseif not SigmaVisualCheck then
        print("Error: SigmaVisualStuff ScreenGui not found in CoreGui.")
    elseif SigmaVisualCheck then
        print("Debug: SigmaVisualCheck Found")
        local ArraylistCheck = SigmaVisualCheck:FindFirstChild("ArrayListHolder")
        if not ArraylistCheck then
            print("Error: ArrayList Holder not found in SigmaVisualStuff.")
        elseif ArraylistCheck then
            print("Debug: ArrayList Found")
            return
        end
    end
end


Library:createScreenGui()
LibraryCheck()
createnotification("Sigma", "Welcome to Sigma, Press V", 1, true)

local tab1 = Library:createTabs(CoreGui.Sigma, "Gui")
local tab2 = Library:createTabs(CoreGui.Sigma, "Combat")

--ActiveMods
local toggleButton1 = tab1:ToggleButton({
    name = "ActiveMods",
    info = "Arraylist goes brrr",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = not CoreGui.SigmaVisualStuff.ArrayListHolder.Visible
    end
})
local sliderStuff = toggleButton1:Slider({
    title = "Dugong",
    min = 5,
    max = 10,
    default = 5,
    callback = function(value)
        print("current value rn is" .. value)
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
isRotating = false
local RotateStuff = tab2:ToggleButton({
    name = "Rotate",
    info = "Honk Rotate",
    callback = function(enabled)
        if enabled then
            local function rotateToNearestPlayer()
                isRotating = true
                while enabled and isRotating do
                    local nearestPlayer = findNearestLivingPlayer()
                    if nearestPlayer then
                        local direction = (nearestPlayer.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Unit
                        direction = Vector3.new(direction.X, 0, direction.Z)
                        local rotation = CFrame.new(Vector3.new(), direction)
                        local currentCFrame = localPlayer.Character.HumanoidRootPart.CFrame
                        local newCFrame = CFrame.new(currentCFrame.Position) * rotation
                        localPlayer.Character:SetPrimaryPartCFrame(newCFrame)
                    end
                    task.wait(0.1)
                end
                isRotating = false
            end

            spawn(rotateToNearestPlayer)
        else
            isRotating = false
        end
    end
})
