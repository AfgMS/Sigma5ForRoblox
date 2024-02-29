--MainCore
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/SigmaJello4Roblox/main/SigmaLibrary.lua", true))()
local Camera = game:GetService("Workspace").CurrentCamera
local CoreGui = game:WaitForChild("CoreGui")
local Lighting = game:GetService("Lighting")
local Player = game:GetService("Players")
local localPlayer = game.Players.LocalPlayer

--Functions
local TeamCheck = false
local function GetNearestPlr(range)
    local nearestPlayer
    local nearestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not TeamCheck or player.Team ~= localPlayer.Team then
                local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < nearestDistance and distance <= range then
                    nearestPlayer = player
                    nearestDistance = distance
                end
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
local RenderTab = Library:createTabs(CoreGui.Sigma, "Render")
local PlayerTab = Library:createTabs(CoreGui.Sigma, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma, "World")
--Notification
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
local AimbotRange
local Aimbot = CombatTab:ToggleButton({
    name = "Aimbot",
    info = "Automatically aim at players",
    callback = function(enabled)
        if enabled then
            AimbotRange = 20
            while enabled do
                local NearestPlayer = GetNearestPlr(AimbotRange)
                if NearestPlayer then
                    local direction = (NearestPlayer.Character.HumanoidRootPart.Position - Camera.CFrame.Position).unit
                    local newLookAt = CFrame.new(Camera.CFrame.Position, NearestPlayer.Character.HumanoidRootPart.Position)
                    Camera.CFrame = newLookAt
                end
                wait(0.01)
            end
        else
            AimbotRange = 0
        end
    end
})
local AimbotRangeCustom = Aimbot:Slider({
    title = "Range",
    min = 0,
    max = 20,
    default = 20,
    callback = function(val)
        AimbotRange = val
    end
})
