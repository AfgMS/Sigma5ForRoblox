--BridgeDuels have some interesting AntiCheat..
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/BetaLibrary.lua", true))()
local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Roblox"):WaitForChild("New"):FindFirstChild("Eternal"))
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer:FindFirstChildOfClass("Humanoid")
Library:CreateCore()

local Combat = Library:CreateTab("Combat")
local Movement = Library:CreateTab("Movement")
local Player = Library:CreateTab("Player")

local function Alive(plr)
	return plr and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0.11
end

local function GetNearestPlayer(MaxDist)
	local Nearest = nil
	local MinDistance = math.huge

	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if Alive(player) then
				local Distances = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
				if Distances < MinDistance and Distances <= MaxDist then
					MinDistance = Distances
					Nearest = player
				end
			end
		end
	end
	return Nearest
end

local function GetSword(character)
	for _, tool in pairs(character:GetChildren()) do
		if tool:IsA("Tool") and string.match(tool.Name, "Sword") then
			return tool
		end
	end
	return nil
end

local function Damage(plr, critical, sword)
	local args = {
		[1] = plr,
		[2] = critical,
		[3] = sword
	}
	game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RF.AttackPlayerWithSword:InvokeServer(unpack(args))
end


local AutoSwordDistance = 28
local AutoSword = Combat:CrateToggle("AutoSword", false, false, function(callback)
	if callback then
		local Nearest = GetNearestPlayer(AutoSwordDistance)
		if Nearest then
			local Sword = GetSword()
			if Sword then
				Humanoid:EquipTool(Sword.Name)
			end
		end
	else
		local Sword = GetSword()
		if Sword then
			Humanoid:UnequipTools(Sword.Name)
		end
	end
end)

local KillAuraCriticals = false
local Criticals = Combat:CrateToggle("Criticals", false, true, function(callback)
	if callback then
		KillAuraCriticals = true
	else
		KillAuraCriticals = false
	end
end)

local KillAuraDistance = 25
local KillAuraDelay
local KillAura = Combat:CrateToggle("KillAura", false, false, function(callback)
	if callback then
		KillAuraDelay = 0.01
		local Nearest = GetNearestPlayer(KillAuraDistance)
		if Nearest then
			local Sword = GetSword()
			if Sword then
				while true do
					wait(KillAuraDelay)
					Damage(Nearest.Character, KillAuraCriticals, Sword.Name)
				end
			end
		end
	else
		KillAuraDelay = 86400
	end
end)

local Tes4 = Movement:CrateToggle("Test4", false, false, function(callback)
	if callback then
		print("Debug 42")
	else
		print("Unbug 24")
	end
end)

local herbet
local Tes4 = Player:CrateToggle("Speed", false, false, function(callback)
	if callback then
		herbet = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
			game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, -28 * deltaTime)
		end)
	else
		herbet:Disconnect()
	end
end)
