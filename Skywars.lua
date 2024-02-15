local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SkywarsCont = {}
--Tabs
local GuiTab = Library:createTabs(CoreGui.Sigma, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma, "Combat")
local PlayerTab = Library:createTabs(CoreGui.Sigma, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma, "World")
--Remotes
local SkywarsRemote = {
    HitRemote = ReplicatedStorage:FindFirstChild("events-Eqz") and ReplicatedStorage:FindFirstChild("events-Eqz"):FindFirstChild("5c73e2ee-c179-4b60-8be7-ef8e4a7eebaa")
}
--Functions
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

local function GetImportantShit()
    local FlaemWork = require(game:GetService("ReplicatedStorage").rbxts_include.node_modules["@flamework"].core.out).Flamework
    repeat wait() until FlaemWork.isInitialized

    local controllers = {}
    local eventnames = {}

    for i, v in pairs(debug.getupvalue(FlaemWork.Testing.patchDependency, 1).idToObj) do
        controllers[tostring(v)] = v
        local controllerevents = {}

        for i2, v2 in pairs(v) do
            if type(v2) == "function" then
                local eventsfound = {}
                for i3, v3 in pairs(debug.getconstants(v2)) do
                    if tostring(v3):find("-") == 9 then
                        table.insert(eventsfound, tostring(v3))
                    end
                end
                if #eventsfound > 0 then
                    controllerevents[i2] = eventsfound
                end
            end
        end
        eventnames[tostring(v)] = controllerevents
    end

    SkywarsCont = {
        ["HotbarController"] = controllers["HotbarController"],
        ["BlockUtil"] = require(game:GetService("ReplicatedStorage").TS.util["block-util"]).BlockUtil
    }
end

local WeaponTier = {
    BronzeSword = 1,
    IronSword = 2,
    GoldSword = 3,
    DiamondSword = 4,
    OnyxSword = 5
}

local function GetBestSword()
    local bestSword
    local highestTier = 0
    
    for _, itemId in ipairs(SkywarsCont.HotbarController:getHotbarItems()) do
        local swordTier = WeaponTier[itemId]
        if swordTier and swordTier > highestTier then
            bestSword = itemId
            highestTier = swordTier
        end
    end

    return bestSword
end
--CreatingUI
Library:createScreenGui()
task.wait()
LibraryCheck()
GetImportantShit()
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
                local HeldedItem = GetBestSword()
                        local KillAuraShit = {
                            [1] = nearestPlayer
                        }
                        SkywarsRemote.HitRemote:FireServer(unpack(KillAuraShit))
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
local RotationsCheck = KillAura:ToggleButtonInsideUI({
    name = "Rotations",
    callback = function(enabled)
        if enabled then
            StartRotatingRange = 20
            while enabled do
                local NearestPlayer = GetNearestPlr(StartRotatingRange)
                if NearestPlayer then
                    local character = localPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local direction = (NearestPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).unit
                        local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
                        local newCFrame = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + lookVector)
                        character:SetPrimaryPartCFrame(newCFrame)
                    end
                end
                wait(0.01)
            end
        else
            StartRotatingRange = 0
        end
    end
})
