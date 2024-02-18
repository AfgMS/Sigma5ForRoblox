local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/SigmaJello4Roblox/main/SigmaLibrary.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
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
--CreatingUI
Library:createScreenGui()
task.wait()
LibraryCheck()
createnotification("Sigma5", "Loaded Successfully", 1, true)
--Tabs
local GuiTab = Library:createTabs(CoreGui.Sigma, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma, "Combat")
local RenderTab = Library:createTabs(CoreGui.Sigma, "Render")
local PlayerTab = Library:createTabs(CoreGui.Sigma, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma, "World")
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
    info = "AimAssist?",
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
local KnockbackTS = debug.getupvalue(require(ReplicatedStorage.TS.damage.knockback-util.KnockbackUtil.calculateKnockbackVelocity, 1)
local OriginalHValue = KnockbackTS.kbDirectionStrength
local OriginalYValue = KnockbackTS.kbUpwardStrength

local AntiKnockback = CombatTab:ToggleButton({
    name = "AntiKnockback",
    info = "Prevent Knockback",
    callback = function(enabled)
        if enabled then
            KnockbackTS.kbDirectionStrength = 0
            KnockbackTS.kbUpwardStrength = 0
        else
            KnockbackTS.kbDirectionStrength = OriginalHValue
            KnockbackTS.kbUpwardStrength = OriginalYValue
        end
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
    info = "RageQuit when your low",
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
    info = "Attack nearest plr",
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
--Criticals
local Criticals = CombatTab:ToggleButton({
    name = "Criticals",
    info = "Gay Effect",
    callback = function(enabled)
        if enabled then
            local NearestPlayer = GetNearestPlr(20)
            local CritEffect = Instance.new("Sparkles")
            CritEffect.SparkleColor = Color3.fromRGB(170, 0, 0)
            if KillAuraCriticalEffect and NearestPlayer then
                CritEffect.Parent = NearestPlayer.Character:FindFirstChild("HumanoidRootPart") or NearestPlayer.Character
            elseif not KillAuraCriticalEffect or not NearestPlayer then
                CritEffect.Parent = game.Workspace
            end
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
