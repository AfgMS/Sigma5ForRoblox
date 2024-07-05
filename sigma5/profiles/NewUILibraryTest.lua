--BridgeDuels have some interesting AntiCheat..
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/BetaLibrary.lua", true))()
local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("Roblox"):WaitForChild("New"):FindFirstChild("Eternal"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer:FindFirstChildOfClass("Humanoid")
Library:CreateCore()

local Tabs = {
	Combat = Library:CreateTab("Combat"),
	Movement = Library:CreateTab("Movement"),
	Player = Library:CreateTab("Player"),
	Render = Library:CreateTab("Render"),
	Exploit = Library:CreateTab("Exploit"),
	Misc = Library:CreateTab("Misc")
}

local Remotes = {
	AttackPlayerWithSword = ReplicatedStorage.Packages.Knit.Services.ToolService.RF.AttackPlayerWithSword,
	ToggleBlockSword = ReplicatedStorage.Packages.Knit.Services.ToolService.RF.ToggleBlockSword,
	BowFire = LocalPlayer.Character.DefaultBow.comm.RF.Fire
}

local function IsAlive(plr)
	return plr.Character and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

local function GetNearestPlayer(MaxDistance)
	local NearestPlayer = nil
	local MinDistance = math.huge

	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if IsAlive(player) then
				local Distances = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
				if Distances < MinDistance and Distances <= NearestPlayer then
					MinDistance = Distances
					NearestPlayer = player
				end
			end
		end
	end
	return NearestPlayer
end

local function GetTool(matchname)
	local Tool = nil

	for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
		if tool:IsA("Tool") and string.match(tool.Name, matchname) then
			Tool = tool
		end
	end
	return Tool
end

local function DamagePlayer(player, critical, sword)
	Remotes.AttackPlayerWithSword:InvokeServer({
		[1] = player,
		[2] = critical,
		[3] = sword
	})
end

local function BowFired(position, power)
	Remotes.BowFire:InvokeServer({
		[1] = position,
		[2] = power
	})
end

local BowDelay = 5
local BowDistance = 30
local BowAura = Tabs.Combat:CrateToggle("BowAura", false, false, function(callback)
	if callback then
		BowDelay = 5
		local Target = GetNearestPlayer(BowDistance)
		if Target and IsAlive(Target) then
			print(Target.Name)
			local Bow = GetTool("Bow")
			if Bow then
				print(Bow.Name)
				while true do
					wait(BowDelay)
					BowFired(Target.Character:FindFirstChild("HumanoidRootPart").Position, 2.5)
				end
			end
		end
	else
		BowDelay = 86400
	end
end)

local Criticals = Tabs.Combat:CrateToggle("Criticals", false, false, function(callback)
	
end)

local KillAura = Tabs.Combat:CrateToggle("KillAura", false, false, function(callback)

end)
