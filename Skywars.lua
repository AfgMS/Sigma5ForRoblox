local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer

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
local function findNearestLivingPlayer()
    local nearestPlayer
    local nearestDistance = math.huge

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and isAlive(player) then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestPlayer = player
                nearestDistance = distance
            end
        end
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
--KillAura
local KillAura = COMBATtab:ToggleButton({
    name = "KillAura",
    info = "Attack Nearest Player?",
    callback = function(enabled)
        if enabled then
            local NearestPlayer = findNearestLivingPlayer(20)
            if NearestPlayer then
                while wait(0.03) do
                    game:GetService("ReplicatedStorage"):FindFirstChild("events-Eqz"):FindFirstChild("5c73e2ee-c179-4b60-8be7-ef8e4a7eebaa"):FireServer(NearestPlayer or NearestPlayer.Character:WaitForChild("HumanoidRootPart"))
                end
            end
        end
    end
})
local ButtonFix = KillAura:Slider({
    title = "ButtonFix",
    min = 0,
    max = 0,
    default = 0,
    callback = function(value)
    end
})
local Rotation = KillAura:ToggleButtonInsideUI({
    name = "Rotation",
    callback = function(enabled)
        if enabled then
            local NearestPlayer = findNearestLivingPlayer(20)
            if NearestPlayer then 
                while wait(0.1) do
                    localPlayer.Character:WaitForChild("Humanoid").Direction = (NearestPlayer.Character:WaitForChild("HumanoidRootPart").Position - localPlayer.Character:WaitForChild("HumanoidRootPart").Position).unit
                end
            end
        end
    end
})
