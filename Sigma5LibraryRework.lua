local CoreGui = game:GetService("CoreGui")
local Lightning = game:GetService("Lighting")
local Font = game:GetService("TextService")

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

local BlurEffect = Instance.new("BlurEffect", Lightning)
BlurEffect.Size = 28
BlurEffect.Enabled = false

function Library:CreateCore()
	local ScreenGui = Instance.new("ScreenGui", CoreGui)
	ScreenGui.Name = "sigma5"
	return ScreenGui
end

function Library:CreateTabs(Name)

	local TabsHolder = Instance.new("Frame", CoreGui:WaitForChild("sigma5"))
	TabsHolder.BorderSizePixel = 0
	TabsHolder.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	TabsHolder.BackgroundTransparency = 0.050
	TabsHolder.Size = UDim2.new(0, 133, 0, 40)
	TabsHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabsHolder.ZIndex = 3
	TabsHolder.Position = UDim2.new(0, 25, 0, 10)
	TabsHolder.Name = "TabsVHolder"
	TabsHolder.Visible = false

	local TabsNameHolder = Instance.new("TextLabel", TabsHolder)
	TabsNameHolder.BorderSizePixel = 0
	TabsNameHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabsNameHolder.TextXAlignment = Enum.TextXAlignment.Left
	TabsNameHolder.Font = Enum.Font.Roboto
	TabsNameHolder.TextSize = 18.000
	TabsNameHolder.ZIndex = 3
	TabsNameHolder.TextColor3 = Color3.fromRGB(95, 95, 95)
	TabsNameHolder.Size = UDim2.new(1, 0, 1, 0)
	TabsNameHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabsNameHolder.Text = "    " .. Name
	TabsNameHolder.Name = "TabsName"
	TabsNameHolder.TextTransparency = 0.350
	TabsNameHolder.Position = UDim2.new(0, 0, 0, 0)
	TabsNameHolder.TextStrokeTransparency = 0.990
	TabsNameHolder.BackgroundTransparency = 1.000

	local ScrollingHolder = Instance.new("Frame", TabsHolder)
	ScrollingHolder.BorderSizePixel = 0
	ScrollingHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingHolder.BackgroundTransparency = 1.000
	ScrollingHolder.Size = UDim2.new(0, 133, 0, 250)
	ScrollingHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingHolder.ZIndex = 3
	ScrollingHolder.Position = UDim2.new(0, 0, 0, 40)
	ScrollingHolder.Name = "ScrollingPart"
	ScrollingHolder.Visible = true

	local ScrollForToggle = Instance.new("ScrollingFrame", ScrollingHolder)
	ScrollForToggle.Active = true
	ScrollForToggle.BorderSizePixel = 0
	ScrollForToggle.ZIndex = 3
	ScrollForToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollForToggle.Size = UDim2.new(0, 133, 0, 173)
	ScrollForToggle.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	ScrollForToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollForToggle.ScrollBarThickness = 3
	ScrollForToggle.CanvasSize = UDim2.new(0, 0, 1, 0)
	ScrollForToggle.Name = "ScrollingModules"

	local UIListLayout = Instance.new("UIListLayout", ScrollForToggle)
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
			if tab.Name == "TabsVHolder" and tab:IsA("Frame") then
				tab.Visible = not tab.Visible
				BlurEffect.Enabled = not BlurEffect.Enabled
				end
			end
		end)

	game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
			TabsHolder.Visible = not TabsHolder.Visible
			BlurEffect.Enabled = not BlurEffect.Enabled
		end
	end)

	if Library.TabsWidth < 10 * TabsHolder.Size.X.Offset then
		local newX = UDim2.new(0, Library.TabsWidth * 1.03, 0, 0)
		Library.TabsWidth = Library.TabsWidth + TabsHolder.Size.X.Offset

		TabsHolder.Position = newX
	else
		warn("Reached the maximum number of tabs. Cannot create more tabs.")
	end

function Library:CreateToggles(Name, Description, callback)
	
	local ToggleButton = {
		Enabled = false
	}
	
	--ToggleButtons
	local ToggleButtonHolder = Instance.new("TextButton", ScrollForToggle)
	ToggleButtonHolder.BorderSizePixel = 0
	ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ToggleButtonHolder.TextXAlignment = Enum.TextXAlignment.Left
	ToggleButtonHolder.Font = Enum.Font.Roboto
	ToggleButtonHolder.TextSize = 15.000
	ToggleButtonHolder.TextColor3 = Color3.fromRGB(15, 15, 15)
	ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 20)
	ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ToggleButtonHolder.Text = "     " .. Name
	ToggleButtonHolder.ZIndex = 3
	ToggleButtonHolder.Name = "Toggle Button For" .. Name
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
	MobileOpenMenu.Position = UDim2.new(0, 113, 0, 0)
	MobileOpenMenu.AutoButtonColor = false
	MobileOpenMenu.TextTransparency = 0.250

	--RightClickMenu

	local MenuHolder = Instance.new("Frame", CoreGui:WaitForChild("sigma5"))
	MenuHolder.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	MenuHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuHolder.BorderSizePixel = 0
	MenuHolder.Position = UDim2.new(0.497, -155, 0.521, -148)
	MenuHolder.Size = UDim2.new(0, 325, 0, 295)
	MenuHolder.ZIndex = 4
	MenuHolder.Visible = false

	local MenuHolderCorner = Instance.new("UICorner", MenuHolder)
	MenuHolderCorner.CornerRadius = UDim.new(0, 8)

	local ButtonsMenuTitleText = Instance.new("TextLabel", MenuHolder)
	ButtonsMenuTitleText.Name = "Menu For" .. Name
	ButtonsMenuTitleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ButtonsMenuTitleText.BackgroundTransparency = 1.000
	ButtonsMenuTitleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ButtonsMenuTitleText.BorderSizePixel = 0
	ButtonsMenuTitleText.Position = UDim2.new(0, 0, 0, -52)
	ButtonsMenuTitleText.Size = UDim2.new(0, 200, 0, 50)
	ButtonsMenuTitleText.Font = Enum.Font.Roboto
	ButtonsMenuTitleText.Text = Name
	ButtonsMenuTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	ButtonsMenuTitleText.TextSize = 30.000
	ButtonsMenuTitleText.TextXAlignment = Enum.TextXAlignment.Left
	ButtonsMenuTitleText.Visible = true
	ButtonsMenuTitleText.ZIndex = 4

	local MobileCloseMenu = Instance.new("TextButton", MenuHolder)
	MobileCloseMenu.BorderSizePixel = 0
	MobileCloseMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MobileCloseMenu.Font = Enum.Font.Roboto
	MobileCloseMenu.TextScaled  = true
	MobileCloseMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
	MobileCloseMenu.Size = UDim2.new(0, 45, 0, 45)
	MobileCloseMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MobileCloseMenu.Text = "x"
	MobileCloseMenu.BackgroundTransparency = 1
	MobileCloseMenu.ZIndex = 4
	MobileCloseMenu.Name = "CloseMobileSupport"
	MobileCloseMenu.Position = UDim2.new(0, 290, 0, -52)
	MobileCloseMenu.AutoButtonColor = false

	local ButtonsMenuInner = Instance.new("ScrollingFrame", MenuHolder)
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
	ButtonsMenuTitle.Name = "Info for" .. Name
	ButtonsMenuTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ButtonsMenuTitle.BackgroundTransparency = 1.000
	ButtonsMenuTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ButtonsMenuTitle.BorderSizePixel = 0
	ButtonsMenuTitle.Size = UDim2.new(1, 0, 0, 35)
	ButtonsMenuTitle.Font = Enum.Font.Roboto
	ButtonsMenuTitle.Text = "      " .. Description
	ButtonsMenuTitle.TextColor3 = Color3.fromRGB(85, 85, 85)
	ButtonsMenuTitle.TextSize = 13
	ButtonsMenuTitle.TextWrapped = true
	ButtonsMenuTitle.TextXAlignment = Enum.TextXAlignment.Left
	ButtonsMenuTitle.Visible = true
	ButtonsMenuTitle.ZIndex = 4

	local function ToggleButtonOnClicked()
		if ToggleButton.Enabled then
			ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(115, 185, 255)
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleButtonHolder.Text = "       " .. Name
			PlaySound(SoundList.OnEnabled)
			PlaySound(SoundList.OnErrorOriginal)
		else
			ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(15, 15, 15)
			ToggleButtonHolder.Text = "     " .. Name
			PlaySound(SoundList.OnDisabled)
			PlaySound(SoundList.OnDisabledOriginal)
		end
	end

	ToggleButtonHolder.MouseButton1Click:Connect(function()
		ToggleButton.Enabled = not ToggleButton.Enabled
		ToggleButtonOnClicked()

		if callback then
			callback(ToggleButton.Enabled)
		end
	end)

	ToggleButtonHolder.MouseButton2Click:Connect(function()
		MenuHolder.Visible = not MenuHolder.Visible
		ButtonsMenuInner.Visible = not ButtonsMenuInner.Visible
	end)


	MobileOpenMenu.MouseButton1Click:Connect(function()
		MenuHolder.Visible = not MenuHolder.Visible
		ButtonsMenuInner.Visible = not ButtonsMenuInner.Visible
	end)

	MobileCloseMenu.MouseButton1Click:Connect(function()
		MenuHolder.Visible = not MenuHolder.Visible
		ButtonsMenuInner.Visible = not ButtonsMenuInner.Visible
	end)

	ToggleButtonOnClicked()
end
end

return Library
