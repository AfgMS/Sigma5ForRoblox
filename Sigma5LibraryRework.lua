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

function Library:Valid(normal, advance)
	for i, v in pairs(normal) do
		if advance[i] == nil then
			advance[i] = v
		end
	end
	return advance
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
	ScrollingHolder.Visible = false

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

	local MobileSupportUI = Instance.new("TextButton", CoreGui:WaitForChild("sigma5"))
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

	local MobileCornerSupport = Instance.new("UICorner", MobileSupportUI)
	MobileCornerSupport.CornerRadius = UDim.new(0, 8)

	MobileSupportUI.MouseButton1Click:Connect(function()
		for _, tab in pairs(CoreGui:WaitForChild("sigma5"):GetChildren()) do
			if tab.Name == "TabsVHolder" and tab:IsA("Frame") then
				tab.Visible = not tab.Visible
				BlurEffect.Enabled = not BlurEffect.Enabled
				ScrollingHolder.Visible = not ScrollingHolder.Visible
			end
		end
	end)

	game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
			TabsHolder.Visible = not TabsHolder.Visible
			ScrollingHolder.Visible = not ScrollingHolder.Visible
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

end

return Library
