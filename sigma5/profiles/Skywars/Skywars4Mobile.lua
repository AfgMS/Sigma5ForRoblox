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

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character:WaitForChild("HumanoidRootPart") and LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
			local playerPrimary = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			local lplrPrimary = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if playerPrimary and lplrPrimary then
				local distance = (playerPrimary.Position - lplrPrimary.Position).magnitude
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
local CrazyAimModes = Aimbot:ToggleButtonInsideUI({
	name = "CrazyAim",
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
--KillAura
local SilentRotateDelay
local KillAuraDistance
local KillAura = CombatTab:ToggleButton({
	name = "KillAura",
	info = "Attack the nearest entity",
	callback = function(enabled)
		if enabled then
			KillAuraDistance = 20
			while enabled do
				local Target = GetNearest(KillAuraDistance)
				if Target then
					local KillAuraComponent = {
						[1] = Target
					}
					game:GetService("ReplicatedStorage"):FindFirstChild("events-eL9"):FindFirstChild("089f902f-520f-4165-a497-80b7dbd0b7ff"):FireServer(unpack(KillAuraComponent))
					game:GetService("ReplicatedStorage"):FindFirstChild("events-eL9"):FindFirstChild("24f1b7a0-a1d8-444b-9866-5fcdfb43530d"):FireServer(unpack(KillAuraComponent))
				end
				task.wait()
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
			SilentRotateDelay = 0.01
			while enabled do
				if Target then
					local Direction = (Target.Character:WaitForChild("HumanoidRootPart").Position - LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).unit
					local LookAtVector = Vector3.new(Direction.X, 0, Direction.Z).unit
					local newCFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position, LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + LookAtVector)
					LocalPlayer.Character:SetPrimaryPartCFrame(newCFrame)
				end
				wait(SilentRotateDelay)
			end
		else
			SilentRotateDelay = 86400
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
--NameTag
local NameTag = RenderTab:ToggleButton({
	name = "NameTag",
	info = "Modified Nametag",
	callback = function(enabled)
		if enabled then
			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local NameTagEEE = player.Character:FindFirstChild("Nametag")
					if NameTagEEE and NameTagEEE:IsA("BillboardGui") then
						NameTagEEE = NameTagEEE:FindFirstChild("NameTag")
						if NameTagEEE then
							NameTagEEE.Size = UDim2.new(35, 0, 15, 0)
							NameTagEEE.MaxDistance = math.huge
						end
					end
				end
			end
		else
			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local NameTagEEE = player.Character:FindFirstChild("Nametag")
					if NameTagEEE and NameTagEEE:IsA("BillboardGui") then
						NameTagEEE = NameTagEEE:FindFirstChild("NameTag")
						if NameTagEEE then
							NameTagEEE.Size = UDim2.new(5, 0, 2, 0)
							NameTagEEE.MaxDistance = 288
						end
					end
				end
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
				end
			end
		else
			if VoxelMode then
				VoxelMode = false
				game.Workspace.Gravity = 196.2
			elseif EasyGGMode then
				EasyGGMode = false
				game.Workspace.Gravity = 196.2
			elseif Bit16Mode then
				Bit16Mode = false
				game.Workspace.Gravity = 196.2
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
	list = {"Voxels", "Easy.GG", "16BitPlay"},
	callback = function(selectedItem)
		DefaultFlyMode = selectedItem
	end
})
--[[
local DefaultLongJumpMode = "Voxels"
local VoxelLongMode = false
local EasyGGLongMode = false

local function VoxelLongJump()
	while VoxelLongMode do
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, 18, 0))
		wait(0.3)
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, -15, 0))
		wait(0.5)
		game.Workspace.Gravity = 0
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(25, 8, 0))
		wait(3)
		VoxelLongMode = false
		game.Workspace.Gravity = 192.6
	end
end

local function EasyGGLongJump()
	while EasyGGLongMode do
		game.Workspace.Gravity = 8
		LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)    
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").Velocity = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame.LookVector * LocalPlayer.Character:WaitForChild("Humanoid").JumpPower * 1.3
		wait(3)
		EasyGGLongMode = false
		game.Workspace.Gravity = 192.6
	end
end

local LongJump = PlayerTab:ToggleButton({
	name = "LongJump",
	info = "long jumpzzzz",
	callback = function(enabled)
		if enabled then
			if LocalPlayer.Character then
				if DefaultLongJumpMode == "Voxels" then
					VoxelLongMode = true
					VoxelLongJump()
				elseif DefaultLongJumpMode == "Easy.GG" then
					EasyGGLongMode = true
					EasyGGLongJump()
				end
			end
		else
			VoxelLongMode = false
			EasyGGLongMode = false
		end
	end
})
local CustomLongJumpPush = LongJump:Slider({
	title = "LongJumpPower",
	min = 0,
	max = 100,
	default = 8,
	callback = function(val)
	end
})
local LongJumpRageMode = LongJump:ToggleButtonInsideUI({
	name = "RageMode",
	callback = function()
		CreateNotification("Sigma5", "This feature is for premium", 3, true)
	end
})
local LongJumpMode = LongJump:Dropdown({
	name = "LongJumpModes",
	default = "Voxels",
	list = {"Voxels", "Easy.GG"},
	callback = function(selectedItem)
		DefaultLongJumpMode = selectedItem
	end
})
--]]
--Speed
local Speed = PlayerTab:ToggleButton({
	name = "Speed",
	info = "speedddddedd",
	callback = function(enabled)
		if enabled then
			LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 43
		else
			LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
		end
	end
})
--TargetStrafe
local StrafeRadius = 8
local StrafeSpeed = 13
local StrafeAngle = 0
local StrafeDelay

local TargetStrafe = PlayerTab:ToggleButton({
	name = "TargetStrafe",
	info = "circle around a player",
	callback = function(enabled)
		if enabled then
			StrafeDelay = 0.01
			local Target = GetNearest(20)
			while task.wait(StrafeDelay) do
				StrafeAngle = StrafeAngle + StrafeSpeed
				local x = math.cos(math.rad(StrafeAngle)) * StrafeRadius
				local z = math.sin(math.rad(StrafeAngle)) * StrafeRadius
				local newPosition = Target.Character.PrimaryPart.Position + Vector3.new(x, 0, z)

				LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(newPosition, LocalPlayer.Character.PrimaryPart.Position))

				local Direction = (Target.Character:WaitForChild("HumanoidRootPart").Position - LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).unit
				local LookAtVector = Vector3.new(Direction.X, 0, Direction.Z).unit
				local newCFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position, LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + LookAtVector)
				LocalPlayer.Character:SetPrimaryPartCFrame(newCFrame)
			end
		else
			StrafeDelay = 86400
		end
	end
})
local CustomStrafeRadius = TargetStrafe:Slider({
	title = "Radius",
	min = 0,
	max = 100,
	default = 8,
	callback = function(val)
		StrafeRadius = val
	end
})
local CustomStrafeSpeed = TargetStrafe:Slider({
	title = "Speed",
	min = 0,
	max = 100,
	default = 5,
	callback = function(val)
		StrafeSpeed = val
	end
})
local CustomStrafeAngle = TargetStrafe:Slider({
	title = "Angle",
	min = 0,
	max = 100,
	default = 5,
	callback = function(val)
		StrafeAngle = val
	end
})
--AntiVanish
local AntiVanish = WorldTab:ToggleButton({
	name = "AntiVanish",
	info = "Staff detector",
	callback = function(enabled)
		if enabled then
			for _, player in pairs(game.Players:GetPlayers()) do
				if player:IsInGroup(8154377) and player:GetRankInGroup(8154377) >= 1 then
					CreateNotification("AntiVanish", "Player " .. player.Name .. " Vanished", 10, true)
				elseif player.UserId == 1162748399 and player.Name == "erpanmand" then
					CreateNotification("AntiVanish", "Owner Here", 5, true)
				end
			end
		end
	end
})
--AntiVoid
local antivoidpart
local function AntiVoidTest()
	antivoidpart = Instance.new("Part", game.Workspace)
	antivoidpart.Transparency = 0.38
	antivoidpart.CanCollide = true
	antivoidpart.BrickColor = BrickColor.new(255, 255, 255)
	antivoidpart.Size = Vector3.new(999999, 3, 999999)
	antivoidpart.Anchored = true
	antivoidpart.Position = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Vector3.new(0, 15, 0)
	antivoidpart.Name = "antivoidpart"

	antivoidpart.Touched:Connect(function(other)
		if other:IsDescendantOf(LocalPlayer.Character) then
			local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			wait(0.28)
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			wait(0.28)
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
end
local AntiVoid = WorldTab:ToggleButton({
	name = "AntiVoid",
	info = "Prevents falling into the void",
	callback = function(enabled)
		if enabled then
			AntiVoidTest()
		else
			if antivoidpart then
				antivoidpart:Destroy()
				antivoidpart = nil
			end
		end
	end
})
