local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/SigmaJello4Roblox/main/SigmaLibrary.lua", true))()
CreateNotification("Sigma5", "Please Choose!", 3, true)

if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
    local Sigma5Device = Instance.new("ScreenGui")
    Sigma5Device.Name = "Sigma5Device"
    Sigma5Device.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    Sigma5Device.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Panel = Instance.new("Frame")
    Panel.Name = "Panel"
    Panel.Parent = Sigma5Device
    Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Panel.BackgroundTransparency = 1.000
    Panel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Panel.BorderSizePixel = 0
    Panel.Size = UDim2.new(1, 0, 1, 0)
    
    local Question = Instance.new("TextLabel")
    Question.Name = "Question"
    Question.Parent = Panel
    Question.AnchorPoint = Vector2.new(0.5, 0.5)
    Question.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Question.BackgroundTransparency = 1.000
    Question.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Question.BorderSizePixel = 0
    Question.Position = UDim2.new(0.5, 0, 0.400000006, 0)
    Question.Size = UDim2.new(0, 200, 0, 50)
    Question.Font = Enum.Font.SourceSans
    Question.Text = "Choose Your Device!"
    Question.TextColor3 = Color3.fromRGB(255, 255, 255)
    Question.TextScaled = true
    Question.TextSize = 14.000
    Question.TextWrapped = true
    
    local Answer = Instance.new("Frame")
    Answer.Name = "Answer"
    Answer.Parent = Panel
    Answer.AnchorPoint = Vector2.new(0.5, 0.5)
    Answer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Answer.BackgroundTransparency = 1.000
    Answer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Answer.BorderSizePixel = 0
    Answer.Position = UDim2.new(0.5, 0, 0.5, 0)
    Answer.Size = UDim2.new(0, 155, 0, 75)
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Answer
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    local Mobile = Instance.new("ImageButton")
    Mobile.Name = "Mobile"
    Mobile.Parent = Answer
    Mobile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Mobile.BackgroundTransparency = 0.850
    Mobile.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Mobile.BorderSizePixel = 0
    Mobile.Size = UDim2.new(0, 75, 1, 0)
    Mobile.Image = "http://www.roblox.com/asset/?id=11838014063"
    Mobile.MouseButton1Click:Connect(function()
        -- For Mobile
        Sigma5Device:Destroy()
    end)
    
    local Emulator = Instance.new("ImageButton")
    Emulator.Name = "Emulator"
    Emulator.Parent = Answer
    Emulator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Emulator.BackgroundTransparency = 0.850
    Emulator.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Emulator.BorderSizePixel = 0
    Emulator.Size = UDim2.new(0, 75, 1, 0)
    Emulator.Image = "http://www.roblox.com/asset/?id=11838013128"
    Emulator.MouseButton1Click:Connect(function()
        -- For Emulator/PC
        Sigma5Device:Destroy()
    end)
end
