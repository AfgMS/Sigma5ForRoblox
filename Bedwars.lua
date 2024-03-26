--Sigma5ForRoblox
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/SigmaJello4Roblox/main/SigmaLibrary.lua", true))()
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

local function PlayAnimation(id)
    local animator = localPlayer.Character:FindFirstChildOfClass("Animator")
    if animator then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://" .. id
        animator:LoadAnimation(animation):Play()
    end
end

local function PlaySound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = game.Workspace
    sound:Play()

    sound.Ended:Connect(function()
        sound:Destroy()
    end)
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
local GuiTab = Library:createTabs(CoreGui.Sigma5, "Gui")
local CombatTab = Library:createTabs(CoreGui.Sigma5, "Combat")
local RenderTab = Library:createTabs(CoreGui.Sigma5, "Render")
local PlayerTab = Library:createTabs(CoreGui.Sigma5, "Player")
local WorldTab = Library:createTabs(CoreGui.Sigma5, "World")
--Notification
CreateNotification("Loader", "Loaded Successfully", 3, true)
--ActiveMods
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
--DeleteGui
local BlurEffect = Lighting:FindFirstChild("Blur")
local DeleteGui = GuiTab:ToggleButton({
    name = "DeleteGUI",
    info = "Does not uninject",
    callback = function(enabled)
        if enabled then
            BlurEffect:Destroy()
            CoreGui.Sigma5:Destroy()
            print("Destroyed Main")
            CoreGui.Sigma5Visual:Destroy()
            print("Destroyed Notif")
        end
    end
})
--Aimbot
local aimbotDistance
local Aimbot = CombatTab:ToggleButton({
    name = "Aimbot",
    info = "Automatically aim at players",
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
local Customdistance = Aimbot:Slider({
    title = "Distance",
    min = 0,
    max = 100,
    default = 20,
    callback = function(val)
        aimbotDistance = val
    end
})
--AntiKnockback
local OriginalH = KnockbackCont.kbDirectionStrength
local OriginalY = KnockbackCont.kbUpwardStrength
local AntiKnockback = CombatTab:ToggleButton({
    name = "AntiKnockback",
    info = "Prevent you from taking knockback",
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
local AutoQuit = CombatTab:ToggleButton({
    name = "AutoQuit",
    info = "Automatically quit the game",
    callback = function(enabled)
        if enabled then
            MaxHealth = 0.11
            if localPlayer and isAlive(localPlayer) then
                while enabled do
                    if localPlayer.Character:FindFirstChild("Humanoid").Health < MaxHealth then
                        CreateNotification("AutoQuit", "You are getting kicked", 3, true)
                        task.wait(2)
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
local Target = GetNearestPlr(20)
local Sword = GetMelee()
local KillAuraAutoSword = false
local KillAuraRotation = false
local KillAuraSwingNSound = false
local KillAura = CombatTab:ToggleButton({
    name = "KillAura",
    info = "Attack the nearby player",
    callback = function(enabled)
        if enabled then
            spawn(function()
                repeat
                    if KillAuraAutoSword then
                        if Target and isAlive(localPlayer) then
                            SetHotbar(Sword)
                        else
                            KillAuraAutoSword = false
                        end
                    end
                    if KillAuraRotation then
                        while KillAuraRotation do
                            if Target and isAlive(localPlayer) then
                                if not isAlive(Target) then
                                    repeat task.wait() until isAlive(Target)
                                end
                                local direction = (Target.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).unit
                                local lookVector = Vector3.new(direction.X, 0, direction.Z).unit
                                local newCFrame = CFrame.new(localPlayer.Character.HumanoidRootPart.Position, localPlayer.Character.HumanoidRootPart.Position + lookVector)
                                localPlayer.Character:SetPrimaryPartCFrame(newCFrame)
                            end
                            task.wait()
                        end
                    end
                    if KillAuraSwingNSound then
                        while KillAuraSwingNSound do
                            if Target and isAlive(localPlayer) then
                                if not isAlive(Target) then
                                    repeat task.wait() until isAlive(Target)
                                end
                                PlayAnimation(4947108314)
                                PlaySound(6760544639)
                                task.wait(1.3)
                            end
                        end
                    end

                    if Target and isAlive(localPlayer) then
                        if not isAlive(Target) then
                            repeat task.wait() until isAlive(Target)
                        end
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
                    task.wait(0.03)
                until not enabled or not KillAura.Enabled
            end)
        end
    end
})
local UnknownSlider0 = KillAura:Slider({
    title = "???",
    min = 0,
    max = 0,
    default = 0,
    callback = function(value)
    end
})
local AutoSword = KillAura:ToggleButtonInsideUI({
    name = "AutoSword",
    callback = function(enabled)
        KillAuraAutoSword = not KillAuraAutoSword
    end
})
local Rotation = KillAura:ToggleButtonInsideUI({
    name = "Rotation",
    callback = function(enabled)
        KillAuraRotation = not KillAuraRotation
    end
})
local SwordVisual = KillAura:ToggleButtonInsideUI({
    name = "SwingNSound",
    callback = function(enabled)
        KillAuraSwingNSound = not KillAuraSwingNSound
    end
})
--Teams
local Teams = CombatTab:ToggleButton({
    name = "Teams",
    info = "Avoid combat modules targeting your teammate",
    callback = function(enabled)
        TeamCheck = enabled
    end
})
--Fullbright
local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient
local Fullbright = RenderTab:ToggleButton({
    name = "Fullbright",
    info = "Enhances visibility in the dark",
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
            localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 23
        else
            localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
        end
    end
})
--AntiVanish
local AntiVanish = WorldTab:ToggleButton({
    name = "AntiVanish",
    info = "Staff detector",
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
local Nuker = WorldTab:ToggleButton({
    name = "Nuker",
    info = "Auto bed break",
    callback = function(enabled)
        if enabled then
            BedHitDelay = 0.82
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
