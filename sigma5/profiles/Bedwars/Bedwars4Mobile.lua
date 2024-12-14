--Services
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/refs/heads/main/sigma5/LibraryMobile.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = game:GetService("Workspace").CurrentCamera
local TeamsService = game:GetService("Teams")
local Lighting = game:GetService("Lighting")
local CoreGui = game:WaitForChild("CoreGui")
local LocalPlayer = game.Players.LocalPlayer
local Player = game:GetService("Players")
local VisualFolder = Instance.new("Folder", game.Workspace)
VisualFolder.Name = "VisualFolder"
--Functions
local KnitClient = debug.getupvalue(require(LocalPlayer.PlayerScripts.TS.knit).setup, 6)
local ClientStore = require(LocalPlayer.PlayerScripts.TS.ui.store).ClientStore
local TeamChecks = false
local function GetNearest(dist)
	local nearestPlr = {}
	local minDist = dist + 1

	for _, v in ipairs(game.Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			if not TeamChecks or v.Team ~= LocalPlayer.Team then
				if v.Character:FindFirstChild("HumanoidRootPart") then
					local distance = (v.Character:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).magnitude
					if distance <= dist then
						table.insert(nearestPlr, v)
						minDist = math.min(minDist, distance)
					end
				end
			end
		end
	end

	for i = #nearestPlr, 1, -1 do
		if (nearestPlr[i].Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude > minDist then
			table.remove(nearestPlr, i)
		end
	end

	return nearestPlr
end

local function wrapVector(vec)
	return { value = vec }
end

local SwordRank = {
	[1] = { Name = "wood_sword", Rank = 1 },
	[2] = { Name = "stone_sword", Rank = 2 },
	[3] = { Name = "iron_sword", Rank = 3 },
	[4] = { Name = "diamond_sword", Rank = 4 },
	[5] = { Name = "void_sword", Rank = 5 },
	[6] = { Name = "emerald_sword", Rank = 6 },
	[7] = { Name = "rageblade", Rank = 7 },
}

local function GetSword()
	local bestsword = nil
	local bestrank = 0

	for i, v in pairs(LocalPlayer.Character.InventoryFolder.Value:GetChildren()) do
		if v.Name:match("sword") or v.Name:match("blade") then
			for _, data in pairs(SwordRank) do
				if data["Name"] == v.Name then
					if bestrank <= data["Rank"] then
						bestrank = data["Rank"]
						bestsword = v
					end
				end
			end
		end
	end
	return bestsword
end

local function GetMatchState()
	return ClientStore:getState().Game.matchState
end

local function getQueueType()
	local MatchState = ClientStore:getState()
	return MatchState.Game.queueType or "bedwars_test"
end

local function GetBed(range)
	local nearestBed
	local nearestDistance = math.huge
	local LocalPlayer = game.Players.LocalPlayer

	for _, v in pairs(game.Workspace:GetChildren()) do
		if v.Name == "bed" and v.Blanket.BrickColor ~= LocalPlayer.Team.TeamColor then
			local distance = (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
			if distance < nearestDistance and distance <= range then
				nearestBed = v
				nearestDistance = distance
			end
		end
	end
	return nearestBed
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
local JitterAimMode = Aimbot:ToggleButtonInsideUI({
	name = "JitterMode",
	callback = function()
		Library:CreateNotification("Sigma5", "This feature is for premium", 3, true)
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
--AntiKnockback
local KnockbackCont = debug.getupvalue(require(ReplicatedStorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local OldHorizontal = KnockbackCont.kbDirectionStrength
local OldVertical = KnockbackCont.kbUpwardStrength
local AntiKnockback = CombatTab:ToggleButton({
	name = "AntiKnockback",
	info = "Prevent you from taking knockback",
	callback = function(enabled)
		if enabled then
			KnockbackCont.kbDirectionStrength = 0
			KnockbackCont.kbUpwardStrength = 0
		else
			KnockbackCont.kbDirectionStrength = OldHorizontal
			KnockbackCont.kbUpwardStrength = OldVertical
		end
	end
})
--AutoQuit
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
						Library:CreateNotification("AutoQuit", "Modules Triggered", 3, true)
						task.wait()
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
--KillAura
local KillAuraDistance
local KillAuraDelay
local Sword
local KillAura = CombatTab:ToggleButton({
	name = "KillAura",
	info = "Attack Nearest Player",
	callback = function(enabled)
		if enabled then
			KillAuraDelay = 0.01
			KillAuraDistance = 20
			Sword = GetSword()
			while enabled do
				local Target = GetNearest(KillAuraDistance)
				if Target and Target.Character and LocalPlayer.Character then
					local TargetRoot = Target.Character:FindFirstChild("HumanoidRootPart")
					if TargetRoot then
						local raycastParams = {
							["cursorDirection"] = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, TargetRoot.Position).Unit.Direction,
							["cameraPosition"] = TargetRoot.Position,
						}
						ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.SwordHit:FireServer({
							["entityInstance"] = Target.Character,
							["chargedAttack"] = {
								["chargeRatio"] = 1
							},
							["validate"] = {
								["raycast"] = raycastParams,
								["selfPosition"] = (LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position - TargetRoot.Position).Unit * math.min(2, (LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position - TargetRoot.Position).Magnitude) + TargetRoot.Position,
								["targetPosition"] = TargetRoot.Position,
							},
							["weapon"] = Sword
						})
					end
				end
				task.wait(KillAuraDelay)
			end
		else
			KillAuraDelay = 86400
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
local KillAuraSilentAim = KillAura:ToggleButtonInsideUI({
	name = "SilentAim",
	callback = function(enabled)
		while enabled do
			local Target = GetNearest(KillAuraDistance)
			if Target and Target.Character then
				local direction = (Target.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).unit
				local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
				local newCFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, LocalPlayer.Character.HumanoidRootPart.Position + lookVector)
				LocalPlayer.Character:SetPrimaryPartCFrame(newCFrame)
			else
				repeat task.wait() until Target and Target.Character
			end
			task.wait()
		end
	end
})
local KillAuraESP = KillAura:ToggleButtonInsideUI({
	name = "TargetESP",
	callback = function(enabled)
		if enabled then
			if not game.Workspace:FindFirstChild("VisualFolder") then
				local VisualFolder = Instance.new("Folder", game.Workspace)
				VisualFolder.Name = "VisualFolder"
			end

			local SimsHolder = Instance.new("BillboardGui")
			SimsHolder.Name = "SimsESP"
			SimsHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			SimsHolder.Active = true
			SimsHolder.AlwaysOnTop = true
			SimsHolder.LightInfluence = 1.000
			SimsHolder.MaxDistance = 28.000
			SimsHolder.Size = UDim2.new(0, 500, 0, 500)
			SimsHolder.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)

			local SimsGreen = Instance.new("ImageLabel", SimsHolder)
			SimsGreen.AnchorPoint = Vector2.new(0.5, 0.5)
			SimsGreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SimsGreen.BackgroundTransparency = 1.000
			SimsGreen.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SimsGreen.BorderSizePixel = 0
			SimsGreen.Position = UDim2.new(0.5, 0, 0.5, 0)
			SimsGreen.Size = UDim2.new(0.215, 0, 0.245, 0)
			SimsGreen.Image = "http://www.roblox.com/asset/?id=17329562110" -- Closing parenthesis added here.

			local function UpdateSimsHolder()
				local Target = GetNearest(KillAuraDistance)
				if Target then
					SimsHolder.Parent = Target.Character:WaitForChild("Head")
				else
					SimsHolder.Parent = game.Workspace:FindFirstChild("VisualFolder")
				end
			end

			while enabled do
				UpdateSimsHolder()
				task.wait()
			end
		end
	end
})
--Teams
local Teams = CombatTab:ToggleButton({
	name = "Teams",
	info = "Avoid combat on your team",
	callback = function(enabled)
		TeamChecks = not TeamChecks
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
local ESP = RenderTab:ToggleButton({
	name = "ESP",
	info = "Highlight All Players",
	callback = function(enabled)
		if enabled then
			if not game.Workspace:FindFirstChild("VisualFolder") then
				local VisualFolder = Instance.new("Folder", game.Workspace)
				VisualFolder.Name = "VisualFolder"
			end

			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer and player.Character then
					if not VisualFolder:FindFirstChild(player.Name) then
						local ESPHighlight = Instance.new("Highlight", VisualFolder)
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
			if VisualFolder then
				VisualFolder:Destroy()
				VisualFolder = nil
			end
		end
	end
})

--PlayerModules
local AutoQueue = false
local AutoGG = false
local ActionDelay = 1
local GamePlay = PlayerTab:ToggleButton({
	name = "GamePlay",
	info = "Makes your experience better",
	callback = function(enabled)
		if enabled then
			if AutoQueue then
				spawn(function()
					repeat
						task.wait(ActionDelay)
					until GetMatchState() == 2 or not enabled
					ReplicatedStorage:FindFirstChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue:FireServer({["queueType"] = getQueueType()})
				end)
			end

			if AutoGG then
				spawn(function()
					repeat
						task.wait(ActionDelay)
					until GetMatchState() == 2 or not enabled
					ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GG", "All")
				end)
			end
		else
			AutoQueue, AutoGG = false, false
		end
	end
})
local GamePlayFix = GamePlay:Slider({
	title = "Delay",
	min = 0,
	max = 100,
	default = 1,
	callback = function(val)
		ActionDelay = val
	end
})
local AutoQueueToggle = GamePlay:ToggleButtonInsideUI({
	name = "AutoQueue",
	callback = function(enabled)
		AutoQueue = enabled
	end
})
local AutoGGToggle = GamePlay:ToggleButtonInsideUI({
	name = "AutoGG",
	callback = function(enabled)
		AutoGG = enabled
	end
})
--AutoSprint
local SprintCont = KnitClient.Controllers.SprintController
local AutoSprint = PlayerTab:ToggleButton({
	name = "AutoSprint",
	info = "Automatically Sprint",
	callback = function(enabled)
		if enabled then
			spawn(function()
				while enabled do
					task.wait()
					if not SprintCont.sprinting then
						SprintCont:startSprinting()
					end
				end
			end)
		else
			spawn(function()
				while not enabled do
					task.wait()
					if SprintCont.sprinting then
						SprintCont:stopSprinting()
					end
				end
			end)
		end
	end
})
--Speed
local Speed = PlayerTab:ToggleButton({
	name = "Speed",
	info = "Speed goes brrr",
	callback = function(enabled)
		if enabled then
			LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 23
		else
			LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
		end
	end
})
--Fly
local DefaultFlyMode = "Easy.GG"
local VoxelMode = false
local EasyGGMode = false
local Bit16Mode = false

local function VoxelFly()
	while VoxelMode do
		LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, 3, 0))
		wait(0.10)
		LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,-0.1,-1.3)
		wait(0.18)
	end
end

local function EasyGGFly()
	while EasyGGMode do
		LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,-0.1,-1.5)
		wait(0.23)
	end
end

local function Bit16Fly()
	while Bit16Mode do
		LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,-0.1,-1.3)
		wait(0.12)
		LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,-0.1,-1.3)
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
					LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
					task.wait(0.32)
					game.Workspace.Gravity = 0
					task.wait(0.3)
					game.Workspace.Gravity = 3
					Bit16Mode = true
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
		Library:CreateNotification("Sigma5", "This feature is for premium", 3, true)
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

--WorldModules
local AntiVanish = WorldTab:ToggleButton({
	name = "AntiVanish",
	info = "Staff detector",
	callback = function(enabled)
		if enabled then
			game.Players.PlayerAdded:Connect(function(player)
				if not player:IsFriendsWith(game.Players.LocalPlayer.UserId) and GetMatchState() ~= 0 then
					Library:CreateNotification("AntiVanish", "Someone just vanished", 5, true)
				end
			end)

			for i, player in pairs(game.Players:GetPlayers()) do
				if player:IsInGroup(5774246) and player:GetRankInGroup(5774246) >= 2 then
					Library:CreateNotification("AntiVanish", "Someone just vanished", 5, true)
				end
			end
		end
	end
})
--Nuker
local BlockHit = ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["block-engine"].node_modules["@rbxts"].net.out._NetManaged.DamageBlock
local raycastParams = RaycastParams.new()
raycastParams.IgnoreWater = true
local function HitBed(bed)
	local raycastResult = workspace:Raycast(bed.Position + Vector3.new(0, 13, 0), Vector3.new(0, -16, 0), raycastParams)
	if raycastResult then
		local nearestBed = raycastResult.Instance
		for i, v in pairs(nearestBed:GetChildren()) do
			if v:IsA("Texture") then
				v:Destroy()
			end
		end
		nearestBed.Transparency = 0.75
		nearestBed.Color = Color3.fromRGB(255, 255, 255)
		BlockHit:InvokeServer({
			["blockRef"] = {
				["blockPosition"] = Vector3.new(math.round(nearestBed.Position.X / 3), math.round(nearestBed.Position.Y / 3), math.round(nearestBed.Position.Z / 3))
			},
			["hitPosition"] = Vector3.new(math.round(nearestBed.Position.X / 3), math.round(nearestBed.Position.Y / 3), math.round(nearestBed.Position.Z / 3)),
			["hitNormal"] = Vector3.new(math.round(nearestBed.Position.X / 3), math.round(nearestBed.Position.Y / 3), math.round(nearestBed.Position.Z / 3))
		})
	end
end
local BedHitDelay
local Nuker = WorldTab:ToggleButton({
	name = "Nuker",
	info = "Auto bed break",
	callback = function(enabled)
		if enabled then
			BedHitDelay = 0.01
			while enabled do
				if not LocalPlayer.Character then 
					repeat task.wait() until LocalPlayer.Character
				end
				local nearestBed = GetBed(28.3)
				if nearestBed then
					HitBed(nearestBed)
				end
				task.wait(BedHitDelay)
			end
		else
			BedHitDelay = 86000
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
