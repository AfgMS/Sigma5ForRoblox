local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Range = 20

local function findNearestPlayer()
    local nearestPlayer
    local minDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < minDistance then
                nearestPlayer = player
                minDistance = distance
            end
        end
    end

    return nearestPlayer, minDistance
end

local function rotateCharacterToNearestPlayer()
    local nearestPlayer, distance = findNearestPlayer()
    if nearestPlayer and distance <= Range then
        local character = localPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local direction = (nearestPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).unit
            local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
            local newCFrame = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + lookVector)
            character:SetPrimaryPartCFrame(newCFrame)
        end
    end
end

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        character = nil
    end)
end

local function onCharacterChanged(property)
    if property == "Health" and localPlayer.Character then
        rotateCharacterToNearestPlayer()
    end
end

local function onCharacterChildAdded(child)
    if child:IsA("Humanoid") then
        child.Died:Connect(function()
            rotateCharacterToNearestPlayer()
        end)
    end
end

local function setupCharacter(character)
    onCharacterAdded(character)
    character.ChildAdded:Connect(onCharacterChildAdded)
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(setupCharacter)
end

Players.PlayerAdded:Connect(onPlayerAdded)
setupCharacter(localPlayer.Character)

game:GetService("RunService").Stepped:Connect(function()
    if localPlayer.Character then
        rotateCharacterToNearestPlayer()
    end
end)
