local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Font = game:GetService("TextService")
local TouchInput = game:GetService("TouchInputService")
local Lighting = game:GetService("Lighting")

local Library = {}
Library.TabsWidth = 15
local SoundHolder = {}

local SoundList = {
	OnEnabled = 3318713980,
	OnEnabledOriginal = 14393273745,
	OnDisabled = 3318714899,
	OnDisabledOriginal = 14393278136,
	OnError = 9066167010,
	OnErrorOriginal = {}
}

function Library:validate(defaults, options)
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end
	return options
end

function PlaySound(soundId)
	local sound = Instance.new("Sound", game.Workspace)
	sound.SoundId = "rbxassetid://" .. soundId
	sound:Play()

	SoundHolder[sound] = true

	sound.Ended:Connect(function()
		SoundHolder[sound] = nil
		sound:Destroy()
	end)
end

local BlurEffect = Instance.new("BlurEffect", Lighting)
BlurEffect.Size = 28
BlurEffect.Enabled = false


--UILibrary
function Library:createScreenGui()
	local screenGui = Instance.new("ScreenGui", CoreGui)
	screenGui.Name = "sigma5"
	return screenGui
end

function Library:CreateTabs(Name)
	local TAB = {}
	TAB.Buttons = {}

	TAB.TabsHolder = Instance.new("Frame", CoreGui:WaitForChild("sigma5"))
	TAB.TabsHolder.BorderSizePixel = 0
	TAB.TabsHolder.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	TAB.TabsHolder.BackgroundTransparency = 0.050
	TAB.TabsHolder.Size = UDim2.new(0, 133, 0, 40)
	TAB.TabsHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TAB.TabsHolder.ZIndex = 3
	TAB.TabsHolder.Position = UDim2.new(0, 25, 0, 10)
	TAB.TabsHolder.Name = "Tabs"
	TAB.TabsHolder.Visible = false

	TAB.TabsNameHolder = Instance.new("TextLabel", TAB.TabsHolder)
	TAB.TabsNameHolder.BorderSizePixel = 0
	TAB.TabsNameHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TAB.TabsNameHolder.TextXAlignment = Enum.TextXAlignment.Left
	TAB.TabsNameHolder.Font = Enum.Font.Roboto
	TAB.TabsNameHolder.TextSize = 18.000
	TAB.TabsNameHolder.ZIndex = 3
	TAB.TabsNameHolder.TextColor3 = Color3.fromRGB(95, 95, 95)
	TAB.TabsNameHolder.Size = UDim2.new(1, 0, 1, 0)
	TAB.TabsNameHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TAB.TabsNameHolder.Text = "    " .. Name
	TAB.TabsNameHolder.TextTransparency = 0.350
	TAB.TabsNameHolder.Position = UDim2.new(0, 0, 0, 0)
	TAB.TabsNameHolder.TextStrokeTransparency = 0.990
	TAB.TabsNameHolder.BackgroundTransparency = 1.000

	TAB.ScrollingHolder = Instance.new("Frame", TAB.TabsHolder)
	TAB.ScrollingHolder.BorderSizePixel = 0
	TAB.ScrollingHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TAB.ScrollingHolder.BackgroundTransparency = 1.000
	TAB.ScrollingHolder.Size = UDim2.new(0, 133, 0, 250)
	TAB.ScrollingHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TAB.ScrollingHolder.ZIndex = 3
	TAB.ScrollingHolder.Position = UDim2.new(0, 0, 0, 40)

	TAB.ScrollForToggle = Instance.new("ScrollingFrame", TAB.ScrollingHolder)
	TAB.ScrollForToggle.Active = true
	TAB.ScrollForToggle.BorderSizePixel = 0
	TAB.ScrollForToggle.ZIndex = 3
	TAB.ScrollForToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TAB.ScrollForToggle.Size = UDim2.new(0, 133, 0, 173)
	TAB.ScrollForToggle.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	TAB.ScrollForToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TAB.ScrollForToggle.ScrollBarThickness = 3
	TAB.ScrollForToggle.CanvasSize = UDim2.new(0, 0, 1, 0)

	local UIListLayout = Instance.new("UIListLayout", TAB.ScrollForToggle)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local MobileOpenUI = Instance.new("TextButton", CoreGui:WaitForChild("sigma5"))
	MobileOpenUI.BorderSizePixel = 0
	MobileOpenUI.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
	MobileOpenUI.TextSize = 8
	MobileOpenUI.TextColor3 = Color3.fromRGB(0, 0, 0)
	MobileOpenUI.Size = UDim2.new(0, 23, 0, 23)
	MobileOpenUI.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MobileOpenUI.Text = "+"
	MobileOpenUI.ZIndex = 2
	MobileOpenUI.Name = "MobileOpenUI"
	MobileOpenUI.Position = UDim2.new(0.963096738, 0, 0.351765305, 0)
	MobileOpenUI.AutoButtonColor = false
	MobileOpenUI.TextTransparency = 0.250

	local MobileCornerSupport = Instance.new("UICorner", MobileOpenUI)
	MobileCornerSupport.CornerRadius = UDim.new(0, 8)

	MobileOpenUI.MouseButton1Click:Connect(function()
		for _, tab in pairs(CoreGui:WaitForChild("sigma5"):GetChildren()) do
			if tab.Name == "Tabs" and tab:IsA("Frame") then
				tab.Visible = not tab.Visible
				BlurEffect.Enabled = not BlurEffect.Enabled
			end
		end
	end)


	game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
			TAB.Tabs.Visible = not TAB.Tabs.Visible
			BlurEffect.Enabled = not BlurEffect.Enabled
		end
	end)

	if Library.TabsWidth < 10 * TAB.Tabs.Size.X.Offset then
		local newX = UDim2.new(0, Library.TabsWidth * 1.03, 0, 0)
		Library.TabsWidth = Library.TabsWidth + TAB.Tabs.Size.X.Offset

		TAB.Tabs.Position = newX
	else
		warn("Reached the maximum number of tabs. Cannot create more tabs.")
	end

	function TAB:ToggleButton(options)
		options = Library:validate({
			name = "Error404",
			info = "Error404",
		}, options or {})

		local ToggleButton = {
			Enabled = false
		}

		local ToggleButtonHolder = Instance.new("TextButton", TAB.ScrollForToggle)
		ToggleButtonHolder.BorderSizePixel = 0
		ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleButtonHolder.TextXAlignment = Enum.TextXAlignment.Left
		ToggleButtonHolder.Font = Enum.Font.Roboto
		ToggleButtonHolder.TextSize = 15.000
		ToggleButtonHolder.TextColor3 = Color3.fromRGB(15, 15, 15)
		ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 20)
		ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleButtonHolder.Text = "     " .. options.name
		ToggleButtonHolder.ZIndex = 3
		ToggleButtonHolder.Name = options.name
		ToggleButtonHolder.Position = UDim2.new(0, 3, 0, 0)
		ToggleButtonHolder.AutoButtonColor = false
		ToggleButtonHolder.TextTransparency = 0.250


		local MobileOpenMenu = Instance.new("TextButton", ToggleButtonHolder)
		MobileOpenMenu.BorderSizePixel = 0
		MobileOpenMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MobileOpenMenu.Font = Enum.Font.Roboto
		MobileOpenMenu.TextSize = 15.000
		MobileOpenMenu.TextColor3 = Color3.fromRGB(15, 15, 15)
		MobileOpenMenu.Size = UDim2.new(0, 20, 0, 20)
		MobileOpenMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MobileOpenMenu.Text = "+"
		MobileOpenMenu.BackgroundTransparency = 0.050
		MobileOpenMenu.ZIndex = 3
		MobileOpenMenu.Name = "MobileSupport"
		MobileOpenMenu.Position = UDim2.new(0, 113, 0, 0)
		MobileOpenMenu.AutoButtonColor = false
		MobileOpenMenu.TextTransparency = 0.250

		-- RightClickStuff

		local ButtonsMenuFrame = Instance.new("Frame", CoreGui:WaitForChild("sigma5"))
		ButtonsMenuFrame.Name = "Holder"
		ButtonsMenuFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
		ButtonsMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonsMenuFrame.BorderSizePixel = 0
		ButtonsMenuFrame.Position = UDim2.new(0.497, -155, 0.521, -148)
		ButtonsMenuFrame.Size = UDim2.new(0, 325, 0, 295)
		ButtonsMenuFrame.ZIndex = 4
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
		ButtonsMenuTitleText.ZIndex = 4

		local CloseButtonsMenuFrame = Instance.new("TextButton", ButtonsMenuFrame)
		CloseButtonsMenuFrame.BorderSizePixel = 0
		CloseButtonsMenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CloseButtonsMenuFrame.Font = Enum.Font.Roboto
		CloseButtonsMenuFrame.TextScaled  = true
		CloseButtonsMenuFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
		CloseButtonsMenuFrame.Size = UDim2.new(0, 45, 0, 45)
		CloseButtonsMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CloseButtonsMenuFrame.Text = "x"
		CloseButtonsMenuFrame.BackgroundTransparency = 1
		CloseButtonsMenuFrame.ZIndex = 4
		CloseButtonsMenuFrame.Name = "CloseMobileSupport"
		CloseButtonsMenuFrame.Position = UDim2.new(0, 290, 0, -52)
		CloseButtonsMenuFrame.AutoButtonColor = false

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
		ButtonsMenuInner.ZIndex = 4

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
		ButtonsMenuTitle.ZIndex = 4
		ToggleButton.MenuFrame = ButtonsMenuFrame

		local function updateColors()
			if ToggleButton.Enabled then
				ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(115, 185, 255)
				ToggleButtonHolder.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleButtonHolder.Text = "       " .. options.name
				PlaySound(SoundList.OnEnabled)
				PlaySound(SoundList.OnEnabledOriginal)
			else
				ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleButtonHolder.TextColor3 = Color3.fromRGB(15, 15, 15)
				ToggleButtonHolder.Text = "     " .. options.name
				PlaySound(SoundList.OnDisabled)
				PlaySound(SoundList.OnDisabledOriginal)
			end
		end

		ToggleButtonHolder.MouseButton1Click:Connect(function()
			ToggleButton.Enabled = not ToggleButton.Enabled
			updateColors()

			if options.callback then
				options.callback(ToggleButton.Enabled)
			end
		end)

		ToggleButtonHolder.MouseButton2Click:Connect(function()
			ButtonsMenuFrame.Visible = not ButtonsMenuFrame.Visible
			ButtonsMenuInner.Visible = not ButtonsMenuInner.Visible
		end)


		MobileOpenMenu.MouseButton1Click:Connect(function()
			ButtonsMenuFrame.Visible = not ButtonsMenuFrame.Visible
			ButtonsMenuInner.Visible = not ButtonsMenuInner.Visible
		end)

		CloseButtonsMenuFrame.MouseButton1Click:Connect(function()
			ButtonsMenuFrame.Visible = not ButtonsMenuFrame.Visible
		end)

		updateColors()

		return ToggleButton
	end

	return TAB
end

return Library
