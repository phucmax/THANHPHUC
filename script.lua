--////////////////////////////////////////////////////
-- PHUCMAX UI + Fly Utilities (Client-side Utility)
-- Language: English (100%)
--////////////////////////////////////////////////////

--======================
-- SETTINGS
--======================
local UI_BG_IMAGE_ID = "rbxassetid://89799706653949"      -- MAIN UI background
local TOGGLE_BG_IMAGE_ID = "rbxassetid://89799706653949"  -- Toggle button background

local FLY_HEIGHT = 8
local FLY_SPEED = 150

local DROP_THRESHOLD = 5      -- studs (terrain drop detection)
local AHEAD_DISTANCE = 10      -- studs (look ahead for terrain)
local WALL_DETECT_DIST = 10   -- studs (left/right wall avoidance)

--======================
-- SERVICES
--======================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

--======================
-- CHARACTER
--======================
local char, hrp, humanoid

local function setCharacter(c)
	char = c
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
end

setCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setCharacter)

--======================
-- RAYCAST UTILS
--======================
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist
rayParams.IgnoreWater = true

local function rayDown(fromPos)
	rayParams.FilterDescendantsInstances = {char}
	local r = workspace:Raycast(fromPos, Vector3.new(0, -1000, 0), rayParams)
	return r and r.Position.Y or nil
end

local function raySide(origin, dir)
	rayParams.FilterDescendantsInstances = {char}
	return workspace:Raycast(origin, dir * WALL_DETECT_DIST, rayParams)
end

--======================
-- NOTIFICATION
--======================
local function notify(title, text)
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = 2
	})
end

--======================
-- RAINBOW WAVES
--======================
local function rainbowStroke(uiStroke)
	task.spawn(function()
		local h = 0
		while uiStroke.Parent do
			h = (h + 0.005) % 1
			uiStroke.Color = Color3.fromHSV(h, 1, 1)
			task.wait()
		end
	end)
end

--======================
-- UI BUILD
--======================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Toggle UI Button
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.Image = TOGGLE_BG_IMAGE_ID
toggleBtn.BackgroundTransparency = 1
toggleBtn.Active = true
toggleBtn.Draggable = true

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 360) -- taller than wide
main.Position = UDim2.new(0.5, -130, 0.5, -180)
main.BackgroundTransparency = 1
main.Visible = true
main.Active = true
main.Draggable = true

-- Background
local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.fromScale(1,1)
bg.Image = UI_BG_IMAGE_ID
bg.ScaleType = Enum.ScaleType.Crop
bg.BackgroundTransparency = 1

-- Border Rainbow
local stroke = Instance.new("UIStroke", bg)
stroke.Thickness = 2
rainbowStroke(stroke)

-- Header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1,0,0,50)
header.BackgroundTransparency = 1
header.Text = "PHUCMAX"
header.Font = Enum.Font.GothamBlack
header.TextSize = 28
header.TextColor3 = Color3.new(1,1,1)
header.TextStrokeTransparency = 0

task.spawn(function()
	local h = 0
	while header.Parent do
		h = (h + 0.006) % 1
		header.TextColor3 = Color3.fromHSV(h,1,1)
		task.wait()
	end
end)

--======================
-- BUTTON FACTORY
--======================
local function makeButton(text, y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(1, -40, 0, 45)
	b.Position = UDim2.new(0, 20, 0, y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.new(1,1,1)
	b.AutoButtonColor = true
	local s = Instance.new("UIStroke", b)
	rainbowStroke(s)
	return b
end

--======================
-- STATES
--======================
local fly1On = false
local fly2On = false
local shiftLockOn = false

local conn1, conn2
local bp, bv

--======================
-- FLY CORE
--======================
local function startFly(baseHeight, withDropCheck, withWallAvoid)
	bp = Instance.new("BodyPosition", hrp)
	bp.MaxForce = Vector3.new(0,1e9,0)
	bp.P = 1e6
	bp.D = 500

	bv = Instance.new("BodyVelocity", hrp)
	bv.MaxForce = Vector3.new(1e9,0,1e9)

	local baseGround = rayDown(hrp.Position)
	local fixedY = (baseGround or hrp.Position.Y) + baseHeight

	return RunService.RenderStepped:Connect(function()
		local dir = humanoid.MoveDirection
		if dir.Magnitude > 0 then
			dir = Vector3.new(dir.X,0,dir.Z).Unit
		else
			dir = Vector3.zero
		end

		-- Wall avoid
		if withWallAvoid and dir.Magnitude > 0 then
			local left = raySide(hrp.Position, -hrp.CFrame.RightVector)
			local right = raySide(hrp.Position, hrp.CFrame.RightVector)
			if left and not right then
				dir += hrp.CFrame.RightVector
			elseif right and not left then
				dir -= hrp.CFrame.RightVector
			end
		end

		bv.Velocity = dir * FLY_SPEED
		bp.Position = Vector3.new(hrp.Position.X, fixedY, hrp.Position.Z)

		-- Terrain drop detection
		if withDropCheck and dir.Magnitude > 0 then
			local nowY = rayDown(hrp.Position)
			local aheadY = rayDown(hrp.Position + dir * AHEAD_DISTANCE)
			if nowY and aheadY and (nowY - aheadY) >= DROP_THRESHOLD then
				notify("PHUCMAX", "Terrain drop detected. Fly disabled.")
				fly1On = false
				if conn1 then conn1:Disconnect() end
				if bp then bp:Destroy() end
				if bv then bv:Destroy() end
				hrp.CFrame = CFrame.new(hrp.Position.X, nowY + 2, hrp.Position.Z)
			end
		end
	end)
end

--======================
-- BUTTONS
--======================
local fly1Btn = makeButton("Fly Mode 1 (Auto Stop on Drop)", 70)
local fly2Btn = makeButton("Fly Mode 2 (Wall Avoid)", 125)
local shiftBtn = makeButton("Shift Lock : OFF", 180)

-- Fly Mode 1
fly1Btn.MouseButton1Click:Connect(function()
	fly1On = not fly1On
	if fly1On then
		notify("PHUCMAX", "Fly  1 ")
		conn1 = startFly(FLY_HEIGHT, true, false)
	else
		notify("PHUCMAX", "Fly  1 ")
		if conn1 then conn1:Disconnect() end
		if bp then bp:Destroy() end
		if bv then bv:Destroy() end
	end
end)

-- Fly Mode 2
fly2Btn.MouseButton1Click:Connect(function()
	fly2On = not fly2On
	if fly2On then
		notify("PHUCMAX", "Fly  2 ")
		conn2 = startFly(FLY_HEIGHT, false, true)
	else
		notify("PHUCMAX", "Fly Mode 2 Disabled")
		if conn2 then conn2:Disconnect() end
		if bp then bp:Destroy() end
		if bv then bv:Destroy() end
	end
end)

-- Shift Lock
shiftBtn.MouseButton1Click:Connect(function()
	shiftLockOn = not shiftLockOn
	humanoid.AutoRotate = not shiftLockOn
	shiftBtn.Text = shiftLockOn and "Shift Lock : ON" or "Shift Lock : OFF"
end)

--======================
-- UI TOGGLE ANIMATION
--======================
local uiOpen = true
toggleBtn.MouseButton1Click:Connect(function()
	uiOpen = not uiOpen
	local goal = uiOpen and {Size = UDim2.new(0,260,0,360)} or {Size = UDim2.new(0,260,0,0)}
	local tw = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
	tw:Play()
end)