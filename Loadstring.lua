local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer

--Remote
local KARemote = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.SwordHit

--Stuff
local SwordInfo = {
    [1] = { Name = "wood_sword", Display = "Wood Sword", Rank = 1 },
    [2] = { Name = "stone_sword", Display = "Stone Sword", Rank = 2 },
    [3] = { Name = "iron_sword", Display = "Iron Sword", Rank = 3 },
    [4] = { Name = "diamond_sword", Display = "Diamond Sword", Rank = 4 },
    [5] = { Name = "emerald_sword", Display = "Emerald Sword", Rank = 5 },
    [6] = { Name = "rageblade", Display = "Rage Blade", Rank = 6 },
}

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

local function isAlive(localPlayer)
    if not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild("Head") or not localPlayer.Character:FindFirstChild("Humanoid") then
        warn("Bruh")
        return false
    end

    return true
end

local function findNearestLivingPlayer()
    local nearestPlayer
    local nearestDistance = math.huge

    while wait(0.23) do
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and isAlive(player) then
                local character = player.Character
                if character and character:IsA("Model") and character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = character.HumanoidRootPart
                    if humanoidRootPart:IsA("BasePart") then
                        local distance = (humanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < nearestDistance then
                            nearestPlayer = player
                            nearestDistance = distance
                        end
                    end
                end
            end
        end
    end

    return nearestPlayer
end

local function attackValue(vec)
  return { value = vec }
end

local function getcloserpos(pos1, pos2, amount)
  local newPos = (pos2 - pos1).Unit * math.min(amount, (pos2 - pos1).Magnitude) + pos1
  return newPos
end

local function getBestSword()
  local bestsword = nil
  local bestrank = 0
  for i, v in pairs(localPlayer.Character.InventoryFolder.Value:GetChildren()) do
    if v.Name:match("sword") or v.Name:match("blade") then
      for _, data in pairs(SwordInfo) do
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

local target = findNearestLivingPlayer(20)
local cam = game.Workspace.CurrentCamera
local mouse = Ray.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position).Unit.Direction
local AttackDelay = 0.03

local function KillAuraAttack()
  KARemote:FireServer({
    ["entityInstance"] = target.Character,
    ["chargedAttack"] = {
      ["chargeRatio"] = 1
    },
    ["validate"] = {
      ["raycast"] = {
        ["cursorDirection"] = attackValue(mouse),
        ["cameraPosition"] = attackValue(target.Character.HumanoidRootPart.Position),
      },
      ["selfPosition"] = attackValue(getcloserpos(localPlayer.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position, 2)),
      ["targetPosition"] = attackValue(target.Character.HumanoidRootPart.Position),
    },
    ["weapon"] = getBestSword()
  })
end

local function KALoop()
    local target = findNearestLivingPlayer(20)
    if target and target.Character then
        while wait(AttackDelay) do
            KillAuraAttack()
        end
    end
end

--SigmaUI
Library:createScreenGui()
LibraryCheck()
createnotification("Sigma", "Welcome to Sigma, Press V", 1, true)

local tab1 = Library:createTabs(CoreGui.Sigma, "Gui")
local tab2 = Library:createTabs(CoreGui.Sigma, "Combat")

--ActiveMods
local ActiveMods = tab1:ToggleButton({
    name = "ActiveMods",
    info = "Arraylist goes brrr",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = not CoreGui.SigmaVisualStuff.ArrayListHolder.Visible
    end
})
local sliderStuff = ActiveMods:Slider({
    title = "Dugong",
    min = 5,
    max = 10,
    default = 5,
    callback = function(value)
        print("current value rn is" .. value)
    end
})
local toggleInsideUI1 = ActiveMods:ToggleButtonInsideUI({
    name = "MyFirne",
    callback = function(enabled)
        if enabled then
            print("hello")
        end
    end
})
local dropdown = ActiveMods:Dropdown({
    name = "Testing",
    default = "Test",
    list = {"Walk", "Run", "Sprint"},
    callback = function(selectedItem)
        print("Movement type set to:", selectedItem)
    end
})

--Uninject
local Uninject = tab1:ToggleButton({
    name = "UninjectTest",
    info = "Fuck Sigma",
    callback = function(enabled)
        if enabled then
            CoreGui.Sigma:Destroy()
            print("Destroyed Main")
            CoreGui.SigmaVisualStuff:Destroy()
            print("Destroyed Notif")
        end
    end
})

--KillAura
local KillAura = tab2:ToggleButton({
    name = "KillAura",
    info = "KillAura Testing",
    callback = function(enabled)
        if enabled then
            AttackDelay = 0.03
            if localPlayer.Character and isAlive(localPlayer) then
                spawn(KALoop)
            else
                AttackDelay = 86400
            end
        end
    end
})
