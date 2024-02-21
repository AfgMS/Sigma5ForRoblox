--ImprotantStuff
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/SigmaJello4Roblox/main/SigmaLibrary.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local TeamsService = game:GetService("Teams")
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local KnitClient = debug.getupvalue(require(localPlayer.PlayerScripts.TS.knit).setup, 6)
local Client = require(ReplicatedStorage.TS.remotes).default.Client
local BlockService = CollectionService:GetTagged("block")

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

local Bedwars = {
    ["KnockbackCont"] = debug.getupvalue(require(ReplicatedStorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1),
    ["SprintCont"] = KnitClient.Controllers.SprintController,
    ["SwordCont"] = KnitClient.Controllers.SwordController,
    ["ViewmodelCont"] = KnitClient.Controllers.ViewmodelController,
    ["ClientHandlerStore"] = require(localPlayer.PlayerScripts.TS.ui.store).ClientStore,
}

local function GetMatchState()
	return Bedwars["ClientHandlerStore"]:getState().Game.matchState
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

local WeaponRank = {
  [1] = { Name = "wood_sword", Rank = 1 },
  [2] = { Name = "stone_sword", Rank = 2 },
  [3] = { Name = "iron_sword", Rank = 3 },
  [4] = { Name = "diamond_sword", Rank = 4 },
  [5] = { Name = "void_sword", Rank = 5 },
  [6] = { Name = "emerald_sword", Rank = 6 },
  [7] = { Name = "rageblade", Rank = 7 },
}

local ProjectilesRank = {
  [1] = { Name = "wood_bow", Rank = 1 },
  [2] = { Name = "fireball", Rank = 2 },
  [3] = { Name = "wood_crossbow", Rank = 3 },
  [4] = { Name = "firecrackers", Rank = 4 },
  [5] = { Name = "headhunter", Rank = 5 }
}

function GetAttackPos(plrpos, nearpost, val)
  local newPos = (nearpost - plrpos).Unit * math.min(val, (nearpost - plrpos).Magnitude) + plrpos
  return newPos
end

local function GetSword()
  local bestsword = nil
  local bestrank = 0
  for i, v in pairs(localPlayer.Character.InventoryFolder.Value:GetChildren()) do
    if v.Name:match("sword") or v.Name:match("blade") then
      for _, data in pairs(WeaponRank) do
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

local function GetProjectiles()
  local bestProject = nil
  local bestrank = 0
  for i, v in pairs(localPlayer.Character.InventoryFolder.Value:GetChildren()) do
    if v.Name:match("bow") or v.Name:match("fire") or v.Name:match("head") then
      for _, data in pairs(ProjectilesRank) do
        if data.Name == v.Name then
          if bestrank <= data.Rank then
            bestrank = data.Rank
            bestProject = v
          end
        end
      end
    end
  end
  return bestProject
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
--[[
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
--]]
--AntiKnockback
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
--[[
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
local WeaponProjectile
local BowAimbotRange = 85
local BowAimbot = CombatTab:ToggleButton({
    name = "BowAimbot",
    info = "Vape ProjectileExploit??",
    callback = function(enabled)
        if enabled then
            WeaponProjectile = GetProjectiles()
            local NearestPlayer = GetNearestPlr(BowAimbotRange)
            if NearestPlayer then
                SetHotbar(WeaponProjectile)
                local BowAimbotRequirement = {
                    [1] = WeaponProjectile,
                    [2] = "arrow",
                    [3] = WeaponProjectile,
                    [4] = Value2Vector(NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position),
                    [5] = Value2Vector(NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position),
                    [6] = Vector3.new(0, NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y, 0),
                    [7] = HttpService:GenerateGUID(true),
                    [8] = {
                        ["drawDurationSeconds"] = 0.95,
                        ["shotId"] = HttpService:GenerateGUID(false)
                    },
                    [9] = Workspace:GetServerTimeNow() - 0.11
                }
                game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.ProjectileFire:InvokeServer(unpack(BowAimbotRequirement))
            end
        else
            WeaponProjectile = nil
        end
    end
})
--]]
--KillAura
local Anims = {
    ["Slow"] = {
        {CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(220), math.rad(100), math.rad(100)), Time = 0.25},
        {CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.25}
    },
    ["Weird"] = {
        {CFrame = CFrame.new(0, 0, 1.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.25},
        {CFrame = CFrame.new(0, 0, -1.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.25},
        {CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.25}
    }
}
local PlayAnims = false
local RightC0 = ReplicatedStorage.Assets.Viewmodel.RightHand.RightWrist.C0
local KillAuraRange
local RotationsRange
local ChoosedAnimations = Anims["Slow"]
local KillAura = CombatTab:ToggleButton({
    name = "KillAura",
    info = "Automatically attacks players",
    callback = function(enabled)
        if enabled then
            KillAuraRange = 20
            local Sword = GetSword()
            if localplayer and localplayer.Character then
                repeat task.wait() until GetMatchState() ~= 0
                local AnimationHolder = Instance.new("Animation")
                AnimationHolder.AnimationId = "rbxassetid://4947108314"
                local AnimationLoader = localPlayer.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator")
                AnimationLoader:LoadAnimation(AnimationHolder):Play()
                if PlayAnims then
                    for i,v in pairs(ChoosedAnimations, Anims) do
                        game:GetService("TweenService"):Create(game.Workspace.CurrentCamera.Viewmodel.RightHand.RightWrist,TweenInfo.new(v.Time),{C0 = RightC0 * v.CFrame}):Play()
                        task.wait(v.Time-0.01)
                    end
                    PlayAnims = false
                end
            end
            if Sword ~= nil then
                while wait(0.01) do
                    local NearestPlayer = GetNearestPlr(KillAuraRange)
                    if NearestPlayer then
                        SetHotbar(Sword)
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
local Rotations = KillAura:ToggleButtonInsideUI({
    name = "Rotations",
    callback = function(enabled)
        if enabled then
            RotationsRange = 20
            while enabled do
                local NearestPlayer = GetNearestPlr(RotationsRange)
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
            RotationsRange = 0
        end
    end
})
local KillAuraAnimationsMode = KillAura:Dropdown({
    name = "Animations",
    default = "Slow",
    list = Anims,
    callback = function(selected)
        ChoosedAnimations = selected
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
--[[ --Under a development
local function CreateNameTags(player)
    if player ~= localPlayer then
        local BillboardGui = Instance.new("BillboardGui", game.CoreGui)
        BillboardGui.Active = true
        BillboardGui.Adornee = player.Character:FindFirstChild("Head")
        BillboardGui.AlwaysOnTop = true
        BillboardGui.MaxDistance = 115.000
        BillboardGui.Name = "Sigma5NameTags"
        BillboardGui.Size = UDim2.new(0, 125, 0, 45)
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
        BillboardGui.ResetOnSpawn = false
        
        local NametagHolder = Instance.new("Frame", BillboardGui)
        NametagHolder.Name = "NametagHolder"
        NametagHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NametagHolder.BackgroundTransparency = 1.000
        NametagHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NametagHolder.BorderSizePixel = 0
        NametagHolder.Size = UDim2.new(1, 0, 1, 0)
        
        local PlayerHealth = Instance.new("Frame", NametagHolder)
        PlayerHealth.Name = "PlayerHealth"
        PlayerHealth.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        PlayerHealth.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PlayerHealth.BorderSizePixel = 0
        PlayerHealth.Position = UDim2.new(0, 0, 0, 40)
        PlayerHealth.Size = UDim2.new(1, 0, 0, 5)
        
        local PlayerFill = Instance.new("Frame", PlayerHealth)
        PlayerFill.Name = "PlayerFill"
        PlayerFill.BackgroundColor3 = Color3.fromRGB(9, 122, 220)
        PlayerFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PlayerFill.BorderSizePixel = 0
        PlayerFill.Size = UDim2.new(1, 0, 0, 5)
        
        local PlayerName = Instance.new("TextLabel", NametagHolder)
        PlayerName.Name = "PlayerName"
        PlayerName.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        PlayerName.BackgroundTransparency = 0.350
        PlayerName.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PlayerName.BorderSizePixel = 0
        PlayerName.Size = UDim2.new(1, 0, 0, 40)
        PlayerName.Font = Enum.Font.Roboto
        PlayerName.Text = player.Name
        PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayerName.TextScaled = true
        PlayerName.TextSize = 25.000
        PlayerName.TextWrapped = true

        local HealthValue = Instance.new("TextLabel", PlayerName)
        HealthValue.Name = "HealthValue"
        HealthValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HealthValue.BackgroundTransparency = 1.000
        HealthValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
        HealthValue.BorderSizePixel = 0
        HealthValue.Position = UDim2.new(0, 0, 0, 27)
        HealthValue.Size = UDim2.new(1, 0, 0, 15)
        HealthValue.Font = Enum.Font.Roboto
        HealthValue.Text = "   Health: " .. tostring(100)
        HealthValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        HealthValue.TextWrapped = true
        HealthValue.TextXAlignment = Enum.TextXAlignment.Left
        
        local function updateHealth()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local maxHealth = humanoid.MaxHealth
                local currentHealth = humanoid.Health
                local fillPercentage = currentHealth / maxHealth
                PlayerFill.Size = UDim2.new(fillPercentage, 0, 0, 5)
                HealthValue.Text = "   Health:" .. tostring(currentHealth)
            end
        end

        spawn(function()
            while wait(0.01) do
                updateHealth()
            end
        end)
    end
end
local NameTags = RenderTab:ToggleButton({
    name = "NameTags",
    info = "Render Sigma5 NameTags",
    callback = function(enabled)
        if enabled then
            while task.wait(1) do
                for _, player in ipairs(game.Players:GetPlayers()) do
                    CreateNameTags(player)
                end
            end
        end
    end
})
local function CheckTeams()
    local localPlayer = Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then
        ReplicatedStorage:WaitForChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue:FireServer({["queueType"] = "bedwars_to1"})
        return true
    end
    
    local localTeam = localPlayer.Team
    local spectatorTeam = TeamsService:FindFirstChild("Spectators")
    
    local foundOtherPlayer = false
    for _, otherTeam in ipairs(TeamsService:GetTeams()) do
        if otherTeam ~= localTeam and otherTeam ~= spectatorTeam then
            if #otherTeam:GetPlayers() > 0 then
                foundOtherPlayer = true
                break
            end
        end
    end
    
    return not foundOtherPlayer
end
local function SigmemeAutoL()
    local RandomChances = math.random(0, 5)

    local function FireServer(message)
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
    end

    if RandomChances == 0 then
        FireServer("I don't hack I just SIGMA")
    elseif RandomChances ~= 0 then
        FireServer("Sigma will help you. Oops, I killed you instead.")
    elseif RandomChances == 2 then
        FireServer("vxpe and godsploit is better than this")
    elseif RandomChances == 3 then
        FireServer("I just have a good gaming chair")
    elseif RandomChances == 4 then
        FireServer("Use sigma to kick some ### while listening to music")
    elseif RandomChances == 5 then
        FireServer("Simga Klien 1945 bye pass 🙀")
    end
end

local AutoQueue = false
local AutoGG = false
local AutoL = false

local GamePlay = PlayerTab:ToggleButton({
    name = "GamePlay",
    info = "Makes your experience better",
    callback = function(enabled)
        if enabled then
            if AutoQueue and CheckTeams() then
                ReplicatedStorage:WaitForChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue:FireServer({["queueType"] = "bedwars_to1"})
            end

            if AutoGG and CheckTeams() then
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GG", "All")
            end

            if AutoL then
                SigmemeAutoL()
            end
        else
            AutoQueue, AutoGG, AutoL = false, false, false
        end
    end
})
local GamePlayFix = GamePlay:Slider({
    title = "??",
    min = 0,
    max = 0,
    default = 0,
    callback = function(val)
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
local AutoLToggle = GamePlay:ToggleButtonInsideUI({
    name = "AutoL",
    callback = function(enabled)
        AutoL = enabled
    end
})
--]]
local EasyGGs = false
local AutoJumps = false
local function EasyGGMode()
    local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
    
    local currentPos = localPlayer.Character:GetPrimaryPartCFrame().Position
    local forwardOffset = Vector3.new(0, 0, 1)
    local targetPos = currentPos + (localPlayer.Character:GetPrimaryPartCFrame().LookVector * forwardOffset)
    
    while EasyGGs do
        localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPos))
        wait(1)
    end
end
local function AutoJumpSet()
    while AutoJumps do
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        wait(0.64)
    end 
end
local ChoosedMode = "Universal"
local Speed = PlayerTab:ToggleButton({
    name = "Speed",
    info = "Insani Spid Bipass!!",
    callback = function(enabled)
        if enabled then
            if ChoosedMode == "EasyGG" then
                localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 23
                EasyGGs = true
                EasyGGMode()
            elseif ChoosedMode == "Universal" then
                localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 20
            end
        else
            localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
            EasyGGs = false
        end
    end
})
local SpeedFix = Speed:Slider({
    title = "??",
    min = 0,
    max = 0,
    default = 0,
    callback = function(val)
    end
})
local AutoJump = Speed:ToggleButtonInsideUI({
    name = "AutoJump",
    callback = function(enabled)
        if enabled then
            AutoJumps = true 
            AutoJumpSet()
        else
            AutoJumps = false 
        end
    end
})
local SpeedModes = Speed:Dropdown({
    name = "SpeedMode",
    default = "Vanilla",
    list = {"EasyGG", "Universal"},
    callback = function(selected)
        ChoosedMode = selected
    end
})
