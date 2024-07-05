local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/Sigma5ForRoblox/main/sigma5/BetaLibrary.lua", true))()
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer:FindFirstChildOfClass("Humanoid")
local FolderName = "Eternal"
local FileName = FolderName .. "/config.txt"
Library:CreateCore()

local Tabs = {
	Combat = Library:CreateTab("Combat"),
	Movement = Library:CreateTab("Movement"),
	Player = Library:CreateTab("Player"),
	Render = Library:CreateTab("Render"),
	Exploit = Library:CreateTab("Exploit"),
	Misc = Library:CreateTab("Misc")
}

local Settings = {
	AutoBlockValue = false,
	CriticalsValue = true,
	KillAuraValue = false
}

local function SaveSettings(table, FileName)
	if not isfolder(FolderName) then
		makefolder(FolderName)
	end

	local JsonData = HttpService:JSONEncode(table)
	writefile(FileName, JsonData)
end

local function LoadSettings(FileName)
	if isfile(FileName) then
		local JsonData = readfile(FileName)
		local Settings = HttpService:JSONDecode(JsonData)
		return Settings
	else
		warn("File not found!")
		return nil
	end
end

SaveSettings(Settings, FileName)

local LoadedSettings = LoadSettings(FileName)
if LoadedSettings then
	for key, value in pairs(LoadedSettings) do
		print(key, value)
	end
end

local function IsAlive(plr)
	return plr.Character and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

local function FindNearestPlayer(distance)
	local NearestPlayer = nil
	local MinDistance = math.huge

	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if IsAlive(player) then
				local Distances = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
				if Distances < MinDistance and Distances <= distance then
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

local AutoBlockT = false
local AutoBlockDistance = 28
local AutoBlock = Tabs.Combat:CrateToggle("AutoBlock", false, Settings.AutoBlockValue, function(callback)
	if callback then
		AutoBlockT = true
		local Target = FindNearestPlayer(AutoBlockDistance)
		if Target and IsAlive(Target) then
			local Sword = GetTool("Sword")
			if Sword~= nil then
				local args = {
					[1] = AutoBlockT,
					[2] = Sword.Name
				}

				ReplicatedStorage.Packages.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(unpack(args))
			end
		end
	else
		AutoBlockT = false
	end
end)

local KillAuraCritical = false
local Critical = Tabs.Combat:CrateToggle("Critical", false, Settings.CriticalsValue, function(callback)
	if callback then
		KillAuraCritical = true
	else
		KillAuraCritical = false
	end
end)

local KillAuraDistance = 25
local KillAura = Tabs.Combat:CrateToggle("KillAura", false, Settings.KillAuraValue, function(callback)
	if callback then
		local Target = FindNearestPlayer(KillAuraDistance)
		if Target and IsAlive(Target) then
			local Sword = GetTool("Sword")
			if Sword~= nil then
				repeat
					task.wait()
					local args = {
						[1] = Target.Character,
						[2] = KillAuraCritical,
						[3] = Sword.Name
					}
					ReplicatedStorage.Packages.Knit.Services.ToolService.RF.AttackPlayerWithSword:InvokeServer(unpack(args))
				until not Sword
			end
		end
	end
end)
