--////////////////////////////////////////////////////
-- PHUCMAX PRO UI + Fly Utilities (For YOUR Roblox game)
-- LocalScript (StarterPlayerScripts)
-- Language: English (100%)
--////////////////////////////////////////////////////

--======================
-- SETTINGS
--======================
local UI_BG_IMAGE_ID = "rbxassetid://89799706653949"
local TOGGLE_BG_IMAGE_ID = "rbxassetid://89799706653949"

local FLY_HEIGHT = 8
local FLY_SPEED = 150

local DROP_THRESHOLD = 5      -- studs: ground ahead is lower than current by this -> trigger
local AHEAD_DISTANCE = 10     -- studs: look-ahead distance for terrain scan
local WALL_DETECT_DIST = 10   -- studs: wall detection distance

-- Shift lock shoulder offset (Humanoid.CameraOffset)
local SHIFTLOCK_CAMERA_OFFSET = Vector3.new(1.5, 0, 0) -- set Vector3.zero to disable offset

-- Auto collect interval (seconds)
local AUTO_COLLECT_INTERVAL = 0.5 -- 0.5s per cycle

--======================
-- THEME (Pro look: neon accent, no rainbow)
--======================
local THEME_PRIMARY = Color3.fromRGB(10, 14, 22)
local THEME_SURFACE = Color3.fromRGB(18, 24, 36)
local THEME_TEXT    = Color3.fromRGB(235, 245, 255)
local THEME_ACCENT  = Color3.fromRGB(90, 255, 170)  -- neon green to match your background
local THEME_OFF     = Color3.fromRGB(150, 160, 170)

--======================
-- SERVICES
--======================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--======================
-- SAFE NOTIFY
--======================
local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 2
		})
	end)
end

--======================
-- CHARACTER
--======================
local char, hrp, humanoid

local function bindCharacter(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	humanoid = c:WaitForChild("Humanoid")
end

bindCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(bindCharacter)

--======================
-- RAYCAST UTILS
--======================
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist
rayParams.IgnoreWater = true

local function rayDown(fromPos)
	if not char then return nil end
	rayParams.FilterDescendantsInstances = { char }
	local r = workspace:Raycast(fromPos, Vector3.new(0, -1000, 0), rayParams)
	return r and r.Position.Y or nil
end

local function raySide(origin, dir)
	if not char then return nil end
	rayParams.FilterDescendantsInstances = { char }
	return workspace:Raycast(origin, dir * WALL_DETECT_DIST, rayParams)
end

--======================
-- STATE
--======================
local fly1On, fly2On = false, false
local conn1, conn2
local bp, bv

local shiftLockOn = false
local shiftLockConn

local function killForces()
	if bp then bp:Destroy() bp = nil end
	if bv then bv:Destroy() bv = nil end
end

--======================
-- REAL SHIFT LOCK (no delay)
--======================
local function disableShiftLock()
	shiftLockOn = false
	if shiftLockConn then shiftLockConn:Disconnect() shiftLockConn = nil end
	if humanoid then
		humanoid.AutoRotate = true
		humanoid.CameraOffset = Vector3.new(0, 0, 0) -- FIX: CameraOffset belongs to Humanoid
	end
end

local function enableShiftLock()
	shiftLockOn = true
	if humanoid then
		humanoid.AutoRotate = false
		humanoid.CameraOffset = SHIFTLOCK_CAMERA_OFFSET -- FIX: Humanoid.CameraOffset
	end

	if shiftLockConn then shiftLockConn:Disconnect() end
	shiftLockConn = RunService.RenderStepped:Connect(function()
		if not shiftLockOn or not hrp or not humanoid or humanoid.Health <= 0 then return end
		local cam = workspace.CurrentCamera
		if not cam then return end

		local lv = cam.CFrame.LookVector
		local flat = Vector3.new(lv.X, 0, lv.Z)
		if flat.Magnitude < 1e-6 then return end
		flat = flat.Unit

		local yaw = math.atan2(-flat.X, -flat.Z)
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yaw, 0)
	end)
end

--======================
-- FLY CORE
--======================
local function startFly(baseHeight, withDropCheck, withWallAvoid, onDropCallback)
	killForces()

	bp = Instance.new("BodyPosition")
	bp.MaxForce = Vector3.new(0, 1e9, 0)
	bp.P = 1e6
	bp.D = 500
	bp.Parent = hrp

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e9, 0, 1e9)
	bv.Parent = hrp

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

		-- Wall avoid (left/right)
		if withWallAvoid and dir.Magnitude > 0 then
			local left = raySide(hrp.Position, -hrp.CFrame.RightVector)
			local right = raySide(hrp.Position, hrp.CFrame.RightVector)

			-- if one side is blocked, steer to the open side
			if left and not right then
				dir += hrp.CFrame.RightVector
			elseif right and not left then
				dir -= hrp.CFrame.RightVector
			end

			if dir.Magnitude > 0 then
				dir = Vector3.new(dir.X, 0, dir.Z).Unit
			end
		end

		bv.Velocity = dir * FLY_SPEED
		bp.Position = Vector3.new(hrp.Position.X, fixedY, hrp.Position.Z)

		-- Terrain drop detection (Mode 1)
		if withDropCheck and dir.Magnitude > 0 then
			local nowY = rayDown(hrp.Position)
			local aheadY = rayDown(hrp.Position + dir * AHEAD_DISTANCE)

			if nowY and aheadY and (nowY - aheadY) >= DROP_THRESHOLD then
				if onDropCallback then onDropCallback(nowY) end
			end
		end
	end)
end

--======================
-- UI (PRO)
--======================
local gui = Instance.new("ScreenGui")
gui.Name = "PHUCMAX_UI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Toggle button
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

-- Main window
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 360)
main.Position = UDim2.new(0.5, -130, 0.5, -180)
main.BackgroundColor3 = THEME_PRIMARY
main.BackgroundTransparency = 0.06
main.Active = true
main.Draggable = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 18)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.Color = THEME_ACCENT

-- Background image
local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundTransparency = 1
bg.Image = UI_BG_IMAGE_ID
bg.ScaleType = Enum.ScaleType.Crop

local bgCorner = Instance.new("UICorner", bg)
bgCorner.CornerRadius = UDim.new(0, 18)

-- Overlay (readability)
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
header.TextColor3 = THEME_ACCENT
header.TextStrokeColor3 = THEME_ACCENT
header.TextStrokeTransparency = 0.35

-- Slight wave effect (pro: subtle pulse, not rainbow)
task.spawn(function()
	local t = 0
	while header and header.Parent do
		t += 0.03
		local pulse = 0.85 + 0.15 * math.sin(t)
		header.TextColor3 = THEME_ACCENT:Lerp(Color3.new(1,1,1), 1 - pulse)
		task.wait()
	end
end)

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

	return b
end

local fly1Btn  = makeButton("Fly Mode 1 (Auto Stop on Drop)", 80)
local fly2Btn  = makeButton("Fly Mode 2 (Wall Avoid)", 140)
local shiftBtn = makeButton("Shift Lock : OFF", 200)
local autoBtn  = makeButton("Auto Collect : OFF", 260) -- newly added

local function setBtnOn(btn, on)
	btn.TextColor3 = on and THEME_ACCENT or THEME_OFF
end

--======================
-- AUTO COLLECT (Spam RemoteEvent)
--======================
local autoCollectOn = false
local collectRemote
-- safe get reference once
pcall(function()
	collectRemote = ReplicatedStorage:WaitForChild("RemoteEvents", 2)
	if collectRemote then
		collectRemote = collectRemote:WaitForChild("CollectMoney", 2)
	end
end)

local function startAutoCollect(interval)
	-- run in a separate task so it won't block UI
	task.spawn(function()
		while autoCollectOn do
			-- ensure remote exists each cycle (in case of reparenting)
			local remote = collectRemote
			if not remote then
				-- try to grab again safely
				local ok, tbl = pcall(function()
					local re = ReplicatedStorage:WaitForChild("RemoteEvents", 2)
					if re then return re:FindFirstChild("CollectMoney") end
					return nil
				end)
				remote = ok and tbl or nil
			end

			for i = 1, 50 do
				if not autoCollectOn then break end
				if remote then
					local success, err = pcall(function()
						local args = { "Slot"..i }
						remote:FireServer(unpack(args))
					end)
					-- ignore errors, continue
				end
				-- small short wait between sends to avoid overwhelming - optional tiny gap
				task.wait(0.01)
			end

			-- wait the configured interval before next cycle
			local waited = 0
			while autoCollectOn and waited < interval do
				task.wait(0.05)
				waited = waited + 0.05
			end
		end
	end)
end

-- Auto button logic
autoBtn.MouseButton1Click:Connect(function()
	autoCollectOn = not autoCollectOn

	if autoCollectOn then
		setBtnOn(autoBtn, true)
		autoBtn.Text = "Auto Collect : ON"
		notify("PHUCMAX", "Auto Collect Enabled")
		startAutoCollect(AUTO_COLLECT_INTERVAL)
	else
		setBtnOn(autoBtn, false)
		autoBtn.Text = "Auto Collect : OFF"
		notify("PHUCMAX", "Auto Collect Disabled")
	end
end)

--======================
-- BUTTON LOGIC
--======================
fly1Btn.MouseButton1Click:Connect(function()
	fly1On = not fly1On

	-- prevent both at once
	if fly1On and fly2On then
		fly2On = false
		if conn2 then conn2:Disconnect() conn2 = nil end
	end

	if fly1On then
		setBtnOn(fly1Btn, true)
		setBtnOn(fly2Btn, false)
		notify("PHUCMAX", "Fly Mode 1 Enabled")

		if conn1 then conn1:Disconnect() end
		conn1 = startFly(FLY_HEIGHT, true, false, function(nowY)
			notify("PHUCMAX", "Terrain drop detected. Fly disabled.")
			fly1On = false
			if conn1 then conn1:Disconnect() conn1 = nil end
			killForces()
			-- land safely on current ground (not into the hole)
			hrp.CFrame = CFrame.new(hrp.Position.X, nowY + 2, hrp.Position.Z)
			setBtnOn(fly1Btn, false)
		end)
	else
		setBtnOn(fly1Btn, false)
		notify("PHUCMAX", "Fly Mode 1 Disabled")
		if conn1 then conn1:Disconnect() conn1 = nil end
		killForces()
	end
end)

fly2Btn.MouseButton1Click:Connect(function()
	fly2On = not fly2On

	-- prevent both at once
	if fly2On and fly1On then
		fly1On = false
		if conn1 then conn1:Disconnect() conn1 = nil end
	end

	if fly2On then
		setBtnOn(fly2Btn, true)
		setBtnOn(fly1Btn, false)
		notify("PHUCMAX", "Fly Mode 2 Enabled")

		if conn2 then conn2:Disconnect() end
		conn2 = startFly(FLY_HEIGHT, false, true, nil)
	else
		setBtnOn(fly2Btn, false)
		notify("PHUCMAX", "Fly Mode 2 Disabled")
		if conn2 then conn2:Disconnect() conn2 = nil end
		killForces()
	end
end)

shiftBtn.MouseButton1Click:Connect(function()
	if shiftLockOn then
		disableShiftLock()
		shiftBtn.Text = "Shift Lock : OFF"
		setBtnOn(shiftBtn, false)
	else
		enableShiftLock()
		shiftBtn.Text = "Shift Lock : ON"
		setBtnOn(shiftBtn, true)
	end
end)

--======================
-- UI TOGGLE ANIMATION (premium)
--======================
local uiOpen = true
local openSize = UDim2.new(0, 260, 0, 360)
local closedSize = UDim2.new(0, 260, 0, 0)

local function tweenDescTransparency(root, target, t)
	for _, d in ipairs(root:GetDescendants()) do
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

	if uiOpen then
		main.Visible = true
		TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = openSize}):Play()
		tweenDescTransparency(main, 0, 0.25)
	else
		TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = closedSize}):Play()
		tweenDescTransparency(main, 1, 0.2)
		task.delay(0.25, function()
			if not uiOpen then main.Visible = false end
		end)
	end
end)

--======================
-- Cleanup on death
--======================
if humanoid then
	humanoid.Died:Connect(function()
		fly1On, fly2On = false, false
		if conn1 then conn1:Disconnect() conn1 = nil end
		if conn2 then conn2:Disconnect() conn2 = nil end
		killForces()
		disableShiftLock()

		-- ensure auto collect stops on death
		autoCollectOn = false
		setBtnOn(autoBtn, false)
		autoBtn.Text = "Auto Collect : OFF"
	end)
end