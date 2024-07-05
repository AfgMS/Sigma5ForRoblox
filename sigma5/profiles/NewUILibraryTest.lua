--BridgeDuels have some interesting AntiCheat..
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/BetaLibrary.lua", true))()
Library:CreateCore()

local Combat = Library:CreateTab("Combat")
local Movement = Library:CreateTab("Movement")

local Test = Combat:CrateToggle("Test1", false, true, function(callback)
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

local Tes3 = Movement:CrateToggle("Test3", false, true, function(callback)
	if callback then
		print("Debug 32")
	else
		print("Unbug 23")
	end
end)
--[[
local Uninject = Movement:CrateToggle("Uninject", false, false, function(callback)
	if callback then
		Library.Uninjected = true
		shared.UninjectEternal()
	end
end)
--]]
