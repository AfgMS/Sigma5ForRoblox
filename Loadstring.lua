local SigmaLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Simga345/main/SigmaDev.lua", true))()

SigmaLibrary:createScreenGui()

createnotification("Simga", "Welcome to Sigma, Press V", 3, true)

local tab1 = SigmaLibrary:createTabs(CoreGui.Sigma, "Gui")
local tab2 = SigmaLibrary:createTabs(CoreGui.Sigma, "Combat")

local button1 = tab1:ToggleButton({
	name = "Hendro",
	info = "QuACK Quack",
	callback = function(enabled)
		print("cum")
	end
})
local SliderStuff = button1:Slider({
	title = "Dugong",
	min = 5,
	max = 10,
	default = 5,
	callback = function(val)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
	end
})
local ToggleInsideUI1 = button1:ToggleButtonInsideUI({
	name = "MyFirne",
	callback = function(enabled)
		if enabled then
			print("hello")
		end
	end
})
local Dropdown = button1:Dropdown({
	name = "Yes",
	todo = "E",
	list = {"Walk", "Run", "Sprint"},
	Default = "Walk",
	callback = function(selectedItem)
		print("Movement type set to:", selectedItem)
	end
})
local button99 = tab2:ToggleButton({
	name = "UninjectShit",
	info = "Click to uninject the Sigma hack.",
	callback = function(enabled)
		if enabled then
			CoreGui.Sigma:Destroy()
			print("Destroyed Main")
			CoreGui.SigmaVisualStuff:Destroy()
			print("Destroyed Notif")
		end
	end
})
local SliderStuff = button99:Slider({
	title = "Walkspeed",
	min = 10,
	max = 200,
	default = 5,
	callback = function(val)
		print("" ..val)
	end
})
local ToggleInsideUI1 = button99:ToggleButtonInsideUI({
	name = "MyFirne",
	callback = function(enabled)
		if enabled then
			print("hello")
		end
	end
})
local Dropdown = button99:Dropdown({
	name = "Yes",
	todo = "E",
	list = {"Walk", "Run", "Sprint"},
	Default = "Walk",
	callback = function(selectedItem)
		print("Movement type set to:", selectedItem)
	end
})
