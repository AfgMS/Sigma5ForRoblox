--NotHm.. on youtube, and nothm_ on discord
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/sigma5ForRoblox/main/sigma5/LibraryPC.lua", true))()
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

function getQueueType()
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

local MeleeRank = {
	[1] = { Name = "wood_sword", Rank = 1 },
	[2] = { Name = "stone_sword", Rank = 2 },
	[3] = { Name = "iron_sword", Rank = 3 },
	[4] = { Name = "diamond_sword", Rank = 4 },
	[5] = { Name = "void_sword", Rank = 5 },
	[6] = { Name = "emerald_sword", Rank = 6 },
	[7] = { Name = "rageblade", Rank = 7 },
}
function GetAttackPos(plrpos, nearpost, val)
	local newPos = (nearpost - plrpos).Unit * math.min(val, (nearpost - plrpos).Magnitude) + plrpos
	return newPos
end

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
--Notification
CreateNotification("Loader", "Loaded Successfully", 3, true)
--ActiveMods
local ActiveMods = GuiTab:CreateToggle({
	Name = "ActiveMods",
	Description = "Render active mods",
	callback = function(enabled)
		CoreGui.SigmaVisualStuff.ArrayListHolder.Visible = not CoreGui.SigmaVisualStuff.ArrayListHolder.Visible
	end
})
--TabGUI
local TabGUI = GuiTab:CreateToggle({
	Name = "TabGUI",
	Description = "Just decorations",
	callback = function(enabled)
		CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible = not CoreGui.SigmaVisualStuff.LeftHolder.TabHolder.Visible
	end
})
--DeleteGui
local BlurEffect = Lighting:FindFirstChild("Blur")
local DeleteGui = GuiTab:CreateToggle({
	Name = "DeleteGUI",
	Description = "Does not uninject",
	callback = function(enabled)
		if enabled then
			BlurEffect:Destroy()
			CoreGui.sigma5:Destroy()
			print("Destroyed Main")
			CoreGui.sigma5Visual:Destroy()
			print("Destroyed Notif")
		end
	end
})
--Aimbot
local AimbotRange
local Aimbot = CombatTab:CreateToggle({
	Name = "Aimbot",
	Description = "Automatically aim at players",
	callback = function(enabled)
		if enabled then
			AimbotRange = 20
			while enabled do
				local NearestPlayer = GetNearestPlr(AimbotRange)
				if NearestPlayer and isAlive(NearestPlayer) and isAlive(localPlayer) then
					local direction = (NearestPlayer.Character.HumanoidRootPart.Position - Camera.CFrame.Position).unit
					local newLookAt = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
					Camera.CFrame = newLookAt
				end
				wait(0.01)
			end
		else
			AimbotRange = 0
		end
	end
})
local AimbotRangeCustom = Aimbot:CreateSlider({
	title = "Range",
	min = 0,
	max = 20,
	default = 20,
	callback = function(val)
		AimbotRange = val
	end
})
--AntiKnockback
local OriginalH = KnockbackCont.kbDirectionStrength
local OriginalY = KnockbackCont.kbUpwardStrength
local AntiKnockback = CombatTab:CreateToggle({
	Name = "AntiKnockback",
	Description = "Prevent you from taking knockback",
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
local LowHealthValue
local function CheckHealth()
	while wait(0.01) do
		if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character.Humanoid.Health < LowHealthValue then
			localPlayer:Kick("AutoQuit")
		end
	end
end
local AutoQuit = CombatTab:CreateToggle({
	Name = "AutoQuit",
	Description = "Automatically quit the game",
	callback = function(enabled)
		if enabled then
			LowHealthValue = 3
			CheckHealth()
		else
			LowHealthValue = nil
		end
	end
})
local CustomLowHealth = AutoQuit:CreateSlider({
	title = "HealthMin",
	min = 0.11,
	max = 100,
	default = 0.11,
	callback = function(value)
		LowHealthValue = value
	end
})
--KillAura
local KillAuraRange
local RotationsRange
local AutoSword = false
local KillAura = CombatTab:CreateToggle({
	Name = "KillAura",
	Description = "Automatically attacks players",
	Bind = "R",
	callback = function(enabled)
		if enabled then
			KillAuraRange = 20
			while task.wait(0.01) do
				local NearestPlayer = GetNearestPlr(KillAuraRange)
				local Sword = GetMelee()
				if AutoSword then
					if NearestPlayer then
						SetHotbar(Sword)
					else
						AutoSword = false
					end
				end
				if isAlive(localPlayer) then
					if NearestPlayer and isAlive(NearestPlayer) then
						ReplicatedStorage.rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit:FireServer({
							["entityInstance"] = NearestPlayer.Character,
							["chargedAttack"] = {
								["chargeRatio"] = 1
							},
							["validate"] = {
								["raycast"] = {
									["cursorDirection"] = Value2Vector(Ray.new(game.Workspace.CurrentCamera.CFrame.Position, NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction),
									["cameraPosition"] = Value2Vector(NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position),
								},
								["selfPosition"] = Value2Vector(GetAttackPos(localPlayer.Character:FindFirstChild("HumanoidRootPart").Position, NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position, 2)),
								["targetPosition"] = Value2Vector(NearestPlayer.Character.HumanoidRootPart.Position),
							},
							["weapon"] = Sword
						})
					end
				else
					repeat
						task.wait()
					until isAlive(localPlayer)
				end
			end
		else
			KillAuraRange = 0
		end
	end
})
local KillAuraRangeCustom = KillAura:CreateSlider({
	title = "Range",
	min = 0,
	max = 20,
	default = 20,
	callback = function(value)
		KillAuraRange = value
		RotationsRange = value
	end
})
local AutoWeapon = KillAura:MiniToggle({
	Name = "AutoWeapon",
	callback = function(enabled)
		AutoSword = not AutoSword
	end
})
local Rotations = KillAura:MiniToggle({
	Name = "Rotations",
	callback = function(enabled)
		if enabled then
			RotationsRange = 20
			while task.wait(0.01) do
				local NearestPlayer = GetNearestPlr(RotationsRange)
				if NearestPlayer and isAlive(NearestPlayer) and isAlive(localPlayer) then
					local direction = (NearestPlayer.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).unit
					local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
					local newCFrame = CFrame.new(localPlayer.Character.HumanoidRootPart.Position, localPlayer.Character.HumanoidRootPart.Position + lookVector)
					localPlayer.Character:SetPrimaryPartCFrame(newCFrame)
				end
			end
		else
			RotationsRange = 0
		end
	end
})
--Teams
local Teams = CombatTab:CreateToggle({
	Name = "Teams",
	Description = "Avoid combat modules to target your teammate",
	callback = function(enabled)
		TeamCheck = not TeamCheck
	end
})
--Fullbright
local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient
local Fullbright = RenderTab:CreateToggle({
	Name = "Fullbright",
	Description = "Makes you see in the dark",
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
	callback = function(enabled)
		if enabled then
			if AutoQueue then
				repeat
					task.wait(ActionDelay)
				until GetMatchState() == 2 or not enabled
				ReplicatedStorage:FindFirstChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue:FireServer({["queueType"] = getQueueType()})
			end

			if AutoGG then
				repeat
					task.wait(ActionDelay)
				until GetMatchState() == 2 or not enabled
				ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GG", "All")
			end
		else
			AutoQueue, AutoGG = false, false
		end
	end
})
local GamePlayFix = GamePlay:CreateSlider({
	title = "Delay",
	min = 0,
	max = 100,
	default = 1,
	callback = function(val)
		ActionDelay = val
	end
})
local AutoQueueToggle = GamePlay:MiniToggle({
	Name = "AutoQueue",
	callback = function(enabled)
		AutoQueue = not AutoQueue
	end
})
local AutoGGToggle = GamePlay:MiniToggle({
	Name = "AutoGG",
	callback = function(enabled)
		AutoGG = not AutoGG
	end
})
--LongJump
local LongJump = PlayerTab:CreateToggle({
	Name = "LongJump",
	Bind = "nil",
	callback = function(enabled)
		if enabled then
			game.Workspace.Gravity = 3
			task.wait(1.3)
			localPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait(0.23)
			localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,-0.1,-1.3)
			localPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait(0.8)
			game.Workspace.Gravity = 8
			localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,-0.3,-1.8)
			localPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait(0.8)
			game.Workspace.Gravity = 192.6
			localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,-0.1,-1.3)
		end
	end
})
--AutoSprint
local StopSprinting = SprintCont.stopSprinting
local AutoSprint = PlayerTab:CreateToggle({
	Name = "AutoSprint",
	Description = "Automatically Sprint",
	callback = function(enabled)
		if enabled then
			spawn(function()
				repeat
					task.wait()
					if not SprintCont.sprinting then
						SprintCont:startSprinting()
					end
				until not enabled
			end)
		else
			spawn(function()
				repeat
					task.wait()
					if StopSprinting then
						SprintCont:stopSprinting()
					end
				until enabled
			end)
		end
	end
})
--Speed
local Speed = PlayerTab:CreateToggle({
	Name = "Speed",
	Description = "speed goes brrr",
	Bind = "X",
	callback = function(enabled)
		if enabled then
			localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 22
		else
			localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
		end
	end
})
--AntiVanish
local AntiVanish = WorldTab:CreateToggle({
	Name = "AntiVanish",
	Description = "Staff detector",
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
			BedHitDelay = 0
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
--[[
local antivoidpart = nil
local oldpos = nil

local function UpdateOldPosition()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = localPlayer.Character.HumanoidRootPart
        local newPosition = rootPart.Position
        if antivoidpart and newPosition.Y > antivoidpart.Position.Y then
            oldpos = newPosition
        else
            oldpos = nil
        end
    else
        oldpos = nil
    end
end

local function CreatePlatform()
    antivoidpart = Instance.new("Part", game.Workspace)
    antivoidpart.Transparency = 0.75
    antivoidpart.CanCollide = true
    antivoidpart.BrickColor = BrickColor.new(255, 255, 255)
    antivoidpart.Size = Vector3.new(999999, 3, 999999)
    antivoidpart.Anchored = true
    antivoidpart.Position = localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Vector3.new(0, 18, 0)
    antivoidpart.Name = "antivoidpart"

    antivoidpart.Touched:Connect(function(hit)
        local parent = hit.Parent
        if parent and parent:FindFirstChild("HumanoidRootPart") and oldpos then
            if localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local character = localPlayer.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local playerPos = humanoidRootPart.Position
                    if playerPos.Y < oldpos.Y then
                        local tweenDescription = TweenDescription.new(0.83, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                        local tween = TweenService:Create(character, tweenDescription, {PrimaryPartCFrame = CFrame.new(Vector3.new(character.PrimaryPart.Position.X, oldpos.Y, character.PrimaryPart.Position.Z))})
                        tween:Play()
                        local ray = Ray.new(humanoidRootPart.Position, Vector3.new(0, -100, 0))
                        local hitPart, hitPos = workspace:FindPartOnRay(ray)
                        if hitPart then
                            local destination = hitPos + Vector3.new(0, character.PrimaryPart.Size.Y / 2, 0)
                            local distance = (destination - humanoidRootPart.Position).Magnitude
                            local tween = TweenService:Create(character, TweenDescription.new(distance / 50, Enum.EasingStyle.Linear), {PrimaryPartCFrame = CFrame.new(destination)})
                            tween:Play()
                        end
                    end
                end
            end
        end
    end)

    return antivoidpart
end

local AntiVoid = WorldTab:CreateToggle({
    name = "AntiVoid",
    Description = "Prevents falling into the void",
    callback = function(enabled)
        if enabled then
            UpdateOldPosition()
            CreatePlatform()
        else
            if antivoidpart then
                antivoidpart:Destroy()
                antivoidpart = nil
            end
        end
    end
})

local function CheckIfInAir()
    while true do
        wait(3)
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = localPlayer.Character.Humanoid
            if humanoid:GetState() == Enum.HumanoidStateType.Physics then
                oldpos = nil
            else
                UpdateOldPosition()
            end
        end
    end
end

spawn(CheckIfInAir)
--]]
