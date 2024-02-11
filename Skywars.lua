local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
--AutoSave?
local FileName = "Sigma5Test.lua"
local Settings
local FirstExecute = true

function SettingTest()
    local Settings = {
        ActiveMods = {Value = true},
        TabGUI = {Value = true},
        Uninject = {Value = false},
        Aimbot = {Value = false},
        KillAura = {Value = false, Rotation = false,}, 
        SpeedTemp = {Value = true},
        LongJumpToggle = {Value = false}
    }
    
    local JsonEncodeSettings = HttpService:JSONEncode(Settings)
    print("Encoded Settings:", JsonEncodeSettings)
    
    if writefile and makefolder then
        makefolder("Sigma5")
        writefile("Sigma5/" .. FileName, JsonEncodeSettings)
    end
end
function FirstTimeExecuteCheck()
    return not (readfile and isfile and isfile("Sigma5/" .. FileName))
end
function SaveModules()    
    if not FirstExecute then
        local JsonEncodeSettings = HttpService:JSONEncode(Settings)
        
        if writefile then
            local success, errorMessage = pcall(function()
                writefile("Sigma5/" .. FileName, JsonEncodeSettings)
            end)
            
            if not success then
                warn("Error saving settings:", errorMessage)
            end
        else
            warn("writefile function is not available")
        end
    end
end
function LoadModules()
    if readfile and isfile and isfile("Sigma5/" .. FileName) then
        local fileContent = readfile("Sigma5/" .. FileName)
        if fileContent then
            Settings = HttpService:JSONDecode(fileContent)
            print("Loaded Settings:", Settings)
        else
            print("Error reading file content.")
        end
    else
        print("Settings file not found.")
    end
end
task.spawn(function()
    if FirstTimeExecuteCheck() then
        SettingTest()
    end
end)
task.spawn(function()
    LoadModules()
end)
task.spawn(function()
    repeat
        task.wait(1)
        SaveModules()
    until not game
end)
task.wait(1)
--Function
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
local function findNearestPlayer(range)
    local nearestPlayer
    local nearestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < nearestDistance and distance <= range then
                nearestPlayer = player
                nearestDistance = distance
            end
        end
    end

    return nearestPlayer
end
local function GetAllPlayers()
    local allPlayers = {}

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(allPlayers, player)
        end
    end

    return allPlayers
end
local function aimAtNearestPlayer(range)
    local nearestPlayer = findNearestPlayer(range)
    if nearestPlayer then
        local direction = (nearestPlayer.Character.HumanoidRootPart.Position - Camera.CFrame.Position).unit
        local newLookAt = CFrame.new(Camera.CFrame.Position, nearestPlayer.Character.HumanoidRootPart.Position)
        Camera.CFrame = newLookAt
    end
end
local function attackNearestPlayer()
    local nearestPlayer = findNearestPlayer(20)
    if nearestPlayer then
        local args = {
            [1] = nearestPlayer
        }
        game:GetService("ReplicatedStorage"):FindFirstChild("events-Eqz"):FindFirstChild("5c73e2ee-c179-4b60-8be7-ef8e4a7eebaa"):FireServer(unpack(args))
    end
end
--SigmaUI
Library:createScreenGui()
LibraryCheck()
LoadModules()
createnotification("Sigma5", "Loaded Successfully", 1, true)

local GUItab = Library:createTabs(CoreGui.Sigma, "Gui")
--ActiveMods
local ActiveModsEnabled = Settings.ActiveMods.Value
local ActiveModsToggle = GUItab:ToggleButton({
    name = "ActiveMods",
    info = "Render active mods",
    callback = function()
        Settings.ActiveMods.Value = not Settings.ActiveMods.Value
        ActiveModsEnabled = Settings.ActiveMods.Value
        CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = ActiveModsEnabled
    end
})
--TabGUI
local TabGUIEnabled = Settings.TabGUI.Value
local TabGUIToggle = GUItab:ToggleButton({
    name = "TabGUI",
    info = "Just decorations",
    callback = function()
        Settings.TabGUI.Value = not Settings.TabGUI.Value
        TabGUIEnabled = Settings.TabGUI.Value
        CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible = TabGUIEnabled
    end
})
--Uninject
local UninjectEnabled = Settings.Uninject.Value
local Uninject = GUItab:ToggleButton({
    name = "DeleteGUI",
    info = "Doesn't Uninject 100%",
    callback = function()
        Settings.Uninject.Value = not Settings.Uninject.Value
        UninjectEnabled = Settings.Uninject.Value
        if UninjectEnabled then
            CoreGui.Sigma:Destroy()
            print("Destroyed Main")
            CoreGui.SigmaVisualStuff:Destroy()
            print("Destroyed Notif")
        end
    end
})
--CombatSection
local COMBATtab = Library:createTabs(CoreGui.Sigma, "Combat")
--AimBot
local AimbotEnabled = Settings.Aimbot.Value
local AimRange = 20
local Aimbot = COMBATtab:ToggleButton({
    name = "Aimbot",
    info = "Aim At Nearest Player?",
    callback = function()
        Settings.Aimbot.Value = not Settings.Aimbot.Value
        AimbotEnabled = Settings.Aimbot.Value
        if AimbotEnabled then
            AimRange = 20
            while AimbotEnabled do
                aimAtNearestPlayer(AimRange)
                wait(0.01)
            end
        else
            AimRange = 0
        end
    end
})
local AimRangeSlider = Aimbot:Slider({
    title = "AimRange",
    min = 0,
    max = 20,
    default = 20,
    callback = function(val)
        AimRange = val
    end
})
--KillAura
local Delay
local KillAuraEnabled = Settings.KillAura.Value
local KillAura = COMBATtab:ToggleButton({
    name = "KillAura",
    info = "Attack Nearest Player?",
    callback = function()
        Settings.KillAura.Value = not Settings.KillAura.Value
        KillAuraEnabled = Settings.KillAura.Value
        if KillAuraEnabled then
            Delay = 0.03
            while KillAuraEnabled do
                attackNearestPlayer()
                wait(Delay)
            end
        else
            Delay = 86400
        end
    end
})
local TableFix = KillAura:Slider({
    title = "None",
    min = 0,
    max = 0,
    default = 0,
    callback = function(value)
    end
})
local StartRotatingRange = nil
local function RotateNearest()
    local nearestPlayer = findNearestPlayer(StartRotatingRange)
    if nearestPlayer then
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local direction = (nearestPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).unit
            local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
            local newCFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + lookVector)
            character:SetPrimaryPartCFrame(newCFrame)
        end
    end
end
local Rotation = KillAura:ToggleButtonInsideUI({
    name = "Rotations",
    callback = function()
        Settings.Rotation.Value = not Settings.Rotation.Value
        if Settings.Rotation.Value then
            StartRotatingRange = 20
            if localPlayer.Character then
                RotateNearest()
            end
        else
            StartRotatingRange = 0
        end
    end
})
--PlayerSection
local PLAYERtab = Library:createTabs(CoreGui.Sigma, "Player")
--SpeedTemporarily
local CustomSpeed = 58
local SpeedTempEnabled = Settings.SpeedTemp.Value
local SpeedTemp = PLAYERtab:ToggleButton({
    name = "SpeedTemp",
    info = "Temporary speed boost",
    callback = function()
        Settings.SpeedTemp.Value = not Settings.SpeedTemp.Value
        SpeedTempEnabled = Settings.SpeedTemp.Value
        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = SpeedTempEnabled and CustomSpeed or 16
    end
})
local CustomSpeedSlider = SpeedTemp:Slider({
    title = "CustomSpeed",
    min = 0,
    max = 100,
    default = 58,
    callback = function(val)
        CustomSpeed = val
        if SpeedTempEnabled then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = CustomSpeed
        end
    end
})
--LongJump
local CustomMultiplier = 2.8
local LongJumpEnabled = Settings.LongJumpToggle.Value
local function LongJump()
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local rootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")  
    local forwardVector = rootPart.CFrame.lookVector
    local jumpPower = humanoid.JumpPower
    
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.38)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(1)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(1)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    rootPart.Velocity = forwardVector * jumpPower * CustomMultiplier
end
local LongJumpToggle = PLAYERtab:ToggleButton({
    name = "LongJump",
    info = "Jump multiple times and then move forward",
    callback = function()
        Settings.LongJumpToggle.Value = not Settings.LongJumpToggle.Value
        LongJumpEnabled = Settings.LongJumpToggle.Value
        if LongJumpEnabled then
            LongJump()
        end
    end
})
local CustomMultiplierSlider = LongJumpToggle:Slider({
    title = "CustomMultiplier",
    min = 0,
    max = 8,
    default = 2.8,
    callback = function(val)
        CustomMultiplier = val
    end
})
