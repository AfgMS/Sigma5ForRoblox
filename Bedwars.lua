local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
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
            -- Check team membership if TeamCheck is enabled
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

local function Value2Vector(Vec)
    return { value = Vec }
end

local function SetAttackPosition(MyselfCharacter, TargetCharacter, magnitude)
    if magnitude > 21 then
        return Vector3.new(0, 0, 0)
    else
        local lookVector = CFrame.new(MyselfCharacter.HumanoidRootPart.Position, TargetCharacter.HumanoidRootPart.Position).lookVector * 4
        return MyselfCharacter.HumanoidRootPart.Position + lookVector
    end
end

local function GetInventory(localPlayer)
    if not localPlayer then return {} end

    local Success, Return = pcall(function()
        return require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil.getInventory(localPlayer)
    end)

    if not Success then return { Items = {}, Armor = {} } end
    
    local InventoryFolder = localPlayer.Character and localPlayer.Character:FindFirstChild("InventoryFolder") and localPlayer.Character.InventoryFolder.Value
    if not InventoryFolder then return Return end

    for _, item in pairs(Return) do
        if type(item) == 'table' and item.itemType then
            item.instance = InventoryFolder:FindFirstChild(item.itemType)
        end
    end

    return Return
end

local function GetBestSword()
    local bestSword
    local maxDamage = 0

    for _, item in pairs(GetInventory(localPlayer)) do
        if item.itemType:lower():find('sword') or item.itemType:lower():find('scythe') or item.itemType:lower():find('blade') or item.itemType:lower():find('dagger') or item.itemType:lower():find('hammer') then
            local swordDamage = Modules.ItemTable[item.itemType].sword.damage
            if swordDamage > maxDamage then
                maxDamage = swordDamage
                bestSword = item.tool
            end
        end
    end

    return bestSword
end
--CreatingUI
Library:createScreenGui()
task.wait()
LibraryCheck()
--Tabs
local GuiTab = Library:createTabs(CoreGui.Sigma, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma, "Combat")
local PlayerTab = Library:createTabs(CoreGui.Sigma, "Player")
local RenderTab = Library:createTabs(CoreGui.Sigma, "Render")
local WorldTab = Library:createTabs(CoreGui.Sigma, "World")
--Sigma5Bedwars
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
    info = "Aim Assist?",
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
local KnockbackTS = debug.getupvalue(require(ReplicatedStorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local OriginalHValue = KnockbackTS.kbDirectionStrength
local OriginalYValue = KnockbackTS.kbUpwardStrength
local AntiKnockback = CombatTab:ToggleButton({
    name = "AntiKnockback",
    info = "Sexwars KnockbackTable sexy",
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
--AutoRageQuit
local LowHealthValue = 0.11
local AutoRageQuit = CombatTab:ToggleButton({
    name = "AutoRageQuit",
    info = "Leave the game when you are low",
    callback = function(enabled)
        if enabled then
            if localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character.Humanoid.Health < LowHealthValue then
                localPlayer:Kick("AutoRageQuitTriggered")
            end
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
--Criticals Coming Soon
--InteractRange Coming Soon
--KillAura
local KillAuraRange
local RotationsRange
local AutoBlockValue = false
local KillAura = CombatTab:ToggleButton({
    name = "KillAura",
    info = "Attack Nearest Entity",
    callback = function(enabled)
        if enabled then
            KillAuraRange = 20
            while enabled do
                local NearestPlayer = GetNearestPlr(KillAuraRange)
                if NearestPlayer then
                    local Magnitude = (localPlayer.Character.HumanoidRootPart.Position - NearestPlayer.Character.HumanoidRootPart.Position).Magnitude
                    local targetPosition = Value2Vector(NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position)
                    local selfPosition = Value2Vector(SetAttackPosition(localPlayer.Character, NearestPlayer.Character, Magnitude + ((localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude > 14 and (CFrame.lookAt(localPlayer.Character:FindFirstChild("HumanoidRootPart").Position, NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0))))
                    local GetSword = GetBestSword()
                    local KillAuraRequirement = {
                        {
                            entityInstance = NearestPlayer.Character,
                            chargedAttack = {
                                chargeRatio = 0
                            },
                            validate = {
                                targetPosition = {
                                    value = targetPosition
                                },
                                selfPosition = {
                                    value = selfPosition
                                }
                            },
                            weapon = GetSword
                        }
                    }
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit:FireServer(unpack(KillAuraRequirement))
                end
                wait(0.01)
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
