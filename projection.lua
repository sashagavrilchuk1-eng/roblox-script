--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
    Projection Sorcery (Zenin)
    Made by sa*avrilchuk1
]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local character
local humanoid
local hrp
local FRAMES = 24
local DISTANCE = 3
local COOLDOWN = false
local READY = false

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
	READY = true
end
if player.Character then
	setupCharacter(player.Character)
end
player.CharacterAdded:Connect(function(char)
	READY = false
	task.wait(0.2)
	setupCharacter(char)
end)

local function makeFrame(position)
	local forward = camera.CFrame.LookVector
	local cf = CFrame.new(position, position + forward)
	local part = Instance.new("Part")
	part.Size = Vector3.new(2, 5, 1)
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(180, 70, 255)
	part.Transparency = 0.5
	part.CFrame = cf
	part.Parent = workspace
	Debris:AddItem(part, 0.4)
end

local function projectionSorcery()
	if COOLDOWN or not READY then return end
	COOLDOWN = true
	local framesPositions = {}
	for i = 1, FRAMES do
		if not hrp then break end
		local forward = camera.CFrame.LookVector
		local position = hrp.Position + forward * (i * DISTANCE)
		table.insert(framesPositions, position)
		makeFrame(position)
		task.wait(0.01)
	end
	if humanoid then
		local oldSpeed = humanoid.WalkSpeed
		local oldJump = humanoid.JumpPower
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		for _, pos in ipairs(framesPositions) do
			if not hrp then break end
			local forward = camera.CFrame.LookVector
			hrp.CFrame = CFrame.new(pos, pos + forward)
			RunService.RenderStepped:Wait()
		end
		humanoid.WalkSpeed = oldSpeed
		humanoid.JumpPower = oldJump
	end
	task.wait(0.5)
	COOLDOWN = false
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Z then
		projectionSorcery()
	end
end)

-- GUI
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProjectionSorceryGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ✅ Watermark / Attribution label
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 260, 0, 30)
watermark.Position = UDim2.new(0, 10, 0, 10)
watermark.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
watermark.BackgroundTransparency = 0.4
watermark.Text = "Projection Sorcery | Made by sa*avrilchuk1"
watermark.TextColor3 = Color3.fromRGB(200, 130, 255)
watermark.TextScaled = true
watermark.Font = Enum.Font.GothamBold
watermark.Parent = screenGui
local wmCorner = Instance.new("UICorner")
wmCorner.CornerRadius = UDim.new(0, 8)
wmCorner.Parent = watermark

-- Кнопка
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 60)
button.Position = UDim2.new(1, -160, 1, -120)
button.BackgroundColor3 = Color3.fromRGB(180, 70, 255)
button.Text = "Projection"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = screenGui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = button

button.MouseButton1Click:Connect(function()
	projectionSorcery()
end)
