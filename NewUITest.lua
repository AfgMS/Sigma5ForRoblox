--Sigma5ForMobile
local CoreGui = game:GetService("CoreGui")
local Font = game:GetService("TextService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local Library = {}

local SoundList = {
	OnEnabled = 3318713980,
	OnEnabledOriginal = 14393273745,
	OnDisabled = 3318714899,
	OnDisabledOriginal = 14393278136,
	OnError = 9066167010,
	OnErrorOriginal = {}
}

function PlaySound(id)
	local sound = Instance.new("Sound", game.Workspace)
	sound.SoundId = "rbxassetid://" .. id
	sound:Play()

	sound.Ended:Connect(function()
		sound:Destroy()
	end)
end

function Library:FadeEffect(object, properties)
	local tweenInfo = TweenInfo.new(properties.time or 0.10, properties.easingStyle or Enum.EasingStyle.Quad, properties.easingDirection or Enum.EasingDirection.Out)
	local tween = TweenService:Create(object, tweenInfo, properties)
	tween:Play()
end

local SigmaVisual = Instance.new("ScreenGui")
SigmaVisual.ResetOnSpawn = false
SigmaVisual.Name = "Sigma5Visual"

local LeftHolder = Instance.new("Frame", SigmaVisual)
LeftHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftHolder.BackgroundTransparency = 1
LeftHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
LeftHolder.BorderSizePixel = 0
LeftHolder.Size = UDim2.new(0, 255, 1, 0)

local RightHolder = Instance.new("Frame", SigmaVisual)
RightHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RightHolder.BackgroundTransparency = 1
RightHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
RightHolder.BorderSizePixel = 0
RightHolder.Position = UDim2.new(0.842202961, 0, 0, 0)
RightHolder.Size = UDim2.new(0, 255, 1, 0)

local BlurEffect = Instance.new("BlurEffect", Lighting)
BlurEffect.Size = 28
BlurEffect.Enabled = false

function CreateNotification(NotificationName, NotificationText, NotificationDuration, Fired)
	
	local Notification = Instance.new("Frame", RightHolder)
	Notification.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Notification.BackgroundTransparency = 0.150
	Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(0, 130, 0, 285)
	--PosFired = {0, 15},{0, 715}
	--PosOld = {0, 255},{0, 715}
	Notification.Size = UDim2.new(0, 238, 0, 55)
	Notification.Visible = false

	local WarningIcon = Instance.new("ImageLabel", Notification)
	WarningIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WarningIcon.BackgroundTransparency = 1.000
	WarningIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WarningIcon.BorderSizePixel = 0
	WarningIcon.Position = UDim2.new(0, 10, 0, 13)
	WarningIcon.Size = UDim2.new(0, 30, 0, 30)
	WarningIcon.Image = "http://www.roblox.com/asset/?id=16826468454"
	WarningIcon.ScaleType = Enum.ScaleType.Fit

	local Name = Instance.new("TextLabel", Notification)
	Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Name.BackgroundTransparency = 1.000
	Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Name.BorderSizePixel = 0
	Name.Position = UDim2.new(0, 58, 0, 0)
	Name.Size = UDim2.new(0, 183, 0, 35)
	Name.Font = Enum.Font.SourceSans
	Name.Text = NotificationName
	Name.TextColor3 = Color3.fromRGB(255, 255, 255)
	Name.TextSize = 20.000
	Name.TextXAlignment = Enum.TextXAlignment.Left

	local Text = Instance.new("TextLabel", Notification)
	Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Text.BackgroundTransparency = 1.000
	Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Text.BorderSizePixel = 0
	Text.Position = UDim2.new(0, 57, 0, 20)
	Text.Size = UDim2.new(0, 183, 0, 35)
	Text.Font = Enum.Font.SourceSans
	Text.Text = NotificationText
	Text.TextColor3 = Color3.fromRGB(255, 255, 255)
	Text.TextSize = 15.000
	Text.TextXAlignment = Enum.TextXAlignment.Left

	local ShadowHolder = Instance.new("Frame", Notification)
	ShadowHolder.BackgroundTransparency = 1.000
	ShadowHolder.BorderSizePixel = 0
	ShadowHolder.Size = UDim2.new(1, 0, 1, 0)
	ShadowHolder.ZIndex = 0

	local Shadow = Instance.new("ImageLabel", ShadowHolder)
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.BackgroundTransparency = 1.000
	Shadow.BorderSizePixel = 0
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	Shadow.Size = UDim2.new(1, 47, 1, 47)
	Shadow.ZIndex = 0
	Shadow.Image = "rbxassetid://6015897843"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.500
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

	if Fired then
		Notification.Visible = true
		wait()
		Notification:TweenPosition(UDim2.new(0, -115, 0, 285), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.8)

		wait(NotificationDuration)

		Notification:TweenPosition(UDim2.new(0, 130, 0, 285), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.8)
		wait()
		Notification.Visible = false
	end
end

function Library:CreateCore(Fired)
	if Fired then
	local Sigma5 = Instance.new("ScreenGui")
	Sigma5.ResetOnSpawn = false
	Sigma5.Name = "sigma5"
	
	local TabsHolder = Instance.new("Frame", Sigma5)
	TabsHolder.Transparency = 1
	TabsHolder.Name = "AllTabsHere"
	TabsHolder.Size = UDim2.new(1, 0, 1, 0)
	TabsHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	TabsHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	
	local TabsList = Instance.new("UIListLayout", TabsHolder)
	TabsList.FillDirection = Enum.FillDirection.Horizontal
	TabsList.Padding = UDim.new(0, 8)

	local TabPadding = Instance.new("UIPadding", TabsHolder)
	TabPadding.PaddingLeft = UDim.new(0, 18)
	TabPadding.PaddingTop = UDim.new(0, 18)
end
end

function CreateTab(tabName)

	local TabHolder = Instance.new("Frame", CoreGui:WaitForChild("sigma5"):FindFirstChild("AllTabsHere"))
	TabHolder.BorderSizePixel = 0
	TabHolder.Tabs.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	TabHolder.BackgroundTransparency = 0.050
	TabHolder.Size = UDim2.new(0, 133, 0, 40)
	TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabHolder.ZIndex = 3
	TabHolder.Position = UDim2.new(0, 25, 0, 10)
	TabHolder.Name = "TabHolderz"
	TabHolder.Visible = false
	
	local TabName = Instance.new("TextLabel", TabHolder)
	TabName.BorderSizePixel = 0
	TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabName.TextXAlignment = Enum.TextXAlignment.Left
	TabName.Font = Enum.Font.Roboto
	TabName.TextSize = 18.000
	TabName.ZIndex = 3
	TabName.TextColor3 = Color3.fromRGB(95, 95, 95)
	TabName.Size = UDim2.new(1, 0, 1, 0)
	TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabName.Text = "    " .. tabName
	TabName.Name = "This tab name is" .. tabName
	TabName.TextTransparency = 0.350
	TabName.Position = UDim2.new(0, 0, 0, 0)
	TabName.TextStrokeTransparency = 0.990
	TabName.BackgroundTransparency = 1.000
	
	local TabScrollingHolder = Instance.new("Frame", TabHolder)
	TabScrollingHolder.BorderSizePixel = 0
	TabScrollingHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabScrollingHolder.BackgroundTransparency = 1.000
	TabScrollingHolder.Size = UDim2.new(0, 133, 0, 250)
	TabScrollingHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabScrollingHolder.ZIndex = 3
	TabScrollingHolder.Position = UDim2.new(0, 0, 0, 40)
	TabScrollingHolder.Name = "ScrollingHolder"
	TabScrollingHolder.Visible = false
	
	local TabButtonsHolder = Instance.new("ScrollingFrame", TabScrollingHolder)
	TabButtonsHolder.Active = true
	TabButtonsHolder.BorderSizePixel = 0
	TabButtonsHolder.ZIndex = 3
	TabButtonsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabButtonsHolder.Size = UDim2.new(0, 133, 0, 173)
	TabButtonsHolder.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	TabButtonsHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabButtonsHolder.ScrollBarThickness = 3
	TabButtonsHolder.CanvasSize = UDim2.new(0, 0, 1, 0)
	TabButtonsHolder.Name = "ScrollingModules"
	
	local ButtonsList = Instance.new("UIListLayout", TabButtonsHolder)
	ButtonsList.SortOrder = Enum.SortOrder.LayoutOrder

	local OpenToggleSetting4Mobile4Mobile = Instance.new("TextButton", CoreGui:WaitForChild("sigma5"))
	OpenToggleSetting4Mobile4Mobile.BorderSizePixel = 0
	OpenToggleSetting4Mobile4Mobile.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
	OpenToggleSetting4Mobile4Mobile.TextSize = 8
	OpenToggleSetting4Mobile4Mobile.TextColor3 = Color3.fromRGB(0, 0, 0)
	OpenToggleSetting4Mobile4Mobile.Size = UDim2.new(0, 23, 0, 23)
	OpenToggleSetting4Mobile4Mobile.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OpenToggleSetting4Mobile4Mobile.Text = "+"
	OpenToggleSetting4Mobile4Mobile.ZIndex = 2
	OpenToggleSetting4Mobile4Mobile.Name = "MobileFix1"
	OpenToggleSetting4Mobile4Mobile.Position = UDim2.new(0.963096738, 0, 0.351765305, 0)
	OpenToggleSetting4Mobile4Mobile.AutoButtonColor = false
	OpenToggleSetting4Mobile4Mobile.TextTransparency = 0.250

	local OpenToggleSetting4MobileCorner = Instance.new("UICorner", OpenToggleSetting4Mobile4Mobile)
	OpenToggleSetting4MobileCorner.CornerRadius = UDim.new(0, 8)
	
	OpenToggleSetting4Mobile4Mobile.MouseButton1Click:Connect(function()
		for _, tab in pairs(CoreGui:WaitForChild("sigma5"):GetChildren()) do
			if tab.Name == "TabHolderz" and tab:IsA("Frame") then
				tab.Visible = not tab.Visible
				BlurEffect.Enabled = not BlurEffect.Enabled
				if tab.ScrollingPart then
					tab.ScrollingPart.Visible = not tab.ScrollingPart.Visible
				end
			end
		end
	end)
	

function Library:CreateToggle(toggleName, Description, Fired, togglecallback)
	
	local ToggleHolders = Instance.new("TextButton", TabButtonsHolder)
	ToggleHolders.BorderSizePixel = 0
	ToggleHolders.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ToggleHolders.TextXAlignment = Enum.TextXAlignment.Left
	ToggleHolders.Font = Enum.Font.Roboto
	ToggleHolders.TextSize = 15.000
	ToggleHolders.TextColor3 = Color3.fromRGB(15, 15, 15)
	ToggleHolders.Size = UDim2.new(1, 0, 0, 20)
	ToggleHolders.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ToggleHolders.Text = "     " .. toggleName
	ToggleHolders.ZIndex = 3
	ToggleHolders.Name = toggleName
	ToggleHolders.Position = UDim2.new(0, 3, 0, 0)
	ToggleHolders.AutoButtonColor = false
	ToggleHolders.TextTransparency = 0.250
	
	local OpenToggleSetting4Mobile = Instance.new("TextButton", ToggleHolders)
	OpenToggleSetting4Mobile.BorderSizePixel = 0
	OpenToggleSetting4Mobile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OpenToggleSetting4Mobile.Font = Enum.Font.Roboto
	OpenToggleSetting4Mobile.TextSize = 15.000
	OpenToggleSetting4Mobile.TextColor3 = Color3.fromRGB(15, 15, 15)
	OpenToggleSetting4Mobile.Size = UDim2.new(0, 20, 0, 20)
	OpenToggleSetting4Mobile.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OpenToggleSetting4Mobile.Text = "+"
	OpenToggleSetting4Mobile.BackgroundTransparency = 0.050
	OpenToggleSetting4Mobile.ZIndex = 3
	OpenToggleSetting4Mobile.Name = "MobileFix2"
	OpenToggleSetting4Mobile.Position = UDim2.new(0, 113, 0, 0)
	OpenToggleSetting4Mobile.AutoButtonColor = false
	OpenToggleSetting4Mobile.TextTransparency = 0.250
	
	local ToggleSettingsMenu = Instance.new("Frame", CoreGui:WaitForChild("sigma5"))
	ToggleSettingsMenu.Name = "Menu4Toggles"
	ToggleSettingsMenu.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	ToggleSettingsMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ToggleSettingsMenu.BorderSizePixel = 0
	ToggleSettingsMenu.Position = UDim2.new(0.497, -155, 0.521, -148)
	ToggleSettingsMenu.Size = UDim2.new(0, 325, 0, 295)
	ToggleSettingsMenu.ZIndex = 4
	ToggleSettingsMenu.Visible = false

	local ToggleSettingsMenuCorner = Instance.new("UICorner", ToggleSettingsMenu)
	ToggleSettingsMenuCorner.CornerRadius = UDim.new(0, 8)

	local MenuTitle = Instance.new("TextLabel", ToggleSettingsMenu)
	MenuTitle.Name = "Menu For" .. toggleName
	MenuTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuTitle.BackgroundTransparency = 1.000
	MenuTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuTitle.BorderSizePixel = 0
	MenuTitle.Position = UDim2.new(0, 0, 0, -52)
	MenuTitle.Size = UDim2.new(0, 200, 0, 50)
	MenuTitle.Font = Enum.Font.Roboto
	MenuTitle.Text = toggleName
	MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	MenuTitle.TextSize = 30.000
	MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
	MenuTitle.Visible = true
	MenuTitle.ZIndex = 4
	
	local CloseMenu = Instance.new("TextButton", ToggleSettingsMenu)
	CloseMenu.BorderSizePixel = 0
	CloseMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	CloseMenu.Font = Enum.Font.Roboto
	CloseMenu.TextScaled  = true
	CloseMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseMenu.Size = UDim2.new(0, 45, 0, 45)
	CloseMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseMenu.Text = "x"
	CloseMenu.BackgroundTransparency = 1
	CloseMenu.ZIndex = 4
	CloseMenu.Name = "CloseMobileSupport"
	CloseMenu.Position = UDim2.new(0, 290, 0, -52)
	CloseMenu.AutoButtonColor = false
	
	local MenuScrollingPart = Instance.new("ScrollingFrame", ToggleSettingsMenu)
	MenuScrollingPart.Name = "ScrollHolder"
	MenuScrollingPart.Active = true
	MenuScrollingPart.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuScrollingPart.BackgroundTransparency = 1.000
	MenuScrollingPart.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuScrollingPart.BorderSizePixel = 0
	MenuScrollingPart.Size = UDim2.new(1, 0, 1, 0)
	MenuScrollingPart.ScrollBarThickness = 0
	MenuScrollingPart.Visible = false
	MenuScrollingPart.ZIndex = 4
	
	local MenuDescription = Instance.new("TextLabel", MenuScrollingPart)
	MenuDescription.Name = "Info for" .. toggleName
	MenuDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuDescription.BackgroundTransparency = 1.000
	MenuDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuDescription.BorderSizePixel = 0
	MenuDescription.Size = UDim2.new(1, 0, 0, 35)
	MenuDescription.Font = Enum.Font.Roboto
	MenuDescription.Text = "      " .. Description
	MenuDescription.TextColor3 = Color3.fromRGB(85, 85, 85)
	MenuDescription.TextSize = 13
	MenuDescription.TextWrapped = true
	MenuDescription.TextXAlignment = Enum.TextXAlignment.Left
	MenuDescription.Visible = true
	MenuDescription.ZIndex = 4
	
	local function WhenFired()
		if Fired then
			Library:FadeEffect(ToggleHolders, {BackgroundColor3 = Color3.fromRGB(115, 185, 255)})
			Library:FadeEffect(ToggleHolders, {TextColor3 = Color3.fromRGB(255, 255, 255)})
			ToggleHolders.Text = "       " .. toggleName
			PlaySound(SoundList.OnEnabled)
			if togglecallback then
				togglecallback(true)
			end
		else
			Library:FadeEffect(ToggleHolders, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
			Library:FadeEffect(ToggleHolders, {TextColor3 = Color3.fromRGB(15, 15, 15)})
			ToggleHolders.Text = "     " .. toggleName
			PlaySound(SoundList.OnDisabled)
			if togglecallback then
				togglecallback(false)
			end
		end
	end
	
	ToggleHolders.MouseButton1Click:Connect(function()
		Fired = not Fired
		WhenFired()
	end)
	
	OpenToggleSetting4Mobile.MouseButton1Click:Connect(function()
			ToggleSettingsMenu.Visible = true
			MenuScrollingPart.Visible = true
	end)
	
	CloseMenu.MouseButton1Click:Connect(function()
			ToggleSettingsMenu.Visible = false
			MenuScrollingPart.Visible = false
	end)
end
end
