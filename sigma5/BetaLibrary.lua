--Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Font = game:GetService("TextService")
local TouchInput = game:GetService("TouchInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = game.Players.LocalPlayer

--LibraryFunctions
local SigmaLibrary = {
	MobileSupport = false,
	ClickGUIAnimations = false,
	ClickGUIBlur = false
}

local soundIds = {
	OnEnabled = 3318713980,
	OnEnabledOriginal = 14393273745,
	OnDisabled = 3318714899,
	OnDisabledOriginal = 14393278136,
	OnError = 9066167010,
	OnErrorOriginal = {}
}

function SigmaLibrary:Setting(normal, advance)
	for i, v in pairs(normal) do
		if advance[i] == nil then
			advance[i] = v
		end
	end
	return advance
end

function SigmaLibrary:Create(instanceType, properties)
	local instance = Instance.new(instanceType)
	for property, value in pairs(properties) do
		instance[property] = value
	end
	return instance
end

function SigmaLibrary:FadeEffect(object, properties)
	local TweenProperties = TweenInfo.new(properties.time or 0.10, properties.easingStyle or Enum.EasingStyle.Quad, properties.easingDirection or Enum.EasingDirection.Out)
	local TweenAnim = TweenService:Create(object, TweenProperties, properties)
	TweenAnim:Play()
end

function PlaySound(soundId)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. soundId
	sound.Parent = game.Workspace
	sound:Play()

	sound.Ended:Connect(function()
		sound:Destroy()
	end)
end

local function onInputBegan(Choosed, KEYYY)
	return function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode[KEYYY] and not gameProcessedEvent then
			Choosed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
end

local function onInputEnded(Choosed, KEYYY)
	return function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode[KEYYY] and not gameProcessedEvent then
			Choosed.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		end
	end
end

--Library
function SigmaLibrary:CreateCore()
	--CreateMain
	local ScreenGui = Instance.new("ScreenGui")
	if game:GetService("RunService"):IsStudio() then
		ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	else
		ScreenGui.Parent = CoreGui
	end
	ScreenGui.Name = "Sigma4Roblox"
	
	local MainTabHolder = Instance.new("Frame", ScreenGui)
	MainTabHolder.Name = "MainTabHolder"
	MainTabHolder.BackgroundColor3 = Color3.new(1, 1, 1)
	MainTabHolder.BackgroundTransparency = 1
	MainTabHolder.BorderColor3 = Color3.new(0, 0, 0)
	MainTabHolder.BorderSizePixel = 0
	MainTabHolder.Size = UDim2.new(1, 100, 1, 0)
	MainTabHolder.Visible = false
	MainTabHolder.ZIndex = 2
	
	local TabsScrollingList = Instance.new("ScrollingFrame", MainTabHolder)
	TabsScrollingList.Name = "TabsScrollingList"
	TabsScrollingList.Active = true
	TabsScrollingList.BackgroundColor3 = Color3.new(1, 1, 1)
	TabsScrollingList.BackgroundTransparency = 1
	TabsScrollingList.BorderColor3 = Color3.new(0, 0, 0)
	TabsScrollingList.BorderSizePixel = 0
	TabsScrollingList.Size = UDim2.new(1, 0, 1, 0)
	TabsScrollingList.CanvasSize = UDim2.new(2, 0, 0, 0)
	TabsScrollingList.ScrollBarThickness = 3
	
	local UIPadding1 = Instance.new("UIPadding", TabsScrollingList)
	UIPadding1.PaddingLeft = UDim.new(0.008, 0)
	UIPadding1.PaddingTop = UDim.new(0.05, 0)
	
	local UIList1 = Instance.new("UIListLayout", TabsScrollingList)
	UIList1.SortOrder = Enum.SortOrder.LayoutOrder
	
	local BlurFX = Instance.new("BlurEffect", Lighting)
	BlurFX.Size = 28
	BlurFX.Enabled = false
	
	--CreateSettings
	local OpenSettingsMenu = Instance.new("TextButton", ScreenGui)
	OpenSettingsMenu.Name = "OpenSettingsMenu"
	OpenSettingsMenu.BackgroundColor3 = Color3.new(1, 1, 1)
	OpenSettingsMenu.BackgroundTransparency = 0.44999998807907104
	OpenSettingsMenu.BorderColor3 = Color3.new(0, 0, 0)
	OpenSettingsMenu.BorderSizePixel = 0
	OpenSettingsMenu.Position = UDim2.new(0.945623815, 0, 0.925012589, 0)
	OpenSettingsMenu.Size = UDim2.new(0.0450000018, 0, 0.0549999997, 0)
	OpenSettingsMenu.Visible = false
	OpenSettingsMenu.AutoButtonColor = false
	OpenSettingsMenu.Font = Enum.Font.Unknown
	OpenSettingsMenu.LineHeight = 0
	OpenSettingsMenu.Text = "···"
	OpenSettingsMenu.TextColor3 = Color3.new(0, 0, 0)
	OpenSettingsMenu.TextScaled = true
	OpenSettingsMenu.TextSize = 14
	OpenSettingsMenu.TextTransparency = 0.25
	OpenSettingsMenu.TextWrapped = true
	OpenSettingsMenu.TextYAlignment = Enum.TextYAlignment.Bottom
	
	local UICorner1 = Instance.new("UICorner", OpenSettingsMenu)
	UICorner1.CornerRadius = UDim2.new(0, 8)
	
	local SettingsMenu = Instance.new("Frame", ScreenGui)
	SettingsMenu.Name = "SettingsMenu"
	SettingsMenu.BackgroundColor3 = Color3.new(1, 1, 1)
	SettingsMenu.BorderColor3 = Color3.new(0, 0, 0)
	SettingsMenu.BorderSizePixel = 0
	SettingsMenu.Position = UDim2.new(0.868371785, 0, 0.622807026, 0)
	SettingsMenu.Size = UDim2.new(0.122000009, 0, 0.35720557, 0)
	SettingsMenu.Visible = false
	SettingsMenu.ZIndex = 2
	
	local UICorner2 = Instance.new("UICorner", SettingsMenu)
	UICorner2.CornerRadius = UDim2.new(0, 8)
	
	local SettingLine = Instance.new("Frame", SettingsMenu)
	SettingLine.Name = "SettingLine"
	SettingLine.BackgroundColor3 = Color3.new(0.960784, 0.960784, 0.960784)
	SettingLine.BorderColor3 = Color3.new(0, 0, 0)
	SettingLine.BorderSizePixel = 0
	SettingLine.Position = UDim2.new(0.904857993, 0, 0.176491886, 0)
	SettingLine.Size = UDim2.new(-0.800000012, 0, 0.00499999989, 0)
	
	local UICorner3 = Instance.new("UICorner", SettingLine)
	UICorner3.CornerRadius = UDim2.new(0, 8)
	
	local SettingsTitle = Instance.new("TextLabel", SettingsMenu)
	SettingsTitle.Name = "SettingText"
	SettingsTitle.BackgroundColor3 = Color3.new(1, 1, 1)
	SettingsTitle.BackgroundTransparency = 1
	SettingsTitle.BorderColor3 = Color3.new(0, 0, 0)
	SettingsTitle.BorderSizePixel = 0
	SettingsTitle.Position = UDim2.new(0.104999997, 0, 0.0549999997, 0)
	SettingsTitle.Size = UDim2.new(0.387505949, 0, 0.0899184644, 0)
	SettingsTitle.Font = Enum.Font.Unknown
	SettingsTitle.Text = "Settings"
	SettingsTitle.TextColor3 = Color3.new(0, 0, 0)
	SettingsTitle.TextScaled = true
	SettingsTitle.TextSize = 14
	SettingsTitle.TextWrapped = true
	
	local SettingsClose = Instance.new("TextBox", SettingsMenu)
	SettingsClose.Name = "SettingsClose"
	SettingsClose.BackgroundColor3 = Color3.new(1, 1, 1)
	SettingsClose.BackgroundTransparency = 1
	SettingsClose.BorderColor3 = Color3.new(0, 0, 0)
	SettingsClose.BorderSizePixel = 0
	SettingsClose.Position = UDim2.new(0.822993636, 0, 0.0696380958, 0)
	SettingsClose.Size = UDim2.new(0.0815821588, 0, 0.0556063056, 0)
	SettingsClose.AutoButtonColor = false
	SettingsClose.Font = Enum.Font.Unknown
	SettingsClose.Text = "X"
	SettingsClose.TextColor3 = Color3.new(0.431373, 0.72549, 1)
	SettingsClose.TextScaled = true
	SettingsClose.TextSize = 14
	SettingsClose.TextWrapped = true
	
	local SettingsModulesList = Instance.new("ScrollingFrame", SettingsMenu)
	SettingsModulesList.Name = "SettingsList"
	SettingsModulesList.Active = true
	SettingsModulesList.BackgroundColor3 = Color3.new(1, 1, 1)
	SettingsModulesList.BorderColor3 = Color3.new(0, 0, 0)
	SettingsModulesList.BorderSizePixel = 0
	SettingsModulesList.Position = UDim2.new(0.100000001, 0, 0.224999994, 0)
	SettingsModulesList.Size = UDim2.new(0.800000012, 0, 0.685000002, 0)
	SettingsModulesList.ScrollBarThickness = 0
	
	local UIList2 = Instance.new("UIListLayout", SettingsModulesList) 
	UIList2.SortOrder = Enum.SortOrder.LayoutOrder
	UIList2.Padding = UDim.new(0, 3)
	
	--SettingsMobileSupport
	
	local MobileSupportSettings = Instance.new("Frame", SettingsModulesList)
	MobileSupportSettings.Name = "MobileSupportSettings"
	MobileSupportSettings.BackgroundColor3 = Color3.new(1, 1, 1)
	MobileSupportSettings.BackgroundTransparency = 1
	MobileSupportSettings.BorderColor3 = Color3.new(0, 0, 0)
	MobileSupportSettings.BorderSizePixel = 0
	MobileSupportSettings.Size = UDim2.new(1, 0, 0.0500000007, 0)
	
	local MobileSupportSettingsName = Instance.new("TextLabel", MobileSupportSettings)
	MobileSupportSettingsName.Name = "SettingToggleName"
	MobileSupportSettingsName.BackgroundColor3 = Color3.new(1, 1, 1)
	MobileSupportSettingsName.BackgroundTransparency = 1
	MobileSupportSettingsName.BorderColor3 = Color3.new(0, 0, 0)
	MobileSupportSettingsName.BorderSizePixel = 0
	MobileSupportSettingsName.Position = UDim2.new(0.0450000018, 0, 0.245000005, 0)
	MobileSupportSettingsName.Size = UDim2.new(0.672986567, 0, 0.473778754, 0)
	MobileSupportSettingsName.Font = Enum.Font.Unknown
	MobileSupportSettingsName.Text = "Mobile Supports"
	MobileSupportSettingsName.TextColor3 = Color3.new(0, 0, 0)
	MobileSupportSettingsName.TextScaled = true
	MobileSupportSettingsName.TextSize = 14
	MobileSupportSettingsName.TextWrapped = true
	MobileSupportSettingsName.TextXAlignment = Enum.TextXAlignment.Left
	
	local MobileSupportSettingsCore = Instance.new("TextButton", MobileSupportSettings)
	MobileSupportSettingsCore.Name = "ToggleCore"
	MobileSupportSettingsCore.BackgroundColor3 = Color3.new(0.933333, 0.933333, 0.933333)
	MobileSupportSettingsCore.BorderColor3 = Color3.new(0, 0, 0)
	MobileSupportSettingsCore.BorderSizePixel = 0
	MobileSupportSettingsCore.Position = UDim2.new(0.899999976, 0, 0.245000005, 0)
	MobileSupportSettingsCore.Size = UDim2.new(0.0850000009, 0, 0.460000008, 0)
	MobileSupportSettingsCore.Font = Enum.Font.SourceSans
	MobileSupportSettingsCore.Text = ""
	MobileSupportSettingsCore.TextColor3 = Color3.new(0, 0, 0)
	MobileSupportSettingsCore.TextSize = 14

	local UICorner4 = Instance.new("UICorner", MobileSupportSettingsCore)
	UICorner4.CornerRadius = UDim.new(1, 0)
	
	MobileSupportSettingsCore.MouseButton1Click:Connect(function()
		SigmaLibrary.MobileSupport = not SigmaLibrary.MobileSupport
	end)
	
	--[[ SettingsClickGUIAnimations
	
	local ClickGUIAnimationSettings = Instance.new("Frame", SettingsModulesList)
	ClickGUIAnimationSettings.Name = "ClickGUIAnimationSettings"
	ClickGUIAnimationSettings.BackgroundColor3 = Color3.new(1, 1, 1)
	ClickGUIAnimationSettings.BackgroundTransparency = 1
	ClickGUIAnimationSettings.BorderColor3 = Color3.new(0, 0, 0)
	ClickGUIAnimationSettings.BorderSizePixel = 0
	ClickGUIAnimationSettings.Size = UDim2.new(1, 0, 0.0500000007, 0)

	local ClickGUIAnimationSettingsName = Instance.new("TextLabel", MobileSupportSettings)
	ClickGUIAnimationSettingsName.Name = "SettingToggleName"
	ClickGUIAnimationSettingsName.BackgroundColor3 = Color3.new(1, 1, 1)
	ClickGUIAnimationSettingsName.BackgroundTransparency = 1
	ClickGUIAnimationSettingsName.BorderColor3 = Color3.new(0, 0, 0)
	ClickGUIAnimationSettingsName.BorderSizePixel = 0
	ClickGUIAnimationSettingsName.Position = UDim2.new(0.0450000018, 0, 0.245000005, 0)
	ClickGUIAnimationSettingsName.Size = UDim2.new(0.672986567, 0, 0.473778754, 0)
	ClickGUIAnimationSettingsName.Font = Enum.Font.Unknown
	ClickGUIAnimationSettingsName.Text = "UI-Animations"
	ClickGUIAnimationSettingsName.TextColor3 = Color3.new(0, 0, 0)
	ClickGUIAnimationSettingsName.TextScaled = true
	ClickGUIAnimationSettingsName.TextSize = 14
	ClickGUIAnimationSettingsName.TextWrapped = true
	ClickGUIAnimationSettingsName.TextXAlignment = Enum.TextXAlignment.Left

	local ClickGUIAnimationSettingsCore = Instance.new("TextButton", MobileSupportSettings)
	ClickGUIAnimationSettingsCore.Name = "ToggleCore"
	ClickGUIAnimationSettingsCore.BackgroundColor3 = Color3.new(0.933333, 0.933333, 0.933333)
	ClickGUIAnimationSettingsCore.BorderColor3 = Color3.new(0, 0, 0)
	ClickGUIAnimationSettingsCore.BorderSizePixel = 0
	ClickGUIAnimationSettingsCore.Position = UDim2.new(0.899999976, 0, 0.245000005, 0)
	ClickGUIAnimationSettingsCore.Size = UDim2.new(0.0850000009, 0, 0.460000008, 0)
	ClickGUIAnimationSettingsCore.Font = Enum.Font.SourceSans
	ClickGUIAnimationSettingsCore.Text = ""
	ClickGUIAnimationSettingsCore.TextColor3 = Color3.new(0, 0, 0)
	ClickGUIAnimationSettingsCore.TextSize = 14

	local UICorner5 = Instance.new("UICorner", ClickGUIAnimationSettingsCore)
	UICorner5.CornerRadius = UDim.new(1, 0)
	
	ClickGUIAnimationSettingsCore.MouseButton1Click:Connect(function()
		SigmaLibrary.ClickGUIAnimations = not SigmaLibrary.ClickGUIAnimations
	end)
	--]]
	
	--SettingsClickGUIBlurs
	
	local ClickGUIBlurSettings = Instance.new("Frame", SettingsModulesList)
	ClickGUIBlurSettings.Name = "ClickGUIAnimationSettings"
	ClickGUIBlurSettings.BackgroundColor3 = Color3.new(1, 1, 1)
	ClickGUIBlurSettings.BackgroundTransparency = 1
	ClickGUIBlurSettings.BorderColor3 = Color3.new(0, 0, 0)
	ClickGUIBlurSettings.BorderSizePixel = 0
	ClickGUIBlurSettings.Size = UDim2.new(1, 0, 0.0500000007, 0)

	local ClickGUIBlurSettingsName = Instance.new("TextLabel", MobileSupportSettings)
	ClickGUIBlurSettingsName.Name = "SettingToggleName"
	ClickGUIBlurSettingsName.BackgroundColor3 = Color3.new(1, 1, 1)
	ClickGUIBlurSettingsName.BackgroundTransparency = 1
	ClickGUIBlurSettingsName.BorderColor3 = Color3.new(0, 0, 0)
	ClickGUIBlurSettingsName.BorderSizePixel = 0
	ClickGUIBlurSettingsName.Position = UDim2.new(0.0450000018, 0, 0.245000005, 0)
	ClickGUIBlurSettingsName.Size = UDim2.new(0.672986567, 0, 0.473778754, 0)
	ClickGUIBlurSettingsName.Font = Enum.Font.Unknown
	ClickGUIBlurSettingsName.Text = "UI-Blurs"
	ClickGUIBlurSettingsName.TextColor3 = Color3.new(0, 0, 0)
	ClickGUIBlurSettingsName.TextScaled = true
	ClickGUIBlurSettingsName.TextSize = 14
	ClickGUIBlurSettingsName.TextWrapped = true
	ClickGUIBlurSettingsName.TextXAlignment = Enum.TextXAlignment.Left

	local ClickGUIBlurSettingsCore = Instance.new("TextButton", MobileSupportSettings)
	ClickGUIBlurSettingsCore.Name = "ToggleCore"
	ClickGUIBlurSettingsCore.BackgroundColor3 = Color3.new(0.933333, 0.933333, 0.933333)
	ClickGUIBlurSettingsCore.BorderColor3 = Color3.new(0, 0, 0)
	ClickGUIBlurSettingsCore.BorderSizePixel = 0
	ClickGUIBlurSettingsCore.Position = UDim2.new(0.899999976, 0, 0.245000005, 0)
	ClickGUIBlurSettingsCore.Size = UDim2.new(0.0850000009, 0, 0.460000008, 0)
	ClickGUIBlurSettingsCore.Font = Enum.Font.SourceSans
	ClickGUIBlurSettingsCore.Text = ""
	ClickGUIBlurSettingsCore.TextColor3 = Color3.new(0, 0, 0)
	ClickGUIBlurSettingsCore.TextSize = 14
	
	ClickGUIBlurSettingsCore.MouseButton1Click:Connect(function()
		SigmaLibrary.ClickGUIBlur = not SigmaLibrary.ClickGUIBlur
	end)
	
	local MobileSupport1 = Instance.new("TextButton", ScreenGui)
	MobileSupport1.BorderSizePixel = 0
	MobileSupport1.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
	MobileSupport1.TextSize = 8
	MobileSupport1.TextColor3 = Color3.fromRGB(0, 0, 0)
	MobileSupport1.Size = UDim2.new(0, 23, 0, 23)
	MobileSupport1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MobileSupport1.Text = "+"
	MobileSupport1.ZIndex = 2
	MobileSupport1.Name = "MobileOpenUI"
	MobileSupport1.Position = UDim2.new(0.963096738, 0, 0.351765305, 0)
	MobileSupport1.AutoButtonColor = false
	MobileSupport1.TextTransparency = 0.250
	MobileSupport1.Visible = false
	
	local UICorner6 = Instance.new("UICorner", MobileSupport1)
	UICorner6.CornerRadius = UDim.new(0, 8)
	
	if SigmaLibrary.MobileSupport then
		MobileSupport1.Visible = true
	else
		MobileSupport1.Visible = false
	end
	
	--Hud's
	
	local HudsHolder = Instance.new("Frame", ScreenGui)
	HudsHolder.Name = "HudHolder"
	HudsHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	HudsHolder.BackgroundColor3 = Color3.new(1, 1, 1)
	HudsHolder.BackgroundTransparency = 1
	HudsHolder.BorderColor3 = Color3.new(0, 0, 0)
	HudsHolder.BorderSizePixel = 0
	HudsHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	HudsHolder.Size = UDim2.new(1, 0, 1, 0)
	
	--Hud's LeftSide
	
	local HudLeftSide = Instance.new("Frame", HudsHolder)
	HudLeftSide.Name = "HudLeftSide"
	HudLeftSide.BackgroundColor3 = Color3.new(1, 1, 1)
	HudLeftSide.BackgroundTransparency = 1
	HudLeftSide.BorderColor3 = Color3.new(0, 0, 0)
	HudLeftSide.BorderSizePixel = 0
	HudLeftSide.Size = UDim2.new(0.193051174, 0, 1, 0)
	
	local UIList3 = Instance.new("UIListLayout", HudLeftSide)
	UIList3.SortOrder = Enum.SortOrder.LayoutOrder
	UIList3.Padding = UDim.new(0.0280000009, 0)
	
	local UIPadding2 = Instance.new("UIPadding", HudLeftSide)
	UIPadding2.PaddingLeft = UDim.new(0.0450000018, 0)
	UIPadding2.PaddingTop = UDim.new(0.00800000038, 0)
	
	--Sigma5-Logo
	local HudLogo = Instance.new("TextLabel", HudLeftSide)
	HudLogo.Name = "HudLogo"
	HudLogo.BackgroundColor3 = Color3.new(1, 1, 1)
	HudLogo.BackgroundTransparency = 1
	HudLogo.BorderColor3 = Color3.new(0, 0, 0)
	HudLogo.BorderSizePixel = 0
	HudLogo.Size = UDim2.new(0.990190744, 0, 0.0569620244, 0)
	HudLogo.Font = Enum.Font.Unknown
	HudLogo.Text = "Sigma"
	HudLogo.TextColor3 = Color3.new(0.921569, 0.921569, 0.921569)
	HudLogo.TextScaled = true
	HudLogo.TextSize = 14
	HudLogo.TextTransparency = 0.25
	HudLogo.TextWrapped = true
	HudLogo.Visible = true
	HudLogo.TextXAlignment = Enum.TextXAlignment.Left
	
	local LogoVersion = Instance.new("TextLabel", HudLogo)
	LogoVersion.Name = "LogoVersion"
	LogoVersion.BackgroundColor3 = Color3.new(1, 1, 1)
	LogoVersion.BackgroundTransparency = 1
	LogoVersion.BorderColor3 = Color3.new(0, 0, 0)
	LogoVersion.BorderSizePixel = 0
	LogoVersion.Position = UDim2.new(0, 0, 0.850000024, 0)
	LogoVersion.Size = UDim2.new(0.155172408, 0, 0.444444448, 0)
	LogoVersion.Font = Enum.Font.Unknown
	LogoVersion.Text = "Jello"
	LogoVersion.TextColor3 = Color3.new(0.921569, 0.921569, 0.921569)
	LogoVersion.TextScaled = true
	LogoVersion.TextSize = 14
	LogoVersion.TextTransparency = 0.25
	LogoVersion.TextWrapped = true
	LogoVersion.TextXAlignment = Enum.TextXAlignment.Left
	
	--TabGUI
	
	local TabGUIHolder = Instance.new("Frame", HudLeftSide)
	TabGUIHolder.Name = "TabGUIHolder"
	TabGUIHolder.BackgroundColor3 = Color3.new(0.529412, 0.529412, 0.529412)
	TabGUIHolder.BackgroundTransparency = 0.44999998807907104
	TabGUIHolder.BorderColor3 = Color3.new(0, 0, 0)
	TabGUIHolder.BorderSizePixel = 0
	TabGUIHolder.Visible = false
	TabGUIHolder.Position = UDim2.new(0.029450262, 0, 0.109022558, 0)
	TabGUIHolder.Size = UDim2.new(0.443979084, 0, 0.182205543, 0)
	
	local UIList4 = Instance.new("UIListLayout", TabGUIHolder)
	UIList4.SortOrder = Enum.SortOrder.LayoutOrder
	
	local MovementFrame = Instance.new("Frame", TabGUIHolder)
	MovementFrame.Name = "MovementFrame"
	MovementFrame.BackgroundColor3 = Color3.new(0.294118, 0.294118, 0.294118)
	MovementFrame.BackgroundTransparency = 0.8500000238418579
	MovementFrame.BorderColor3 = Color3.new(0, 0, 0)
	MovementFrame.BorderSizePixel = 0
	MovementFrame.Size = UDim2.new(1, 0, 0.200000003, 0)
	
	local MovementFrameText = Instance.new("TextLabel", MovementFrame)
	MovementFrameText.Name = "MovementText"
	MovementFrameText.Parent = MovementFrame
	MovementFrameText.BackgroundColor3 = Color3.new(1, 1, 1)
	MovementFrameText.BackgroundTransparency = 1
	MovementFrameText.BorderColor3 = Color3.new(0, 0, 0)
	MovementFrameText.BorderSizePixel = 0
	MovementFrameText.Position = UDim2.new(0.147405699, 0, 0.137273937, 0)
	MovementFrameText.Size = UDim2.new(0.852594316, 0, 0.724065244, 0)
	MovementFrameText.Font = Enum.Font.SourceSans
	MovementFrameText.Text = "Movement"
	MovementFrameText.TextColor3 = Color3.new(1, 1, 1)
	MovementFrameText.TextScaled = true
	MovementFrameText.TextSize = 14
	MovementFrameText.TextWrapped = true
	MovementFrameText.TextXAlignment = Enum.TextXAlignment.Left
	
	local PlayerFrame = Instance.new("Frame", TabGUIHolder)
	PlayerFrame.Name = "PlayerFrame"
	PlayerFrame.BackgroundColor3 = Color3.new(0.607843, 0.607843, 0.607843)
	PlayerFrame.BackgroundTransparency = 0.8500000238418579
	PlayerFrame.BorderColor3 = Color3.new(0, 0, 0)
	PlayerFrame.BorderSizePixel = 0
	PlayerFrame.Size = UDim2.new(1, 0, 0.200000003, 0)

	local PlayerFrameText = Instance.new("TextLabel", PlayerFrame)
	PlayerFrameText.Name = "PlayerText"
	PlayerFrameText.BackgroundColor3 = Color3.new(1, 1, 1)
	PlayerFrameText.BackgroundTransparency = 1
	PlayerFrameText.BorderColor3 = Color3.new(0, 0, 0)
	PlayerFrameText.BorderSizePixel = 0
	PlayerFrameText.Position = UDim2.new(0.0737028271, 0, 0.171939179, 0)
	PlayerFrameText.Size = UDim2.new(0.852594376, 0, 0.621733606, 0)
	PlayerFrameText.Font = Enum.Font.SourceSans
	PlayerFrameText.Text = "Player"
	PlayerFrameText.TextColor3 = Color3.new(1, 1, 1)
	PlayerFrameText.TextScaled = true
	PlayerFrameText.TextSize = 14
	PlayerFrameText.TextWrapped = true
	PlayerFrameText.TextXAlignment = Enum.TextXAlignment.Left
	
	local CombatFrame = Instance.new("Frame", TabGUIHolder)
	CombatFrame.Name = "CombatFrame"
	CombatFrame.BackgroundColor3 = Color3.new(0.607843, 0.607843, 0.607843)
	CombatFrame.BackgroundTransparency = 0.8500000238418579
	CombatFrame.BorderColor3 = Color3.new(0, 0, 0)
	CombatFrame.BorderSizePixel = 0
	CombatFrame.Size = UDim2.new(1, 0, 0.200000003, 0)

	local CombatFrameText = Instance.new("TextLabel", CombatFrame)
	CombatFrameText.Name = "CombatText"
	CombatFrameText.BackgroundColor3 = Color3.new(1, 1, 1)
	CombatFrameText.BackgroundTransparency = 1
	CombatFrameText.BorderColor3 = Color3.new(0, 0, 0)
	CombatFrameText.BorderSizePixel = 0
	CombatFrameText.Position = UDim2.new(0.0737028271, 0, 0.171939179, 0)
	CombatFrameText.Size = UDim2.new(0.852594376, 0, 0.621733606, 0)
	CombatFrameText.Font = Enum.Font.SourceSans
	CombatFrameText.Text = "Combat"
	CombatFrameText.TextColor3 = Color3.new(1, 1, 1)
	CombatFrameText.TextScaled = true
	CombatFrameText.TextSize = 14
	CombatFrameText.TextWrapped = true
	CombatFrameText.TextXAlignment = Enum.TextXAlignment.Left

	local ItemFrame = Instance.new("Frame", TabGUIHolder)
	ItemFrame.Name = "ItemFrame"
	ItemFrame.BackgroundColor3 = Color3.new(0.607843, 0.607843, 0.607843)
	ItemFrame.BackgroundTransparency = 0.8500000238418579
	ItemFrame.BorderColor3 = Color3.new(0, 0, 0)
	ItemFrame.BorderSizePixel = 0
	ItemFrame.Size = UDim2.new(1, 0, 0.200000003, 0)

	local ItemFrameText = Instance.new("TextLabel", ItemFrame)
	ItemFrameText.Name = "ItemText"
	ItemFrameText.BackgroundColor3 = Color3.new(1, 1, 1)
	ItemFrameText.BackgroundTransparency = 1
	ItemFrameText.BorderColor3 = Color3.new(0, 0, 0)
	ItemFrameText.BorderSizePixel = 0
	ItemFrameText.Position = UDim2.new(0.0737028271, 0, 0.171939179, 0)
	ItemFrameText.Size = UDim2.new(0.852594376, 0, 0.621733606, 0)
	ItemFrameText.Font = Enum.Font.SourceSans
	ItemFrameText.Text = "Item"
	ItemFrameText.TextColor3 = Color3.new(1, 1, 1)
	ItemFrameText.TextScaled = true
	ItemFrameText.TextSize = 14
	ItemFrameText.TextWrapped = true
	ItemFrameText.TextXAlignment = Enum.TextXAlignment.Left

	local RenderFrame = Instance.new("Frame", TabGUIHolder)
	RenderFrame.Name = "RenderFrame"
	RenderFrame.BackgroundColor3 = Color3.new(0.607843, 0.607843, 0.607843)
	RenderFrame.BackgroundTransparency = 0.8500000238418579
	RenderFrame.BorderColor3 = Color3.new(0, 0, 0)
	RenderFrame.BorderSizePixel = 0
	RenderFrame.Size = UDim2.new(1, 0, 0.200000003, 0)
	
	local RenderFrameText = Instance.new("TextLabel", RenderFrame)
	RenderFrameText.Name = "RenderText"
	RenderFrameText.BackgroundColor3 = Color3.new(1, 1, 1)
	RenderFrameText.BackgroundTransparency = 1
	RenderFrameText.BorderColor3 = Color3.new(0, 0, 0)
	RenderFrameText.BorderSizePixel = 0
	RenderFrameText.Position = UDim2.new(0.0737028271, 0, 0.171939179, 0)
	RenderFrameText.Size = UDim2.new(0.852594376, 0, 0.621733606, 0)
	RenderFrameText.Font = Enum.Font.SourceSans
	RenderFrameText.Text = "Render"
	RenderFrameText.TextColor3 = Color3.new(1, 1, 1)
	RenderFrameText.TextScaled = true
	RenderFrameText.TextSize = 14
	RenderFrameText.TextWrapped = true
	RenderFrameText.TextXAlignment = Enum.TextXAlignment.Left
	
	--Keystrokes
	
	local KeystrokesHolder = Instance.new("Frame", HudLeftSide)
	KeystrokesHolder.Name = "KeystrokesHolder"
	KeystrokesHolder.BackgroundColor3 = Color3.new(1, 1, 1)
	KeystrokesHolder.BackgroundTransparency = 1
	KeystrokesHolder.BorderColor3 = Color3.new(0, 0, 0)
	KeystrokesHolder.BorderSizePixel = 0
	KeystrokesHolder.Visible = false
	KeystrokesHolder.Position = UDim2.new(-6.53541798e-09, 0, 0.295167595, 0)
	KeystrokesHolder.Size = UDim2.new(0.46453771, 0, 0.164629325, 0)
	
	local S = Instance.new("Frame", KeystrokesHolder)
	S.Name = "S"
	S.AnchorPoint = Vector2.new(0.5, 0.5)
	S.BackgroundColor3 = Color3.new(0, 0, 0)
	S.BackgroundTransparency = 0.6499999761581421
	S.BorderColor3 = Color3.new(0, 0, 0)
	S.BorderSizePixel = 0
	S.Position = UDim2.new(0.5, 0, 0.474999994, 0)
	S.Size = UDim2.new(0.284999996, 0, 0.294, 0)
	
	local SText = Instance.new("TextLabel", S)
	SText.Name = "SText"
	SText.AnchorPoint = Vector2.new(0.5, 0.5)
	SText.BackgroundColor3 = Color3.new(1, 1, 1)
	SText.BackgroundTransparency = 1
	SText.BorderColor3 = Color3.new(0, 0, 0)
	SText.BorderSizePixel = 0
	SText.Position = UDim2.new(0.5, 0, 0.5, 0)
	SText.Size = UDim2.new(0.5, 0, 0.5, 0)
	SText.Font = Enum.Font.Unknown
	SText.Text = "S"
	SText.TextColor3 = Color3.new(1, 1, 1)
	SText.TextScaled = true
	SText.TextSize = 14
	SText.TextWrapped = true

	local W = Instance.new("Frame", KeystrokesHolder)
	W.Name = "W"
	W.AnchorPoint = Vector2.new(0.5, 0.5)
	W.BackgroundColor3 = Color3.new(0, 0, 0)
	W.BackgroundTransparency = 0.6499999761581421
	W.BorderColor3 = Color3.new(0, 0, 0)
	W.BorderSizePixel = 0
	W.Position = UDim2.new(0.5, 0, 0.158000007, 0)
	W.Size = UDim2.new(0.285247982, 0, 0.294283658, 0)

	local WText = Instance.new("TextLabel", W)
	WText.Name = "WText"
	WText.AnchorPoint = Vector2.new(0.5, 0.5)
	WText.BackgroundColor3 = Color3.new(1, 1, 1)
	WText.BackgroundTransparency = 1
	WText.BorderColor3 = Color3.new(0, 0, 0)
	WText.BorderSizePixel = 0
	WText.Position = UDim2.new(0.5, 0, 0.5, 0)
	WText.Size = UDim2.new(0.5, 0, 0.5, 0)
	WText.Font = Enum.Font.Unknown
	WText.Text = "W"
	WText.TextColor3 = Color3.new(1, 1, 1)
	WText.TextScaled = true
	WText.TextSize = 14
	WText.TextWrapped = true

	local A = Instance.new("Frame", KeystrokesHolder)
	A.Name = "A"
	A.AnchorPoint = Vector2.new(0.5, 0.5)
	A.BackgroundColor3 = Color3.new(0, 0, 0)
	A.BackgroundTransparency = 0.6499999761581421
	A.BorderColor3 = Color3.new(0, 0, 0)
	A.BorderSizePixel = 0
	A.Position = UDim2.new(0.189999998, 0, 0.474999994, 0)
	A.Size = UDim2.new(0.284999996, 0, 0.294, 0)

	local AText = Instance.new("TextLabel", A)
	AText.Name = "AText"
	AText.AnchorPoint = Vector2.new(0.5, 0.5)
	AText.BackgroundColor3 = Color3.new(1, 1, 1)
	AText.BackgroundTransparency = 1
	AText.BorderColor3 = Color3.new(0, 0, 0)
	AText.BorderSizePixel = 0
	AText.Position = UDim2.new(0.5, 0, 0.5, 0)
	AText.Size = UDim2.new(0.5, 0, 0.5, 0)
	AText.Font = Enum.Font.Unknown
	AText.Text = "A"
	AText.TextColor3 = Color3.new(1, 1, 1)
	AText.TextScaled = true
	AText.TextSize = 14
	AText.TextWrapped = true

	local D = Instance.new("Frame", KeystrokesHolder)
	D.Name = "D"
	D.AnchorPoint = Vector2.new(0.5, 0.5)
	D.BackgroundColor3 = Color3.new(0, 0, 0)
	D.BackgroundTransparency = 0.6499999761581421
	D.BorderColor3 = Color3.new(0, 0, 0)
	D.BorderSizePixel = 0
	D.Position = UDim2.new(0.805000007, 0, 0.474999994, 0)
	D.Size = UDim2.new(0.284999996, 0, 0.294, 0)

	local DText = Instance.new("TextLabel", D)
	DText.Name = "DText"
	DText.AnchorPoint = Vector2.new(0.5, 0.5)
	DText.BackgroundColor3 = Color3.new(1, 1, 1)
	DText.BackgroundTransparency = 1
	DText.BorderColor3 = Color3.new(0, 0, 0)
	DText.BorderSizePixel = 0
	DText.Position = UDim2.new(0.5, 0, 0.5, 0)
	DText.Size = UDim2.new(0.5, 0, 0.5, 0)
	DText.Font = Enum.Font.Unknown
	DText.Text = "D"
	DText.TextColor3 = Color3.new(1, 1, 1)
	DText.TextScaled = true
	DText.TextSize = 14
	DText.TextWrapped = true

	local L = Instance.new("Frame", KeystrokesHolder)
	L.Name = "L"
	L.AnchorPoint = Vector2.new(0.5, 0.5)
	L.BackgroundColor3 = Color3.new(0, 0, 0)
	L.BackgroundTransparency = 0.6499999761581421
	L.BorderColor3 = Color3.new(0, 0, 0)
	L.BorderSizePixel = 0
	L.Position = UDim2.new(0.263760269, 0, 0.795000315, 0)
	L.Size = UDim2.new(0.432520568, 0, 0.294, 0)

	local LText = Instance.new("TextLabel", L)
	LText.Name = "LText"
	LText.AnchorPoint = Vector2.new(0.5, 0.5)
	LText.BackgroundColor3 = Color3.new(1, 1, 1)
	LText.BackgroundTransparency = 1
	LText.BorderColor3 = Color3.new(0, 0, 0)
	LText.BorderSizePixel = 0
	LText.Position = UDim2.new(0.5, 0, 0.5, 0)
	LText.Size = UDim2.new(0.5, 0, 0.5, 0)
	LText.Font = Enum.Font.Unknown
	LText.Text = "L"
	LText.TextColor3 = Color3.new(1, 1, 1)
	LText.TextScaled = true
	LText.TextSize = 14
	LText.TextWrapped = true

	local R = Instance.new("Frame", KeystrokesHolder)
	R.Name = "R"
	R.AnchorPoint = Vector2.new(0.5, 0.5)
	R.BackgroundColor3 = Color3.new(0, 0, 0)
	R.BackgroundTransparency = 0.6499999761581421
	R.BorderColor3 = Color3.new(0, 0, 0)
	R.BorderSizePixel = 0
	R.Position = UDim2.new(0.726156652, 0, 0.795000315, 0)
	R.Size = UDim2.new(0.435000002, 0, 0.294, 0)

	local RText = Instance.new("TextLabel", R)
	RText.Name = "RText"
	RText.AnchorPoint = Vector2.new(0.5, 0.5)
	RText.BackgroundColor3 = Color3.new(1, 1, 1)
	RText.BackgroundTransparency = 1
	RText.BorderColor3 = Color3.new(0, 0, 0)
	RText.BorderSizePixel = 0
	RText.Position = UDim2.new(0.5, 0, 0.5, 0)
	RText.Size = UDim2.new(0.5, 0, 0.5, 0)
	RText.Font = Enum.Font.Unknown
	RText.Text = "R"
	RText.TextColor3 = Color3.new(1, 1, 1)
	RText.TextScaled = true
	RText.TextSize = 14
	RText.TextWrapped = true
	
	UserInputService.InputBegan:Connect(onInputBegan(W, "W"))
	UserInputService.InputEnded:Connect(onInputEnded(W, "W"))

	UserInputService.InputBegan:Connect(onInputBegan(A, "A"))
	UserInputService.InputEnded:Connect(onInputEnded(A, "A"))

	UserInputService.InputBegan:Connect(onInputBegan(S, "S"))
	UserInputService.InputEnded:Connect(onInputEnded(S, "S"))

	UserInputService.InputBegan:Connect(onInputBegan(D, "D"))
	UserInputService.InputEnded:Connect(onInputEnded(D, "D"))

	UserInputService.InputBegan:Connect(onInputBegan(R, "MouseButton2"))
	UserInputService.InputEnded:Connect(onInputEnded(R, "MouseButton2"))

	UserInputService.InputBegan:Connect(onInputBegan(L, "MouseButton1"))
	UserInputService.InputEnded:Connect(onInputEnded(L, "MouseButton1"))
	
	--Cords
	local Cords = Instance.new("TextLabel", HudLeftSide)
	Cords.Name = "Cords"
	Cords.BackgroundColor3 = Color3.new(1, 1, 1)
	Cords.BackgroundTransparency = 1
	Cords.BorderColor3 = Color3.new(0, 0, 0)
	Cords.BorderSizePixel = 0
	Cords.Position = UDim2.new(9.80932313e-09, 0, 0.487796903, 0)
	Cords.Size = UDim2.new(0.443979084, 0, 0.0199692566, 0)
	Cords.Font = Enum.Font.Unknown
	Cords.Text = "191 85 22"
	Cords.TextColor3 = Color3.new(1, 1, 1)
	Cords.TextScaled = true
	Cords.TextSize = 14
	Cords.TextTransparency = 0.2800000011920929
	Cords.TextWrapped = true
	
	while true do
		Cords.Text = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
		task.wait()
	end
	
	--Hud's RightSide
	
	local HudRightSide = Instance.new("Frame", HudsHolder)
	HudRightSide.Name = "HUDRight"
	HudRightSide.BackgroundColor3 = Color3.new(1, 1, 1)
	HudRightSide.BackgroundTransparency = 1
	HudRightSide.BorderColor3 = Color3.new(0, 0, 0)
	HudRightSide.BorderSizePixel = 0
	HudRightSide.Position = UDim2.new(0.806573927, 0, 0, 0)
	HudRightSide.Size = UDim2.new(0.193051174, 0, 1, 0)
	
	--ActiveMods
	
	local ActiveModsHolder = Instance.new("Frame", HudRightSide)
	ActiveModsHolder.Name = "ActiveModsHolder"
	ActiveModsHolder.BackgroundColor3 = Color3.new(1, 1, 1)
	ActiveModsHolder.BackgroundTransparency = 1
	ActiveModsHolder.BorderColor3 = Color3.new(0, 0, 0)
	ActiveModsHolder.BorderSizePixel = 0
	ActiveModsHolder.Position = UDim2.new(0, 0, 0.0167719722, 0)
	ActiveModsHolder.Size = UDim2.new(0.95337379, 0, 0.983228028, 0)
	
	local UIList5 = Instance.new("UIListLayout", ActiveModsHolder)
	UIList5.SortOrder = Enum.SortOrder.LayoutOrder
	UIList5.Padding = UDim.new(0.00200000009, 0)
	
	local function AddActivatedMods(ModsName)
		local ActivatedMods = Instance.new("TextLabel", ActiveModsHolder)
		ActivatedMods.Name = ModsName
		ActivatedMods.BackgroundColor3 = Color3.new(1, 1, 1)
		ActivatedMods.BackgroundTransparency = 1
		ActivatedMods.BorderColor3 = Color3.new(0, 0, 0)
		ActivatedMods.BorderSizePixel = 0
		ActivatedMods.Size = UDim2.new(1, 0, 0.0283208098, 0)
		ActivatedMods.Font = Enum.Font.Unknown
		ActivatedMods.Text = ModsName
		ActivatedMods.TextColor3 = Color3.new(1, 1, 1)
		ActivatedMods.TextScaled = true
		ActivatedMods.TextSize = 14
		ActivatedMods.TextWrapped = true
		ActivatedMods.TextXAlignment = Enum.TextXAlignment.Right
		
		ActiveModsHolder.LayoutOrder = -#ModsName
	end
	
	local function RemoveActivatedMods(ModsName)
		for i, v in pairs(ActiveModsHolder:GetChildren()) do
			if v:IsA("TextLabel") and v.Name == ModsName then
				v:Destroy()
				break
			end
		end
	end
	
	--Notifications
	local function CreateNotification(NotificationName, NotificationInfo, NotificationDuration, Fired)
		
		local NotificationHolder = Instance.new("Frame", HudRightSide)
		NotificationHolder.Name = "NotificationHolder"
		NotificationHolder.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
		NotificationHolder.BackgroundTransparency = 0.15000000596046448
		NotificationHolder.BorderColor3 = Color3.new(0, 0, 0)
		NotificationHolder.BorderSizePixel = 0
		NotificationHolder.Position = UDim2.new(0.9, 0, 0.906, 0)
		NotificationHolder.Size = UDim2.new(0.955130398, 0, 0.0776942223, 0)
		NotificationHolder.Visible = false
		
		local NotificationTitle = Instance.new("TextButton", NotificationHolder)
		NotificationTitle.Name = "NotificationTitle"
		NotificationTitle.BackgroundColor3 = Color3.new(1, 1, 1)
		NotificationTitle.BackgroundTransparency = 1
		NotificationTitle.BorderColor3 = Color3.new(0, 0, 0)
		NotificationTitle.BorderSizePixel = 0
		NotificationTitle.Position = UDim2.new(0.257110417, 0, 0.177419394, 0)
		NotificationTitle.Size = UDim2.new(0.361706495, 0, 0.364516228, 0)
		NotificationTitle.Font = Enum.Font.Unknown
		NotificationTitle.Text = NotificationName
		NotificationTitle.TextColor3 = Color3.new(1, 1, 1)
		NotificationTitle.TextScaled = true
		NotificationTitle.TextSize = 14
		NotificationTitle.TextWrapped = true
		NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
		
		local NotificationImage = Instance.new("ImageLabel", NotificationHolder)
		NotificationImage.Name = "NotificationImage"
		NotificationImage.BackgroundColor3 = Color3.new(1, 1, 1)
		NotificationImage.BackgroundTransparency = 1
		NotificationImage.BorderColor3 = Color3.new(0, 0, 0)
		NotificationImage.BorderSizePixel = 0
		NotificationImage.Position = UDim2.new(0.044565808, 0, 0.177419394, 0)
		NotificationImage.Size = UDim2.new(0.132021099, 0, 0.622581184, 0)
		NotificationImage.Image = "rbxassetid://16826468454"
		
		local NotificationText = Instance.new("TextLabel", NotificationHolder)
		NotificationText.Name = "NotificationText"
		NotificationText.BackgroundColor3 = Color3.new(1, 1, 1)
		NotificationText.BackgroundTransparency = 1
		NotificationText.BorderColor3 = Color3.new(0, 0, 0)
		NotificationText.BorderSizePixel = 0
		NotificationText.Position = UDim2.new(0.257110417, 0, 0.580645263, 0)
		NotificationText.Size = UDim2.new(0.742889166, 0, 0.219355777, 0)
		NotificationText.Font = Enum.Font.Unknown
		NotificationText.Text = NotificationInfo
		NotificationText.TextColor3 = Color3.new(1, 1, 1)
		NotificationText.TextScaled = true
		NotificationText.TextSize = 14
		NotificationText.TextWrapped = true
		NotificationText.TextXAlignment = Enum.TextXAlignment.Left
		
		if Fired then
			NotificationHolder.Visible = true
			wait()
			NotificationHolder:TweenPosition(UDim2.new(0.043, 0, 0.906, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.8)

			wait(NotificationDuration)

			NotificationHolder:TweenPosition(UDim2.new(0.9, 0, 0.906, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.8)
			wait()
			NotificationHolder.Visible = false
		end
	end
	
	--CoreFunctions
	
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
			MainTabHolder.Visible = not MainTabHolder.Visible
			OpenSettingsMenu.Visible = not OpenSettingsMenu.Visible
			if SigmaLibrary.ClickGUIBlur then
				BlurFX.Enabled = MainTabHolder.Visible
			else
				BlurFX.Enabled = false
			end
		end
	end)
	
	OpenSettingsMenu.MouseButton1Click:Connect(function()
		SettingsMenu.Visible = not SettingsMenu.Visible
	end)
	
	--Tabs
	
	function SigmaLibrary:CreateTabs(tabName)
		local tabe = {}

		tabe.TabHolder = Instance.new("Frame", TabsScrollingList)
		tabe.TabHolder.Name = "TabHolder"
		tabe.TabHolder.BackgroundColor3 = Color3.new(1, 1, 1)
		tabe.TabHolder.BackgroundTransparency = 0.17999999225139618
		tabe.TabHolder.BorderColor3 = Color3.new(0, 0, 0)
		tabe.TabHolder.BorderSizePixel = 0
		tabe.TabHolder.Position = UDim2.new(9.16994569e-09, 0, 0, 0)
		tabe.TabHolder.Size = UDim2.new(0.0529999994, 0, 0.0710000023, 0)
		tabe.TabHolder.ZIndex = 2

		tabe.TabName = Instance.new("TextLabel", tabe.TabHolder)
		tabe.TabName.Name = "TabName"
		tabe.TabName.BackgroundColor3 = Color3.new(1, 1, 1)
		tabe.TabName.BackgroundTransparency = 1
		tabe.TabName.BorderColor3 = Color3.new(0, 0, 0)
		tabe.TabName.BorderSizePixel = 0
		tabe.TabName.Position = UDim2.new(0.0799999982, 0, 0.270000011, 0)
		tabe.TabName.Size = UDim2.new(1, 0, 0.479999989, 0)
		tabe.TabName.ZIndex = 2
		tabe.TabName.Font = Enum.Font.Unknown
		tabe.TabName.Text = tabName
		tabe.TabName.TextColor3 = Color3.new(0.411765, 0.411765, 0.411765)
		tabe.TabName.TextScaled = true
		tabe.TabName.TextSize = 14
		tabe.TabName.TextTransparency = 0.2800000011920929
		tabe.TabName.TextWrapped = true
		tabe.TabName.TextXAlignment = Enum.TextXAlignment.Left

		tabe.MainTogglesHolder = Instance.new("Frame", tabe.TabHolder)
		tabe.MainTogglesHolder.Name = "MainTogglesHolder"
		tabe.MainTogglesHolder.BackgroundColor3 = Color3.new(1, 1, 1)
		tabe.MainTogglesHolder.BackgroundTransparency = 1
		tabe.MainTogglesHolder.BorderColor3 = Color3.new(0, 0, 0)
		tabe.MainTogglesHolder.BorderSizePixel = 0
		tabe.MainTogglesHolder.Position = UDim2.new(0, 0, 0.99999994, 0)
		tabe.MainTogglesHolder.Size = UDim2.new(1, 0, 8, 0)

		tabe.TogglesScrollingList = Instance.new("ScrollingFrame", tabe.MainTogglesHolder)
		tabe.TogglesScrollingList.Name = "TogglesScrollingList"
		tabe.TogglesScrollingList.Active = true
		tabe.TogglesScrollingList.BackgroundColor3 = Color3.new(1, 1, 1)
		tabe.TogglesScrollingList.BorderColor3 = Color3.new(0, 0, 0)
		tabe.TogglesScrollingList.BorderSizePixel = 0
		tabe.TogglesScrollingList.Position = UDim2.new(0, 0, -3.44411077e-08, 0)
		tabe.TogglesScrollingList.Size = UDim2.new(1, 0, 0.52232182, 0)
		tabe.TogglesScrollingList.ZIndex = 2
		tabe.TogglesScrollingList.ScrollBarThickness = 0
		
		--Toggles
		function tabe:CreateToggles(advance)
			advance = SigmaLibrary:Setting({
				Name = "Invalid",
				Description = "Invalid",
				callback = function(enabled) end
			}, advance or {})

			local ToggleButton = {Enabled = advance.callback, MiniToggles = {}, Sliders = {}, Dropdowns = {}, TextBoxs = {}}
			
			--TogglePart
			ToggleButton.ToggleButtonHolder = Instance.new("TextButton", tabe.TogglesScrollingList)
			ToggleButton.ToggleButtonHolder.Name = "Toggle For" .. advance.Name
			ToggleButton.ToggleButtonHolder.BackgroundColor3 = Color3.new(1, 1, 1)
			ToggleButton.ToggleButtonHolder.BorderColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleButtonHolder.BorderSizePixel = 0
			ToggleButton.ToggleButtonHolder.Position = UDim2.new(-0.125095308, 0, 0.438973874, 0)
			ToggleButton.ToggleButtonHolder.Size = UDim2.new(1, 0, 0.0309999995, 0)
			ToggleButton.ToggleButtonHolder.ZIndex = 2
			ToggleButton.ToggleButtonHolder.AutoButtonColor = false
			ToggleButton.ToggleButtonHolder.Font = Enum.Font.SourceSans
			ToggleButton.ToggleButtonHolder.Text = ""
			ToggleButton.ToggleButtonHolder.TextColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleButtonHolder.TextSize = 1
			ToggleButton.ToggleButtonHolder.TextWrapped = true
			
			ToggleButton.ToggleButtonName = Instance.new("TextLabel", ToggleButton.ToggleButtonHolder)
			ToggleButton.ToggleButtonName.Name = "ToggleName"
			ToggleButton.ToggleButtonName.BackgroundColor3 = Color3.new(1, 1, 1)
			ToggleButton.ToggleButtonName.BackgroundTransparency = 1
			ToggleButton.ToggleButtonName.BorderColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleButtonName.BorderSizePixel = 0
			ToggleButton.ToggleButtonName.Position = UDim2.new(0.0799999908, 0, 0.1333334, 0)
			ToggleButton.ToggleButtonName.Size = UDim2.new(0.795000017, 0, 0.679999948, 0)
			ToggleButton.ToggleButtonName.ZIndex = 2
			ToggleButton.ToggleButtonName.Font = Enum.Font.Roboto
			ToggleButton.ToggleButtonName.Text = advance.Name
			ToggleButton.ToggleButtonName.TextColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleButtonName.TextScaled = true
			ToggleButton.ToggleButtonName.TextSize = 14
			ToggleButton.ToggleButtonName.TextWrapped = true
			ToggleButton.ToggleButtonName.TextXAlignment = Enum.TextXAlignment.Left
			
			ToggleButton.MobileSupport2 = Instance.new("TextButton", ToggleButton.ToggleButtonHolder)
			ToggleButton.MobileSupport2.Name = "Open"
			ToggleButton.MobileSupport2.BackgroundColor3 = Color3.new(1, 1, 1)
			ToggleButton.MobileSupport2.BackgroundTransparency = 1
			ToggleButton.MobileSupport2.BorderColor3 = Color3.new(0, 0, 0)
			ToggleButton.MobileSupport2.BorderSizePixel = 0
			ToggleButton.MobileSupport2.Position = UDim2.new(0.875, 0, 0.133000001, 0)
			ToggleButton.MobileSupport2.Size = UDim2.new(0.104698911, 0, 0.680000007, 0)
			ToggleButton.MobileSupport2.Visible = false
			ToggleButton.MobileSupport2.AutoButtonColor = false
			ToggleButton.MobileSupport2.Font = Enum.Font.Unknown
			ToggleButton.MobileSupport2.Text = "+"
			ToggleButton.MobileSupport2.TextColor3 = Color3.new(0, 0, 0)
			ToggleButton.MobileSupport2.TextScaled = true
			ToggleButton.MobileSupport2.TextSize = 14
			ToggleButton.MobileSupport2.TextWrapped = true
			
			if SigmaLibrary.MobileSupport then
				ToggleButton.MobileSupport2.Visible = true
			else
				ToggleButton.MobileSupport2.Visible = false
			end
			
			--MenuPart
			ToggleButton.ToggleMenu = Instance.new("Frame", ScreenGui)
			ToggleButton.ToggleMenu.Name = "ToggleMenu"
			ToggleButton.ToggleMenu.AnchorPoint = Vector2.new(0.5, 0.5)
			ToggleButton.ToggleMenu.BackgroundColor3 = Color3.new(0.972549, 0.972549, 0.972549)
			ToggleButton.ToggleMenu.BorderColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleMenu.BorderSizePixel = 0
			ToggleButton.ToggleMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
			ToggleButton.ToggleMenu.Size = UDim2.new(0.292999446, 0, 0.696716666, 0)
			ToggleButton.ToggleMenu.Visible = false
			
			ToggleButton.UICorner7 = Instance.new("UICorner", ToggleButton.ToggleMenu)
			ToggleButton.UICorner7.CornerRadius = UDim.new(0, 10)
			
			ToggleButton.ToggleMenuTitle = Instance.new("TextLabel", ToggleButton.ToggleMenu)
			ToggleButton.ToggleMenuTitle.Name = "ToggleMenuTitle"
			ToggleButton.ToggleMenuTitle.BackgroundColor3 = Color3.new(1, 1, 1)
			ToggleButton.ToggleMenuTitle.BackgroundTransparency = 1
			ToggleButton.ToggleMenuTitle.BorderColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleMenuTitle.BorderSizePixel = 0
			ToggleButton.ToggleMenuTitle.Position = UDim2.new(0, 0, -0.0850000009, 0)
			ToggleButton.ToggleMenuTitle.Size = UDim2.new(1, 0, 0.0729999989, 0)
			ToggleButton.ToggleMenuTitle.Font = Enum.Font.Roboto
			ToggleButton.ToggleMenuTitle.Text = advance.Name
			ToggleButton.ToggleMenuTitle.TextColor3 = Color3.new(1, 1, 1)
			ToggleButton.ToggleMenuTitle.TextScaled = true
			ToggleButton.ToggleMenuTitle.TextSize = 14
			ToggleButton.ToggleMenuTitle.TextWrapped = true
			ToggleButton.ToggleMenuTitle.TextXAlignment = Enum.TextXAlignment.Left
			
			ToggleButton.ToggleMenuClose = Instance.new("TextButton", ToggleButton.ToggleMenu)
			ToggleButton.ToggleMenuClose.Name = "SettingsClose"
			ToggleButton.ToggleMenuClose.BackgroundColor3 = Color3.new(1, 1, 1)
			ToggleButton.ToggleMenuClose.BackgroundTransparency = 1
			ToggleButton.ToggleMenuClose.BorderColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleMenuClose.BorderSizePixel = 0
			ToggleButton.ToggleMenuClose.Position = UDim2.new(0.930000007, 0, -0.0803958774, 0)
			ToggleButton.ToggleMenuClose.Size = UDim2.new(0.0700000003, 0, 0.0599999987, 0)
			ToggleButton.ToggleMenuClose.AutoButtonColor = false
			ToggleButton.ToggleMenuClose.Font = Enum.Font.Unknown
			ToggleButton.ToggleMenuClose.Text = "X"
			ToggleButton.ToggleMenuClose.TextColor3 = Color3.new(0.431373, 0.72549, 1)
			ToggleButton.ToggleMenuClose.TextScaled = true
			ToggleButton.ToggleMenuClose.TextSize = 14
			ToggleButton.ToggleMenuClose.TextWrapped = true
			ToggleButton.ToggleMenuClose.Visible = false
			
			if SigmaLibrary.MobileSupport then
				ToggleButton.ToggleMenuClose.Visible = true
			else
				ToggleButton.ToggleMenuClose.Visible = false
			end
			
			ToggleButton.ToggleMenuDescription = Instance.new("TextLabel", ToggleButton.ToggleMenu)
			ToggleButton.ToggleMenuDescription.Name = "ToggleMenuDescription"
			ToggleButton.ToggleMenuDescription.BackgroundColor3 = Color3.new(1, 1, 1)
			ToggleButton.ToggleMenuDescription.BackgroundTransparency = 1
			ToggleButton.ToggleMenuDescription.BorderColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleMenuDescription.BorderSizePixel = 0
			ToggleButton.ToggleMenuDescription.Position = UDim2.new(0.0556127615, 0, 0.0305764247, 0)
			ToggleButton.ToggleMenuDescription.Size = UDim2.new(0.927909434, 0, 0.0348790921, 0)
			ToggleButton.ToggleMenuDescription.Font = Enum.Font.Unknown
			ToggleButton.ToggleMenuDescription.Text = advance.Description
			ToggleButton.ToggleMenuDescription.TextColor3 = Color3.new(0.333333, 0.333333, 0.333333)
			ToggleButton.ToggleMenuDescription.TextScaled = true
			ToggleButton.ToggleMenuDescription.TextSize = 14
			ToggleButton.ToggleMenuDescription.TextWrapped = true
			ToggleButton.ToggleMenuDescription.TextXAlignment = Enum.TextXAlignment.Left
			
			ToggleButton.ToggleMenuScroll = Instance.new("ScrollingFrame", ToggleButton.ToggleMenu)
			ToggleButton.ToggleMenuScroll.Name = "ToggleMenuScroll"
			ToggleButton.ToggleMenuScroll.Active = true
			ToggleButton.ToggleMenuScroll.BackgroundColor3 = Color3.new(1, 1, 1)
			ToggleButton.ToggleMenuScroll.BackgroundTransparency = 1
			ToggleButton.ToggleMenuScroll.BorderColor3 = Color3.new(0, 0, 0)
			ToggleButton.ToggleMenuScroll.BorderSizePixel = 0
			ToggleButton.ToggleMenuScroll.Position = UDim2.new(0.0556125082, 0, 0.0985835195, 0)
			ToggleButton.ToggleMenuScroll.Size = UDim2.new(0.874387324, 0, 0.819208205, 0)
			ToggleButton.ToggleMenuScroll.ScrollBarThickness = 0
			
			ToggleButton.UIList6 = Instance.new("UIListLayout", ToggleButton.ToggleMenuScroll)
			ToggleButton.UIList6.SortOrder = Enum.SortOrder.LayoutOrder
			ToggleButton.UIList6.Padding = UDim.new(0, 8)
			
			local function ToggleButtonFunc()
				if ToggleButton.Enabled then
					SigmaLibrary:FadeEffect(ToggleButton.ToggleButtonHolder, {BackgroundColor3 = Color3.fromRGB(110, 185, 255)})
					SigmaLibrary:FadeEffect(ToggleButton.ToggleButtonName, {TextColor3 = Color3.fromRGB(255, 255, 255)})
					ToggleButton.ToggleButtonName = "   " .. advance.Name
					AddActivatedMods(advance.Name)
					PlaySound(soundIds.OnEnabled)
				else
					SigmaLibrary:FadeEffect(ToggleButton.ToggleButtonHolder, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
					SigmaLibrary:FadeEffect(ToggleButton.ToggleButtonName, {TextColor3 = Color3.fromRGB(0, 0, 0)})
					ToggleButton.ToggleButtonName = advance.Name
					RemoveActivatedMods(advance.Name)
					PlaySound(soundIds.OnDisabled)
				end
			end
			
			ToggleButton.ToggleButtonHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleButtonFunc()
				
				if advance.callback then
					advance.callback = ToggleButton.Enabled
				end
			end)
			
			ToggleButton.ToggleButtonHolder.MouseButton2Click:Connect(function()
				ToggleButton.ToggleMenu.Visible = not ToggleButton.ToggleMenu.Visible
			end)
			
			
			ToggleButton.MobileSupport2.MouseButton1Click:Connect(function()
				ToggleButton.ToggleMenu.Visible = not ToggleButton.ToggleMenu.Visible
			end)
			
			ToggleButton.ToggleMenuClose.MouseButton1Click:Connect(function()
				ToggleButton.ToggleMenu.Visible = false
			end)
			
			ToggleButtonFunc()
			return ToggleButton
		end
		return tabe
	end
	return ScreenGui
end
return SigmaLibrary
