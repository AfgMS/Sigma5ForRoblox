--NotHm.. on youtube, and nothm_ on discord
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/SigmaJello4Roblox/main/SigmaLibrary.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local TeamsService = game:GetService("Teams")
local Camera = game:GetService("Workspace").CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local KnitClient = debug.getupvalue(require(localPlayer.PlayerScripts.TS.knit).setup, 6)
local Client = require(ReplicatedStorage.TS.remotes).default.Client
local ClientStore = require(localPlayer.PlayerScripts.TS.ui.store).ClientStore
local KnockbackCont = debug.getupvalue(require(ReplicatedStorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local SprintCont = KnitClient.Controllers.SprintController
local SwordCont = KnitClient.Controllers.SwordController
local BlockHit = ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["block-engine"].node_modules["@rbxts"].net.out._NetManaged.DamageBlock

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

local function GetBed(range)
    local nearestBed
    local nearestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer

    for _, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "bed" and v.Covers.BrickColor ~= localPlayer.Team.TeamColor then
            local distance = (v.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < nearestDistance and distance <= range then
                nearestBed = v
                nearestDistance = distance
            end
        end
    end
    
    return nearestBed
end

local function GetMatchState()
    return ClientStore:getState().Game.matchState
end

function getQueueType()
    local MatchState = ClientStore:getState()
    return MatchState.Game.queueType or "bedwars_test"
end

local function SetHotbar(item)
    if localPlayer.Character:FindFirstChild("HandInvItem").Value ~= item then
        local Inventories = game:GetService("ReplicatedStorage").Inventories:FindFirstChild(localPlayer.Name):FindFirstChild(item)

        ReplicatedStorage.rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SetInvItem:InvokeServer({["hand"] = item})
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

local ToolRank = {
    [1] = { Name = "shears", Rank = 1 },
    [2] = { Name = "wood_pickaxe", Rank = 2 },
    [3] = { Name = "wood_axe", Rank = 3 },
    [4] = { Name = "stone_pickaxe", Rank = 4 },
    [5] = { Name = "stone_axe", Rank = 5 },
    [6] = { Name = "iron_pickaxe", Rank = 6 },
    [7] = { Name = "iron_axe", Rank = 7 },
    [8] = { Name = "diamond_pickaxe", Rank = 8 },
    [9] = { Name = "diamond_axe", Rank = 9 },
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

--[[
local function GetTool()
    local besttool = nil
    local bestrank = 0
    for i, v in pairs(localPlayer.Character.InventoryFolder.Value:GetChildren()) do
        if v.Name:match("shears") or v.Name:match("pickaxe") or v.Name:match("axe") then
            for _, data in pairs(ToolRank) do
                if data["Name"] == v.Name then
                    if bestrank <= data["Rank"] then
                        bestrank = data["Rank"]
                        besttool = v
                    end
                end
            end
        end
    end
    return besttool
end
--]]
--CreatingUI
Library:createScreenGui()
--Tabs
local GuiTab = Library:createTabs(CoreGui.Sigma, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma, "Combat")
local RenderTab = Library:createTabs(CoreGui.Sigma, "Render")
local PlayerTab = Library:createTabs(CoreGui.Sigma, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma, "World")
--Notification
CreateNotification("Loader", "Loaded Successfully", 3, true)
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
--AntiKnockback
local OriginalH = KnockbackCont.kbDirectionStrength
local OriginalY = KnockbackCont.kbUpwardStrength
local AntiKnockback = CombatTab:ToggleButton({
    name = "AntiKnockback",
    info = "Prevent you from taking knockback",
    callback = function(enabled)
        if enabled then
            KnockbackCont.kbDirectionStrength = 0
            KnockbackCont.kbUpwardStrength = 0
        else
            KnockbackCont.kbDirectionStrength = OriginalH
            KnockbackCont.kbUpwardStrength = OriginalY
        end
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
local KillAuraRange
local RotationsRange
local AutoSword = false
local KillAura = CombatTab:ToggleButton({
    name = "KillAura",
    info = "Automatically attacks players",
    callback = function(enabled)
        if enabled then
            KillAuraRange = 20
            local NearestPlayer = GetNearestPlr(KillAuraRange)
            local Sword = GetMelee()
            if AutoSword then
                if NearestPlayer then
                    SetHotbar(Sword)
                else
                    AutoSword = false
                end
            end
            if NearestPlayer then
                while task.wait(0.01) do
                    ReplicatedStorage.rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit:FireServer({
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
        RotationsRange = value
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
            RotationsRange = 20
            while task.wait(0.01) do
                local NearestPlayer = GetNearestPlr(RotationsRange)
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
            RotationsRange = 0
        end
    end
})
--Teams
local Teams = CombatTab:ToggleButton({
    name = "Teams",
    info = "Avoid combat modules to target your teammate",
    callback = function(enabled)
        TeamCheck = not TeamCheck
    end
})
--Fullbright
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
--Gameplay
local AutoQueue = false
local AutoGG = false
local ActionDelay = 1
local GamePlay = PlayerTab:ToggleButton({
    name = "GamePlay",
    info = "Makes your experience better",
    callback = function(enabled)
        if enabled then
            if AutoQueue then
                repeat
                    task.wait(ActionDelay)
                until GetMatchState() == 2 or not enabled
                ReplicatedStorage:FindFirstChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue:FireServer({["queueType"] = getQueueType()})
            end

            if AutoGG then
                repeat
                    task.wait(ActionDelay)
                until GetMatchState() == 2 or not enabled
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GG", "All")
            end
        else
            AutoQueue, AutoGG = false, false
        end
    end
})
local GamePlayFix = GamePlay:Slider({
    title = "Delay",
    min = 0,
    max = 100,
    default = 1,
    callback = function(val)
        ActionDelay = val
    end
})
local AutoQueueToggle = GamePlay:ToggleButtonInsideUI({
    name = "AutoQueue",
    callback = function(enabled)
        AutoQueue = not AutoQueue
    end
})
local AutoGGToggle = GamePlay:ToggleButtonInsideUI({
    name = "AutoGG",
    callback = function(enabled)
        AutoGG = not AutoGG
    end
})
--AutoSprint
local StopSprinting = SprintCont.stopSprinting
local AutoSprint = PlayerTab:ToggleButton({
    name = "AutoSprint",
    info = "Automatically Sprint",
    callback = function(enabled)
        if enabled then
            spawn(function()
                repeat
                    task.wait()
                    if not SprintCont.sprinting then
                        SprintCont:startSprinting()
                    end
                until not enabled
            end)
        else
            spawn(function()
                repeat
                    task.wait()
                    if StopSprinting then
                        SprintCont:stopSprinting()
                    end
                until enabled
            end)
        end
    end
})
--Speed
local Speed = PlayerTab:ToggleButton({
    name = "Speed",
    info = "speed goes brrr",
    callback = function(enabled)
        if enabled then
            localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 22
        else
            localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
        end
    end
})
--AntiVanish
local AntiVanish = WorldTab:ToggleButton({
    name = "AntiVanish",
    info = "Staff detector",
    callback = function(enabled)
        if enabled then
            game.Players.PlayerAdded:Connect(function(player)
                if not player:IsFriendsWith(game.Players.LocalPlayer.UserId) and GetMatchState() ~= 0 then
                    CreateNotification("AntiVanish", "Someone just vanished", 5, true)
                end
            end)
            
            for i, player in pairs(game.Players:GetPlayers()) do
                if player:IsInGroup(5774246) and player:GetRankInGroup(5774246) >= 2 then
                    CreateNotification("AntiVanish", "Someone just vanished", 5, true)
                end
            end
        end
    end
})
--Nuker
local raycastParams = RaycastParams.new()
raycastParams.IgnoreWater = true

local function HitBed(bed)
    local raycastResult = workspace:Raycast(bed.Position + Vector3.new(0, 13, 0), Vector3.new(0, -16, 0), raycastParams)
    if raycastResult then
        local nearestBed = raycastResult.Instance
        nearestBed.Color = Color3.fromRGB(255, 255, 255)
        nearestBed.Transparency = 0.48

        BlockHit:InvokeServer({
            ["blockRef"] = {
                ["blockPosition"] = Vector3.new(math.round(nearestBed.Position.X / 3), math.round(nearestBed.Position.Y / 3), math.round(nearestBed.Position.Z / 3))
            },
            ["hitPosition"] = Vector3.new(math.round(nearestBed.Position.X / 3), math.round(nearestBed.Position.Y / 3), math.round(nearestBed.Position.Z / 3)),
            ["hitNormal"] = Vector3.new(math.round(nearestBed.Position.X / 3), math.round(nearestBed.Position.Y / 3), math.round(nearestBed.Position.Z / 3))
        })
    end
end

-- local Tool = GetTool()
local Nuker = WorldTab:ToggleButton({
    name = "Nuker",
    info = "Auto bed break",
    callback = function(enabled)
        if enabled then
            spawn(function()
                repeat
                    task.wait()
                    if localPlayer.Character then
                        local nearestBed = GetBed(28.5)
                        if nearestBed then
                            -- SetHotbar(Tool)
                            while true do
                                HitBed(nearestBed)
                                wait()
                            end
                        end
                    end
                until not enabled
            end)
        end
    end
})
--[[
local antivoidpart = nil
local oldpos = nil

local function UpdateOldPosition()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = localPlayer.Character.HumanoidRootPart
        local newPosition = rootPart.Position
        if antivoidpart and newPosition.Y > antivoidpart.Position.Y then
            oldpos = newPosition
        else
            oldpos = nil
        end
    else
        oldpos = nil
    end
end

local function CreatePlatform()
    antivoidpart = Instance.new("Part", game.Workspace)
    antivoidpart.Transparency = 0.75
    antivoidpart.CanCollide = true
    antivoidpart.BrickColor = BrickColor.new(255, 255, 255)
    antivoidpart.Size = Vector3.new(999999, 3, 999999)
    antivoidpart.Anchored = true
    antivoidpart.Position = localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Vector3.new(0, 18, 0)
    antivoidpart.Name = "antivoidpart"

    antivoidpart.Touched:Connect(function(hit)
        local parent = hit.Parent
        if parent and parent:FindFirstChild("HumanoidRootPart") and oldpos then
            if localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local character = localPlayer.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local playerPos = humanoidRootPart.Position
                    if playerPos.Y < oldpos.Y then
                        local tweenInfo = TweenInfo.new(0.83, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                        local tween = TweenService:Create(character, tweenInfo, {PrimaryPartCFrame = CFrame.new(Vector3.new(character.PrimaryPart.Position.X, oldpos.Y, character.PrimaryPart.Position.Z))})
                        tween:Play()
                        local ray = Ray.new(humanoidRootPart.Position, Vector3.new(0, -100, 0))
                        local hitPart, hitPos = workspace:FindPartOnRay(ray)
                        if hitPart then
                            local destination = hitPos + Vector3.new(0, character.PrimaryPart.Size.Y / 2, 0)
                            local distance = (destination - humanoidRootPart.Position).Magnitude
                            local tween = TweenService:Create(character, TweenInfo.new(distance / 50, Enum.EasingStyle.Linear), {PrimaryPartCFrame = CFrame.new(destination)})
                            tween:Play()
                        end
                    end
                end
            end
        end
    end)

    return antivoidpart
end

local AntiVoid = WorldTab:ToggleButton({
    name = "AntiVoid",
    info = "Prevents falling into the void",
    callback = function(enabled)
        if enabled then
            UpdateOldPosition()
            CreatePlatform()
        else
            if antivoidpart then
                antivoidpart:Destroy()
                antivoidpart = nil
            end
        end
    end
})

local function CheckIfInAir()
    while true do
        wait(3)
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = localPlayer.Character.Humanoid
            if humanoid:GetState() == Enum.HumanoidStateType.Physics then
                oldpos = nil
            else
                UpdateOldPosition()
            end
        end
    end
end

spawn(CheckIfInAir)
--]]
