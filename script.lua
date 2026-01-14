--////////////////////////////////////////////////////
-- PHUCMAX UI + Fly Utilities (Client-side Utility)
-- Language: English (100%)
--////////////////////////////////////////////////////

--======================
-- SETTINGS
--======================
local UI_BG_IMAGE_ID = "rbxassetid://89799706653949"
local TOGGLE_BG_IMAGE_ID = "rbxassetid://89799706653949"

local FLY_HEIGHT = 8
local FLY_SPEED = 150

local DROP_THRESHOLD = 5
local AHEAD_DISTANCE = 10
local WALL_DETECT_DIST = 10

-- Shift Lock camera shoulder offset (optional)
local SHIFTLOCK_CAMERA_OFFSET = Vector3.new(1.5, 0, 0) -- set Vector3.new(0,0,0) to disable offset

--======================
-- THEME (matches your neon-green background)
--======================
local THEME_PRIMARY = Color3.fromRGB(10, 14, 22)
local THEME_SURFACE = Color3.fromRGB(18, 24, 36)
local THEME_TEXT = Color3.fromRGB(235, 245, 255)
local THEME_ACCENT = Color3.fromRGB(90, 255, 170)
local THEME_OFF = Color3.fromRGB(140, 150, 160)
local USE_RAINBOW_BORDER = true

--======================
-- SERVICES
--======================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

--======================
-- CHARACTER
--======================
local char, hrp, humanoid

-- Shift Lock state/conn
local shiftLockOn = false
local shiftLockConn

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 2
		})
	end)
end

local function rainbowStroke(uiStroke)
	task.spawn(function()
		local h = 0
		while uiStroke and uiStroke.Parent do
			h = (h + 0.006) % 1
			uiStroke.Color = Color3.fromHSV(h, 1, 1)
			task.wait()
		end
	end)
end

local function disableShiftLock()
	shiftLockOn = false
	if shiftLockConn then shiftLockConn:Disconnect() shiftLockConn = nil end
	if humanoid then humanoid.AutoRotate = true end
	local cam = workspace.CurrentCamera
	if cam then cam.CameraOffset = Vector3.new(0,0,0) end
end

local function getCameraYaw()
	local cam = workspace.CurrentCamera
	if not cam then return nil end
	local lv = cam.CFrame.LookVector
	local flat = Vector3.new(lv.X, 0, lv.Z)
	if flat.Magnitude < 1e-6 then return nil end
	flat = flat.Unit
	return math.atan2(-flat.X, -flat.Z) -- Roblox yaw
end

local function enableShiftLock()
	shiftLockOn = true
	if humanoid then humanoid.AutoRotate = false end

	local cam = workspace.CurrentCamera
	if cam then cam.CameraOffset = SHIFTLOCK_CAMERA_OFFSET end

	if shiftLockConn then shiftLockConn:Disconnect() end
	shiftLockConn = RunService.RenderStepped:Connect(function()
		if not shiftLockOn or not hrp or not humanoid or humanoid.Health <= 0 then return end
		local yaw = getCameraYaw()
		if not yaw then return end

		-- Instantly rotate character to camera yaw (no delay)
		local pos = hrp.Position
		hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, yaw, 0)
	end)
end

local function setCharacter(c)
	char = c
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")

	-- Always reset shift lock cleanly on respawn
	disableShiftLock()
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
-- UI BUILD (Rounded + Themed)
--======================
local gui = Instance.new("ScreenGui")
gui.Name = "PHUCMAX_UI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Toggle UI Button
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 56, 0, 56)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -28)
toggleBtn.Image = TOGGLE_BG_IMAGE_ID
toggleBtn.BackgroundColor3 = THEME_SURFACE
toggleBtn.BackgroundTransparency = 0.12
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.AutoButtonColor = true

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 14)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2
toggleStroke.Color = THEME_ACCENT
if USE_RAINBOW_BORDER then rainbowStroke(toggleStroke) end

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 360)
main.Position = UDim2.new(0.5, -130, 0.5, -180)
main.BackgroundColor3 = THEME_PRIMARY
main.BackgroundTransparency = 0.06
main.Visible = true
main.Active = true
main.Draggable = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 18)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.Color = THEME_ACCENT
if USE_RAINBOW_BORDER then rainbowStroke(mainStroke) end

-- Background image (rounded)
local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundTransparency = 1
bg.Image = UI_BG_IMAGE_ID
bg.ScaleType = Enum.ScaleType.Crop

local bgCorner = Instance.new("UICorner", bg)
bgCorner.CornerRadius = UDim.new(0, 18)

-- Overlay
local overlay = Instance.new("Frame", main)
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = THEME_PRIMARY
overlay.BackgroundTransparency = 0.35

local overlayCorner = Instance.new("UICorner", overlay)
overlayCorner.CornerRadius = UDim.new(0, 18)

-- Header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundTransparency = 1
header.Text = "PHUCMAX"
header.Font = Enum.Font.GothamBlack
header.TextSize = 28
header.TextStrokeTransparency = 0.7
header.TextColor3 = THEME_ACCENT

task.spawn(function()
	local h = 0
	while header and header.Parent do
		h = (h + 0.007) % 1
		header.TextColor3 = Color3.fromHSV(h, 1, 1)
		task.wait()
	end
end)

--======================
-- BUTTON FACTORY
--======================
local function makeButton(text, y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(1, -40, 0, 46)
	b.Position = UDim2.new(0, 20, 0, y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.BackgroundColor3 = THEME_SURFACE
	b.BackgroundTransparency = 0.14
	b.TextColor3 = THEME_TEXT
	b.AutoButtonColor = true

	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0, 14)

	local s = Instance.new("UIStroke", b)
	s.Thickness = 2
	s.Color = THEME_ACCENT
	if USE_RAINBOW_BORDER then rainbowStroke(s) end

	return b
end

--======================
-- STATES
--======================
local fly1On = false
local fly2On = false

local conn1, conn2
local bp, bv

local function killForces()
	if bp then bp:Destroy() bp = nil end
	if bv then bv:Destroy() bv = nil end
end

--======================
-- FLY CORE
--======================
local function startFly(baseHeight, withDropCheck, withWallAvoid)
	killForces()

	bp = Instance.new("BodyPosition", hrp)
	bp.MaxForce = Vector3.new(0, 1e9, 0)
	bp.P = 1e6
	bp.D = 500

	bv = Instance.new("BodyVelocity", hrp)
	bv.MaxForce = Vector3.new(1e9, 0, 1e9)

	local baseGround = rayDown(hrp.Position)
	local fixedY = (baseGround or hrp.Position.Y) + baseHeight

	return RunService.RenderStepped:Connect(function()
		if not humanoid or humanoid.Health <= 0 then return end

		local dir = humanoid.MoveDirection
		if dir.Magnitude > 0 then
			dir = Vector3.new(dir.X, 0, dir.Z).Unit
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

		-- Terrain drop detection ( 1)
		if withDropCheck and dir.Magnitude > 0 then
			local nowY = rayDown(hrp.Position)
			local aheadY = rayDown(hrp.Position + dir * AHEAD_DISTANCE)
			if nowY and aheadY and (nowY - aheadY) >= DROP_THRESHOLD then
				notify("PHUCMAX", "Terrain drop detected. Fly disabled.")
				fly1On = false
				if conn1 then conn1:Disconnect() conn1 = nil end
				killForces()
				hrp.CFrame = CFrame.new(hrp.Position.X, nowY + 2, hrp.Position.Z)
			end
		end
	end)
end

--======================
-- BUTTONS
--======================
local fly1Btn = makeButton("Fly  1 (Auto Stop on Drop)", 80)
local fly2Btn = makeButton("Fly  2 (Wall Avoid)", 140)
local shiftBtn = makeButton("Shift Lock : OFF", 200)

local function setButtonState(btn, on)
	btn.TextColor3 = on and THEME_ACCENT or THEME_OFF
end

-- Fly Mode 1
fly1Btn.MouseButton1Click:Connect(function()
	fly1On = not fly1On

	-- prevent both modes at once
	if fly1On and fly2On then
		fly2On = false
		if conn2 then conn2:Disconnect() conn2 = nil end
	end

	if fly1On then
		setButtonState(fly1Btn, true)
		setButtonState(fly2Btn, false)
		notify("PHUCMAX", "Fly  1 ")
		if conn1 then conn1:Disconnect() end
		conn1 = startFly(FLY_HEIGHT, true, false)
	else
		setButtonState(fly1Btn, false)
		notify("PHUCMAX", "Fly  1 ")
		if conn1 then conn1:Disconnect() conn1 = nil end
		killForces()
	end
end)

-- Fly Mode 2
fly2Btn.MouseButton1Click:Connect(function()
	fly2On = not fly2On

	-- prevent both modes at once
	if fly2On and fly1On then
		fly1On = false
		if conn1 then conn1:Disconnect() conn1 = nil end
	end

	if fly2On then
		setButtonState(fly2Btn, true)
		setButtonState(fly1Btn, false)
		notify("PHUCMAX", "Fly  2 ")
		if conn2 then conn2:Disconnect() end
		conn2 = startFly(FLY_HEIGHT, false, true)
	else
		setButtonState(fly2Btn, false)
		notify("PHUCMAX", "Fly  2 ")
		if conn2 then conn2:Disconnect() conn2 = nil end
		killForces()
	end
end)

-- Shift Lock (REAL: instant rotate character to camera)
shiftBtn.MouseButton1Click:Connect(function()
	if shiftLockOn then
		disableShiftLock()
		shiftBtn.Text = "Shift Lock : OFF"
		shiftBtn.TextColor3 = THEME_OFF
	else
		enableShiftLock()
		shiftBtn.Text = "Shift Lock : ON"
		shiftBtn.TextColor3 = THEME_ACCENT
	end
end)

--======================
-- UI TOGGLE ANIMATION (size + fade)
--======================
local uiOpen = true
local openSize = UDim2.new(0, 260, 0, 360)
local closedSize = UDim2.new(0, 260, 0, 0)

local function tweenTransparency(obj, target, t)
	for _, d in ipairs(obj:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("TextButton") then
			TweenService:Create(d, TweenInfo.new(t), {TextTransparency = target}):Play()
		elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
			TweenService:Create(d, TweenInfo.new(t), {ImageTransparency = target}):Play()
		elseif d:IsA("Frame") then
			TweenService:Create(d, TweenInfo.new(t), {BackgroundTransparency = math.clamp(target + 0.1, 0, 1)}):Play()
		end
	end
end

toggleBtn.MouseButton1Click:Connect(function()
	uiOpen = not uiOpen
	local goalSize = uiOpen and openSize or closedSize
	local tw = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = goalSize})
	tw:Play()

	if uiOpen then
		main.Visible = true
		tweenTransparency(main, 0, 0.25)
	else
		tweenTransparency(main, 1, 0.2)
		task.delay(0.25, function()
			if not uiOpen then
				main.Visible = false
			end
		end)
	end
end)

--======================
-- Cleanup on death (and respawn handled in setCharacter)
--======================
if humanoid then
	humanoid.Died:Connect(function()
		fly1On, fly2On = false, false
		if conn1 then conn1:Disconnect() conn1 = nil end
		if conn2 then conn2:Disconnect() conn2 = nil end
		killForces()
		disableShiftLock()
	end)
end