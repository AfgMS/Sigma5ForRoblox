--Sigma5Library4EMulator/PC
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Font = game:GetService("TextService")
local TouchInput = game:GetService("TouchInputService")
local Lighting = game:GetService("Lighting")

local Library = {}

function Library:Setting(normal, advance)
	for i, v in pairs(normal) do
		if advance[i] == nil then
			advance[i] = v
		end
	end
	return advance
end

function Library:FadeEffect(object, properties)
	local TweenProperties = TweenInfo.new(properties.time or 0.10, properties.easingStyle or Enum.EasingStyle.Quad, properties.easingDirection or Enum.EasingDirection.Out)
	local TweenAnim = TweenService:Create(object, TweenProperties, properties)
	TweenAnim:Play()
end

local soundIds = {
	OnEnabled = 3318713980,
	OnEnabledOriginal = 14393273745,
	OnDisabled = 3318714899,
	OnDisabledOriginal = 14393278136,
	OnError = 9066167010,
	OnErrorOriginal = {}
}

function PlaySound(soundId)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. soundId
	sound.Parent = game.Workspace
	sound:Play()

	sound.Ended:Connect(function()
		sound:Destroy()
	end)
end

local Sigma5Visual = Instance.new("ScreenGui", CoreGui)
Sigma5Visual.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Sigma5Visual.Name = "Sigma5Visual"
Sigma5Visual.ResetOnSpawn = false

local BlurUI = Instance.new("BlurEffect")
BlurUI.Parent = Lighting
BlurUI.Size = 28
BlurUI.Enabled = false
--LeftSide
local LeftHolder = Instance.new("Frame", Sigma5Visual)
LeftHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftHolder.BackgroundTransparency = 1
LeftHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
LeftHolder.BorderSizePixel = 0
LeftHolder.Name = "LeftSide"
LeftHolder.Size = UDim2.new(0, 255, 1, 0)

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
SigmaTittle.ZIndex = 1
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
Jello.ZIndex = 1
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
TabHolder.ZIndex = 1
TabHolder.Visible = false
TabHolder.Position = UDim2.new(0, 15, 0, 60)
TabHolder.Size = UDim2.new(0, 110, 0, 124)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabHolder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Movement = Instance.new("TextLabel")
Movement.Name = "Movement"
Movement.Parent = TabHolder
Movement.ZIndex = 1
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
Player.ZIndex = 1
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
Combat.ZIndex = 1
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
Render.ZIndex = 1
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
World.ZIndex = 1
World.TextColor3 = Color3.fromRGB(255, 255, 255)
World.TextSize = 14
World.TextXAlignment = Enum.TextXAlignment.Left
--RightSide
local RightHolder = Instance.new("Frame", Sigma5Visual)
RightHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RightHolder.BackgroundTransparency = 1
RightHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
RightHolder.BorderSizePixel = 0
RightHolder.Name = "RightSide"
RightHolder.Position = UDim2.new(0, 575, 0, 0)
RightHolder.Size = UDim2.new(0, 255, 1, 0)

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
		Notification:TweenPosition(UDim2.new(0, -45, 0, 285), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.8)

		wait(NotificationDuration)

		Notification:TweenPosition(UDim2.new(0, 130, 0, 285), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.8)
		wait()
		Notification.Visible = false
	end
end

local ActiveModsHolder = Instance.new("Frame", RightHolder)
ActiveModsHolder.Name = "ActiveModsHolder"
ActiveModsHolder.Visible = false
ActiveModsHolder.BackgroundTransparency = 1
ActiveModsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ActiveModsHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
ActiveModsHolder.Size = UDim2.new(0, 195, 0, 550)
ActiveModsHolder.Position = UDim2.new(0, 0, 0, 0)

local ActiveModsList = Instance.new("UIListLayout", ActiveModsHolder)
ActiveModsList.Padding = UDim.new(0, -10)
ActiveModsList.SortOrder = Enum.SortOrder.LayoutOrder

local function ActiveModsAdd(ModulesName)
	local ModulesName = Instance.new("TextLabel", ActiveModsHolder)
	ModulesName.Name = ModulesName
	ModulesName.TextXAlignment = Enum.TextXAlignment.Right
	ModulesName.BackgroundTransparency = 1
	ModulesName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ModulesName.Font = Enum.Font.Roboto
	ModulesName.TextSize = 15.8
	ModulesName.Text = ModulesName
	ModulesName.TextColor3 = Color3.fromRGB(255, 255, 255)
	ModulesName.Size = UDim2.new(1, 0, 0, 30)
	ModulesName.ZIndex = 3
	ModulesName.BorderColor3 = Color3.fromRGB(0, 0, 0)

	ModulesName.LayoutOrder = -#ModulesName
end

local function ActiveModsRemove(ModulesName)
	local children = RightHolder:GetChildren()
	for _, child in ipairs(children) do
		if child:IsA("Frame") and child.Name == "ActiveModsHolder" then
			local label = child:FindFirstChild(ModulesName)
			if label and label:IsA("TextLabel") then
				label:Destroy()
				break
			end
		end
	end
end

--UICore
function Library:createScreenGui()
	local screenGui = Instance.new("ScreenGui", CoreGui)
	screenGui.Name = "sigma5"

	local TabsHolder = Instance.new("Frame", screenGui)
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

	return TabsHolder
end

function Library:CreateTab(tabsName)

	local tabHOLD = {}

	tabHOLD.TabMainHolder = Instance.new("Frame", CoreGui:WaitForChild("sigma5"):FindFirstChild("TabsHolder"))
	tabHOLD.TabMainHolder.BorderSizePixel = 0
	tabHOLD.TabMainHolder.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	tabHOLD.TabMainHolder.BackgroundTransparency = 0.050
	tabHOLD.TabMainHolder.Size = UDim2.new(0, 133, 0, 40)
	tabHOLD.TabMainHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabHOLD.TabMainHolder.ZIndex = 3
	tabHOLD.TabMainHolder.Position = UDim2.new(0, 25, 0, 10)
	tabHOLD.TabMainHolder.Name = "Tabs"
	tabHOLD.TabMainHolder.Visible = false

	tabHOLD.TabName = Instance.new("TextLabel", tabHOLD.TabMainHolder)
	tabHOLD.TabName.BorderSizePixel = 0
	tabHOLD.TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabHOLD.TabName.TextXAlignment = Enum.TextXAlignment.Left
	tabHOLD.TabName.Font = Enum.Font.Roboto
	tabHOLD.TabName.TextSize = 18.000
	tabHOLD.TabName.ZIndex = 3
	tabHOLD.TabName.TextColor3 = Color3.fromRGB(95, 95, 95)
	tabHOLD.TabName.Size = UDim2.new(1, 0, 1, 0)
	tabHOLD.TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabHOLD.TabName.Text = "    " .. tabsName
	tabHOLD.TabName.Name = "TabsName"
	tabHOLD.TabName.TextTransparency = 0.350
	tabHOLD.TabName.Position = UDim2.new(0, 0, 0, 0)
	tabHOLD.TabName.TextStrokeTransparency = 0.990
	tabHOLD.TabName.BackgroundTransparency = 1.000

	tabHOLD.TabScrollingHolder = Instance.new("Frame", tabHOLD.TabMainHolder)
	tabHOLD.TabScrollingHolder.BorderSizePixel = 0
	tabHOLD.TabScrollingHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabHOLD.TabScrollingHolder.BackgroundTransparency = 1.000
	tabHOLD.TabScrollingHolder.Size = UDim2.new(0, 133, 0, 250)
	tabHOLD.TabScrollingHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabHOLD.TabScrollingHolder.ZIndex = 3
	tabHOLD.TabScrollingHolder.Position = UDim2.new(0, 0, 0, 40)
	tabHOLD.TabScrollingHolder.Name = "ScrollingPart"
	--tabHOLD.TabScrollingHolder.Visible = false

	tabHOLD.TabToggleMenu = Instance.new("ScrollingFrame", tabHOLD.TabScrollingHolder)
	tabHOLD.TabToggleMenu.Active = true
	tabHOLD.TabToggleMenu.BorderSizePixel = 0
	tabHOLD.TabToggleMenu.ZIndex = 3
	tabHOLD.TabToggleMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabHOLD.TabToggleMenu.Size = UDim2.new(0, 133, 0, 173)
	tabHOLD.TabToggleMenu.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	tabHOLD.TabToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabHOLD.TabToggleMenu.ScrollBarThickness = 3
	tabHOLD.TabToggleMenu.CanvasSize = UDim2.new(0, 0, 1, 0)
	tabHOLD.TabToggleMenu.Name = "ScrollingModules"

	local ToggleUIList = Instance.new("UIListLayout", tabHOLD.TabToggleMenu)
	ToggleUIList.SortOrder = Enum.SortOrder.LayoutOrder

	game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
			tabHOLD.TabMainHolder.Visible = not tabHOLD.TabMainHolder.Visible
			BlurUI.Enabled = not BlurUI.Enabled
		end
	end)

	function tabHOLD:CreateToggle(advance)
		advance = Library:Setting({
			Name = "Invalid",
			Description = "Invalid",
			Bind = nil,
		}, advance or {})

		local ToggleButton = {
			Enabled = false
		}

		local ToggleButtonHolder = Instance.new("TextButton", tabHOLD.TabToggleMenu)
		ToggleButtonHolder.BorderSizePixel = 0
		ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleButtonHolder.TextXAlignment = Enum.TextXAlignment.Left
		ToggleButtonHolder.Font = Enum.Font.Roboto
		ToggleButtonHolder.TextSize = 15.000
		ToggleButtonHolder.TextColor3 = Color3.fromRGB(15, 15, 15)
		ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 20)
		ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleButtonHolder.Text = "     " .. advance.Name
		ToggleButtonHolder.ZIndex = 3
		ToggleButtonHolder.Name = advance.Name
		ToggleButtonHolder.Position = UDim2.new(0, 3, 0, 0)
		ToggleButtonHolder.AutoButtonColor = false
		ToggleButtonHolder.TextTransparency = 0.250

		local ToggleSettingHolder = Instance.new("Frame", CoreGui:FindFirstChild("sigma5"))
		ToggleSettingHolder.Name = "Holder"
		ToggleSettingHolder.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
		ToggleSettingHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleSettingHolder.BorderSizePixel = 0
		ToggleSettingHolder.Position = UDim2.new(0.497, -155, 0.521, -148)
		ToggleSettingHolder.Size = UDim2.new(0, 325, 0, 295)
		ToggleSettingHolder.ZIndex = 4
		ToggleSettingHolder.Visible = false

		local ToggleSettingHolderCorner = Instance.new("UICorner", ToggleSettingHolder)
		ToggleSettingHolderCorner.CornerRadius = UDim.new(0, 8)

		local ToggleSettingName = Instance.new("TextLabel", ToggleSettingHolder)
		ToggleSettingName.Name = "Menu For" .. advance.Name
		ToggleSettingName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleSettingName.BackgroundTransparency = 1.000
		ToggleSettingName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleSettingName.BorderSizePixel = 0
		ToggleSettingName.Position = UDim2.new(0, 0, 0, -52)
		ToggleSettingName.Size = UDim2.new(0, 200, 0, 50)
		ToggleSettingName.Font = Enum.Font.Roboto
		ToggleSettingName.Text = advance.Name
		ToggleSettingName.TextColor3 = Color3.fromRGB(255, 255, 255)
		ToggleSettingName.TextSize = 30.000
		ToggleSettingName.TextXAlignment = Enum.TextXAlignment.Left
		ToggleSettingName.Visible = true
		ToggleSettingName.ZIndex = 4

		local ToggleSettingScroller = Instance.new("ScrollingFrame", ToggleSettingHolder)
		ToggleSettingScroller.Name = "ScrollHolder"
		ToggleSettingScroller.Active = true
		ToggleSettingScroller.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleSettingScroller.BackgroundTransparency = 1.000
		ToggleSettingScroller.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleSettingScroller.BorderSizePixel = 0
		ToggleSettingScroller.Size = UDim2.new(1, 0, 1, 0)
		ToggleSettingScroller.ScrollBarThickness = 0
		ToggleSettingScroller.Visible = true
		ToggleSettingScroller.ZIndex = 4

		local ToggleSettingUIList = Instance.new("UIListLayout", ToggleSettingScroller)
		ToggleSettingUIList.SortOrder = Enum.SortOrder.LayoutOrder

		local ToggleSettingDescription = Instance.new("TextLabel", ToggleSettingScroller)
		ToggleSettingDescription.Name = "Info for" .. advance.Name
		ToggleSettingDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleSettingDescription.BackgroundTransparency = 1.000
		ToggleSettingDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleSettingDescription.BorderSizePixel = 0
		ToggleSettingDescription.Size = UDim2.new(1, 0, 0, 35)
		ToggleSettingDescription.Font = Enum.Font.Roboto
		ToggleSettingDescription.Text = "      " .. advance.Name
		ToggleSettingDescription.TextColor3 = Color3.fromRGB(85, 85, 85)
		ToggleSettingDescription.TextSize = 13
		ToggleSettingDescription.TextWrapped = true
		ToggleSettingDescription.TextXAlignment = Enum.TextXAlignment.Left
		ToggleSettingDescription.Visible = true
		ToggleSettingDescription.ZIndex = 4
		ToggleButton.MenuFrame = ToggleSettingHolder

		local function WhenClicked()
			if ToggleButton.Enabled then
				Library:FadeEffect(ToggleButtonHolder, {BackgroundColor3 = Color3.fromRGB(115, 185, 255)})
				Library:FadeEffect(ToggleButtonHolder, {TextColor3 = Color3.fromRGB(255, 255, 255)})
				ToggleButtonHolder.Text = "       " .. advance.Name
				ActiveModsAdd(advance.Name)
				PlaySound(soundIds.OnEnabled)
			else
				Library:FadeEffect(ToggleButtonHolder, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
				Library:FadeEffect(ToggleButtonHolder, {TextColor3 = Color3.fromRGB(15, 15, 15)})
				ToggleButtonHolder.Text = "     " .. advance.Name
				ActiveModsRemove(advance.Name)
				PlaySound(soundIds.OnDisabled)
			end
		end

		ToggleButtonHolder.MouseButton1Click:Connect(function()
			ToggleButton.Enabled = not ToggleButton.Enabled
			WhenClicked()

			if advance.callback then
				advance.callback(ToggleButton.Enabled)
			end
		end)

		ToggleButtonHolder.MouseButton2Click:Connect(function()
			ToggleSettingHolder.Visible = not ToggleSettingHolder.Visible
		end)

		game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
			if input.KeyCode == Enum.KeyCode[advance.Bind] and not gameProcessedEvent then
				ToggleButton.Enabled = not ToggleButton.Enabled
				WhenClicked()

				if advance.callback then
					advance.callback(ToggleButton.Enabled)
				end
			end
		end)

		WhenClicked()

		function ToggleButton:CreateSlider(advance)
			advance = Library:Setting({
				Name = "Invalid",
				MinVal = nil,
				MaxVal = nil,
				callback = function(val) end
			}, advance or {})

			local Slider = {}
			local Percent
			local MouseDown = false

			local SlidersNames = Instance.new("TextLabel", ToggleSettingScroller)
			SlidersNames.Name = "Slider For" .. advance.Name
			SlidersNames.Size = UDim2.new(1, 0, 0, 30)
			SlidersNames.Position = UDim2.new(0, 0, 0, 0)
			SlidersNames.Text = "      " .. advance.Name
			SlidersNames.TextColor3 = Color3.fromRGB(0, 0, 0)
			SlidersNames.TextSize = 15
			SlidersNames.Font = Enum.Font.Roboto
			SlidersNames.BackgroundTransparency = 1
			SlidersNames.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SlidersNames.ZIndex = 5
			SlidersNames.TextXAlignment = Enum.TextXAlignment.Left

			local SliderValue = Instance.new("TextLabel", SlidersNames)
			SliderValue.Name = "Sliders Value"
			SliderValue.Size = UDim2.new(0, 30, 0, 30)
			SliderValue.Position = UDim2.new(0, 195, 0, 5)
			SliderValue.Text = ""
			SliderValue.TextColor3 = Color3.fromRGB(85, 85, 85)
			SliderValue.TextSize = 10
			SliderValue.Font = Enum.Font.Roboto
			SliderValue.BackgroundTransparency = 1
			SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderValue.ZIndex = 5

			local SliderBackground = Instance.new("Frame", SlidersNames)
			SliderBackground.Name = "SliderBackground"
			SliderBackground.Size = UDim2.new(0, 75, 0, 5)
			SliderBackground.Position = UDim2.new(0, 225, 0, 15)
			SliderBackground.BorderSizePixel = 0
			SliderBackground.BackgroundColor3 = Color3.fromRGB(205, 235, 255)
			SliderBackground.BackgroundTransparency = 0.45
			SliderBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderBackground.ZIndex = 5

			local SliderBackgroundCorner = Instance.new("UICorner", SliderBackground)
			SliderBackgroundCorner.CornerRadius = UDim.new(1, 0)

			local SliderFiller = Instance.new("Frame", SliderBackground)
			SliderFiller.Name = "SliderFiller"
			SliderFiller.Size = UDim2.new(advance.MinVal, 0, 1, 0)
			SliderFiller.Position = UDim2.new(0, 0, 0, 0)
			SliderFiller.BorderSizePixel = 0
			SliderFiller.BackgroundColor3 = Color3.fromRGB(116, 184, 255)
			SliderFiller.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SliderFiller.ZIndex = 5

			local SliderFillerCorner = Instance.new("UICorner", SliderFiller)
			SliderFillerCorner.CornerRadius = UDim.new(1, 0)

			local UISliderButton = Instance.new("TextButton", SliderFiller)
			UISliderButton.Name = "UISliderButton"
			UISliderButton.Size = UDim2.new(0, 15, 0, 15)
			UISliderButton.AnchorPoint = Vector2.new(1, 0.5)
			UISliderButton.Position = UDim2.new(1, 0, 0.5, 0)
			UISliderButton.Text = ""
			UISliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			UISliderButton.BorderSizePixel = 0
			UISliderButton.AutoButtonColor = false
			UISliderButton.ClipsDescendants = true
			UISliderButton.ZIndex = 5

			local UISliderButtonCorner = Instance.new("UICorner", UISliderButton)
			UISliderButtonCorner.CornerRadius = UDim.new(1, 0)

			local function Update(input)
				MouseDown = true
				repeat
					task.wait()

					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local inputPosition = input.Position
						Percent = math.clamp((inputPosition.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
						local sliderValue = math.round(Percent * 100)
						SliderValue.Text = sliderValue
						SliderFiller.Size = UDim2.fromScale(Percent, 1)

						advance.callback(sliderValue)
					end
				until not MouseDown
			end

			UISliderButton.MouseButton1Down:Connect(function()
				Update(game:GetService("UserInputService").InputChanged:Wait())
			end)

			game:GetService("UserInputService").InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					MouseDown = false
				end
			end)


			function ToggleButton:MiniToggle(advance)
				advance = Library:Setting({
					Name = "Invalid",
				}, advance or {})

				local MiniToggle = {
					Enabled = false
				}

				local MiniToggleHolder = Instance.new("TextLabel", ToggleSettingScroller)
				MiniToggleHolder.Name = "MiniToggle For" .. advance.Name
				MiniToggleHolder.Size = UDim2.new(1, 0, 0, 30)
				MiniToggleHolder.Position = UDim2.new(0, 0, 0, 0)
				MiniToggleHolder.Text = "      " .. advance.Name
				MiniToggleHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.TextSize = 15
				MiniToggleHolder.Font = Enum.Font.Roboto
				MiniToggleHolder.BackgroundTransparency = 1
				MiniToggleHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolder.ZIndex = 5
				MiniToggleHolder.TextXAlignment = Enum.TextXAlignment.Left

				local MiniToggleCheckmark = Instance.new("TextButton", MiniToggleHolder)
				MiniToggleCheckmark.BorderSizePixel = 0
				MiniToggleCheckmark.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
				MiniToggleCheckmark.TextSize = 5
				MiniToggleCheckmark.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleCheckmark.Size = UDim2.new(0, 15, 0, 15)
				MiniToggleCheckmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleCheckmark.Text = " "
				MiniToggleCheckmark.ZIndex = 5
				MiniToggleCheckmark.Name = "Checkmark"
				MiniToggleCheckmark.Position = UDim2.new(0, 285, 0, 8)
				MiniToggleCheckmark.AutoButtonColor = false
				MiniToggleCheckmark.TextTransparency = 0.250

				local MiniToggleCheckmarkCorner = Instance.new("UICorner", MiniToggleCheckmark)
				MiniToggleCheckmarkCorner.CornerRadius = UDim.new(1, 0)

				local function OnClicked()
					if MiniToggle.Enabled then
						Library:FadeEffect(MiniToggleCheckmark, {BackgroundColor3 = Color3.fromRGB(115, 185, 255)})
						MiniToggleCheckmark.Text = "✔️"
					else
						Library:FadeEffect(MiniToggleCheckmark, {BackgroundColor3 = Color3.fromRGB(240, 240, 240)})
						MiniToggleCheckmark.Text = ""
					end
				end

				MiniToggleCheckmark.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					OnClicked()

					if advance.callback then
						advance.callback(MiniToggle.Enabled)
					end
				end)

				OnClicked()

				--[[[function ToggleButton:Dropdown(options)
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

					local DropdownName = Instance.new("TextLabel", ToggleSettingScroller)
					DropdownName.Name = "Dropdown For" .. options.name
					DropdownName.Size = UDim2.new(1, 0, 0, 30)
					DropdownName.Position = UDim2.new(0, 0, 0, 0)
					DropdownName.Text = "      " .. options.name
					DropdownName.TextColor3 = Color3.fromRGB(0, 0, 0)
					DropdownName.TextSize = 15
					DropdownName.Font = Enum.Font.Roboto
					DropdownName.BackgroundTransparency = 1
					DropdownName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					DropdownName.ZIndex = 5
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
					DropdownHolders.ZIndex = 5
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
					DropdownMenu.ZIndex = 5

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
						DropdownOption.ZIndex = 5
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
--]] --Dropdown, ill just leave it...
				return MiniToggle
			end

			return Slider
		end

		return ToggleButton
	end

	return tabHOLD
end

return Library
