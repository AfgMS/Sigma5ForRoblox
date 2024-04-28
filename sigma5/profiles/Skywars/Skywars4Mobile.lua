--Services
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/LibraryMobile.lua", true))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = game:GetService("Workspace").CurrentCamera
local Lighting = game:GetService("Lighting")
local CoreGui = game:WaitForChild("CoreGui")
local LocalPlayer = game.Players.LocalPlayer
local Player = game:GetService("Players")
--Functions
local function GetNearest(range)
	local nearestPlayer
	local nearestDistance = math.huge
	local localPlayer = game.Players.LocalPlayer

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= localPlayer then
			local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			local localHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			if playerHRP and localHRP then
				local distance = (playerHRP.Position - localHRP.Position).magnitude
				if distance < nearestDistance and distance <= range then
					nearestPlayer = player
					nearestDistance = distance
				end
			end
		end
	end
	return nearestPlayer
end
--Tabs
Library:createScreenGui()
local GuiTab = Library:createTabs(CoreGui.Sigma5, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma5, "Combat")
local RenderTab = Library:createTabs(CoreGui.Sigma5, "Render")
local PlayerTab = Library:createTabs(CoreGui.Sigma5, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma5, "World")
--GuiModules
local ActiveMods = GuiTab:ToggleButton({
	name = "ActiveMods",
	info = "Render active mods",
	callback = function(enabled)
		CoreGui.Sigma5Visual.RightSide.ArrayListHolder.Visible = not CoreGui.Sigma5Visual.RightSide.ArrayListHolder.Visible
	end
})
--TabGUI
local TabGUI = GuiTab:ToggleButton({
	name = "TabGUI",
	info = "Just decorations",
	callback = function(enabled)
		CoreGui.Sigma5Visual.LeftSide.TabHolder.Visible = not CoreGui.Sigma5Visual.LeftSide.TabHolder.Visible
	end
})
--RemoveUI
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
--CombatModules
local DefaultAimPart = "HumRoot"
local CameraDirection
local AimbotDistance
local Aimbot = CombatTab:ToggleButton({
	name = "Aimbot",
	info = "Automatically aim at players",
	callback = function(enabled)
		if enabled then
			AimbotDistance = 20
			local Target = GetNearest(AimbotDistance)
			while task.wait(0.01) do
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
local CrazyAimModes = Aimbot:ToggleButtonInsideUI({
	name = "CrazyAim",
	callback = function()
		CreateNotification("Sigma5", "This feature is for premium", 3, true)
	end
})
local AimPartModes = Aimbot:Dropdown({
	name = "AimPart",
	default = "HumRoot",
	List = {"Head", "HumRoot", "LowerTorso"},
	callback = function(selectedItem)
		selectedItem = DefaultAimPart
	end
})
--KillAura
local KillAuraDistance
local KillAura = CombatTab:ToggleButton({
	name = "KillAura",
	info = "Attack the nearest entity",
	callback = function(enabled)
		if enabled then
			KillAuraDistance = 20
			local Target = GetNearest(KillAuraDistance)
			while task.wait(0.01) do
				if Target then
					local HitRemote = {
						[1] = Target
					}
					game:GetService("ReplicatedStorage"):FindFirstChild("events-Eqz"):FindFirstChild("5c73e2ee-c179-4b60-8be7-ef8e4a7eebaa"):FireServer(unpack(HitRemote))
				end
			end
		else
			KillAuraDistance = 0
		end
	end
})
local CustomKillAuraDist = KillAura:Slider({
	title = "Distance",
	min = 0,
	max = 100,
	default = 20,
	callback = function(val)
		KillAuraDistance = val
	end
})
local KillAuraSilent = KillAura:ToggleButtonInsideUI({
	name = "Silent",
	callback = function(enabled)
		if enabled then
			local Target = GetNearest(KillAuraDistance)
			local Direction = (Target.Character:WaitForChild("HumanoidRootPart").Position - LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).unit
			local LookAtVector = Vector3.new(Direction.X, 0, Direction.Z).unit
			local newCFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position, LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + LookAtVector)
			while task.wait(0.01) do
				LocalPlayer.Character:SetPrimaryPartCFrame(newCFrame)
			end
		end
	end
})
--RenderModules
local OldTime = Lighting.TimeOfDay
local OldBrightness = Lighting.Brightness
local Ambience = RenderTab:ToggleButton({
	name = "Ambience",
	info = "Change the game time",
	callback = function(enabled)
		if enabled then
			Lighting.TimeOfDay = "00:00:00"
			Lighting.Brightness = 7.55
		else
			Lighting.TimeOfDay = OldTime
			Lighting.Brightness = OldBrightness
		end
	end
})
--ESP
local ESPFolder
local ESP = RenderTab:ToggleButton({
	name = "ESP",
	info = "Highlight All Players",
	callback = function(enabled)
		if enabled then
			if not ESPFolder then
				ESPFolder = Instance.new("Folder", game.Workspace)
				ESPFolder.Name = "ESPHolder"
			end

			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer and player.Character then
					if not ESPFolder:FindFirstChild(player.Name) then
						local ESPHighlight = Instance.new("Highlight", ESPFolder)
						ESPHighlight.Adornee = player.Character
						ESPHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						ESPHighlight.Enabled = true
						ESPHighlight.FillColor = Color3.new(255, 255, 255)
						ESPHighlight.FillTransparency = 0.85
						ESPHighlight.OutlineColor = Color3.new(0, 0, 0)
						ESPHighlight.OutlineTransparency = 0.65
					end
				end
			end
		else
			if ESPFolder then
				ESPFolder:Destroy()
				ESPFolder = nil
			end
		end
	end
})
--Fullbright
local OldAmbient = Lighting.Ambient
local OldOutDoor = Lighting.OutdoorAmbient
local Fullbright = RenderTab:ToggleButton({
	name = "Fullbright",
	info = "Enhances visibility in the dark",
	callback = function(enabled)
		if enabled then
			Lighting.Ambient = Color3.new(1, 1, 1)
			Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		else
			Lighting.Ambient = OldAmbient
			Lighting.OutdoorAmbient = OldOutDoor
		end
	end
})
--[[
local FOVvalue = 90
local FOVChanger = RenderTab:ToggleButton({
	name = "FOVChanger",
	info = "Change your FOV value",
	callback = function(enabled)
		if enabled then
			game:GetService("ReplicatedStorage"):FindFirstChild("events-eL9"):FindFirstChild("99700188-ef7b-4d8a-89a6-3ac668d1d734"):FireServer("FieldOfView", FOVvalue)
			task.wait()
		end
	end
})
local CustomFOV = FOVChanger:Slider({
	title = "Custom",
	min = 0,
	max = 135,
	default = 90,
	callback = function(val)
		FOVvalue = val
	end
})
--]]
--PlayerModules
local DefaultFlyMode = "Easy.GG"
local VoxelMode = false
local EasyGGMode = false
local Bit16Mode = false
local OldGravity = game.Workspace.Gravity
local function VoxelFly()
	while VoxelMode do
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, 3, 0))
		wait(0.18)
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.LookVector * LocalPlayer.Character:WaitForChild("Humanoid").JumpPower * 1.8
		wait(0.85)
	end
end

local function EasyGGFly()
	while EasyGGMode do
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.LookVector * LocalPlayer.Character:WaitForChild("Humanoid").JumpPower * 2.3
		wait(3)
	end
end

local function Bit16Fly()
	while Bit16Mode do
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.LookVector * LocalPlayer.Character:WaitForChild("Humanoid").JumpPower * 0.3
		wait(0.8)
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.LookVector * LocalPlayer.Character:WaitForChild("Humanoid").JumpPower * 0.3
	end
end
local Fly = PlayerTab:ToggleButton({
	name = "Fly",
	info = "Weeeeeeeee",
	callback = function(enabled)
		if enabled then
			if LocalPlayer.Character then
				if DefaultFlyMode == "Voxels" then
					game.Workspace.Gravity = 0
					VoxelMode = true
					VoxelFly()
				elseif DefaultFlyMode == "Easy.GG" then
					game.Workspace.Gravity = 0
					EasyGGMode = true
					EasyGGFly()
				elseif DefaultFlyMode == "16BitPlay" then
					game.Workspace.Gravity = 8
					Bit16Mode = true
					LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, 28, 0))
					Bit16Fly()
				else
					VoxelMode = false
					EasyGGMode = false
					Bit16Mode = false
					game.Workspace.Gravity = 196.2
				end
			end
		end
	end
})
local CustomFlyPush = Fly:Slider({
	title = "PushPower",
	min = 0,
	max = 0,
	default = 0,
	callback = function(val)
	end
})
local FlyRageMode = Fly:ToggleButtonInsideUI({
	name = "RageMode",
	callback = function()
		CreateNotification("Sigma5", "This feature is for premium", 3, true)
	end
})
local FlyModes = Fly:Dropdown({
	name = "FlyModes",
	default = "Easy.GG",
	List = {"Voxels", "Easy.GG", "16BitPlay"},
	callback = function(selectedItem)
		selectedItem = DefaultFlyMode
	end
})
--Disabler
local Animate = LocalPlayer.Character:WaitForChild("Animate")
local Disabler = PlayerTab:ToggleButton({
	name = "Disabler",
	info = "Get trolled",
	callback = function(enabled)
		if enabled then
			for _, v in pairs(Animate:GetChildren()) do
				for _, x in pairs(v:GetChildren()) do
					if x:IsA("Animation") then
						x.AnimationId = ""
					end
				end
			end
		else
			CreateNotification("Disabler", "You can't turn this off", 3, true)
		end
	end
})
--Speed
local Speed = PlayerTab:ToggleButton({
	name = "Speed",
	info = "speedddddedd",
	callback = function(enabled)
		if enabled then
			LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 38
		else
			LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
		end
	end
})
