local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Character = localPlayer.Character

local function findNearestPlayer()
    local nearestPlayer
    local minDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).magnitude
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
    if nearestPlayer and distance <= 20 and not localPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
        local direction = (nearestPlayer.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).unit
        local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
        local newCFrame = CFrame.new(Character.HumanoidRootPart.Position, Character.HumanoidRootPart.Position + lookVector)
        Character:SetPrimaryPartCFrame(newCFrame)
    end
end

while true do
    rotateCharacterToNearestPlayer()
    wait(0.1)
end
