local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera

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
local WaitDelay = 0.1

local Aimbot = COMBATtab:ToggleButton({
    name = "Aimbot",
    info = "Aim At Nearest Player?",
    callback = function(enabled)
        if enabled then
            AimRange = 20
            while enabled do
                aimAtNearestPlayer(AimRange)
                wait(WaitDelay)
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
local HitDelaySlider = Aimbot:Slider({
    title = "HitDelay",
    min = 0,
    max = 3,
    default = 0,
    callback = function(val)
        WaitDelay = val
    end
})
--AutoQueue
local AutoQueueDelay = 3
local function AutoQueueOnDeath()
    game:GetService("ReplicatedStorage").events-Eqz.a800bb9a-1030-420e-b141-21aaada3d57e:FireServer(true, "SkyWarsSolo")
end
local function CharacterCheck()
    if LocalPlayer.Character and LocalPlayer.Character.Parent ~= workspace then
        AutoQueueOnDeath()
    end
end
local AutoQueue = COMBATtab:ToggleButton({
    name = "AutoQueue",
    info = "Automatically Play Again",
    callback = function(enabled)
        if enabled then
            while true do
                CharacterCheck()
                wait(AutoQueueDelay)
            end
        end
    end
})
local QueueDelaySlider = AutoQueue:Slider({
    title = "QueueDelay",
    min = 0,
    max = 5,
    default = 3,
    callback = function(val)
        AutoQueueDelay = val
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
