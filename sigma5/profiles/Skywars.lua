local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/SigmaLibrary.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local function GetNearestPlr(range)
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

--CreatingUI
Library:createScreenGui()
--Tabs
local GuiTab = Library:createTabs(CoreGui.Sigma, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma, "Combat")
local PlayerTab = Library:createTabs(CoreGui.Sigma, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma, "World")
--SigmaSkywarsEdition
createnotification("Sigma5", "Loaded Successfully", 1, true)
--ActiveMods
local ActiveMods = GuiTab:ToggleButton({
    name = "ActiveMods",
    info = "Render active mods",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = not CoreGui.SigmaVisualStuff.ArrayListHolder.Visible
    end
})
--TabGUI
local TabGUI = GuiTab:ToggleButton({
    name = "TabGUI",
    info = "Just decorations",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible = not CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible
    end
})
--DeleteGui
local BlurEffect = Lighting:FindFirstChild("Blur")
local DeleteGui = GuiTab:ToggleButton({
    name = "DeleteGUI",
    info = "Does not uninject",
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
--Aimbot
local StartAimingRange
local Aimbot = CombatTab:ToggleButton({
    name = "Aimbot",
    info = "Aim Assist?",
    callback = function(enabled)
        if enabled then
            StartAimingRange = 20
            while enabled do
                local NearestPlayer = GetNearestPlr(StartAimingRange)
                if NearestPlayer then
                    local direction = (NearestPlayer.Character.HumanoidRootPart.Position - Camera.CFrame.Position).unit
                    local newLookAt = CFrame.new(Camera.CFrame.Position, NearestPlayer.Character.HumanoidRootPart.Position)
                    Camera.CFrame = newLookAt
                end
                wait(0.01)
            end
        else
            StartAimingRange = 0
        end
    end
})
local StartAimingRangeCustom = Aimbot:Slider({
    title = "Range",
    min = 0,
    max = 20,
    default = 20,
    callback = function(val)
        StartAimingRange = val
    end
})
--AutoQuit
local LowHealthValue
local function CheckHealth()
    while wait(0.01) do
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character.Humanoid.Health < LowHealthValue then
            localPlayer:Kick("AutoQuit")
        end
    end
end
local AutoQuit = CombatTab:ToggleButton({
    name = "AutoQuit",
    info = "Automatically quit the game",
    callback = function(enabled)
        if enabled then
            LowHealthValue = 3
            CheckHealth()
        else
            LowHealthValue = nil
        end
    end
})
local CustomLowHealth = AutoQuit:Slider({
    title = "HealthMin",
    min = 0.11,
    max = 100,
    default = 0.11,
    callback = function(value)
        LowHealthValue = value
    end
})
--KillAura
local StartAttackingRange
local StartRotatingRange
local KillAura = CombatTab:ToggleButton({
    name = "KillAura",
    info = "Attack Nearest Entity",
    callback = function(enabled)
        if enabled then
            StartAttackingRange = 20
            while enabled do
                local NearestPlayer = GetNearestPlr(StartAttackingRange)
                if NearestPlayer then
                    local args = {
                        [1] = NearestPlayer
                    }
                    game:GetService("ReplicatedStorage"):FindFirstChild("events-Eqz"):FindFirstChild("5c73e2ee-c179-4b60-8be7-ef8e4a7eebaa"):FireServer(unpack(args))
                end
                wait(0.01)
            end
        else
            StartAttackingRange = 0
        end
    end
})
local StartAttackingRangeCustom = KillAura:Slider({
    title = "Range",
    min = 0,
    max = 20,
    default = 20,
    callback = function(value)
        StartAttackingRange = value
        StartRotatingRange = value
    end
})
local Rotations = KillAura:ToggleButtonInsideUI({
    name = "Rotations",
    callback = function(enabled)
        if enabled then
            StartRotatingRange = 20
            while task.wait(0.01) do
                local NearestPlayer = GetNearestPlr(StartRotatingRange)
                if NearestPlayer then
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local direction = (NearestPlayer.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).unit
                        local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
                        local newCFrame = CFrame.new(localPlayer.Character.HumanoidRootPart.Position, localPlayer.Character.HumanoidRootPart.Position + lookVector)
                        localPlayer.Character:SetPrimaryPartCFrame(newCFrame)
                    end
                end
            end
        else
            StartRotatingRange = 0
        end
    end
})
