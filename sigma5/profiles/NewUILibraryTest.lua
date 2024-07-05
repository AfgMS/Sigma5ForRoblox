--BridgeDuels have some interesting AntiCheat..
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/BetaLibrary.lua", true))()
Library:CreateCore()

local Combat = Library:CreateTab("Combat")
local Movement = Library:CreateTab("Movement")

local Test = Combat:CrateToggle("Yessir", false, false, function(callback)
	print("eeee")
end)

local Test = Movement:CrateToggle("Yessir", false, true, function(callback)
	if callback then
		print("e")
	else
		print("o")
	end
end)
