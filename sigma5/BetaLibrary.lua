local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Font = game:GetService("TextService")
local TouchInput = game:GetService("TouchInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local Library = {
	Settings = {
		GuiKeybind = "V",
		GuiBlur = true,
	},
	SoundIds = {
		OnEnabled = 14393273745,
		OnDisabled = 14393278136,
		OnError = 9066167010
	},
	MobileButtons = {},
	Uninjected = false,
}

function Library:Set(normal, advance)
	for i, v in pairs(normal) do
		if advance[i] == nil then
			advance[i] = v
		end
	end
	return advance
end

function Library:Spoof(length)
	local Letter = {}
	for i = 1, length do
		local RandomLetter = string.char(math.random(97, 122))
		table.insert(Letter, RandomLetter)
	end
	return table.concat(Letter)
end

function Library:Fade(object, properties)
	local TweenProperties = TweenInfo.new(properties.time or 0.10, properties.easingStyle or Enum.EasingStyle.Quad, properties.easingDirection or Enum.EasingDirection.Out)
	local TweenAnim = TweenService:Create(object, TweenProperties, properties)
	TweenAnim:Play()
end

function Library:PlaySound(id)
	if not game.Workspace:WaitForChild("SoundsAssets") then
		local Folder = Instance.new("Folder")
		Folder.Parent = game.Workspace
		Folder.Name = "SoundsAssets"
	end
	local Sounds = Instance.new("Sound")
	Sounds.Parent = game.Workspace:FindFirstChild("SoundsAssets")
	Sounds.Name = "Sigma5Assets"
	Sounds.SoundId = "rbxassetid://" .. id
	Sounds:Play()
	Sounds.Ended:Connect(function()
		Sounds:Destroy()
	end)
end

function Library:CreateCore()
	local Core = {}
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = Library:Spoof(math.random(4, 8))
	ScreenGui.ResetOnSpawn = false
	if RunService:IsStudio() --[[ or game.PlaceId == 11630038968 --]] then
		warn("Unable to use CoreGui")
		ScreenGui.Parent = LocalPlayer.PlayerGui
	else
		ScreenGui.Parent = CoreGui
	end
	table.insert(Core, ScreenGui)
	
	local BlurFX = Instance.new("BlurEffect")
	BlurFX.Parent = Lighting
	BlurFX.Size = 25
	BlurFX.Enabled = false
	
	local TabsHolder = Instance.new("ScrollingFrame") 
	TabsHolder.Parent = ScreenGui
	TabsHolder.Active = true
	TabsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabsHolder.BackgroundTransparency = 1.000
	TabsHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabsHolder.BorderSizePixel = 0
	TabsHolder.Size = UDim2.new(1, 0, 1, 0)
	TabsHolder.CanvasSize = UDim2.new(2, 0, 0, 0)
	TabsHolder.ScrollingDirection = Enum.ScrollingDirection.XY
	TabsHolder.ScrollBarThickness = 3
	TabsHolder.Visible = false
	table.insert(Core, TabsHolder)

	local function UninjectAll()
		if Library.Uninjected then
		print("Session Uninjected")
		wait(2)
		TabsHolder:Destroy()
		print("Destroyed TabHolder")
		wait(2)
		BlurFX:Destroy()
		print("Destroyed Blur")
		wait(2)
		ScreenGui:Destroy()
		print("Destroyed All, Uninject Completed..")
		end
	end
	
	local GUIOpen = Instance.new("TextButton")
	GUIOpen.Parent = ScreenGui
	GUIOpen.AnchorPoint = Vector2.new(0.5, 0.5)
	GUIOpen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GUIOpen.BackgroundTransparency = 0.150
	GUIOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUIOpen.BorderSizePixel = 0
	GUIOpen.Position = UDim2.new(0.970000029, 0, 0.25, 0)
	GUIOpen.Size = UDim2.new(0, 20, 0, 20)
	GUIOpen.AutoButtonColor = false
	GUIOpen.Font = Enum.Font.SourceSansLight
	GUIOpen.LineHeight = 0.000
	GUIOpen.Text = "+"
	GUIOpen.TextColor3 = Color3.fromRGB(0, 0, 0)
	GUIOpen.TextScaled = true
	GUIOpen.TextSize = 36.000
	GUIOpen.TextTransparency = 0.250
	GUIOpen.TextWrapped = true
	GUIOpen.TextXAlignment = Enum.TextXAlignment.Center
	GUIOpen.TextYAlignment = Enum.TextYAlignment.Center
	table.insert(Core, GUIOpen)
	
	local UICornier = Instance.new("UICorner")
	UICornier.CornerRadius = UDim.new(0, 4)
	UICornier.Parent = GUIOpen
	table.insert(Core, UICornier)
	
	local UIPadding_2 = Instance.new("UIPadding")
	UIPadding_2.Parent = TabsHolder
	UIPadding_2.PaddingLeft = UDim.new(0.00800000038, 0)
	UIPadding_2.PaddingTop = UDim.new(0.0799999982, 0)
	table.insert(Core, UIPadding_2)
	
	local UIListLayout_8 = Instance.new("UIListLayout")
	UIListLayout_8.Parent = TabsHolder
	UIListLayout_8.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_8.Padding = UDim.new(0.00400000019, 0)
	table.insert(Core, UIListLayout_8)
	
	local SettingsHolder = Instance.new("Frame")
	SettingsHolder.Parent = ScreenGui
	SettingsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SettingsHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingsHolder.BorderSizePixel = 0
	SettingsHolder.Position = UDim2.new(0.82, 0, 0.415, 0)
	SettingsHolder.Size = UDim2.new(0, 135, 0, 185)
	SettingsHolder.Visible = false
	SettingsHolder.ZIndex = 2
	table.insert(Core, SettingsHolder)
	
	local SettingText = Instance.new("TextLabel")
	SettingText.Parent = SettingsHolder
	SettingText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SettingText.BackgroundTransparency = 1.000
	SettingText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingText.BorderSizePixel = 0
	SettingText.Position = UDim2.new(0.104999997, 0, 0.0549999997, 0)
	SettingText.Size = UDim2.new(0.38499999, 0, 0.0877192989, 0)
	SettingText.Font = Enum.Font.Unknown
	SettingText.Text = "Settings"
	SettingText.TextColor3 = Color3.fromRGB(0, 0, 0)
	SettingText.TextScaled = true
	SettingText.ZIndex = 2
	SettingText.TextSize = 14.000
	SettingText.TextWrapped = true
	table.insert(Core, SettingText)
	
	local SettingsClose = Instance.new("TextButton")
	SettingsClose.Parent = SettingsHolder
	SettingsClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SettingsClose.BackgroundTransparency = 1.000
	SettingsClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingsClose.BorderSizePixel = 0
	SettingsClose.Position = UDim2.new(0.822993636, 0, 0.0696380958, 0)
	SettingsClose.Size = UDim2.new(0.0799999982, 0, 0.056140352, 0)
	SettingsClose.AutoButtonColor = false
	SettingsClose.Font = Enum.Font.Unknown
	SettingsClose.Text = "X"
	SettingsClose.TextColor3 = Color3.fromRGB(110, 185, 255)
	SettingsClose.TextScaled = true
	SettingsClose.TextSize = 14.000
	SettingsClose.ZIndex = 2
	SettingsClose.TextWrapped = true
	table.insert(Core, SettingsClose)
	
	local UICorner_2 = Instance.new("UICorner")
	UICorner_2.Parent = SettingsHolder
	table.insert(Core, UICorner_2)
	
	local SettingsList = Instance.new("ScrollingFrame")
	SettingsList.Parent = SettingsHolder
	SettingsList.Active = true
	SettingsList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SettingsList.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingsList.BorderSizePixel = 0
	SettingsList.Position = UDim2.new(0.100000001, 0, 0.224999994, 0)
	SettingsList.Size = UDim2.new(0.800000012, 0, 0.684210539, 0)
	SettingsList.ScrollBarThickness = 0
	table.insert(Core, SettingsList)
	
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = SettingsList
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 3)
	table.insert(Core, UIListLayout)
	
	local GuiBlurSetting = Instance.new("Frame")
	GuiBlurSetting.Parent = SettingsList
	GuiBlurSetting.ZIndex = 2
	GuiBlurSetting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GuiBlurSetting.BackgroundTransparency = 1.000
	GuiBlurSetting.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GuiBlurSetting.BorderSizePixel = 0
	GuiBlurSetting.Size = UDim2.new(1, 0, 0.0500000007, 0)
	table.insert(Core, GuiBlurSetting)
	
	local GuiBlurTitle = Instance.new("TextLabel")
	GuiBlurTitle.Parent = GuiBlurSetting
	GuiBlurTitle.ZIndex = 2
	GuiBlurTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GuiBlurTitle.BackgroundTransparency = 1.000
	GuiBlurTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GuiBlurTitle.BorderSizePixel = 0
	GuiBlurTitle.Position = UDim2.new(0.0450000018, 0, 0.245000005, 0)
	GuiBlurTitle.Size = UDim2.new(0.668749988, 0, 0.456140339, 0)
	GuiBlurTitle.Font = Enum.Font.Unknown
	GuiBlurTitle.Text = "Background Blur"
	GuiBlurTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
	GuiBlurTitle.TextScaled = true
	GuiBlurTitle.TextSize = 14.000
	GuiBlurTitle.TextWrapped = true
	GuiBlurTitle.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(Core, GuiBlurTitle)
	
	local ToggleCoreBlur = Instance.new("TextButton")
	ToggleCoreBlur.Parent = GuiBlurSetting
	ToggleCoreBlur.ZIndex = 2
	ToggleCoreBlur.BackgroundColor3 = Color3.fromRGB(238, 238, 238)
	ToggleCoreBlur.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ToggleCoreBlur.BorderSizePixel = 0
	ToggleCoreBlur.Position = UDim2.new(0.899999976, 0, 0.245000005, 0)
	ToggleCoreBlur.Size = UDim2.new(0.081249997, 0, 0.456140339, 0)
	ToggleCoreBlur.Font = Enum.Font.SourceSans
	ToggleCoreBlur.Text = ""
	ToggleCoreBlur.TextColor3 = Color3.fromRGB(0, 0, 0)
	ToggleCoreBlur.TextSize = 14.000
	local Blurred = false
	table.insert(Core, ToggleCoreBlur)
	ToggleCoreBlur.MouseButton1Click:Connect(function()
		Blurred = not Blurred
		if Blurred then
			Library.Settings.GuiBlur = false
			BlurFX.Enabled = false
			ToggleCoreBlur.BackgroundColor3 = Color3.fromRGB(110, 185, 255)
		else
			Library.Settings.GuiBlur = true
			ToggleCoreBlur.BackgroundColor3 = Color3.fromRGB(238, 238, 238)
		end
	end)
	
	local UICorner_4 = Instance.new("UICorner")
	UICorner_4.CornerRadius = UDim.new(1, 0)
	UICorner_4.Parent = ToggleCoreBlur
	table.insert(Core, UICorner_4)
	
	local CustomKeybind = Instance.new("Frame")
	CustomKeybind.Parent = SettingsList
	CustomKeybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CustomKeybind.BackgroundTransparency = 1.000
	CustomKeybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CustomKeybind.BorderSizePixel = 0
	CustomKeybind.ZIndex = 2
	CustomKeybind.Size = UDim2.new(1, 0, 0.0500000007, 0)
	table.insert(Core, CustomKeybind)

	local CustomKeybindName = Instance.new("TextLabel")
	CustomKeybindName.Parent = CustomKeybind
	CustomKeybindName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CustomKeybindName.BackgroundTransparency = 1.000
	CustomKeybindName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CustomKeybindName.BorderSizePixel = 0
	CustomKeybindName.Position = UDim2.new(0.0450000018, 0, 0.245000005, 0)
	CustomKeybindName.Size = UDim2.new(0.668749988, 0, 0.456140339, 0)
	CustomKeybindName.Font = Enum.Font.Unknown
	CustomKeybindName.Text = "Custom Keybind"
	CustomKeybindName.TextColor3 = Color3.fromRGB(0, 0, 0)
	CustomKeybindName.TextScaled = true
	CustomKeybindName.TextSize = 14.000
	CustomKeybindName.TextWrapped = true
	CustomKeybindName.ZIndex = 2
	CustomKeybindName.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(Core, CustomKeybindName)

	local CustomKeybindTextbox = Instance.new("TextBox")
	CustomKeybindTextbox.Parent = CustomKeybind
	CustomKeybindTextbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CustomKeybindTextbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CustomKeybindTextbox.BorderSizePixel = 0
	CustomKeybindTextbox.Position = UDim2.new(0.621748745, 0, 0.28007862, 0)
	CustomKeybindTextbox.Size = UDim2.new(0.375, 0, 0.456140339, 0)
	CustomKeybindTextbox.Font = Enum.Font.Unknown
	CustomKeybindTextbox.PlaceholderText = Library.Settings.GuiKeybind
	CustomKeybindTextbox.Text = ""
	CustomKeybindTextbox.ZIndex = 2
	CustomKeybindTextbox.TextColor3 = Color3.fromRGB(0, 0, 0)
	CustomKeybindTextbox.TextScaled = true
	CustomKeybindTextbox.TextSize = 14.000
	CustomKeybindTextbox.TextWrapped = true
	CustomKeybindTextbox.TextXAlignment = Enum.TextXAlignment.Left
	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.UserInputType == Enum.UserInputType.Keyboard then
			if CustomKeybindTextbox:IsFocused() then
				Library.Settings.GuiKeybind = Input.KeyCode.Name
				CustomKeybindTextbox.Text = Input.KeyCode.Name
				CustomKeybindTextbox:ReleaseFocus() 
			end       
		end
	end)
	table.insert(Core, CustomKeybindTextbox)
	
	local GuiUninject = Instance.new("Frame")
	GuiUninject.Parent = SettingsList
	GuiUninject.ZIndex = 2
	GuiUninject.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GuiUninject.BackgroundTransparency = 1.000
	GuiUninject.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GuiUninject.BorderSizePixel = 0
	GuiUninject.Size = UDim2.new(1, 0, 0.0500000007, 0)
	table.insert(Core, GuiUninject)

	local GuiUninjectTitle = Instance.new("TextLabel")
	GuiUninjectTitle.Parent = GuiUninject
	GuiUninjectTitle.ZIndex = 2
	GuiUninjectTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GuiUninjectTitle.BackgroundTransparency = 1.000
	GuiUninjectTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GuiUninjectTitle.BorderSizePixel = 0
	GuiUninjectTitle.Position = UDim2.new(0.0450000018, 0, 0.245000005, 0)
	GuiUninjectTitle.Size = UDim2.new(0.668749988, 0, 0.456140339, 0)
	GuiUninjectTitle.Font = Enum.Font.Unknown
	GuiUninjectTitle.Text = "Uninject"
	GuiUninjectTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
	GuiUninjectTitle.TextScaled = true
	GuiUninjectTitle.TextSize = 14.000
	GuiUninjectTitle.TextWrapped = true
	GuiUninjectTitle.TextXAlignment = Enum.TextXAlignment.Left
	table.insert(Core, GuiUninjectTitle)

	local ToggleCoreBlurUninject = Instance.new("TextButton")
	ToggleCoreBlurUninject.Parent = GuiUninject
	ToggleCoreBlurUninject.ZIndex = 2
	ToggleCoreBlurUninject.BackgroundColor3 = Color3.fromRGB(238, 238, 238)
	ToggleCoreBlurUninject.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ToggleCoreBlurUninject.BorderSizePixel = 0
	ToggleCoreBlurUninject.Position = UDim2.new(0.899999976, 0, 0.245000005, 0)
	ToggleCoreBlurUninject.Size = UDim2.new(0.081249997, 0, 0.456140339, 0)
	ToggleCoreBlurUninject.Font = Enum.Font.SourceSans
	ToggleCoreBlurUninject.Text = ""
	ToggleCoreBlurUninject.TextColor3 = Color3.fromRGB(0, 0, 0)
	ToggleCoreBlurUninject.TextSize = 14.000
	table.insert(Core, ToggleCoreBlurUninject)
	ToggleCoreBlurUninject.MouseButton1Click:Connect(function()
		Library.Uninjected = true
		UninjectAll()
	end)
	
	local UICorner_69 = Instance.new("UICorner")
	UICorner_69.CornerRadius = UDim.new(1, 0)
	UICorner_69.Parent = ToggleCoreBlurUninject
	table.insert(Core, UICorner_69)
	
	local SettingOpen = Instance.new("TextButton")
	SettingOpen.Parent = ScreenGui
	SettingOpen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SettingOpen.BackgroundTransparency = 0.450
	SettingOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingOpen.BorderSizePixel = 0
	SettingOpen.Position = UDim2.new(0.915, 0, 0.856, 0)
	SettingOpen.Size = UDim2.new(0, 60, 0, 40)
	SettingOpen.Visible = false
	SettingOpen.AutoButtonColor = false
	SettingOpen.Font = Enum.Font.SourceSans
	SettingOpen.LineHeight = 0.000
	SettingOpen.Text = "···"
	SettingOpen.TextColor3 = Color3.fromRGB(0, 0, 0)
	SettingOpen.TextScaled = true
	SettingOpen.TextSize = 14.000
	SettingOpen.TextTransparency = 0.250
	SettingOpen.TextWrapped = true
	SettingOpen.TextYAlignment = Enum.TextYAlignment.Bottom
	table.insert(Core, SettingOpen)
	
	local UICorner = Instance.new("UICorner")
	UICorner.Parent = SettingOpen
	table.insert(Core, UICorner)
	
	local HudMain = Instance.new("Frame")
	HudMain.Parent = ScreenGui
	HudMain.AnchorPoint = Vector2.new(0.5, 0.5)
	HudMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HudMain.BackgroundTransparency = 1.000
	HudMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudMain.BorderSizePixel = 0
	HudMain.Position = UDim2.new(0.5, 0, 0.5, 0)
	HudMain.Size = UDim2.new(1, 0, 1, 0)
	
	
	


















	SettingOpen.MouseButton1Click:Connect(function()
		SettingsHolder.Visible = true
	end)
	
	SettingsClose.MouseButton1Click:Connect(function()
		SettingsHolder.Visible = false
	end)
	
	GUIOpen.MouseButton1Click:Connect(function()
		TabsHolder.Visible = not TabsHolder.Visible
		SettingOpen.Visible = TabsHolder.Visible
		if Library.Settings.GuiBlur then
			BlurFX.Enabled = TabsHolder.Visible
		end
	end)
	
	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.KeyCode == Enum.KeyCode[Library.Settings.GuiKeybind] and not isTyping then
			TabsHolder.Visible = not TabsHolder.Visible
			SettingOpen.Visible = not SettingOpen.Visible
			if Library.Settings.GuiBlur then
				BlurFX.Enabled = TabsHolder.Visible
			end
		end
	end)
	
	
	
	
	return Core
end

return Library
