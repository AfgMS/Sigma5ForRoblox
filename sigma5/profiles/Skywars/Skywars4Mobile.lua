--Services
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/LibraryMobile.lua", true))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local LocalPlayer = game.Players.LocalPlayer
--Functions
local function GetNearest()
    local nearestPlayer

    for _, player in ipairs(game.Players:GetPlayers()) do

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
--DeleteGui
local BlurEffect = Lighting:FindFirstChild("Blur")
local DeleteGui = GuiTab:ToggleButton({
    name = "DeleteGUI",
    info = "Does not uninject",
    callback = function(enabled)
        if enabled then
            BlurEffect:Destroy()
            CoreGui.Sigma5:Destroy()
            print("Destroyed Main")
            CoreGui.Sigma5Visual:Destroy()
            print("Destroyed Notif")
        end
    end
})
--Aimbot
local Aimbot = CombatTab:ToggleButton({
    name = "Aimbot",
    info = "Automatically aim at players",
    callback = function(enabled)
        if enabled then

            else
                
    end
})



local Aimbot = CombatTab:ToggleButton({
    name = "Aimbot",
    info = "Automatically aim at players",
    callback = function(enabled)
        if enabled then
            aimbotDistance = 20
            while enabled do
		local Target = GetNearestPlr(aimbotDistance)
                if not isAlive(localPlayer) then
                    repeat task.wait() until isAlive(localPlayer)
                end
                if Target then
                    if not isAlive(Target) then
                        repeat task.wait() until isAlive(Target)
                    end
                    local CameraDirection = (Target.Character.HumanoidRootPart.Position - Camera.CFrame.Position).unit
                    local newLookAt = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + CameraDirection)
                    Camera.CFrame = newLookAt
                end
                task.wait()
            end
        else
            aimbotDistance = 0
        end
    end
})
local Customdistance = Aimbot:Slider({
    title = "Distance",
    min = 0,
    max = 100,
    default = 20,
    callback = function(val)
        aimbotDistance = val
    end
})
