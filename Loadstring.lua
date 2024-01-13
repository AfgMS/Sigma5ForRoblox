local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")

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


Library:createScreenGui()
LibraryCheck()
createnotification("Sigma", "Welcome to Sigma, Press V", 1, true)

local tab1 = Library:createTabs(CoreGui.Sigma, "Gui")
local tab2 = Library:createTabs(CoreGui.Sigma, "Combat")

--ActiveMods
local toggleButton1 = tab1:ToggleButton({
    name = "ActiveMods",
    info = "Arraylist goes brrr",
    callback = function(enabled)
            CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = not CoreGui.SigmaVisualStuff.ArrayListHolder.Visible
    end
})

local sliderStuff = toggleButton1:Slider({
    title = "Dugong",
    min = 5,
    max = 10,
    default = 5,
    callback = function(value)
        print("current value rn is" .. value)
    end
})

local toggleInsideUI1 = toggleButton1:ToggleButtonInsideUI({
    name = "MyFirne",
    callback = function(enabled)
        if enabled then
            print("hello")
        end
    end
})

local dropdown = toggleButton1:Dropdown({
    name = "Testing",
    default = "Test",
    list = {"Walk", "Run", "Sprint"},
    callback = function(selectedItem)
        print("Movement type set to:", selectedItem)
    end
})

local tabGUIButton = tab1:ToggleButton({
    name = "TabGUI",
    info = "Wtf even is this lmao",
    callback = function(enabled)
        print("cum")
    end
})

--KillAura
local localPlayer = game.Players.LocalPlayer
local KillauraRemote = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.SwordHit

local function isalive(plr)
  plr = plr or localPlayer
  if not plr then
    print("Player is nil.")
    return false
  end
  
  if not plr.Character then -- credit to chatgpt am retarded
    print("Player has no character.")
    return false
  end
  
  local head = plr.Character:FindFirstChild("Head")
  local humanoid = plr.Character:FindFirstChild("Humanoid")
  
  if not head then
    print("Player's character has no head.")
    return false
  end
  
  if not humanoid then
    print("Player's character has no humanoid.")
    return false
  end
  
  return true
end

local SwordInfo = {
  [1] = { Name = "wood_sword", Display = "Wood Sword", Rank = 1 },
  [2] = { Name = "stone_sword", Display = "Stone Sword", Rank = 2 },
  [3] = { Name = "iron_sword", Display = "Iron Sword", Rank = 3 },
  [4] = { Name = "diamond_sword", Display = "Diamond Sword", Rank = 4 },
  [5] = { Name = "emerald_sword", Display = "Emerald Sword", Rank = 5 },
  [6] = { Name = "rageblade", Display = "Rage Blade", Rank = 6 },
}

local function findNearestLivingPlayer()
  local nearestPlayer
  local nearestDistance = math.huge

  for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= localPlayer and isalive(player) then
      local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
      if distance < nearestDistance then
        nearestPlayer = player
        nearestDistance = distance
      end
    end
  end

  return nearestPlayer
end

local function attackValue(vec)
  return { value = vec }
end

function getcloserpos(pos1, pos2, amount)
  local newPos = (pos2 - pos1).Unit * math.min(amount, (pos2 - pos1).Magnitude) + pos1
  return newPos
end

local target = findNearestLivingPlayer(20)
local anims = 0
local cam = game.Workspace.CurrentCamera
local mouse = Ray.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position).Unit.Direction

local function GetBestSword()
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

local function attack()
  KillauraRemote:FireServer({
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
    ["weapon"] = GetBestSword()
  })
end

local function isPlayerAlive(player)
    return player.Character and player.Character:FindFirstChild("Humanoid")
end

local button1 = tab1:ToggleButton({
    name = "KillAura",
    info = "Automatically Attack Nearest Player.",
    callback = function(enabled)
        local function attackLoop()
            while enabled and localPlayer.Character do
                local target = findNearestLivingPlayer(20)
                if target and target.Character then
                    attack()
                end
                task.wait(0.03)
            end
        end

        if enabled and localPlayer.Character then
            spawn(attackLoop)
        end
    end
})

local function onPlayerAdded(player) -- Chatgpt ty again fr, from here
    local function onCharacterAdded(character)
        Killaura:SetEnabled(true)
    end

    player.CharacterAdded:Connect(onCharacterAdded)

    player.Character:Wait()
    onCharacterAdded(player.Character)
end

Players.PlayerAdded:Connect(onPlayerAdded)

local function onPlayerDied(player)
    Killaura:SetEnabled(false)
end

Players.PlayerAdded:Connect(onPlayerDied) -- till here

local SliderStuff = Killaura:Slider({ --fix some gay bug
  title = "HolderFix",
  min = 0,
  max = 0,
  default = 0,
  callback = function(val)
end
})

local isRotating = false
local ToggleInsideUI1 = button1:ToggleButtonInsideUI({
    name = "MyFirne",
    callback = function(enabled)
        if enabled then
            local function rotateToNearestPlayer()
                isRotating = true
                while enabled and isRotating do
                    local nearestPlayer = findNearestLivingPlayer()
                    if nearestPlayer then
                        local direction = (nearestPlayer.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Unit
                        direction = Vector3.new(direction.X, 0, direction.Z)
                        local rotation = CFrame.new(Vector3.new(), direction)
                        local currentCFrame = localPlayer.Character.HumanoidRootPart.CFrame
                        local newCFrame = CFrame.new(currentCFrame.Position) * rotation
                        localPlayer.Character:SetPrimaryPartCFrame(newCFrame)
                    end
                    task.wait(0.1)
                end
                isRotating = false
            end

            spawn(rotateToNearestPlayer)
        else
            isRotating = false
        end
    end
})

local Dropdown = Killaura:Dropdown({
    name = "Default",
    todo = "RotationMode",
    list = {"Vanilla", "Smooth", "Autistic"},
    Default = "Vanilla",
    callback = function(selectedItem)
        print("Rotation mode set to:", selectedItem)
    end
})


local anticheatResetButton = tab1:ToggleButton({
    name = "AnticheatResetVL",
    info = "QuACK Quack",
    callback = function(enabled)
        print("cum")
    end
})

local uninjectButton = tab2:ToggleButton({
    name = "UninjectShit",
    info = "Click to uninject the Sigma hack.",
    callback = function(enabled)
        if enabled then
            CoreGui.Sigma:Destroy()
            print("Destroyed Main")
            CoreGui.SigmaVisualStuff:Destroy()
            print("Destroyed Notif")
        end
    end
})
