local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/LibraryMobile.lua", true))()
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = game.Players.LocalPlayer
local Player = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local Lighting = game:GetService("Lighting")

Library:createScreenGui()
local GuiTab = Library:createTabs(CoreGui.Sigma5, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma5, "Combat")
local RenderTab = Library:createTabs(CoreGui.Sigma5, "Render")
local PlayerTab = Library:createTabs(CoreGui.Sigma5, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma5, "World")

local function Alive(plr)
    return plr and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0.11
end

local function FindNearestPlayer(distance)
    local nearestPlayer = nil
    local MinDistance = math.huge

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if Alive(player) then
                local Distances = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
                if Distances < MinDistance and Distances <= distance then
                    MinDistance = Distances
                    nearestPlayer = player
                end
            end
        end
    end
    return nearestPlayer
end

local function GetSword(character)
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") and string.match(tool.Name, "Sword") then
            return tool
        end
    end
    return nil
end

-- ActiveMods
local ActiveMods = GuiTab:ToggleButton({
	name = "ActiveMods",
	info = "Render active mods",
	callback = function(enabled)
		CoreGui.Sigma5Visual.RightSide.ArrayListHolder.Visible = not CoreGui.Sigma5Visual.RightSide.ArrayListHolder.Visible
	end
})

-- TabGUI
local TabGUI = GuiTab:ToggleButton({
	name = "TabGUI",
	info = "Just decorations",
	callback = function(enabled)
		CoreGui.Sigma5Visual.LeftSide.TabHolder.Visible = not CoreGui.Sigma5Visual.LeftSide.TabHolder.Visible
	end
})

-- RemoveUI
local BlurEffect = Lighting:FindFirstChild("Blur")
local RemoveUI = GuiTab:ToggleButton({
	name = "RemoveUI",
	info = "This is not an uninject",
	callback = function(enabled)
		if enabled then
			if BlurEffect then
				BlurEffect:Destroy()
			end
			if CoreGui:FindFirstChild("Sigma5") then
				CoreGui.Sigma5:Destroy()
			end
			if CoreGui:FindFirstChild("Sigma5Visual") then
				CoreGui.Sigma5Visual:Destroy()
			end
		end
	end
})

-- Aimbot
local DefaultAimPart = "HumRoot"
local CameraDirection
local AimbotDistance
local AimbotDelay
local Aimbot = CombatTab:ToggleButton({
	name = "Aimbot",
	info = "Automatically aim at players",
	callback = function(enabled)
		if enabled then
			AimbotDelay = 0.01
			AimbotDistance = 20
			local Target = GetNearest(AimbotDistance)
			while task.wait(AimbotDelay) do
				if Target then
					if DefaultAimPart == "Head" then
						CameraDirection = (Target.Character:WaitForChild("Head").Position - Camera.CFrame.Position).unit
					elseif DefaultAimPart == "HumRoot" then
						CameraDirection = (Target.Character:WaitForChild("HumanoidRootPart").Position - Camera.CFrame.Position).unit
					elseif DefaultAimPart == "LowerTorso" then
						CameraDirection = (Target.Character:WaitForChild("LowerTorso").Position - Camera.CFrame.Position).unit
					end
					local SetLookAt = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + CameraDirection)
					Camera.CFrame = SetLookAt
				end
			end
		else
			AimbotDistance = 0
			AimbotDelay = 86400
		end
	end
})

local CustomAimbotDist = Aimbot:Slider({
	title = "Distance",
	min = 0,
	max = 100,
	default = 20,
	callback = function(val)
		AimbotDistance = val
	end
})

local JitterAimMode = Aimbot:ToggleButtonInsideUI({
	name = "JitterMode",
	callback = function()
		CreateNotification("Sigma5", "This feature is for premium", 3, true)
	end
})

local AimPartModes = Aimbot:Dropdown({
	name = "AimPart",
	default = "HumRoot",
	list = {"Head", "HumRoot", "LowerTorso"},
	callback = function(selectedItem)
		DefaultAimPart = selectedItem
	end
})

-- AutoQuit
local MinHealth
local AutoQuit = CombatTab:ToggleButton({
	name = "AutoQuit",
	info = "Automatically quit the game",
	callback = function(enabled)
		if enabled then
			MinHealth = 0.11
			if LocalPlayer then
				while enabled do
					if LocalPlayer.Character:FindFirstChild("Humanoid").Health < MinHealth then
						CreateNotification("AutoQuit", "Modules Triggered", 3, true)
						task.wait(2)
						LocalPlayer:Kick("You Have Been Banned For Exploiting :trol:")
					end
					task.wait()
				end
			end
		else
			MinHealth = nil
		end
	end
})

local CustomMinHealth = AutoQuit:Slider({
	title = "Health",
	min = 0,
	max = 100,
	default = 0.11,
	callback = function(val)
		MinHealth = val
	end
})

-- KillAura
-- KillAura
local KillAuraDistance = 28
local KillAuraCritical = true
local KillAuraAutoBlock = false
local KillAuraActive = false

local KillAura = CombatTab:ToggleButton({
	name = "KillAura",
	info = "Attack Nearest Player",
	callback = function(enabled)
		KillAuraActive = enabled
		if enabled then
			task.spawn(function()
				while KillAuraActive do
					task.wait(0.03)
					local Target = FindNearestPlayer(KillAuraDistance)
					if Target then
						print(Target.Name)
						local Sword = GetSword(LocalPlayer.Character)
						if Sword then
							local args = {
								[1] = KillAuraAutoBlock,
								[2] = Sword.Name
							}
							game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(unpack(args))

							local args = {
								[1] = Target.Character,
								[2] = KillAuraCritical,
								[3] = Sword.Name
							}
							game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RF.AttackPlayerWithSword:InvokeServer(unpack(args))
						else
							print("No Sword Found")
						end
					else
						print("No Players Found")
					end
				end
			end)
		end
	end
})

local CustomKillAuraDistance = KillAura:Slider({
	title = "Distance",
	min = 0,
	max = 100,
	default = 28,
	callback = function(val)
		KillAuraDistance = val
	end
})

local KillAuraCrit = KillAura:ToggleButtonInsideUI({
	name = "Critical",
	callback = function(enabled)
		KillAuraCritical = enabled
	end
})

local KillAuraBlock = KillAura:ToggleButtonInsideUI({
	name = "AutoBlock",
	callback = function(enabled)
		KillAuraAutoBlock = enabled
	end
})
