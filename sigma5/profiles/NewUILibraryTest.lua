local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Roblox"):WaitForChild("New"):FindFirstChild("Eternal"))
Library:CreateCore()

local Combat = Library:CreateTab("Combat")
local Movement = Library:CreateTab("Movement")
local Player = Library:CreateTab("Player")

local Test = Combat:CrateToggle("Test1", false, false, function(callback)
	if callback then
		print("Debug Test1")
	else
		print("Unbug Test1")
	end
end)

local Test2 = Combat:CrateToggle("Test2", false, true, function(callback)
	if callback then
		print("Debug ..")
	else
		print("Unbug --")
	end
end)

local Tes3 = Movement:CrateToggle("Test3", false, false, function(callback)
	if callback then
		print("Debug 32")
	else
		print("Unbug 23")
	end
end)

local Tes4 = Movement:CrateToggle("Test4", false, false, function(callback)
	if callback then
		print("Debug 42")
	else
		print("Unbug 24")
	end
end)

local Tes4 = Player:CrateToggle("Speed", false, false, function(callback)
	if callback then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 85
	else
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 23
	end
end)
