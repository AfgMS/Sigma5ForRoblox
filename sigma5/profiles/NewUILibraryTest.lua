--BridgeDuels have some interesting AntiCheat..
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/BetaLibrary.lua", true))()
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

local herbet
local Tes4 = Player:CrateToggle("Speed", false, false, function(callback)
	if callback then
		herbet = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
			game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, -32 * deltaTime)
		end)
	else
		herbet:Disconnect()
	end
end)
