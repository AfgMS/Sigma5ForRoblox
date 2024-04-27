--Services
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/LibraryMobile.lua", true))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = game:GetService("Workspace").CurrentCamera
local Lighting = game:GetService("Lighting")
local CoreGui = game:WaitForChild("CoreGui")
local LocalPlayer = game.Players.LocalPlayer
local Player = game:GetService("Players")
--Functions
local function GetNearest(range)
    local nearestPlayer = {}

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            if player.Character and game.Players.LocalPlayer.Character then
                local distance = (player.Character:WaitForChild("HumanoidRootPart") - game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")).magnitude
                if distance <= range then
                    table.insert(nearestPlayer, player)
                end
            end
        end
    end

    return nearestPlayer
end
--Tabs
Library:createScreenGui()
local GuiTab = Library:createTabs(CoreGui.Sigma5, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma5, "Combat")
local RenderTab = Library:createTabs(CoreGui.Sigma5, "Render")
local PlayerTab = Library:createTabs(CoreGui.Sigma5, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma5, "World")
--GuiModules
local ActiveMods = GuiTab:ToggleButton({
    name = "ActiveMods",
    info = "Render active mods",
    callback = function(enabled)
        CoreGui.Sigma5Visual.RightSide.ArrayListHolder.Visible = not CoreGui.Sigma5Visual.RightSide.ArrayListHolder.Visible
    end
})
--TabGUI
local TabGUI = GuiTab:ToggleButton({
    name = "TabGUI",
    info = "Just decorations",
    callback = function(enabled)
        CoreGui.Sigma5Visual.LeftSide.TabHolder.Visible = not CoreGui.Sigma5Visual.LeftSide.TabHolder.Visible
    end
})
--RemoveUI
local BlurEffect = Lighting:FindFirstChild("Blur")
local RemoveUI = GuiTab:ToggleButton({
    name = "RemoveUI",
    info = "This is not an uninject",
    callback = function(enabled)
        if enabled then
            if BlurEffect then
                BlurEffect:Destroy()
            end
            if CoreGui:FindFirstChild("Sigma5") then
                CoreGui.Sigma5:Destroy()
            end
            if CoreGui:FindFirstChild("Sigma5Visual") then
                CoreGui.Sigma5Visual:Destroy()
            end
        end
    end
})
--CombatModules
local AimPart = {"Head", "HumanoidRootPart", "LowerTorso"}
local DefaultAimPart = "HumanoidRootPart"
local CameraDirection
local AimbotDistance
local Aimbot = CombatTab:ToggleButton({
    name = "Aimbot",
    info = "Automatically aim at players",
    callback = function(enabled)
        if enabled then
            AimbotDistance = 20
            while enabled do
                local Target = GetNearest(AimbotDistance)
                if Target then
                    if DefaultAimPart == "Head" then
                        CameraDirection = (Target.Character:WaitForChild("Head").Position - Camera.CFrame.Position).unit
                    elseif DefaultAimPart == "HumanoidRootPart" then
                        CameraDirection = (Target.Character:WaitForChild("HumanoidRootPart").Position - Camera.CFrame.Position).unit
                    elseif DefaultAimPart == "LowerTorso" then
                        CameraDirection = (Target.Character:WaitForChild("LowerTorso").Position - Camera.CFrame.Position).unit
                    end
                    local SetLookAt = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + CameraDirection)
                    Camera.CFrame = SetLookAt
                end
                task.wait(0.01)
            end
        else
            AimbotDistance = 0
        end
    end
})
local CustomAimbotDist = Aimbot:Slider({
    title = "Distance",
    min = 0,
    max = 100,
    default = 20,
    callback = function(val)
        AimbotDistance = val
    end
})
local CrazyAimModes = Aimbot:ToggleButtonInsideUI({
    name = "CrazyAim",
    callback = function(enabled)
        if enabled then
            createnotification("Sigma5", "This feature is for premium", 3, true)
        end
    end
})
local AimPartModes = Aimbot:Dropdown({
    name = "AimPart",
    default = "HumanoidRootPart",
    List = {"Head", "HumanoidRootPart", "LowerTorso"},
    callback = function(selected)
        DefaultAimPart = selected
    end
})
--KillAura
local KillAuraDistance
local KillAura = CombatTab:ToggleButton({
    name = "KillAura",
    info = "Attack the nearest entity",
    callback = function(enabled)
        if enabled then
            KillAuraDistance = 20
            while enabled do
                local Target = GetNearest(KillAuraDistance)
                if Target then
                    local HitRemote = {
                        [1] = Target
                    }
                    game:GetService("ReplicatedStorage"):FindFirstChild("events-Eqz"):FindFirstChild("5c73e2ee-c179-4b60-8be7-ef8e4a7eebaa"):FireServer(unpack(HitRemote))
                end
                task.wait(0.03)
            end
        else
            KillAuraDistance = 0
        end
    end
})
--VisualModules
