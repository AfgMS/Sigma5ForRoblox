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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local KillauraRemote = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.SwordHit

local function isAlive(player)
    player = player or localPlayer

    if not player or not player.Character then
        print("Player is invalid or has no character.")
        return false
    end

    local humanoid = player.Character:FindFirstChild("Humanoid")

    if not humanoid or humanoid.Health <= 0 then
        print("Player is not alive.")
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
        if player ~= localPlayer and isAlive(player) then
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

local function getCloserPos(pos1, pos2, amount)
    return pos1 + (pos2 - pos1).Unit * math.min(amount, (pos2 - pos1).Magnitude)
end

local target = findNearestLivingPlayer(20)
local cam = game.Workspace.CurrentCamera
local mouse = Ray.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position).Unit.Direction

local function getBestSword()
    local bestsword = nil
    local bestrank = 0
    for i, v in pairs(localPlayer.Character.InventoryFolder:GetChildren()) do
        if v.Name:match("sword") or v.Name:match("blade") then
            for _, data in pairs(SwordInfo) do
                if data.Name == v.Name and bestrank <= data.Rank then
                    bestrank = data.Rank
                    bestsword = v
                end
            end
        end
    end
    return bestsword
end

local function attack()
    KillauraRemote:FireServer({
        entityInstance = target.Character,
        chargedAttack = {
            chargeRatio = 1
        },
        validate = {
            raycast = {
                cursorDirection = attackValue(mouse),
                cameraPosition = attackValue(target.Character.HumanoidRootPart.Position),
            },
            selfPosition = attackValue(getCloserPos(localPlayer.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position, 2)),
            targetPosition = attackValue(target.Character.HumanoidRootPart.Position),
        },
        weapon = getBestSword()
    })
end

local function isPlayerAlive(player)
    return player.Character and player.Character:FindFirstChild("Humanoid")
end

local KillAura = tab2:ToggleButton({
    name = "KillAura",
    info = "Attack Players",
    callback = function(enabled)
        while enabled and isAlive(localPlayer) and isPlayerAlive(localPlayer) do
            local target = findNearestLivingPlayer(20)
            if target and target.Character then
                attack()
            end
            task.wait(0.03)
        end
    end
})
local isRotating = false
local Rotation = KillAura:ToggleButtonInsideUI({
    name = "Rotation",
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

