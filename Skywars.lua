local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

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
local function getAllPlayers()
    local localPlayer = game.Players.LocalPlayer
    local players = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            table.insert(players, player)
        end
    end
    return players
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
createnotification("Sigma5", "Loaded Successfully", 1, true)

local GUItab = Library:createTabs(CoreGui.Sigma, "Gui")
--ActiveMods
local ActiveMods = GUItab:ToggleButton({
    name = "ActiveMods",
    info = "Render active mods",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = not CoreGui.SigmaVisualStuff.ArrayListHolder.Visible
    end
})
--TabGUI
local TabGUI = GUItab:ToggleButton({
    name = "TabGUI",
    info = "Just decorations",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible = not CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible
    end
})
--Uninject
local BlurEffect = Lighting:FindFirstChild("Blur")
local Uninject = GUItab:ToggleButton({
    name = "DeleteGUI",
    info = "Doesnt Uninject 100%",
    callback = function(enabled)
        if enabled then
            BlurEffect:Destroy()
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
            AimRange = 20
            while enabled do
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
local Delay = 0.03
local KillAura = COMBATtab:ToggleButton({
    name = "KillAura",
    info = "Attack Nearest Player?",
    callback = function(enabled)
        if enabled then
            while true do
                attackNearestPlayer()
                wait(Delay)
            end
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
local Rotation = KillAura:ToggleButtonInsideUI({
    name = "Rotations",
    callback = function(enabled)
        if enabled then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/Rotate.lua"))()
        end
    end
})
--PlayerSection
local PLAYERtab = Library:createTabs(CoreGui.Sigma, "Player")
--Flight
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local FlyingShit = false

local function LibrecraftFly()
    while FlyingShit do
        rootPart.Velocity = Vector3.new(0, 3, 0)
        wait(0.73)
        rootPart.Velocity = rootPart.CFrame.LookVector * humanoid.JumpPower * 1.8
        wait(1)
    end
end
local FlightTemp = PLAYERtab:ToggleButton({
    name = "FlightTemp",
    info = "Temporary Flight",
    callback = function(enabled)
        if enabled then
            FlyingShit = true
            humanoid.PlatformStand = true
            LibrecraftFly()
        else
            FlyingShit = false
            humanoid.PlatformStand = false
            rootPart.Velocity = Vector3.new()
        end
    end
})
--SpeedTemporarily
local CustomSpeed = 58
local SpeedTemp = PLAYERtab:ToggleButton({
    name = "SpeedTemp",
    info = "Temporary speed boost",
    callback = function(enabled)
        if enabled then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = CustomSpeed
        else
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
    end
})
local function LongJump()
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local rootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")  
    local forwardVector = rootPart.CFrame.lookVector
    local jumpPower = humanoid.JumpPower

    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.38)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.63)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.63)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    rootPart.Velocity = forwardVector * jumpPower * 1.3
end
local LongJumpToggle = PLAYERtab:ToggleButton({
    name = "LongJump",
    info = "Jump multiple times and then move forward",
    callback = function(enabled)
        if enabled then
            LongJump()
        end
    end
})
