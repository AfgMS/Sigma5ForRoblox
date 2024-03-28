--Sigma5ForPC
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/LibraryPC.lua", true))()
local CoreGui = game:WaitForChild("CoreGui")
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = game.Players.LocalPlayer
local TeamsService = game:GetService("Teams")
local Camera = game:GetService("Workspace").CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local KnitClient = debug.getupvalue(require(localPlayer.PlayerScripts.TS.knit).setup, 6)
local Client = require(ReplicatedStorage.TS.remotes).default.Client
local ClientStore = require(localPlayer.PlayerScripts.TS.ui.store).ClientStore
local KnockbackCont = debug.getupvalue(require(ReplicatedStorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local SprintCont = KnitClient.Controllers.SprintController
local SwordCont = KnitClient.Controllers.SwordController
local BlockHit = ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["block-engine"].node_modules["@rbxts"].net.out._NetManaged.DamageBlock

local function isAlive(player)
	return player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Humanoid").Health > 0
end

local TeamCheck = false
local function GetNearestPlr(range)
	local nearestPlayer
	local nearestDistance = math.huge
	local localPlayer = game.Players.LocalPlayer

	for _, player in ipairs(game.Players:GetPlayers()) do
		if isAlive(player) and player ~= localPlayer and isAlive(localPlayer) then
			if not TeamCheck or player.Team ~= localPlayer.Team then
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
	end
	return nearestPlayer
end

local function GetBed(range)
	local nearestBed
	local nearestDistance = math.huge
	local localPlayer = game.Players.LocalPlayer

	for _, v in pairs(game.Workspace:GetChildren()) do
		if v.Name == "bed" and v.Covers.BrickColor ~= localPlayer.Team.TeamColor then
			local distance = (v.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
			if distance < nearestDistance and distance <= range then
				nearestBed = v
				nearestDistance = distance
			end
		end
	end
	return nearestBed
end

local function GetMatchState()
	return ClientStore:getState().Game.matchState
end

local function getQueueType()
	local MatchState = ClientStore:getState()
	return MatchState.Game.queueType or "bedwars_test"
end

local function SetHotbar(item)
	if localPlayer.Character:FindFirstChild("HandInvItem").Value ~= item then
		local Inventories = game:GetService("ReplicatedStorage").Inventories:FindFirstChild(localPlayer.Name):FindFirstChild(item)

		ReplicatedStorage.rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SetInvItem:InvokeServer({["hand"] = item})
	end
end

local function Value2Vector(vec)
	return { value = vec }
end

local function DamagePlayer(Target, Sword)
    ReplicatedStorage.rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit:FireServer({
        ["entityInstance"] = Target.Character,
        ["chargedAttack"] = {
            ["chargeRatio"] = 1
        },
        ["validate"] = {
            ["raycast"] = {
                ["cursorDirection"] = Value2Vector(Ray.new(game.Workspace.CurrentCamera.CFrame.Position, Target.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction),
                ["cameraPosition"] = Value2Vector(Target.Character:FindFirstChild("HumanoidRootPart").Position),
            },
            ["selfPosition"] = Value2Vector((localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Target.Character:FindFirstChild("HumanoidRootPart").Position).Unit * math.min(2, (localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Target.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude) + Target.Character:FindFirstChild("HumanoidRootPart").Position),
            ["targetPosition"] = Value2Vector(Target.Character.HumanoidRootPart.Position),
        },
        ["weapon"] = Sword
    })
end

local MeleeRank = {
	[1] = { Name = "wood_sword", Rank = 1 },
	[2] = { Name = "stone_sword", Rank = 2 },
	[3] = { Name = "iron_sword", Rank = 3 },
	[4] = { Name = "diamond_sword", Rank = 4 },
	[5] = { Name = "void_sword", Rank = 5 },
	[6] = { Name = "emerald_sword", Rank = 6 },
	[7] = { Name = "rageblade", Rank = 7 },
}

local function GetMelee()
	local bestsword = nil
	local bestrank = 0

	for i, v in pairs(localPlayer.Character.InventoryFolder.Value:GetChildren()) do
		if v.Name:match("sword") or v.Name:match("blade") then
			for _, data in pairs(MeleeRank) do
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
--CreatingUI
Library:createScreenGui()
--Tabs
local GuiTab = Library:CreateTab("Gui")
local CombatTab = Library:CreateTab("Combat")
local RenderTab = Library:CreateTab("Render")
local PlayerTab = Library:CreateTab("Player")
local WorldTab = Library:CreateTab("World")
--ActiveMods
local ActiveMods = GuiTab:CreateToggle({
	Name = "ActiveMods",
	Description  = "Render enabled modules",
	Bind = nil,
	callback = function(enabled)
		CoreGui.Sigma5Visual.RightSide.ActiveModsHolder.Visible = not CoreGui.Sigma5Visual.RightSide.ActiveModsHolder.Visible
	end
})
--TabGUI
local TabGUI = GuiTab:CreateToggle({
	Name = "TabGUI",
	Description  = "Render sigma5 TabGUI",
	Bind = nil,
	callback = function(enabled)
		CoreGui.Sigma5Visual.LeftSide.TabHolder.Visible = not CoreGui.Sigma5Visual.LeftSide.TabHolder.Visible
	end
})
--DeleteGui
local BlurEffect = Lighting:FindFirstChild("Blur")
local DeleteGUI = GuiTab:CreateToggle({
	Name = "DeleteGUI",
	Description  = "Delete sigma5 and sigma5visual",
	Bind = nil,
	callback = function(enabled)
		if enabled then
			BlurEffect:Destroy()
			task.wait()
			CoreGui.Sigma5Visual:Destroy()
			task.wait()
			CoreGui.sigma5:Destroy()
		end
	end
})
--Aimbot
local aimbotDistance
local Aimbot = CombatTab:CreateToggle({
	Name = "Aimbot",
	Description  = "Automatically aim at players",
	Bind = nil,
	callback = function(enabled)
		if enabled then
			aimbotDistance = 20
			while enabled do
				local Target = GetNearestPlr(aimbotDistance)
				if not isAlive(localPlayer) then
					repeat task.wait() until isAlive(localPlayer)
				end
				if Target then
					if not isAlive(Target) then
						repeat task.wait() until isAlive(Target)
					end
					local CameraDirection = (Target.Character.HumanoidRootPart.Position - Camera.CFrame.Position).unit
					local newLookAt = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + CameraDirection)
					Camera.CFrame = newLookAt
				end
				task.wait()
			end
		else
			aimbotDistance = 0
		end
	end
})
local aimbotCSDistance = Aimbot:CreateSlider({
	Name = "Distance",
	MinVal = 0,
	MaxVal = 100,
	callback = function(val)
		aimbotDistance = val
	end
})
--AntiKnockback
local OriginalH = KnockbackCont.kbDirectionStrength
local OriginalY = KnockbackCont.kbUpwardStrength
local AntiKnockback = CombatTab:CreateToggle({
	Name = "AntiKnockback",
	Description  = "Remove knockback",
	Bind = nil,
	callback = function(enabled)
		if enabled then
			KnockbackCont.kbDirectionStrength = 0
			KnockbackCont.kbUpwardStrength = 0
		else
			KnockbackCont.kbDirectionStrength = OriginalH
			KnockbackCont.kbUpwardStrength = OriginalY
		end
	end
})
--AutoQuit
local MaxHealth
local AutoQuit = CombatTab:CreateToggle({
	Name = "AutoQuit",
	Description  = "Quit the game when you are low",
	Bind = nil,
	callback = function(enabled)
		if enabled then
			MaxHealth = 0.11
			if localPlayer and isAlive(localPlayer) then
				while enabled do
					if localPlayer.Character:FindFirstChild("Humanoid").Health < MaxHealth then
						CreateNotification("AutoQuit", "You are getting kicked", 3, true)
						task.wait()
						localPlayer:Kick("AutoQuit Triggered")
					end
					task.wait()
				end
			end
		else
			MaxHealth = nil
		end
	end
})
--KillAura
local Target
local KillAuraDistance
local KillAuraAutoSword = false
local KillAuraRotation = false
local Sword = GetMelee()

local KillAura = CombatTab:CreateToggle({
    Name = "KillAura",
    Description = "Attack the nearby player",
    Bind = "R",
    callback = function(enabled)
        if enabled then
            KillAuraDistance = 20
            Target = GetNearestPlr(KillAuraDistance)
            if KillAuraAutoSword then
                if Target and isAlive(localPlayer) then
                    SetHotbar(Sword)
                else
                    KillAuraAutoSword = false
                end
            end
            if KillAuraRotation then
                while task.wait(0.01) do
                    if Target and isAlive(localPlayer) then
                        if not isAlive(Target) then
                            repeat task.wait() until isAlive(Target)
                        end
                        local direction = (Target.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).unit
                        local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
                        local newCFrame = CFrame.new(localPlayer.Character.HumanoidRootPart.Position, localPlayer.Character.HumanoidRootPart.Position + lookVector)
                        localPlayer.Character:SetPrimaryPartCFrame(newCFrame)
                    end
                end
            end
            if Target and isAlive(Target) then
                while task.wait(0.03) do
                    if not isAlive(Target) then
                        repeat task.wait() until isAlive(Target)
                    end
                    DamagePlayer(Target, Sword)
                end
            end
        else
            KillAuraDistance = 0
        end
    end
})
local UnknownSlider0 = KillAura:CreateSlider({
	Name = "???",
	MinVal = 0,
	MaxVal = 0,
	callback = function(val)
	end
})
local AutoSword = KillAura:MiniToggle({
	Name = "AutoSword",
	callback = function(enabled)
		KillAuraAutoSword = not KillAuraAutoSword
	end
})
local Rotation = KillAura:MiniToggle({
	Name = "Rotation",
	callback = function(enabled)
		KillAuraRotation = not KillAuraRotation
	end
})
--Teams
local Teams = CombatTab:CreateToggle({
	Name = "Teams",
	Description = "Avoid combat to your teammate",
	Bind = nil,
	callback = function(enabled)
		TeamCheck = enabled
	end
})
--Fullbright
local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient
local Fullbright = RenderTab:CreateToggle({
	Name = "Fullbright",
	Description = "Enhances visibility in the dark",
	Bind = nil,
	callback = function(enabled)
		if enabled then
			Lighting.Ambient = Color3.new(1, 1, 1)
			Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		else
			Lighting.Ambient = originalAmbient
			Lighting.OutdoorAmbient = originalOutdoor
		end
	end
})
--Gameplay
local AutoQueue = false
local AutoGG = false
local ActionDelay = 1
local GamePlay = PlayerTab:CreateToggle({
	Name = "GamePlay",
	Description = "Makes your experience better",
	Bind = nil,
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
local GamePlayDelay = GamePlay:CreateSlider({
	Name = "Delay",
	MinVal = 0,
	MaxVal = 5,
	callback = function(val)
		ActionDelay = val
	end
})
local AutoQueueToggle = GamePlay:MiniToggle({
	Name = "AutoQueue",
	callback = function(enabled)
		AutoQueue = enabled
	end
})
local AutoGGToggle = GamePlay:MiniToggle({
	Name = "AutoGG",
	callback = function(enabled)
		AutoGG = enabled
	end
})
--AutoSprint
local AutoSprint = PlayerTab:CreateToggle({
	Name = "AutoSprint",
	Description = "Automatically Sprint",
	Bind = nil,
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
local Speed = PlayerTab:CreateToggle({
	Name = "Speed",
	Description = "Speed goes brrr",
	Bind = "X",
	callback = function(enabled)
		if enabled then
			localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 23
		else
			localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
		end
	end
})
--Fly
local startPosition
local Fly = RenderTab:CreateToggle({
    Name = "Fly",
    Bind = "Y",
    callback = function(enabled)
        if enabled then
            game.Workspace.Gravity = 0
            startPosition = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        else
            game.Workspace.Gravity = 192.6
            if startPosition then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(startPosition)
                startPosition = nil
            end
        end
    end
})
--AntiVanish
local AntiVanish = WorldTab:CreateToggle({
	Name = "AntiVanish",
	Description = "Staff detector",
	Bind = nil,
	callback = function(enabled)
		if enabled then
			game.Players.PlayerAdded:Connect(function(player)
				if not player:IsFriendsWith(game.Players.LocalPlayer.UserId) and GetMatchState() ~= 0 then
					CreateNotification("AntiVanish", "Someone just vanished", 5, true)
				end
			end)

			for i, player in pairs(game.Players:GetPlayers()) do
				if player:IsInGroup(5774246) and player:GetRankInGroup(5774246) >= 2 then
					CreateNotification("AntiVanish", "Someone just vanished", 5, true)
				end
			end
		end
	end
})
--Nuker
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
local Nuker = WorldTab:CreateToggle({
	Name = "Nuker",
	Description = "Auto bed break",
	Bind = "Z",
	callback = function(enabled)
		if enabled then
			BedHitDelay = 0.54
			while enabled do
				if not isAlive(localPlayer) then 
					repeat task.wait() until isAlive(localPlayer) 
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
local antivoidpart = nil
local function AntiVoidTest()
	antivoidpart = Instance.new("Part", game.Workspace)
	antivoidpart.Transparency = 0.38
	antivoidpart.CanCollide = true
	antivoidpart.BrickColor = BrickColor.new(255, 255, 255)
	antivoidpart.Size = Vector3.new(999999, 3, 999999)
	antivoidpart.Anchored = true
	antivoidpart.Position = localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Vector3.new(0, 18, 0)
	antivoidpart.Name = "antivoidpart"

	antivoidpart.Touched:Connect(function(hit)
		local player = hit.Parent
		if player and isAlive(player) then
			local humanoid = player:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.PlatformStand = true
				wait(0.48)
				humanoid.PlatformStand = false
			end
		end
	end)
end
local AntiVoid = WorldTab:CreateToggle({
	Name = "AntiVoid",
	Description = "Prevents falling into the void",
	Bind = nil,
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
