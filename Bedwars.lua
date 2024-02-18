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
local AntiKnockback = CombatTab:ToggleButton({
    name = "AntiKnockback",
    info = "Prevent you from taking knockback",
    callback = function(enabled)
        createnotification("Sigma5", "This feature is for premium", 1, true)
    end
})
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
--BowAimbot Coming Soon
--KillAura
local KillAuraRange
local RotationsRange
local KillAuraCriticalEffect
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
    if player ~= game.Players.LocalPlayer and player.Character then
        local AllPLRRoot = player.Character:FindFirstChild("HumanoidRootPart")
        AllPLRRoot.Size = Vector3.new(5, 6, 3)
        AllPLRRoot.Transparency = 0.8
        AllPLRRoot.Color = Color3.fromRGB(255, 255, 255)

        local Highlighthumroot = Instance.new("Highlight", AllPLRRoot)
        Highlighthumroot.Adornee = Highlighthumroot.Parent
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
--Fov
local CustomFovValue = 70
local Fov = RenderTab:ToggleButton({
    name = "Fov",
    info = "Makes your camera zoom",
    callback = function(enabled)
        if enabled then
            Camera.FieldOfView = CustomFovValue
        else
            Camera.FieldOfView = 70
        end
    end
})
local CustomFov = Fov:Slider({
    title = "Value",
    min = 0,
    max = 100,
    default = 70,
    callback = function(val)
        CustomFovValue = val
        if Fov:GetState() then
            Camera.FieldOfView = CustomFovValue
        end
    end
})
--GamePlay
local AutoQueue
local AutoGG
local AutoL

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

    if RandomChances == 0 then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("I don't hack I just SIGMA", "All")
    end

    if RandomChances ~= 0 then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Sigma will help you Oops, I killed you instead.", "All")
    end

    if RandomChances == 2 then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("vxpe and godsploit is better than this", "All")
    end

    if RandomChances == 3 then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("I just have a good gaming chair", "All")
    end

    if RandomChances == 4 then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Use sigma to kick some ### while listening to music", "All")
    end

    if RandomChances == 5 then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Simga Klien 1945 bye pass 🙀", "All")
    end
end

local GamePlay = PlayerTab:ToggleButton({
    name = "GamePlay",
    info = "Makes your experience better",
    callback = function(enabled)
        if enabled then
            if AutoQueue then
                if CheckTeams() then
                    ReplicatedStorage:WaitForChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue:FireServer({["queueType"] = "bedwars_to1"})
                end
            end

            if AutoGG then
                if CheckTeams() then
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GG", "All")
                end
            end

            if AutoL then
                SigmemeAutoL()
            end
        end
    end
})
--Speed
local Heatseeker = false
local function HeatSeekerSAFE()
    while Heatseeker do
        local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 38
            wait(0.3)
            humanoid.WalkSpeed = 0
            wait(0.28)
            humanoid.WalkSpeed = 22.3
        end
    end
end
local Speed = PlayerTab:ToggleButton({
    name = "Speed",
    info = "Make your speed peed",
    callback = function(enabled)
        if enabled then
            Heatseeker = true
            HeatSeekerSAFE()
        else
            Heatseeker = false
        end
    end
})
--FlyJump
local FlyJump = PlayerTab:ToggleButton({
    name = "FlyJump",
    info = "FlyJump?",
    callback = function(enabled)
        if enabled then
            game:GetService("Players").LocalPlayer:GetPropertyChangedSignal("Jump"):Connect(function()
                local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})
