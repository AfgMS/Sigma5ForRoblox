local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/SigmaJello4Roblox/main/SigmaLibrary.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local TeamsService = game:GetService("Teams")
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SelectionService = game:GetService("Selection")

local KnitClient = debug.getupvalue(require(localPlayer.PlayerScripts.TS.knit).setup, 6)
local Client = require(ReplicatedStorage.TS.remotes).default.Client

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

local function isAlive(player)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        return player.Character.Humanoid.Health > 0
    end
    return false
end

local Bedwars = {
    ["KnockbackCont"] = debug.getupvalue(require(ReplicatedStorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1),
    ["SprintCont"] = KnitClient.Controllers.SprintController,
    ["SwordCont"] = KnitClient.Controllers.SwordController,
    ["ViewmodelCont"] = KnitClient.Controllers.ViewmodelController,
    ["ClientHandlerStore"] = require(localPlayer.PlayerScripts.TS.ui.store).ClientStore,
    ["CombatCons"] = require(ReplicatedStorage.TS.combat["combat-constant"]).CombatConstant,
    ["QueryUtil"] = require(ReplicatedStorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
    ["SwordHit"] = ReplicatedStorage.rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit,
    ["MessageRequest"] = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest,
    ["JoinQueue"] = ReplicatedStorage:FindFirstChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue
}

local function GetMatchState()
    return Bedwars["ClientHandlerStore"]:getState().Game.matchState
end

function getQueueType()
    local matchstate = Bedwars["ClientHandlerStore"]:getState()
    return matchstate.Game.queueType or "bedwars_test"
end

local function SetHotbar(item)
    if localPlayer.Character:FindFirstChild("HandInvItem").Value ~= item then
        local Inventories = game:GetService("ReplicatedStorage").Inventories:FindFirstChild(localPlayer.Name):FindFirstChild(item)

        game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SetInvItem:InvokeServer({["hand"] = item})
    end
end

local function Value2Vector(vec)
  return { value = vec }
end

local MeleeRank = {
  [1] = { Name = "wood_sword", Rank = 1 },
  [2] = { Name = "stone_sword", Rank = 2 },
  [3] = { Name = "iron_sword", Rank = 3 },
  [4] = { Name = "diamond_sword", Rank = 4 },
  [5] = { Name = "void_sword", Rank = 5 },
  [6] = { Name = "emerald_sword", Rank = 6 },
  [7] = { Name = "rageblade", Rank = 7 },
}

function GetAttackPos(plrpos, nearpost, val)
  local newPos = (nearpost - plrpos).Unit * math.min(val, (nearpost - plrpos).Magnitude) + plrpos
  return newPos
end

local function GetMelee()
  local bestsword = nil
  local bestrank = 0
  for i, v in pairs(localPlayer.Character.InventoryFolder.Value:GetChildren()) do
    if v.Name:match("sword") or v.Name:match("blade") then
      for _, data in pairs(MeleeRank) do
        if data["Name"] == v.Name then
          if bestrank <= data["Rank"] then
            bestrank = data["Rank"]
            bestsword = v
          end
        end
      end
    end
  end
  return bestsword
end
--CreatingUI
Library:createScreenGui()
task.wait()
LibraryCheck()
--Tabs
local GuiTab = Library:createTabs(CoreGui.Sigma, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma, "Combat")
local RenderTab = Library:createTabs(CoreGui.Sigma, "Render")
local PlayerTab = Library:createTabs(CoreGui.Sigma, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma, "World")
--Notification
createnotification("Sigma5", "Loaded Successfully", 1, true)
--ActiveMods, Done
local ActiveMods = GuiTab:ToggleButton({
    name = "ActiveMods",
    info = "Render active mods",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = not CoreGui.SigmaVisualStuff.ArrayListHolder.Visible
    end
})
--TabGUI, Done
local TabGUI = GuiTab:ToggleButton({
    name = "TabGUI",
    info = "Just decorations",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible = not CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible
    end
})
--DeleteGui, Temporarly
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
--Aimbot, Done
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
--AntiKnockback, Need More Features
local OriginalH = Bedwars["KnockbackCont"]["kbDirectionStrength"]
local OriginalY = Bedwars["KnockbackCont"]["kbUpwardStrength"]
local AntiKnockback = CombatTab:ToggleButton({
    name = "AntiKnockback",
    info = "Prevent you from taking knockback",
    callback = function(enabled)
        if enabled then
            Bedwars["KnockbackCont"]["kbDirectionStrength"] = 0
            Bedwars["KnockbackCont"]["kbUpwardStrength"] = 0
        else
            Bedwars["KnockbackCont"]["kbDirectionStrength"] = OriginalH
            Bedwars["KnockbackCont"]["kbUpwardStrength"] = OriginalY
        end
    end
})
--AutoQuit, Done
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
--KillAura, Need More Features
local KillAuraRange
local RotateDelay = 0.01
local AutoSword = false
local HitDelay = 0.01
local KillAura = CombatTab:ToggleButton({
    name = "KillAura",
    info = "Automatically attacks players",
    callback = function(enabled)
        if enabled then
            KillAuraRange = 20
            local NearestPlayer = GetNearestPlr(KillAuraRange)
            local Sword = GetMelee()
            if AutoSword then
                if NearestPlayer and isAlive(NearestPlayer) then
                    SetHotbar(Sword)
                end
            end
            if NearestPlayer then
                if isAlive(localPlayer) and isAlive(NearestPlayer) then
                    while true do
                        task.wait(HitDelay)
                        Bedwars["SwordHit"]:FireServer({
                            ["entityInstance"] = NearestPlayer.Character,
                            ["chargedAttack"] = {
                                ["chargeRatio"] = 1
                            },
                            ["validate"] = {
                                ["raycast"] = {
                                    ["cursorDirection"] = Value2Vector(Ray.new(game.Workspace.CurrentCamera.CFrame.Position, NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction),
                                    ["cameraPosition"] = Value2Vector(NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position),
                                },
                                ["selfPosition"] = Value2Vector(GetAttackPos(localPlayer.Character:FindFirstChild("HumanoidRootPart").Position, NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position, 2)),
                                ["targetPosition"] = Value2Vector(NearestPlayer.Character.HumanoidRootPart.Position),
                            },
                            ["weapon"] = Sword
                        })
                    end
                end
            else
                KillAuraRange = 0
                AutoSword = false
            end
        end
    end
})
local KillAuraRangeCustom = KillAura:Slider({
    title = "Range",
    min = 0,
    max = 20,
    default = 20,
    callback = function(value)
        KillAuraRange = value
    end
})
local AutoWeapon = KillAura:ToggleButtonInsideUI({
    name = "AutoWeapon",
    callback = function(enabled)
        AutoSword = not AutoSword
    end
})
local Rotations = KillAura:ToggleButtonInsideUI({
    name = "Rotations",
    callback = function(enabled)
        if enabled then
            while true do
                wait(RotateDelay)
                if NearestPlayer then
                    if isAlive(localPlayer) and isAlive(NearestPlayer) then
                        local direction = (NearestPlayer.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).unit
                        local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
                        local newCFrame = CFrame.new(localPlayer.Character.HumanoidRootPart.Position, localPlayer.Character.HumanoidRootPart.Position + lookVector)
                        localPlayer.Character:SetPrimaryPartCFrame(newCFrame)
                    end
                end
            end
        else
            RotateDelay = 86000
        end
    end
})
local HitFix = KillAura:ToggleButtonInsideUI({
    name = "HitFix",
    callback = function(enabled)
        if enabled then
            debug.setconstant(Bedwars["SwordCont"].swingSwordAtMouse, 23, "raycast")
            debug.setupvalue(Bedwars["SwordCont"].swingSwordAtMouse, 4, Bedwars["QueryUtil"])
        else
            debug.setconstant(Bedwars["SwordCont"].swingSwordAtMouse, 23, "Raycast")
            debug.setupvalue(Bedwars["SwordCont"].swingSwordAtMouse, 4, workspace)
        end
    end
})
--Teams, Done
local Teams = CombatTab:ToggleButton({
    name = "Teams",
    info = "Avoid combat modules to target your teammate",
    callback = function(enabled)
        TeamCheck = not TeamCheck
    end
})
--FullBright, Done
local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient
local Fullbright = RenderTab:ToggleButton({
    name = "Fullbright",
    info = "Makes you see in the dark",
    callback = function(enabled)
        if enabled then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            Lighting.Ambient = originalAmbient
            Lighting.OutdoorAmbient = originalOutdoor
        end
    end
})
local CustomFov = FOVChanger:Slider({
    title = "FieldOfView",
    min = 70,
    max = 160,
    default = 120,
    callback = function(value)
        FovValue = value
    end
})
--Tracers, Done
local Tracers = RenderTab:ToggleButton({
    name = "Tracers",
    info = "Draw lines to players",
    callback = function(enabled)
        if enabled then
            while enabled do
                task.wait(0.01)
                local current = Camera.CFrame.Position
                for i, v in pairs(Player:GetPlayers()) do
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local HumanoidRootPart = v.Character.HumanoidRootPart
                        if isAlive(v) and HumanoidRootPart.Position ~= current then
                            Drawing.new({
                                from = current,
                                to = HumanoidRootPart.Position,
                                thickness = 2,
                                color = Color3.fromRGB(0, 255, 0)
                            }):Draw()
                        end
                    end
                end
            end
        else
            Tracers:Remove()
        end
    end
})
--GamePlay, Need More Features
local AutoQueue = false
local AutoGG = false
local GamePlay = PlayerTab:ToggleButton({
    name = "GamePlay",
    info = "Makes your experience better",
    callback = function(enabled)
        if enabled then
            if AutoQueue then
                repeat
                    task.wait(3)
                until GetMatchState() == 2 or not enabled
                if enabled then
                    Bedwars["JoinQueue"]:FireServer({["queueType"] = getQueueType()})
                end
            end

            if AutoGG then
                repeat
                    task.wait(1)
                until GetMatchState() == 2 or not enabled
                if enabled then
                    Bedwars["MessageRequest"]:FireServer("GG", "All")
                end
            end
        else
            AutoQueue, AutoGG = false, false
        end
    end
})
local AutoQueueToggle = GamePlay:ToggleButtonInsideUI({
    name = "AutoQueue",
    callback = function(enabled)
        AutoQueue = enabled
    end
})
local AutoGGToggle = GamePlay:ToggleButtonInsideUI({
    name = "AutoGG",
    callback = function(enabled)
        AutoGG = enabled
    end
})
--AutoSprint, Need Rework
local AutoSprint = PlayerTab:ToggleButton({
    name = "AutoSprint",
    info = "Automatically Sprint",
    callback = function(enabled)
        if enabled then
            spawn(function()
                repeat
                    task.wait()
                    if not Bedwars["SprintCont"].sprinting then
                        Bedwars["SprintCont"]:startSprinting()
                    end
                until not enabled
            end)
        else
            spawn(function()
                repeat 
                    task.wait()
                    if Bedwars["SprintCont"].sprinting then
                        Bedwars["SprintCont"]:stopSprinting()
                    end
                until enabled 
            end)
        end
    end
})
--[[ -- Under a development
local ReachRange = 18
local Reach = PlayerTab:ToggleButton({
    name = "Reach",
    info = "Reach hax",
    callback = function(enabled)
        if enabled then
            Bedwars["CombatCons"].RAYCAST_SWORD_CHARACTER_DISTANCE = ReachRange + 2
        else
            Bedwars["CombatCons"].RAYCAST_SWORD_CHARACTER_DISTANCE = 14.4
        end
    end
})
--]]
