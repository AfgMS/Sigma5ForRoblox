local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
--AutoSave?
local FileName = "Sigma5Test"
local Settings
local FirstExecute = true

function SettingTest()
    Settings = {
        ActiveMods = {Value = true},
        TabGUI = {Value = true},
        Uninject = {Value = false},
        Aimbot = {Value = false},
        KillAura = {Value = false, RotationHandler = true},
        AutoQueue = {Value = false},    
        SpeedTemp = {Value = true},
        LongJumpToggle = {Value = false}
    }
    
    local JsonEncodeSettings = HttpService:JSONEncode(Settings)
    if writefile and makefolder then
        makefolder("Sigma5")
        writefile("Sigma5/" .. FileName, JsonEncodeSettings)
    end
    FirstExecute = false
end

function FirstTimeExecuteCheck()
    return not (readfile and isfile and isfile("Sigma5/" .. FileName))
end
function SaveModules()    
    if not FirstExecute then
        local JsonEncodeSettings = HttpService:JSONEncode(Settings)
        if writefile then
            writefile("Sigma5/" .. FileName, JsonEncodeSettings)
        end
    end
end
function LoadModules()
    if readfile and isfile and isfile("Sigma5/" .. FileName) then
        Settings = HttpService:JSONDecode(readfile("Sigma5/" .. FileName))
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
local ActiveMods = GUItab:ToggleButton({
    name = "ActiveMods",
    info = "Render active mods",
    callback = function(enabled)
            Settings.ActiveMods = not Settings.ActiveMods
            CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = not CoreGui.SigmaVisualStuff.ArrayListHolder.Visible
    end
})
--TabGUI
local TabGUI = GUItab:ToggleButton({
    name = "TabGUI",
    info = "Just decorations",
    callback = function(enabled)
            Settings.TabGUI = not Settings.TabGUI
            CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible = not CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible
    end
})
--Uninject
local Uninject = GUItab:ToggleButton({
    name = "DeleteGUI",
    info = "Doesnt Uninject 100%",
    callback = function(enabled)
        if enabled then
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
local AimRange
local Aimbot = COMBATtab:ToggleButton({
    name = "Aimbot",
    info = "Aim At Nearest Player?",
    callback = function(enabled)
        if enabled then
            Settings.Aimbot = true
            AimRange = 20
            while enabled do
                aimAtNearestPlayer(AimRange)
                wait(0.01)
            end
        else
            Settings.Aimbot = false
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
local KillAura = COMBATtab:ToggleButton({
    name = "KillAura",
    info = "Attack Nearest Player?",
    callback = function(enabled)
        if enabled then
            Settings.KillAura = true
            Delay = 0.03
            while enabled do
                attackNearestPlayer()
                wait(Delay)
            end
        else
            Settings.KillAura = false
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
    callback = function(enabled)
        if enabled then
            Settings.Rotation = true
            StartRotatingRange = 20
            if localPlayer.Character then
                RotateNearest()
            end
        else
            Settings.Rotation = false
            StartRotatingRange = 0
        end
    end
})
--PlayerSection
local PLAYERtab = Library:createTabs(CoreGui.Sigma, "Player")
--SpeedTemporarily
local CustomSpeed = 58
local SpeedTemp = PLAYERtab:ToggleButton({
    name = "SpeedTemp",
    info = "Temporary speed boost",
    callback = function(enabled)
        if enabled then
            Settings.SpeedTemp = true
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = CustomSpeed
        else
            Settings.SpeedTemp = false
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
        end
    end
})
local CustomSpeedSlider = SpeedTemp:Slider({
    title = "CustomSpeed",
    min = 0,
    max = 100,
    default = 58,
    callback = function(val)
        CustomSpeed = val
        if Settings.SpeedTemp then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = CustomSpeed
        end
    end
})
--LongJump
local CustomMultiplier = 2.8
local function LongJump()
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local rootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")  
    local forwardVector = rootPart.CFrame.lookVector
    local jumpPower = humanoid.JumpPower
    
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.38)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.51)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.51)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    rootPart.Velocity = forwardVector * jumpPower * CustomMultiplier
end
local LongJumpToggle = PLAYERtab:ToggleButton({
    name = "LongJump",
    info = "Jump multiple times and then move forward",
    callback = function(enabled)
        if enabled then
            Settings.LongJumpToggle = true
            LongJump()
        else
            Settings.LongJumpToggle = false
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
