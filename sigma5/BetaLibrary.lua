local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {
	MobileButtons = {},
	Uninjected = false
}

function Spoof(length)
	local Letter = {}
	for i = 1, length do
		local RandomLetter = string.char(math.random(97, 122))
		table.insert(Letter, RandomLetter)
	end
	return table.concat(Letter)
end

function Library:CreateCore()
	local Core = {}
	
	local ScreenGui= Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Name = Spoof(math.random(8, 12))
	if RunService:IsStudio() or game.PlaceId == 11630038968 then
		ScreenGui.Parent = PlayerGui
		warn("Unable to use CoreGui")
	else
		ScreenGui.Parent = CoreGui
	end
	table.insert(Core, ScreenGui)
	
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = ScreenGui
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	table.insert(Core, UIListLayout)
	
	local GUIOpen = Instance.new("TextButton")
	GUIOpen.Parent = ScreenGui
	GUIOpen.AnchorPoint = Vector2.new(0.5, 0.5)
	GUIOpen.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	GUIOpen.BackgroundTransparency = 0.150
	GUIOpen.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GUIOpen.BorderSizePixel = 0
	GUIOpen.Position = UDim2.new(0.970000029, 0, 0.25, 0)
	GUIOpen.Size = UDim2.new(0, 20, 0, 20)
	GUIOpen.AutoButtonColor = false
	GUIOpen.Font = Enum.Font.SourceSansLight
	GUIOpen.LineHeight = 0.000
	GUIOpen.Text = "+"
	GUIOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
	GUIOpen.TextScaled = true
	GUIOpen.TextSize = 36.000
	GUIOpen.TextTransparency = 0.250
	GUIOpen.TextWrapped = true
	GUIOpen.TextXAlignment = Enum.TextXAlignment.Center
	GUIOpen.TextYAlignment = Enum.TextYAlignment.Center
	table.insert(Core, GUIOpen)
	
	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = ScreenGui
	UIPadding.PaddingLeft = UDim.new(0, 25)
	UIPadding.PaddingTop = UDim.new(0, 25)
	table.insert(Core, UIPadding)
	
	function Library:CreateTab(TabName)
		local TabInternal = {SizeY = 0}
		
		
		local Frame = Instance.new("Frame")
		Frame.Parent = ScreenGui
		Frame.Name = "MainFrame"
		Frame.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(0, 118, 0, 25)
		Frame.Visible = false
		table.insert(TabInternal, Frame)
		
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = Frame
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.Name = TabName
		TextLabel.Text = TabName
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.TextScaled = true
		TextLabel.TextSize = 14.000
		TextLabel.TextWrapped = true
		table.insert(TabInternal, TextLabel)
		
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		UITextSizeConstraint.Parent = TextLabel
		UITextSizeConstraint.MaxTextSize = 14
		table.insert(TabInternal, UITextSizeConstraint)
		
		local Frame_2 = Instance.new("Frame")
		Frame_2.Parent = Frame
		Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame_2.BackgroundTransparency = 1.000
		Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame_2.BorderSizePixel = 0
		Frame_2.Position = UDim2.new(0, 0, 1.00000024, 0)
		Frame_2.Size = UDim2.new(1, 0, 0, 211)
		table.insert(TabInternal, Frame_2)
		
		local Frame_3 = Instance.new("Frame")
		Frame_3.Parent = Frame_2
		Frame_3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame_3.BorderSizePixel = 0
		Frame_3.Position = UDim2.new(0, 0, -0.00473933667, 0)
		Frame_3.Size = UDim2.new(1, 0, 0.535549045, 0)
		table.insert(TabInternal, Frame_3)
		
		local UIListLayout_2 = Instance.new("UIListLayout")
		UIListLayout_2.Parent = Frame_3
		table.insert(TabInternal, UIListLayout_2)
		
		UserInputService.InputBegan:Connect(function(Input, isTyping)
			if Input.KeyCode == Enum.KeyCode.V and not isTyping then
				Frame.Visible = not Frame.Visible
			end
		end)
		
		GUIOpen.MouseButton1Click:Connect(function()
			Frame.Visible = not Frame.Visible
		end)
		
		for i, v in pairs(Frame_3:GetChildren()) do
			if v:IsA("TextButton") then
				TabInternal.SizeY = TabInternal.SizeY + v.Size.Y.Offset
			end
		end
		
		Frame_3.Size = UDim2.new(Frame_3.Size.X.Scale, Frame_3.Size.X.Offset, 0, TabInternal.SizeY)
		
		function TabInternal:CrateToggle(ToggleName, Enabled, Default, callback)
			local ToggleButton = {}
			
			local TextButton = Instance.new("TextButton")
			TextButton.Name = ToggleName
			TextButton.Parent = Frame_3
			TextButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextButton.BorderSizePixel = 0
			TextButton.Size = UDim2.new(1, 0, -0.0134088602, 28)
			TextButton.AutoButtonColor = false
			TextButton.Font = Enum.Font.SourceSans
			TextButton.Text = ""
			TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextButton.TextSize = 14.000
			table.insert(ToggleButton, TextButton)
			
			local TextLabel_2 = Instance.new("TextLabel")
			TextLabel_2.Parent = TextButton
			TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel_2.BackgroundTransparency = 1.000
			TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel_2.BorderSizePixel = 0
			TextLabel_2.Position = UDim2.new(0.180000007, 0, 0.158999994, 0)
			TextLabel_2.Size = UDim2.new(0, 80, 0, 15)
			TextLabel_2.Font = Enum.Font.SourceSans
			TextLabel_2.Text = ToggleName
			TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel_2.TextSize = 13.000
			TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
			table.insert(ToggleButton, TextLabel_2)
			
			local Frame_4 = Instance.new("Frame")
			Frame_4.Parent = TextButton
			Frame_4.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
			Frame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame_4.BorderSizePixel = 0
			Frame_4.Position = UDim2.new(0.0508474559, 0, 0.254365265, 0)
			Frame_4.Size = UDim2.new(0, 10, 0, 10)
			table.insert(ToggleButton, Frame_4)
			
			local UICorner = Instance.new("UICorner")
			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = Frame_4
			table.insert(ToggleButton, UICorner)
			
			local function OnClicked()
				if Enabled then
					Frame_4.BackgroundColor3 = Color3.fromRGB(0, 175, 0)
				else
					Frame_4.BackgroundColor3 =  Color3.fromRGB(175, 0, 0)
				end
			end
			
			TextButton.MouseButton1Click:Connect(function()
				Enabled = not Enabled
				OnClicked()

				if callback then
					callback(Enabled)
				end
			end)
			
			if Default then
				Enabled = not Enabled
				OnClicked()

				if callback then
					callback(Enabled)
				end
			end
			return ToggleButton
		end
		return TabInternal
	end
	return Core
end
return Library
