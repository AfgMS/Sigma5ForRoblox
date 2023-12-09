local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Font = game:GetService("TextService")

local SigmaLibrary = {}
local TABS = {}
TABS.Modules = {}
TABS.totalWidth = 0 

function SigmaLibrary:tween(object, properties)
	local tweenInfo = TweenInfo.new(properties.time or 0.10, properties.easingStyle or Enum.EasingStyle.Quad, properties.easingDirection or Enum.EasingDirection.Out)
	local tween = TweenService:Create(object, tweenInfo, properties)
	tween:Play()
end

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

function SigmaLibrary:validate(defaults, options)
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end
	return options
end

function SigmaLibrary:LoadScreenGUI()
	local Sigma5 = Instance.new("ScreenGui", CoreGui)
	Sigma5.Name = "Sigma5"
	Sigma5.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Sigma5.ResetOnSpawn = false
	return Sigma5
end

function SigmaLibrary:createTabs(parentFrame, tabName)
	local Tabs = Instance.new("Frame", parentFrame)
	TABS.Tabs = Tabs -- Fixed variable name
	Tabs.Name = "Tabs"
	Tabs.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	Tabs.BackgroundTransparency = 0.050
	Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Tabs.BorderSizePixel = 0
	Tabs.Position = UDim2.new(0.03152666240930557 + (TABS.totalWidth * 0.5), 0, 0.020082522183656693, 0)
	Tabs.Size = UDim2.new(0, 133, 0, 40)

	local Name = Instance.new("TextLabel", Tabs)
	Name.Name = "Name"
	Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Name.BackgroundTransparency = 1.000
	Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Name.BorderSizePixel = 0
	Name.Size = UDim2.new(1, 0, 1, 0)
	Name.Font = Enum.Font.Roboto
	Name.Text = "    Misc"
	Name.TextColor3 = Color3.fromRGB(95, 95, 95)
	Name.TextSize = 18.000
	Name.TextStrokeTransparency = 0.990
	Name.TextTransparency = 0.350
	Name.TextXAlignment = Enum.TextXAlignment.Left

	local ScrollHolder = Instance.new("Frame", Tabs)
	TABS.ScrollHolder = ScrollHolder
	ScrollHolder.Name = "ScrollHolder"
	ScrollHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollHolder.BackgroundTransparency = 1.000
	ScrollHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollHolder.BorderSizePixel = 0
	ScrollHolder.Position = UDim2.new(0, -15, 0, 40)
	ScrollHolder.Size = UDim2.new(0, 133, 0, 250)

	local ModulesHolder = Instance.new("ScrollingFrame", ScrollHolder)
	TABS.ModulesHolder = ModulesHolder
	ModulesHolder.Name = "ModulesHolder"
	ModulesHolder.Active = true
	ModulesHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ModulesHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ModulesHolder.BorderSizePixel = 0
	ModulesHolder.Size = UDim2.new(0, 133, 0, 173)
	ModulesHolder.CanvasSize = UDim2.new(0, 0, 1, 0)
	ModulesHolder.ScrollBarThickness = 3

	local UIListLayout = Instance.new("UIListLayout", ModulesHolder)
	TABS.UIListLayout = UIListLayout
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local UIListLayout_2 = Instance.new("UIListLayout", Tabs)
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if not gameProcessedEvent then
			if input.KeyCode == Enum.KeyCode.V then
				TABS.Tabs.Visible = not TABS.Tabs.Visible
			end
		end
	end)

	if TABS.totalWidth < 10 * Tabs.Size.X.Offset then
		local newX = UDim2.new(0, TABS.totalWidth * 1.03, 0, 0)
		TABS.totalWidth = TABS.totalWidth + Tabs.Size.X.Offset

		Tabs.Position = newX 

		makeDraggable(Tabs)
	else
		warn("Reached the maximum number of tabs. Cannot create more tabs.")
	end
end

function TABS:Modules(options)
	options = SigmaLibrary:validate({
		ModulesName = "Error",
		HoverText = "Error"
	}, options or {})

	local ModuleButton = Instance.new("TextButton", TABS.ModulesHolder)
	ModuleButton.Name = options.ModulesName
	ModuleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ModuleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ModuleButton.BorderSizePixel = 0
	ModuleButton.Size = UDim2.new(1, 0, 0, 20)
	ModuleButton.AutoButtonColor = false
	ModuleButton.Font = Enum.Font.Roboto
	ModuleButton.Text = "     " .. options.ModulesName
	ModuleButton.TextColor3 = Color3.fromRGB(15, 15, 15)
	ModuleButton.TextSize = 15.000
	ModuleButton.TextTransparency = 0.250
	ModuleButton.TextXAlignment = Enum.TextXAlignment.Left

	local function ModuleButtonFunction()
		if ModuleButton.Enabled then
			SigmaLibrary:tween(ModuleButton, {BackgroundColor3 = Color3.fromRGB(115, 185, 255)})
			SigmaLibrary:tween(ModuleButton, {TextColor3 = Color3.fromRGB(255, 255, 255)})
		else
			SigmaLibrary:tween(ModuleButton, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
			SigmaLibrary:tween(ModuleButton, {TextColor3 = Color3.fromRGB(15, 15, 15)})
		end
	end

	ModuleButton.MouseButton1Click:Connect(function()
		ModuleButton.Enabled = not ModuleButton.Enabled
		ModuleButtonFunction()

		if options.callback then
			options.callback(ModuleButton.Enabled)
		end
	end)
end

SigmaLibrary:LoadScreenGUI()

return TABS
