local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Font = game:GetService("TextService")

local Library = {}
local soundObjects = {}
Library.totalWidth = 15

local function makeDraggable(frame, dragSpeedFactor)
    dragSpeedFactor = dragSpeedFactor or 0.8

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = (input.Position - dragStart) * dragSpeedFactor
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:validate(defaults, options)
    for i, v in pairs(defaults) do
        if options[i] == nil then
            options[i] = v
        end
    end
    return options
end

function Library:tween(object, properties)
    local tweenInfo = TweenInfo.new(properties.time or 0.10, properties.easingStyle or Enum.EasingStyle.Quad, properties.easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
end

local function calculateSliderValue(mouseX, sliderBack)
    local relativeX = math.clamp((mouseX - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
    return relativeX
end

local soundIds = {
    enabled = 3318713980,
    disabled = 3318714899
}

function playContinuousSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = game.Workspace
    sound:Play()

    soundObjects[sound] = true

    sound.Ended:Connect(function()
        soundObjects[sound] = nil
        sound:Destroy()
    end)
end

local ScreenGuitwo = Instance.new("ScreenGui")
ScreenGuitwo.Parent = game:WaitForChild("CoreGui")
ScreenGuitwo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGuitwo.Name = "SigmaVisualStuff"

function createnotification(title, text, delay2, toggled)
    local function createFrame()
        if ScreenGuitwo:FindFirstChild("Background") then
            ScreenGuitwo:FindFirstChild("Background"):Destroy()
        end

        local Background = Instance.new("Frame")
        Background.Name = "Background"
        Background.Parent = ScreenGuitwo
        Background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Background.BorderSizePixel = 0
        Background.BackgroundTransparency = 0.15
        Background.Position = UDim2.new(1, -85, 1, -85)
        Background.Size = UDim2.new(0, 215, 0, 55)

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = Background
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.BorderSizePixel = 0
        TextLabel.Position = UDim2.new(0, 55, 0, 25)
        TextLabel.Size = UDim2.new(0, 155, 0, 25)
        TextLabel.Font = Enum.Font.SourceSans
        TextLabel.Text = text
        TextLabel.TextColor3 = Color3.fromRGB(195, 195, 195)
        TextLabel.TextSize = 15.000
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        local TextLabel_2 = Instance.new("TextLabel")
        TextLabel_2.Parent = Background
        TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel_2.BackgroundTransparency = 1.000
        TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel_2.BorderSizePixel = 0
        TextLabel_2.Position = UDim2.new(0, 55, 0, 5)
        TextLabel_2.Size = UDim2.new(0, 155, 0, 25)
        TextLabel_2.Font = Enum.Font.SourceSans
        TextLabel_2.Text = title
        TextLabel_2.TextColor3 = Color3.fromRGB(195, 195, 195)
        TextLabel_2.TextSize = 20.000
        TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.AnchorPoint = Vector2.new(0, 1)
        ImageLabel.Parent = Background
        ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Position = UDim2.new(0, 10, 0, 45)
        ImageLabel.Size = UDim2.new(0, 35, 0, 35)
        ImageLabel.Image = "rbxassetid://7733964719"
        ImageLabel.ImageTransparency = 0.25

        local textSizeX = math.max(TextLabel.TextBounds.X, TextLabel_2.TextBounds.X) + 60
        Background.Size = UDim2.new(0, 215, 0, 55)

        if toggled then
            Background.Position = UDim2.new(1, -textSizeX - 10, 1, -70)
            Background:TweenPosition(UDim2.new(1, -220, 1, -85), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.5)
        end

        wait(delay2)

        if Background then
            Background:TweenPosition(UDim2.new(1, -85, 1, -85), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.5, false, function()
                Background:Destroy()
            end)
        end
    end

    local function checkGameLoaded()
        if game:IsLoaded() then
            createFrame()
        else
            game.Loaded:Wait()
            createFrame()
        end
    end

    checkGameLoaded()
end

local HolderArrayList = Instance.new("Frame")
HolderArrayList.Name = "ArrayListHolder"
HolderArrayList.Visible = false
HolderArrayList.BackgroundTransparency = 1
HolderArrayList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HolderArrayList.BorderColor3 = Color3.fromRGB(0, 0, 0)
HolderArrayList.Size = UDim2.new(0, 195, 0, 550)
HolderArrayList.Position = UDim2.new(1, -210, 0, 0)
HolderArrayList.Parent = ScreenGuitwo

local TheListThingy = Instance.new("UIListLayout")
TheListThingy.Padding = UDim.new(0, -15)
TheListThingy.SortOrder = Enum.SortOrder.LayoutOrder
TheListThingy.Parent = HolderArrayList

local function AddArrayList(name)
    local ModulesName = Instance.new("TextLabel")
    ModulesName.Name = name
    ModulesName.TextXAlignment = Enum.TextXAlignment.Right
    ModulesName.BackgroundTransparency = 1
    ModulesName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ModulesName.Font = Enum.Font.SourceSans
    ModulesName.TextSize = 18.5
    ModulesName.Text = name
    ModulesName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ModulesName.Size = UDim2.new(0, 195, 0, 30)
    ModulesName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    
    ModulesName.LayoutOrder = -#name
    
    ModulesName.Parent = HolderArrayList
end

local function RemoveArraylist(name)
    local children = ScreenGuitwo:GetChildren()
    for _, child in ipairs(children) do
        if child:IsA("Frame") and child.Name == "ArrayListHolder" then
            local label = child:FindFirstChild(name)
            if label and label:IsA("TextLabel") then
                label:Destroy()
                break
            end
        end
    end
end

function Library:createScreenGui()
    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "Sigma"
    return screenGui
end

function Library:createTabs(parentFrame, tabName)
    local TAB = {}
    TAB.Buttons = {}

    TAB.Tabs = Instance.new("Frame", parentFrame)
    TAB.Tabs.BorderSizePixel = 0
    TAB.Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TAB.Tabs.BackgroundTransparency = 0.15
    TAB.Tabs.Size = UDim2.new(0, 135, 0, 40)
    TAB.Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TAB.Tabs.ZIndex = 2
    TAB.Tabs.Position = UDim2.new(0.03152666240930557 + (Library.totalWidth * 0.5), 0, 0.020082522183656693, 0)
    TAB.Tabs.Name = "Tabs"

    TAB.TabsName = Instance.new("TextLabel", TAB.Tabs)
    TAB.TabsName.BorderSizePixel = 0
    TAB.TabsName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TAB.TabsName.TextXAlignment = Enum.TextXAlignment.Left
    TAB.TabsName.Font = Enum.Font.SourceSans
    TAB.TabsName.TextSize = 17
    TAB.TabsName.ZIndex = 2
    TAB.TabsName.TextColor3 = Color3.fromRGB(120, 120, 120)
    TAB.TabsName.Size = UDim2.new(0, -10, 0, 0)
    TAB.TabsName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TAB.TabsName.Text = tabName
    TAB.TabsName.Name = "TabsName"
    TAB.TabsName.BackgroundTransparency = 1
    TAB.TabsName.Position = UDim2.new(0, 20, 0, 20)

    TAB.ScrollingPart = Instance.new("Frame", TAB.Tabs)
    TAB.ScrollingPart.BorderSizePixel = 0
    TAB.ScrollingPart.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TAB.ScrollingPart.BackgroundTransparency = 1
    TAB.ScrollingPart.Size = UDim2.new(0, 135, 0, 550)
    TAB.ScrollingPart.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TAB.ScrollingPart.ZIndex = 2
    TAB.ScrollingPart.Position = UDim2.new(0, 0, 1, 0)
    TAB.ScrollingPart.Name = "ScrollingPart"

    TAB.ScrollingModules = Instance.new("ScrollingFrame", TAB.ScrollingPart)
    TAB.ScrollingModules.Active = true
    TAB.ScrollingModules.BorderSizePixel = 0
    TAB.ScrollingModules.ZIndex = 3
    TAB.ScrollingModules.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TAB.ScrollingModules.Size = UDim2.new(0, 135, 0, 155)
    TAB.ScrollingModules.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    TAB.ScrollingModules.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TAB.ScrollingModules.ScrollBarThickness = 3.5
    TAB.ScrollingModules.Name = "ScrollingModules"

    local UIListLayout = Instance.new("UIListLayout", TAB.ScrollingModules)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.V then
            TAB.Tabs.Visible = not isVisible
            isVisible = not isVisible
        end
    end
end)

    if Library.totalWidth < 10 * TAB.Tabs.Size.X.Offset then
        local newX = UDim2.new(0, Library.totalWidth * 1.03, 0, 0)
        Library.totalWidth = Library.totalWidth + TAB.Tabs.Size.X.Offset

        TAB.Tabs.Position = newX

        makeDraggable(TAB.Tabs)
    else
        warn("Reached the maximum number of tabs. Cannot create more tabs.")
        createnotification("Sigma", "You can't add more tabs", 5, true)
    end

function TAB:ToggleButton(options)
    options = Library:validate({
        name = "Error404",
        info = "Error404",
    }, options or {})

    local ToggleButton = {
        Enabled = false
    }

    local newButton = Instance.new("TextButton", TAB.ScrollingModules)
    newButton.BorderSizePixel = 0
    newButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    newButton.AutoButtonColor = false
    newButton.TextXAlignment = Enum.TextXAlignment.Left
    newButton.Font = Enum.Font.SourceSans
    newButton.TextSize = 15
    newButton.TextColor3 = Color3.fromRGB(35, 35, 35)
    newButton.Size = UDim2.new(0, 135, 0, 35)
    newButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    newButton.Text = "   " .. options.name
    newButton.ZIndex = 3
    newButton.Name = options.name
    newButton.Position = UDim2.new(0, 3, 0, 0)

    ToggleButton["Button"] = newButton

    -- RightClickStuff
    local ButtonsMenuFrame = Instance.new("Frame", CoreGui.Sigma)
    ButtonsMenuFrame.BorderSizePixel = 0
    ButtonsMenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonsMenuFrame.Size = UDim2.new(0, 295, 0, 145)
    ButtonsMenuFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    ButtonsMenuFrame.Name = options.name
    ButtonsMenuFrame.Visible = false

    local ButtonsMenuFrameCorner = Instance.new("UICorner", ButtonsMenuFrame)
    ButtonsMenuFrameCorner.CornerRadius = UDim.new(0, 5)

    local ButtonsMenuInner = Instance.new("ScrollingFrame", ButtonsMenuFrame)
    ButtonsMenuInner.Active = true
    ButtonsMenuInner.BorderSizePixel = 0
    ButtonsMenuInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonsMenuInner.Size = UDim2.new(0, 290, 0, 140)
    ButtonsMenuInner.Position = UDim2.new(0, 3, 0, 2)
    ButtonsMenuInner.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ButtonsMenuInner.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonsMenuInner.ScrollBarThickness = 3
    ButtonsMenuInner.Visible = false
    ButtonsMenuInner.Name = "SettingsScroll"

    local ButtonsMenuInnerCorner = Instance.new("UICorner", ButtonsMenuInner)
    ButtonsMenuInnerCorner.CornerRadius = UDim.new(0, 5)

    local UIListLayout = Instance.new("UIListLayout", ButtonsMenuInner)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ButtonsMenuTitle = Instance.new("TextLabel", ButtonsMenuInner)
    ButtonsMenuTitle.BorderSizePixel = 0
    ButtonsMenuTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonsMenuTitle.TextXAlignment = Enum.TextXAlignment.Left
    ButtonsMenuTitle.Font = Enum.Font.SourceSans
    ButtonsMenuTitle.TextSize = 13
    ButtonsMenuTitle.Visible = true
    ButtonsMenuTitle.TextColor3 = Color3.fromRGB(75, 75, 75)
    ButtonsMenuTitle.Size = UDim2.new(0, 75, 0, 15)
    ButtonsMenuTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonsMenuTitle.Text = "" .. options.info
    ButtonsMenuTitle.Name = options.name
    ButtonsMenuTitle.BackgroundTransparency = 1
    ButtonsMenuTitle.Position = UDim2.new(0, 5, 0, 5)

    local ButtonsMenuTitleCorner = Instance.new("UICorner", ButtonsMenuTitle)
    ButtonsMenuTitleCorner.CornerRadius = UDim.new(0, 5)

    local ButtonsMenuTitleText = Instance.new("TextLabel", ButtonsMenuFrame)
    ButtonsMenuTitleText.BorderSizePixel = 0
    ButtonsMenuTitleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonsMenuTitleText.Font = Enum.Font.SourceSans
    ButtonsMenuTitleText.TextSize = 30
    ButtonsMenuTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonsMenuTitleText.Size = UDim2.new(0, 65, 0, 10)
    ButtonsMenuTitleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonsMenuTitleText.Text = options.name
    ButtonsMenuTitleText.Name = options.name
    ButtonsMenuTitleText.BackgroundTransparency = 1
    ButtonsMenuTitleText.Position = UDim2.new(0, 0, 0, -20)
    ButtonsMenuTitleText.TextXAlignment = Enum.TextXAlignment.Left

    ToggleButton.MenuFrame = ButtonsMenuFrame

    local function updateColors()
        if ToggleButton.Enabled then
            Library:tween(newButton, {BackgroundColor3 = Color3.fromRGB(115, 185, 255)})
            Library:tween(newButton, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            AddArrayList(options.name)
            playContinuousSound(soundIds.enabled)
        else
            Library:tween(newButton, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            Library:tween(newButton, {TextColor3 = Color3.fromRGB(35, 35, 35)})
            RemoveArraylist(options.name)
            playContinuousSound(soundIds.disabled)
        end
    end

    newButton.MouseButton1Click:Connect(function()
        ToggleButton.Enabled = not ToggleButton.Enabled
        updateColors()

        if options.callback then
            options.callback(ToggleButton.Enabled)
        end
    end)

    ToggleButton.Button.MouseButton2Click:Connect(function()
        ButtonsMenuFrame.Visible = not ButtonsMenuFrame.Visible
        ButtonsMenuInner.Visible = not ButtonsMenuInner.Visible
    end)

    updateColors()

function ToggleButton:Slider(options)
    options = Library:validate({
        title = "Error404",
        min = 0,
        max = 100,
        default = 50,
        callback = function(value) print(value) end
    }, options or {})

    local Slider = {}

    local SlidersHolder = Instance.new("Frame", ButtonsMenuInner)
    SlidersHolder.Name = "Slider"
    SlidersHolder.Size = UDim2.new(1, 0, 0, 30)
    SlidersHolder.Position = UDim2.new(0, 0, 0, 0)
    SlidersHolder.BorderSizePixel = 0
    SlidersHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SlidersHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)

    local SliderValueLabel = Instance.new("TextLabel", SlidersHolder)
    SliderValueLabel.Name = "Value"
    SliderValueLabel.Size = UDim2.new(0, 15, 0, 15)
    SliderValueLabel.Position = UDim2.new(0, 5, 0, 13)
    SliderValueLabel.Text = tostring(options.default)
    SliderValueLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    SliderValueLabel.TextSize = 13
    SliderValueLabel.Font = Enum.Font.SourceSans
    SliderValueLabel.BackgroundTransparency = 1
    SliderValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local SliderBack = Instance.new("Frame", SlidersHolder)
    SliderBack.Name = "SliderBack"
    SliderBack.Size = UDim2.new(0, 90, 0, 4)
    SliderBack.Position = UDim2.new(0, 25, 0, 20)
    SliderBack.BorderSizePixel = 0
    SliderBack.BackgroundColor3 = Color3.fromRGB(205, 235, 255)
    SliderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)

    local SliderBackCorner = Instance.new("UICorner", SliderBack)
    SliderBackCorner.CornerRadius = UDim.new(0, 15)

    local SliderFill = Instance.new("Frame", SliderBack)
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new(options.default / options.max, 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BorderSizePixel = 0
    SliderFill.BackgroundColor3 = Color3.fromRGB(116, 184, 255)
    SliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)

    local SliderFillCorner = Instance.new("UICorner", SliderFill)
    SliderFillCorner.CornerRadius = UDim.new(0, 15)

    local UISliderButton = Instance.new("TextButton", SliderFill)
    UISliderButton.Name = "UISliderButton"
    UISliderButton.Size = UDim2.new(0, 13, 0, 13)
    UISliderButton.AnchorPoint = Vector2.new(1, 0.5)
    UISliderButton.Position = UDim2.new(1, 0, 0.5, 0)
    UISliderButton.Text = ""
    UISliderButton.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    UISliderButton.BorderSizePixel = 0
    UISliderButton.AutoButtonColor = false
    UISliderButton.ZIndex = 1
    UISliderButton.ClipsDescendants = true

    local UICorner = Instance.new("UICorner", UISliderButton)
    UICorner.CornerRadius = UDim.new(1, 0)

    local dragging = false

    UISliderButton.MouseButton1Down:Connect(function()
        dragging = true
        dragStart = UserInputService:GetMouseLocation().X
        startPos = UISliderButton.AbsolutePosition.X
    end)

    UISliderButton.MouseButton1Up:Connect(function()
        if dragging then
            dragging = false
        end
    end)

    UISliderButton.MouseEnter:Connect(function()
        if not dragging then
            UISliderButton.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        end
    end)

    UISliderButton.MouseLeave:Connect(function()
        if not dragging then
            UISliderButton.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newX = calculateSliderValue(UserInputService:GetMouseLocation().X, SliderBack)
            local newValue = options.min + newX * (options.max - options.min)
            SliderValueLabel.Text = tostring(math.floor(newValue))

            local maxDelta = (UISliderButton.Size.X.Offset / SliderBack.AbsoluteSize.X)
            local delta = math.clamp(newX, 0, 1 - maxDelta)
            SliderFill.Size = UDim2.new(delta, 0, 1, 0)
            UISliderButton.Position = UDim2.new(delta + maxDelta, 0, 0.5, 0)

            if options.callback then
                options.callback(newValue)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    Slider.SliderHolder = SlidersHolder

function ToggleButton:ToggleButtonInsideUI(options)
    options = Library:validate({
        name = "Error404",
        callback = function(enabled) end
    }, options or {})
    
    local ToggleButtonInsideUI = {
        Enabled = false
    }

    local newTugel = Instance.new("TextButton", ButtonsMenuInner)
    newTugel.BorderSizePixel = 0
    newTugel.Text = " "
    newTugel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    newTugel.BackgroundTransparency = 1
    newTugel.Size = UDim2.new(0, 145, 0, 30)
	newTugel.ZIndex = 5
    newTugel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    newTugel.Position = UDim2.new(0, 0, 0.10571428388357162, 0)
    newTugel.Name = "ToggleInsideUI"

    local newTugelName = Instance.new("TextLabel", newTugel)
    newTugelName.BorderSizePixel = 0
    newTugelName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    newTugelName.TextXAlignment = Enum.TextXAlignment.Left
    newTugelName.Font = Enum.Font.SourceSans
    newTugelName.TextSize = 15
    newTugelName.TextColor3 = Color3.fromRGB(25, 25, 25)
    newTugelName.Size = UDim2.new(0, 80, 0, 15)
    newTugelName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    newTugelName.Text = options.name
    newTugelName.BackgroundTransparency = 1
	newTugelName.ZIndex = 5
    newTugelName.Position = UDim2.new(0.04827586188912392, 0, 0.2571428716182709, 0)

    local newTugelThingy = Instance.new("Frame", newTugel)
    newTugelThingy.BorderSizePixel = 0
    newTugelThingy.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    newTugelThingy.Size = UDim2.new(0, 14, 0, 14)
    newTugelThingy.BorderColor3 = Color3.fromRGB(0, 0, 0)
    newTugelThingy.Position = UDim2.new(0, 105, 0, 10)
    newTugelThingy.Name = "CheckmarkHolder"
	newTugelThingy.ZIndex = 5

    local newTugelThingyCorner = Instance.new("UICorner", newTugelThingy)

    local function UpdateCheckMark()
        if ToggleButtonInsideUI.Enabled then
            Library:tween(newTugelThingy, {BackgroundColor3 = Color3.fromRGB(115, 185, 255)})
        else
            Library:tween(newTugelThingy, {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
        end
    end

    newTugel.MouseButton1Down:Connect(function()
        ToggleButtonInsideUI.Enabled = not ToggleButtonInsideUI.Enabled
        UpdateCheckMark()

        if options.callback then
            options.callback(ToggleButtonInsideUI.Enabled)
        end
    end)

    UpdateCheckMark()

function ToggleButton:Dropdown(options)
    options = Library:validate({
        name = "Error404",
        todo = "MovementType",
        callback = function(selectedItem) end
    }, options or {})

    local Dropdown = {
        Enabled = false,
        List = options.list or {},
        Selected = options.Default or "",
    }
    
    local DropdownActualHolder = Instance.new("Frame", ButtonsMenuInner)
    DropdownActualHolder.Name = "HolderReal"
    DropdownActualHolder.Size = UDim2.new(0, 15, 0, 15)
    DropdownActualHolder.BackgroundTransparency = 1 

    local DropdownInfo = Instance.new("TextLabel", DropdownActualHolder)
    DropdownInfo.Name = options.todo
    DropdownInfo.Size = UDim2.new(0, 15, 0, 15)
    DropdownInfo.Position = UDim2.new(0, 8, 0, 0)
    DropdownInfo.Text = options.todo
    DropdownInfo.TextColor3 = Color3.fromRGB(0, 0, 0)
    DropdownInfo.TextSize = 15
    DropdownInfo.Font = Enum.Font.SourceSans
    DropdownInfo.BackgroundTransparency = 1
    DropdownInfo.TextXAlignment = Enum.TextXAlignment.Left
    DropdownInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local DropdownHolders = Instance.new("TextButton", DropdownInfo)
    DropdownHolders.BorderSizePixel = 0.85
    DropdownHolders.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownHolders.Size = UDim2.new(0, 70, 0, 15)
    DropdownHolders.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownHolders.Text = options.name
    DropdownHolders.AutoButtonColor = false
    DropdownHolders.Position = UDim2.new(0, 75, 0, 0)
    DropdownHolders.Name = "DropdownHolders"
    
    local DropdownMenu = Instance.new("Frame", DropdownHolders)
    DropdownMenu.BorderSizePixel = 0.85
    DropdownMenu.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
    DropdownMenu.Size = UDim2.new(0, 70, 0, 85)
    DropdownMenu.Visible = false
    DropdownMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownMenu.Position = UDim2.new(0, 1, 0, 0)
    DropdownMenu.Name = "DropdownMenu"
    
    local DropdownMenuListHolder = Instance.new("UIListLayout", DropdownMenu)
    DropdownMenuListHolder.SortOrder = Enum.SortOrder.LayoutOrder
    
    for _, item in ipairs(Dropdown.List) do
        local DropdownOption = Instance.new("TextButton", DropdownMenu)
        DropdownOption.BorderSizePixel = 0.85
        DropdownOption.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        DropdownOption.BackgroundTransparency = 1
        DropdownOption.Size = UDim2.new(0, 70, 0, 15)
        DropdownOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DropdownOption.Visible = true
        DropdownOption.Text = item
        DropdownOption.Name = item

        DropdownOption.MouseButton1Click:Connect(function()
            Dropdown.Selected = item
            DropdownHolders.Text = item
            DropdownMenu.Visible = false  -- Hide the menu after selecting an option
            options.callback(item)
        end)
    end

    DropdownHolders.MouseButton1Click:Connect(function() 
        DropdownMenu.Visible = not DropdownMenu.Visible
    end)

return Dropdown
end

return ToggleButtonInsideUI
end

return Slider
end

return ToggleButton
end

return TAB
end

Library:createScreenGui()






















--Sigma
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

createnotification("Sigma", "Welcome to Sigma, Press V", 1, true)

local tab1 = Library:createTabs(CoreGui.Sigma, "Combat")
--
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

local Killaura = tab1:ToggleButton({
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

local Dropdown = Killaura:Dropdown({
    name = "E",
    todo = "E",
    list = {"E", "E", "E"},
    Default = "E",
    callback = function(selectedItem)
        print("Rotation mode set to:", selectedItem)
    end
})

--Uninject 
local button99 = tab1:ToggleButton({
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
