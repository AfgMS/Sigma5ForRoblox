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

function Draggable(object)
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	object.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

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
	
	return Core
end


return Library
