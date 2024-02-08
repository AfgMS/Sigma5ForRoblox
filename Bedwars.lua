local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer

--Remote
local KBRemote = ReplicatedStorage.TS.damage["knockback-util"]

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
local HorizontalKB = 100
local VerticalKB = 100
local AntiKnockback = COMBATtab:ToggleButton({
    name = "AntiKnockback",
    info = "Reduce Knockback?",
    callback = function(enabled)
        if enabled then
            KBRemote["kbDirectionStrength"] = HorizontalKB
            KBRemote["kbUpwardStrength"] = VerticalKB
        else
            KBRemote["kbDirectionStrength"] = 100
            KBRemote["kbUpwardStrength"] = 100
        end
    end
})
