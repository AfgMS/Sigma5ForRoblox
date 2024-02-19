local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/SigmaJello4Roblox/main/SigmaLibrary.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local TeamsService = game:GetService("Teams")
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
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
--[[
local ProjectilesRank = {
  [1] = { Name = "wood_bow", Rank = 1 },
  [2] = { Name = "fireball", Rank = 2 },
  [3] = { Name = "wood_crossbow", Rank = 3 },
  [4] = { Name = "firecrackers", Rank = 4 },
  [5] = { Name = "headhunter", Rank = 5 }
}
--]]
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
--[[
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
--]]
local function GetAllTeam(team)
    local children = {}
    for _, otherTeam in ipairs(TeamsService:GetTeams()) do
        if otherTeam ~= team then
            for _, player in ipairs(otherTeam:GetPlayers()) do
                table.insert(children, player)
            end
        end
    end
    return children
end
--CreatingUI
Library:createScreenGui()
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
--[[ --Premium Features??
local KnockbackUtil = debug.getupvalue(require(ReplicatedStorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local AntiKnockback = CombatTab:ToggleButton({
    name = "AntiKnockback",
    info = "Prevent you from taking knockback",
    callback = function(enabled)
        if enabled then
            KnockbackUtil.kbDirectionStrength = 0
            KnockbackUtil.kbUpwardStrength = 0
        else
            KnockbackUtil.kbDirectionStrength = 100
            KnockbackUtil.kbUpwardStrength = 100
        end
    end
})
--]]
--AutoAutoRageQuit
local LowHealthValue
local function CheckHealth()
    while wait(0.01) do
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character.Humanoid.Health < LowHealthValue then
            localPlayer:Kick("AutoRageQuitTriggered")
        end
    end
end
local AutoRageQuit = CombatTab:ToggleButton({
    name = "AutoRageQuit",
    info = "Automatically logs out",
    callback = function(enabled)
        if enabled then
            LowHealthValue = 3
            CheckHealth()
        else
            LowHealthValue = nil
        end
    end
})
local CustomLowHealth = AutoRageQuit:Slider({
    title = "HealthMin",
    min = 0.11,
    max = 100,
    default = 0.11,
    callback = function(value)
        LowHealthValue = value
    end
})
--[[ --Premium?
local function ProjectileShoot(ProjectileWeapon, Projectile)
  local BowAimbotRequirement = {
    [1] = ProjectileWeapon,
    [2] = Projectile,
    [3] = ProjectileWeapon,
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

local BowAimbotDelay = 1.8

local BowAimbot = CombatTab:ToggleButton({
  name = "BowAimbot",
  info = "Vape ProjectileExploit??",
  callback = function(enabled)
    if enabled then
      local NearestPlayer = GetNearestPlr(math.huge)
      if NearestPlayer then
        local ProjectileAmmo = "arrow"
        while wait(BowAimbotDelay) do
          ProjectileShoot(GetProjectiles(), ProjectileAmmo)
        end
      else
        BowAimbotDelay = 86000
      end
    end
  end
})
--]]
--KillAura
local KillAuraRange
local KillAuraCriticalEffect
local TargetESP
local KillAura = CombatTab:ToggleButton({
    name = "KillAura",
    info = "Automatically attacks players",
    callback = function(enabled)
        if enabled then
            KillAuraRange = 20
            while wait(0.01) do
                local NearestPlayer = GetNearestPlr(KillAuraRange)
                if NearestPlayer then
                    KillAuraCriticalEffect = true
                    TargetESP = true
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
                        ["weapon"] = GetSword()
                    })
                end
            end
        else
            KillAuraRange = 0
            KillAuraCriticalEffect = false
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
local Rotations = KillAura:ToggleButtonInsideUI({
    name = "Rotations",
    callback = function(enabled)
        if enabled then
            while enabled do
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
local TargetESP = KillAura:ToggleButtonInsideUI({
    name = "TargetESP",
    callback = function(enabled)
        if enabled then
            if NearestPlayer and TargetESP then
                local NearestHumRoot = NearestPlayer.Character:FindFirstChild("HumanoidRootPart")
                NearestHumRoot.Size = Vector3.new(5, 6, 3)
                NearestHumRoot.Transparency = 0.58
                NearestHumRoot.Color = Color3.fromRGB(255, 255, 255)
            elseif not NearestPlayer or not TargetESP then
                NearestHumRoot.Size = Vector3.new(2, 2, 1)
                NearestHumRoot.Transparency = 1
                NearestHumRoot.Color = Color3.new(163, 162, 165)
            end
        end
    end
})
--Criticals
local Criticals = CombatTab:ToggleButton({
    name = "Criticals",
    info = "Minecraft crit particles",
    callback = function(enabled)
            if enabled then
                if NearestPlayer then
                    local ParticleHolder = NearestHumRoot:Clone()
                    ParticleHolder.Name = "ParticleHolder"
                    ParticleHolder.CanCollide = false
                    ParticleHolder.Transparency = 1

                    local CritEffect = Instance.new("ParticleEmitter")
                    CritEffect.Enabled = true
                    
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
--ESP
local function BoxESP(player)
    if player ~= game:GetService("Players").LocalPlayer and player.Character then
        local AllPLRRoot = player.Character:FindFirstChild("HumanoidRootPart")
        AllPLRRoot.Size = Vector3.new(5, 6, 3)
        AllPLRRoot.Transparency = 0.8
        AllPLRRoot.Color = Color3.fromRGB(255, 255, 255)

        local Highlighthumroot = Instance.new("Highlight", AllPLRRoot)
        Highlighthumroot.Adornee = player.Character or Highlighthumroot.Parent
        Highlighthumroot.Enabled = true
        Highlighthumroot.FillColor = Color3.fromRGB(255, 255, 255)
        Highlighthumroot.FillTransparency = 0.99
    end
end
local ESP = RenderTab:ToggleButton({
    name = "ESP",
    info = "See players anytime anywhere",
    callback = function(enabled)
        if enabled then
            for _, player in ipairs(game.Players:GetPlayers()) do
                BoxESP(player)
            end
        else
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    player.Character.HumanoidRootPart.Transparency = 1
                    player.Character.HumanoidRootPart.Color = Color3.new(163, 162, 165)
                    local HighlightHumRoot = player.Character.HumanoidRootPart:FindFirstChildOfClass("Highlight")
                    if HighlightHumRoot then
                        HighlightHumRoot:Destroy()
                    end
                end
            end
        end
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
--GamePlay
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
local AutoJump = false
local ChoosedMode = "Hypixel"
local function AutoJumpSettings()
    while AutoJump do
        localPlayer.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
        wait(0.93)
    end
end
local Speed = PlayerTab:ToggleButton({
    name = "Speed",
    info = "Make your speed peed",
    callback = function(enabled)
        if enabled then
            if ChoosedMode == "Hypixel" then
                Camera.FieldOfView = 120
                AutoJump = true
                AutoJumpSettings()
                localPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 22.55
            elseif ChoosedMode == "Vanilla" then
                Camera.FieldOfView = 105
                localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 23
            end
        else
            localPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 16
            AutoJump = false
            localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
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
local DropdownFix = Speed:ToggleButtonInsideUI({
    name = "??",
    callback = function(enabled)
    end
})
local SpeedModes = Speed:Dropdown({
    name = "SpeedMode",
    default = "Vanilla",
    list = {"LibreCraft", "Hypixel", "Vanilla"},
    callback = function(selected)
        ChoosedMode = selected
    end
})
--FlyJump
local FlyJump = PlayerTab:ToggleButton({
    name = "FlyJump",
    info = "FlyJump?",
    callback = function(enabled)
        if enabled then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end)
        end
    end
})
