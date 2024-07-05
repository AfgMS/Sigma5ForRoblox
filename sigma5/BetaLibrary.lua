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
	
	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = ScreenGui
	UIPadding.PaddingLeft = UDim.new(0, 25)
	UIPadding.PaddingTop = UDim.new(0, 25)
	table.insert(Core, UIPadding)
	
	function Library:CreateTab(TabName)
		local TabInternal = {}
		
		local Frame = Instance.new("Frame")
		Frame.Parent = ScreenGui
		Frame.Name = "MainFrame"
		Frame.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(0, 118, 0, 25)
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
		return TabInternal
	end
	return Core
end
return Library
