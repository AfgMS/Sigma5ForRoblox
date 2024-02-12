--ImportantStuff
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Font = game:GetService("TextService")
local Mouse = game.Players.LocalPlayer:GetMouse()
local localplayer = game.Players.LocalPlayer
local TouchInput = game:GetService("TouchInputService")
local Lighting = game:GetService("Lighting")
local Library = {}
local soundObjects = {}
Library.totalWidth = 15

local function makeDraggable(frame, dragSpeedFactor)
	dragSpeedFactor = dragSpeedFactor or 1

	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function onTouchInput(input)
		if dragging then
			local delta = (input.Position - dragStart) * dragSpeedFactor
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
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
		if input.UserInputType == Enum.UserInputType.Touch and dragging then
			onTouchInput(input)
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
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

local function calculateSliderValue(inputPosition, sliderBack)
    local relativeX = math.clamp((inputPosition - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
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

--Sigma5Visual
local ScreenGuitwo = Instance.new("ScreenGui")
ScreenGuitwo.Parent = game:WaitForChild("CoreGui")
ScreenGuitwo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGuitwo.Name = "SigmaVisualStuff"
ScreenGuitwo.ResetOnSpawn = false

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
		Background.BackgroundTransparency = 0.35
		Background.Position = UDim2.new(1, -220, 1, -85)
		Background.Size = UDim2.new(0, 215, 0, 55)

		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = Background
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 55, 0, 25)
		TextLabel.Size = UDim2.new(0, 155, 0, 25)
		TextLabel.Font = Enum.Font.Roboto
		TextLabel.Text = text
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
		TextLabel_2.Font = Enum.Font.Roboto
		TextLabel_2.Text = title
		TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel_2.TextSize = 20.000
		TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.AnchorPoint = Vector2.new(0, 1)
		ImageLabel.Parent = Background
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0, 10, 0, 45)
		ImageLabel.Size = UDim2.new(0, 35, 0, 35)
		ImageLabel.Image = "rbxassetid://7733964719"

		local textSizeX = math.max(TextLabel.TextBounds.X, TextLabel_2.TextBounds.X) + 60
		Background.Size = UDim2.new(0, 215, 0, 55)

		if toggled then
			Background.Position = UDim2.new(1, -textSizeX - 10, 1, -70)
			Background:TweenPosition(UDim2.new(1, -220, 1, -85), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5)
		end

		wait(delay2)

		if Background then
			Background:TweenPosition(UDim2.new(1, -260, 1, -70), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.5, false, function()
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
TheListThingy.Padding = UDim.new(0, -10)
TheListThingy.SortOrder = Enum.SortOrder.LayoutOrder
TheListThingy.Parent = HolderArrayList

local function AddArrayList(name)
	local ModulesName = Instance.new("TextLabel")
	ModulesName.Name = name
	ModulesName.TextXAlignment = Enum.TextXAlignment.Right
	ModulesName.BackgroundTransparency = 1
	ModulesName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ModulesName.Font = Enum.Font.Roboto
	ModulesName.TextSize = 18.5
	ModulesName.Text = name
	ModulesName.TextColor3 = Color3.fromRGB(255, 255, 255)
	ModulesName.Size = UDim2.new(1, 0, 0, 30)
	ModulesName.ZIndex = 5
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

local LeftHolder = Instance.new("Frame")
LeftHolder.Name = "LeftHolder"
LeftHolder.Parent = ScreenGuitwo
LeftHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftHolder.BackgroundTransparency = 1
LeftHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
LeftHolder.BorderSizePixel = 0
LeftHolder.Visible = true
LeftHolder.Size = UDim2.new(0, 245, 1, 0)

local SigmaTittle = Instance.new("TextLabel")
SigmaTittle.Name = "SigmaTittle"
SigmaTittle.Parent = LeftHolder
SigmaTittle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SigmaTittle.BackgroundTransparency = 1.000
SigmaTittle.BorderColor3 = Color3.fromRGB(0, 0, 0)
SigmaTittle.BorderSizePixel = 0
SigmaTittle.Position = UDim2.new(0, 15, 0, 0)
SigmaTittle.Size = UDim2.new(0, 200, 0, 50)
SigmaTittle.Font = Enum.Font.Roboto
SigmaTittle.Text = "Sigma"
SigmaTittle.TextColor3 = Color3.fromRGB(255, 255, 255)
SigmaTittle.TextSize = 33
SigmaTittle.TextTransparency = 0.380
SigmaTittle.Visible = true
SigmaTittle.TextWrapped = true
SigmaTittle.TextXAlignment = Enum.TextXAlignment.Left

local Jello = Instance.new("TextLabel")
Jello.Name = "Jello"
Jello.Parent = SigmaTittle
Jello.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Jello.BackgroundTransparency = 1.000
Jello.BorderColor3 = Color3.fromRGB(0, 0, 0)
Jello.BorderSizePixel = 0
Jello.Position = UDim2.new(0, 0, 0, 33)
Jello.Size = UDim2.new(0, 125, 0, 25)
Jello.Font = Enum.Font.Roboto
Jello.Text = "Jello"
Jello.TextColor3 = Color3.fromRGB(255, 255, 255)
Jello.TextSize = 14
Jello.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Jello.TextTransparency = 0.380
Jello.TextWrapped = true
Jello.TextXAlignment = Enum.TextXAlignment.Left

local TabHolder = Instance.new("Frame")
TabHolder.Name = "TabHolder"
TabHolder.Parent = LeftHolder
TabHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabHolder.BackgroundTransparency = 1.000
TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
TabHolder.BorderSizePixel = 0
TabHolder.Visible = false
TabHolder.Position = UDim2.new(0, 15, 0, 60)
TabHolder.Size = UDim2.new(0, 110, 0, 124)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabHolder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Movement = Instance.new("TextLabel")
Movement.Name = "Movement"
Movement.Parent = TabHolder
Movement.BackgroundColor3 = Color3.fromRGB(168, 168, 168)
Movement.BackgroundTransparency = 0.480
Movement.BorderColor3 = Color3.fromRGB(0, 0, 0)
Movement.BorderSizePixel = 0
Movement.Size = UDim2.new(1, 0, 0, 23)
Movement.Font = Enum.Font.Roboto
Movement.Text = "     Movement"
Movement.TextColor3 = Color3.fromRGB(255, 255, 255)
Movement.TextSize = 14
Movement.TextXAlignment = Enum.TextXAlignment.Left

local Player = Instance.new("TextLabel")
Player.Name = "Player"
Player.Parent = TabHolder
Player.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
Player.BackgroundTransparency = 0.480
Player.BorderColor3 = Color3.fromRGB(0, 0, 0)
Player.BorderSizePixel = 0
Player.Size = UDim2.new(1, 0, 0, 23)
Player.Font = Enum.Font.Roboto
Player.Text = "   Player"
Player.TextColor3 = Color3.fromRGB(255, 255, 255)
Player.TextSize = 14
Player.TextXAlignment = Enum.TextXAlignment.Left

local Combat = Instance.new("TextLabel")
Combat.Name = "Combat"
Combat.Parent = TabHolder
Combat.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
Combat.BackgroundTransparency = 0.480
Combat.BorderColor3 = Color3.fromRGB(0, 0, 0)
Combat.BorderSizePixel = 0
Combat.Size = UDim2.new(1, 0, 0, 23)
Combat.Font = Enum.Font.Roboto
Combat.Text = "   Combat"
Combat.TextColor3 = Color3.fromRGB(255, 255, 255)
Combat.TextSize = 14
Combat.TextXAlignment = Enum.TextXAlignment.Left

local Render = Instance.new("TextLabel")
Render.Name = "Render"
Render.Parent = TabHolder
Render.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
Render.BackgroundTransparency = 0.480
Render.BorderColor3 = Color3.fromRGB(0, 0, 0)
Render.BorderSizePixel = 0
Render.Size = UDim2.new(1, 0, 0, 23)
Render.Font = Enum.Font.Roboto
Render.Text = "   Render"
Render.TextColor3 = Color3.fromRGB(255, 255, 255)
Render.TextSize = 14
Render.TextXAlignment = Enum.TextXAlignment.Left

local World = Instance.new("TextLabel")
World.Name = "World"
World.Parent = TabHolder
World.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
World.BackgroundTransparency = 0.480
World.BorderColor3 = Color3.fromRGB(0, 0, 0)
World.BorderSizePixel = 0
World.Size = UDim2.new(1, 0, 0, 23)
World.Font = Enum.Font.Roboto
World.Text = "   World"
World.TextColor3 = Color3.fromRGB(255, 255, 255)
World.TextSize = 14
World.TextXAlignment = Enum.TextXAlignment.Left

--UILibrary
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
	TAB.Tabs.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	TAB.Tabs.BackgroundTransparency = 0.050
	TAB.Tabs.Size = UDim2.new(0, 133, 0, 40)
	TAB.Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TAB.Tabs.ZIndex = 3
	TAB.Tabs.Position = UDim2.new(0, 25, 0, 10)
	TAB.Tabs.Name = "Tabs"
	TAB.Tabs.Visible = false
	
	TAB.TabsName = Instance.new("TextLabel", TAB.Tabs)
	TAB.TabsName.BorderSizePixel = 0
	TAB.TabsName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TAB.TabsName.TextXAlignment = Enum.TextXAlignment.Left
	TAB.TabsName.Font = Enum.Font.Roboto
	TAB.TabsName.TextSize = 18.000
	TAB.TabsName.ZIndex = 3
	TAB.TabsName.TextColor3 = Color3.fromRGB(95, 95, 95)
	TAB.TabsName.Size = UDim2.new(1, 0, 1, 0)
	TAB.TabsName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TAB.TabsName.Text = "    "..tabName
	TAB.TabsName.Name = "TabsName"
	TAB.TabsName.TextTransparency = 0.350
	TAB.TabsName.Position = UDim2.new(0, 0, 0, 0)
	TAB.TabsName.TextStrokeTransparency = 0.990
	TAB.TabsName.BackgroundTransparency = 1.000
	
	TAB.ScrollingPart = Instance.new("Frame", TAB.Tabs)
	TAB.ScrollingPart.BorderSizePixel = 0
	TAB.ScrollingPart.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TAB.ScrollingPart.BackgroundTransparency = 1.000
	TAB.ScrollingPart.Size = UDim2.new(0, 133, 0, 250)
	TAB.ScrollingPart.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TAB.ScrollingPart.ZIndex = 3
	TAB.ScrollingPart.Position = UDim2.new(0, 0, 0, 40)
	TAB.ScrollingPart.Name = "ScrollingPart"
	TAB.ScrollingPart.Visible = false

	TAB.ScrollingModules = Instance.new("ScrollingFrame", TAB.ScrollingPart)
	TAB.ScrollingModules.Active = true
	TAB.ScrollingModules.BorderSizePixel = 0
	TAB.ScrollingModules.ZIndex = 3
	TAB.ScrollingModules.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TAB.ScrollingModules.Size = UDim2.new(0, 133, 0, 173)
	TAB.ScrollingModules.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	TAB.ScrollingModules.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TAB.ScrollingModules.ScrollBarThickness = 3
	TAB.ScrollingModules.CanvasSize = UDim2.new(0, 0, 1, 0)
	TAB.ScrollingModules.Name = "ScrollingModules"

	local UIListLayout = Instance.new("UIListLayout", TAB.ScrollingModules)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local MobileSupportUI = Instance.new("TextButton", parentFrame)
	MobileSupportUI.BorderSizePixel = 0
	MobileSupportUI.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
	MobileSupportUI.TextSize = 8
	MobileSupportUI.TextColor3 = Color3.fromRGB(0, 0, 0)
	MobileSupportUI.Size = UDim2.new(0, 23, 0, 23)
	MobileSupportUI.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MobileSupportUI.Text = "+"
	MobileSupportUI.ZIndex = 2
	MobileSupportUI.Name = "MobileOpenUI"
	MobileSupportUI.Position = UDim2.new(0.963096738, 0, 0.351765305, 0)
	MobileSupportUI.AutoButtonColor = false
	MobileSupportUI.TextTransparency = 0.250

	local BlurUI = Instance.new("BlurEffect")
	BlurUI.Parent = Lighting
	BlurUI.Size = 28
	BlurUI.Enabled = false
	
	MobileSupportUI.MouseButton1Click:Connect(function()
		for _, tab in pairs(parentFrame:GetChildren()) do
		if tab.Name == "Tabs" and tab:IsA("Frame") then
				tab.Visible = not tab.Visible
				if tab.ScrollingPart then
					tab.ScrollingPart.Visible = not tab.ScrollingPart.Visible
				end
			end
		end
	end)


		game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
			if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
				TAB.Tabs.Visible = not TAB.Tabs.Visible
				TAB.ScrollingPart.Visible = not TAB.ScrollingPart.Visible
				BlurUI.Enabled = not BlurUI.Enabled
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
		newButton.TextXAlignment = Enum.TextXAlignment.Left
		newButton.Font = Enum.Font.Roboto
		newButton.TextSize = 15.000
		newButton.TextColor3 = Color3.fromRGB(15, 15, 15)
		newButton.Size = UDim2.new(1, 0, 0, 20)
		newButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		newButton.Text = "     " .. options.name
		newButton.ZIndex = 3
		newButton.Name = options.name
		newButton.Position = UDim2.new(0, 3, 0, 0)
		newButton.AutoButtonColor = false
		newButton.TextTransparency = 0.250

		ToggleButton["Button"] = newButton

		local openmenu = Instance.new("TextButton", newButton)
		openmenu.BorderSizePixel = 0
		openmenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		openmenu.Font = Enum.Font.Roboto
		openmenu.TextSize = 15.000
		openmenu.TextColor3 = Color3.fromRGB(15, 15, 15)
		openmenu.Size = UDim2.new(0, 20, 0, 20)
		openmenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		openmenu.Text = "+"
		openmenu.BackgroundTransparency = 0.050
		openmenu.ZIndex = 3
		openmenu.Name = "MobileSupport"
		openmenu.Position = UDim2.new(0, 113, 0, 0)
		openmenu.AutoButtonColor = false
		openmenu.TextTransparency = 0.250

		-- RightClickStuff
		
local ButtonsMenuFrame = Instance.new("Frame", CoreGui.Sigma)
ButtonsMenuFrame.Name = "Holder"
ButtonsMenuFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
ButtonsMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtonsMenuFrame.BorderSizePixel = 0
ButtonsMenuFrame.Position = UDim2.new(0.497, -155, 0.521, -158)
ButtonsMenuFrame.Size = UDim2.new(0, 325, 0, 295)
ButtonsMenuFrame.ZIndex = 2
ButtonsMenuFrame.Visible = false
		
local ButtonsMenuFrameCorner = Instance.new("UICorner", ButtonsMenuFrame)
ButtonsMenuFrameCorner.CornerRadius = UDim.new(0, 8)

local ButtonsMenuTitleText = Instance.new("TextLabel", ButtonsMenuFrame)
ButtonsMenuTitleText.Name = "Menu For" .. options.name
ButtonsMenuTitleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonsMenuTitleText.BackgroundTransparency = 1.000
ButtonsMenuTitleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtonsMenuTitleText.BorderSizePixel = 0
ButtonsMenuTitleText.Position = UDim2.new(0, 0, 0, -52)
ButtonsMenuTitleText.Size = UDim2.new(0, 200, 0, 50)
ButtonsMenuTitleText.Font = Enum.Font.Roboto
ButtonsMenuTitleText.Text = options.name
ButtonsMenuTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonsMenuTitleText.TextSize = 30.000
ButtonsMenuTitleText.TextXAlignment = Enum.TextXAlignment.Left
ButtonsMenuTitleText.Visible = true
ButtonsMenuTitleText.ZIndex = 2

local ButtonsMenuInner = Instance.new("ScrollingFrame", ButtonsMenuFrame)
ButtonsMenuInner.Name = "ScrollHolder"
ButtonsMenuInner.Active = true
ButtonsMenuInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonsMenuInner.BackgroundTransparency = 1.000
ButtonsMenuInner.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtonsMenuInner.BorderSizePixel = 0
ButtonsMenuInner.Size = UDim2.new(1, 0, 1, 0)
ButtonsMenuInner.ScrollBarThickness = 0
ButtonsMenuInner.Visible = false
ButtonsMenuInner.ZIndex = 2

local UIListLayout = Instance.new("UIListLayout", ButtonsMenuInner)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ButtonsMenuTitle = Instance.new("TextLabel", ButtonsMenuInner)
ButtonsMenuTitle.Name = "Info for" ..options.name
ButtonsMenuTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonsMenuTitle.BackgroundTransparency = 1.000
ButtonsMenuTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
ButtonsMenuTitle.BorderSizePixel = 0
ButtonsMenuTitle.Size = UDim2.new(1, 0, 0, 35)
ButtonsMenuTitle.Font = Enum.Font.Roboto
ButtonsMenuTitle.Text = "      " .. options.info
ButtonsMenuTitle.TextColor3 = Color3.fromRGB(85, 85, 85)
ButtonsMenuTitle.TextSize = 13
ButtonsMenuTitle.TextWrapped = true
ButtonsMenuTitle.TextXAlignment = Enum.TextXAlignment.Left
ButtonsMenuTitle.Visible = true
ButtonsMenuTitle.ZIndex = 2

		ToggleButton.MenuFrame = ButtonsMenuFrame

		local function updateColors()
			if ToggleButton.Enabled then
				Library:tween(newButton, {BackgroundColor3 = Color3.fromRGB(115, 185, 255)})
				Library:tween(newButton, {TextColor3 = Color3.fromRGB(255, 255, 255)})
				newButton.Text = "       " .. options.name
				AddArrayList(options.name)
				playContinuousSound(soundIds.enabled)
			else
				Library:tween(newButton, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
				Library:tween(newButton, {TextColor3 = Color3.fromRGB(15, 15, 15)})
				newButton.Text = "     " .. options.name
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


		openmenu.MouseButton1Click:Connect(function()
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
			local Percent
			local MouseDown = false
			
			local SliderNameLabel = Instance.new("TextLabel", ButtonsMenuInner)
			SliderNameLabel.Name = "Slider For" .. options.title
			SliderNameLabel.Size = UDim2.new(1, 0, 0, 30)
			SliderNameLabel.Position = UDim2.new(0, 0, 0, 0)
			SliderNameLabel.Text = "      " .. options.title
			SliderNameLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
			SliderNameLabel.TextSize = 15
			SliderNameLabel.Font = Enum.Font.Roboto
			SliderNameLabel.BackgroundTransparency = 1
			SliderNameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderNameLabel.ZIndex = 2
			SliderNameLabel.TextXAlignment = Enum.TextXAlignment.Left

			local SliderValueLabel = Instance.new("TextLabel", SliderNameLabel)
			SliderValueLabel.Name = "Sliders Value"
			SliderValueLabel.Size = UDim2.new(0, 30, 0, 30)
			SliderValueLabel.Position = UDim2.new(0, 195, 0, 5)
			SliderValueLabel.Text = ""
			SliderValueLabel.TextColor3 = Color3.fromRGB(85, 85, 85)
			SliderValueLabel.TextSize = 10
			SliderValueLabel.Font = Enum.Font.Roboto
			SliderValueLabel.BackgroundTransparency = 1
			SliderValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderValueLabel.ZIndex = 2

			local SliderBack = Instance.new("Frame", SliderNameLabel)
			SliderBack.Name = "SliderBack"
			SliderBack.Size = UDim2.new(0, 75, 0, 5)
			SliderBack.Position = UDim2.new(0, 225, 0, 15)
			SliderBack.BorderSizePixel = 0
			SliderBack.BackgroundColor3 = Color3.fromRGB(205, 235, 255)
			SliderBack.BackgroundTransparency = 0.45
			SliderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderBack.ZIndex = 2

			local SliderBackCorner = Instance.new("UICorner", SliderBack)
			SliderBackCorner.CornerRadius = UDim.new(1, 0)

			local SliderFill = Instance.new("Frame", SliderBack)
			SliderFill.Name = "SliderFill"
			SliderFill.Size = UDim2.new(options.default / options.max, 0, 1, 0)
			SliderFill.Position = UDim2.new(0, 0, 0, 0)
			SliderFill.BorderSizePixel = 0
			SliderFill.BackgroundColor3 = Color3.fromRGB(116, 184, 255)
			SliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderFill.ZIndex = 2

			local SliderFillCorner = Instance.new("UICorner", SliderFill)
			SliderFillCorner.CornerRadius = UDim.new(1, 0)

			local UISliderButton = Instance.new("TextButton", SliderFill)
			UISliderButton.Name = "UISliderButton"
			UISliderButton.Size = UDim2.new(0, 15, 0, 15)
			UISliderButton.AnchorPoint = Vector2.new(1, 0.5)
			UISliderButton.Position = UDim2.new(1, 0, 0.5, 0)
			UISliderButton.Text = ""
			UISliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			UISliderButton.BorderSizePixel = 0
			UISliderButton.AutoButtonColor = false
			UISliderButton.ZIndex = 1
			UISliderButton.ClipsDescendants = true
			UISliderButton.ZIndex = 2

			local UICorner = Instance.new("UICorner", UISliderButton)
			UICorner.CornerRadius = UDim.new(1, 0)
			
local function Update(input)
    MouseDown = true
    repeat
        task.wait()

        local inputPosition
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            inputPosition = input.Position
        elseif input.UserInputType == Enum.UserInputType.Touch then
            inputPosition = input.Position
        end

        if inputPosition then
            Percent = math.clamp((inputPosition.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local sliderValue = math.round(Percent * 100)
            SliderValueLabel.Text = sliderValue
            SliderFill.Size = UDim2.fromScale(Percent, 1)

            options.callback(sliderValue)
        end
    until not MouseDown
end

    UISliderButton.MouseButton1Down:Connect(function()
        Update(game:GetService("UserInputService").InputChanged:Wait())
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MouseDown = false
        end
    end)
			function ToggleButton:ToggleButtonInsideUI(options)
				options = Library:validate({
					name = "Error404",
					callback = function(enabled) end
				}, options or {})

				local ToggleButtonInsideUI = {
					Enabled = false
				}

			local newToggle = Instance.new("TextLabel", ButtonsMenuInner)
			newToggle.Name = "MiniToggle For" .. options.name
			newToggle.Size = UDim2.new(1, 0, 0, 30)
			newToggle.Position = UDim2.new(0, 0, 0, 0)
			newToggle.Text = "      " .. options.name
			newToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
			newToggle.TextSize = 15
			newToggle.Font = Enum.Font.Roboto
			newToggle.BackgroundTransparency = 1
			newToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			newToggle.ZIndex = 2
			newToggle.TextXAlignment = Enum.TextXAlignment.Left
				
			local newToggleThingy = Instance.new("TextButton", newToggle)
			newToggleThingy.BorderSizePixel = 0
			newToggleThingy.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
			newToggleThingy.TextSize = 5
			newToggleThingy.TextColor3 = Color3.fromRGB(255, 255, 255)
			newToggleThingy.Size = UDim2.new(0, 15, 0, 15)
			newToggleThingy.BorderColor3 = Color3.fromRGB(0, 0, 0)
			newToggleThingy.Text = " "
			newToggleThingy.ZIndex = 2
			newToggleThingy.Name = "Checkmark"
			newToggleThingy.Position = UDim2.new(0, 285, 0, 8)
			newToggleThingy.AutoButtonColor = false
			newToggleThingy.TextTransparency = 0.250
				
			local newToggleThingyCorner = Instance.new("UICorner", newToggleThingy)
			newToggleThingyCorner.CornerRadius = UDim.new(1, 0)

				local function UpdateCheckMark()
					if ToggleButtonInsideUI.Enabled then
						newToggleThingy.BackgroundColor3 = Color3.fromRGB(115, 185, 255)
						newToggleThingy.Text = "✔️"
					else
						newToggleThingy.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
						newToggleThingy.Text = ""
					end
				end

				newToggleThingy.MouseButton1Click:Connect(function()
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
						default = "Error404",
						callback = function(selectedItem) end
					}, options or {})

					local Dropdown = {
						Enabled = false,
						List = options.list or {},
						Selected = options.Default or "",
					}
					
					local DropdownName = Instance.new("TextLabel", ButtonsMenuInner)
					DropdownName.Name = "Dropdown For" .. options.name
					DropdownName.Size = UDim2.new(1, 0, 0, 30)
					DropdownName.Position = UDim2.new(0, 0, 0, 0)
					DropdownName.Text = "      " .. options.name
					DropdownName.TextColor3 = Color3.fromRGB(0, 0, 0)
					DropdownName.TextSize = 15
					DropdownName.Font = Enum.Font.Roboto
					DropdownName.BackgroundTransparency = 1
					DropdownName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					DropdownName.ZIndex = 2
					DropdownName.TextXAlignment = Enum.TextXAlignment.Left
					
					local DropdownHolders = Instance.new("TextButton", DropdownName)
					DropdownHolders.BorderSizePixel = 0
					DropdownHolders.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					DropdownHolders.Size = UDim2.new(0, 75, 0, 15)
					DropdownHolders.BorderColor3 = Color3.fromRGB(0, 0, 0)
					DropdownHolders.Text = "  " .. options.default
					DropdownHolders.TextColor3 = Color3.fromRGB(85, 85, 85)
					DropdownHolders.Position = UDim2.new(0, 225, 0, 8)
					DropdownHolders.Name = "DropdownHolder"
					DropdownHolders.ZIndex = 2
					DropdownHolders.TextXAlignment = Enum.TextXAlignment.Left
					
					local DropdownMenu = Instance.new("Frame", DropdownHolders)
					DropdownMenu.BorderSizePixel = 0
					DropdownMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					DropdownMenu.Size = UDim2.new(0, 75, 1, 0)
					DropdownMenu.Visible = false
					DropdownMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
					DropdownMenu.Position = UDim2.new(0, 0, 1, 0)
					DropdownMenu.BackgroundTransparency = 1
					DropdownMenu.Name = "DropdownMenu"
					DropdownMenu.ZIndex = 2

					local DropdownMenuListHolder = Instance.new("UIListLayout", DropdownMenu)
					DropdownMenuListHolder.SortOrder = Enum.SortOrder.LayoutOrder
				
					for _, item in ipairs(Dropdown.List) do
						local DropdownOption = Instance.new("TextButton", DropdownMenu)
						DropdownOption.BorderSizePixel = 0
						DropdownOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						DropdownOption.BackgroundTransparency = 0
						DropdownOption.Size = UDim2.new(0, 75, 0, 15)
						DropdownOption.TextColor3 = Color3.fromRGB(85, 85, 85)
						DropdownOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
						DropdownOption.Visible = true
						DropdownOption.Text = "  " .. item
						DropdownOption.Name = item
						DropdownOption.ZIndex = 2
						DropdownOption.TextXAlignment = Enum.TextXAlignment.Left
						
						DropdownOption.MouseButton1Click:Connect(function()
							Dropdown.Selected = item
							DropdownHolders.Text = "  " .. item
							DropdownMenu.Visible = false
							options.callback(item)
						end)
					end

					DropdownHolders.MouseButton1Click:Connect(function() 
						Dropdown.Enabled = not Dropdown.Enabled
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

return Library
