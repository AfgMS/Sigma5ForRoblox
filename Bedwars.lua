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
local function getNearestPlayer(range)
    local nearestPlayer
    local nearestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character.PrimaryPart then
            local playerPosition = player.Character.PrimaryPart.Position
            local distance = (playerPosition - game.Workspace.CurrentCamera.CFrame.Position).magnitude
            if distance < nearestDistance then
                nearestPlayer = player
                nearestDistance = distance
            end
        end
    end

    return nearestPlayer
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
--AntiKnockback
local KnockbackValue = 100
local AntiKnockback = COMBATtab:ToggleButton({
    name = "AntiKnockback",
    info = "Reduce Knockback?",
    callback = function(enabled)
        if enabled then
            if localPlayer and localPlayer.Character then
                debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, KnockbackValue)
            else
                debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 100)
            end
        end
    end
})
local KnockBackValue = AntiKnockback:Slider({
    title = "Value",
    min = 1,
    max = 100,
    default = KnockbackValue,
    callback = function(value)
        KnockbackValue = value
    end
})
--KillAura
local Delay = 0.01
local Range = 20
local KillAura = COMBATtab:ToggleButton({
    name = "KillAura",
    info = "Attack Nearest Player?",
    callback = function(enabled)
        if enabled then
            local NearestTarget = getNearestPlayer(Range)
            if NearestTarget then
            while wait(Delay) do
                local args = {
                    [1] = {
                        ["entityInstance"] = NearestTarget,
                        ["chargedAttack"] = {
                            ["chargeRatio"] = 0
                        },
                        ["validate"] = {
                            ["targetPosition"] = {
                                ["value"] = NearestTarget.Character:WaitForChild("Humanoid").Position
                            },
                            ["selfPosition"] = {
                                ["value"] = localPlayer.Character:WaitForChild("Humanoid").Position
                            }
                        },
                        ["weapon"] = game:GetService("ReplicatedStorage").Inventories.NobolineUser08.wood_sword
                    }
                }

                game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit:FireServer(unpack(args))
            end
        end
    end
})
local KillAuraRange = KillAura:Slider({
    title = "Range",
    min = 0,
    max = 20,
    default = Range,
    callback = function(value)
        Range = value
    end
})
local KillAuraDelay = KillAura:Slider({
    title = "Delay",
    min = 0.01,
    max = 0.5,
    default = Delay,
    callback = function(value)
        Delay = value
    end
})
