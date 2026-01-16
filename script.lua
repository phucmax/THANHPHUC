--==============================
-- PHUCMAX | FULL ORIGINAL + AUTO COLLECT (RSPY EXACT)
--==============================

repeat task.wait() until game:IsLoaded()

--------------------------------------------------
-- CONFIG
--------------------------------------------------
local UI_BG_IMAGE_ID = "rbxassetid://89799706653949"
local TOGGLE_BG_IMAGE_ID = "rbxassetid://89799706653949"

local FLY_HEIGHT = 8
local FLY_SPEED = 150

local DROP_THRESHOLD = 5
local AHEAD_DISTANCE = 10
local WALL_DETECT_DIST = 10

local SHIFTLOCK_CAMERA_OFFSET = Vector3.new(1.5, 0, 0)

local THEME_PRIMARY = Color3.fromRGB(10, 14, 22)
local THEME_SURFACE = Color3.fromRGB(18, 24, 36)
local THEME_TEXT    = Color3.fromRGB(235, 245, 255)
local THEME_ACCENT  = Color3.fromRGB(90, 255, 170)
local THEME_OFF     = Color3.fromRGB(150, 160, 170)

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

--------------------------------------------------
-- NOTIFY
--------------------------------------------------
local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 2
		})
	end)
end

--------------------------------------------------
-- CHARACTER
--------------------------------------------------
local char, hrp, humanoid

local function bindCharacter(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	humanoid = c:WaitForChild("Humanoid")
end

bindCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(bindCharacter)

--------------------------------------------------
-- RAYCAST
--------------------------------------------------
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

--------------------------------------------------
-- FLY CORE (ORIGINAL)
--------------------------------------------------
local fly1On, fly2On = false, false
local conn1, conn2
local bp, bv

local function killForces()
	if bp then bp:Destroy() bp = nil end
	if bv then bv:Destroy() bv = nil end
end

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

		if withWallAvoid and dir.Magnitude > 0 then
			local left = raySide(hrp.Position, -hrp.CFrame.RightVector)
			local right = raySide(hrp.Position, hrp.CFrame.RightVector)

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

		if withDropCheck and dir.Magnitude > 0 then
			local nowY = rayDown(hrp.Position)
			local aheadY = rayDown(hrp.Position + dir * AHEAD_DISTANCE)
			if nowY and aheadY and (nowY - aheadY) >= DROP_THRESHOLD then
				if onDropCallback then onDropCallback(nowY) end
			end
		end
	end)
end

--------------------------------------------------
-- AUTO COLLECT MONEY (RSPY EXACT – KHÔNG SỬA)
--------------------------------------------------
local autoCollectOn = false
local autoCollectThread

local function startAutoCollect()
	if autoCollectThread then return end

	autoCollectThread = task.spawn(function()
		while autoCollectOn do
			for i = 1, 50 do
				if not autoCollectOn then break end
				local args = {
					"Slot"..i
				}
				game:GetService("ReplicatedStorage")
					:WaitForChild("RemoteEvents")
					:WaitForChild("CollectMoney")
					:FireServer(unpack(args))
			end
			task.wait(0.5)
		end
	end)
end

local function stopAutoCollect()
	autoCollectOn = false
	autoCollectThread = nil
end

--------------------------------------------------
-- UI
--------------------------------------------------
pcall(function()
	player.PlayerGui:FindFirstChild("PHUCMAX_UI"):Destroy()
end)

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PHUCMAX_UI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 420)
main.Position = UDim2.new(0.5, -130, 0.5, -210)
main.BackgroundColor3 = THEME_PRIMARY
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundTransparency = 1
header.Text = "PHUCMAX"
header.Font = Enum.Font.GothamBlack
header.TextSize = 28
header.TextColor3 = THEME_ACCENT

local function makeButton(text, y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(1, -40, 0, 46)
	b.Position = UDim2.new(0, 20, 0, y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.BackgroundColor3 = THEME_SURFACE
	b.TextColor3 = THEME_TEXT
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
	return b
end

local fly1Btn  = makeButton("Fly Mode 1 (Auto Stop)", 80)
local fly2Btn  = makeButton("Fly Mode 2 (Wall Avoid)", 140)
local shiftBtn = makeButton("Shift Lock : OFF", 200)
local collectBtn = makeButton("Auto Collect Money : OFF", 260)

--------------------------------------------------
-- SHIFT LOCK
--------------------------------------------------
local shiftLockOn = false
local shiftLockConn

local function disableShiftLock()
	shiftLockOn = false
	if shiftLockConn then shiftLockConn:Disconnect() shiftLockConn = nil end
	if humanoid then
		humanoid.AutoRotate = true
		humanoid.CameraOffset = Vector3.new()
	end
end

local function enableShiftLock()
	shiftLockOn = true
	if humanoid then
		humanoid.AutoRotate = false
		humanoid.CameraOffset = SHIFTLOCK_CAMERA_OFFSET
	end

	if shiftLockConn then shiftLockConn:Disconnect() end
	shiftLockConn = RunService.RenderStepped:Connect(function()
		if not shiftLockOn or not hrp then return end
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

--------------------------------------------------
-- BUTTON EVENTS
--------------------------------------------------
fly1Btn.MouseButton1Click:Connect(function()
	fly1On = not fly1On
	if fly1On then
		if conn1 then conn1:Disconnect() end
		conn1 = startFly(FLY_HEIGHT, true, false, function(nowY)
			fly1On = false
			if conn1 then conn1:Disconnect() conn1 = nil end
			killForces()
			hrp.CFrame = CFrame.new(hrp.Position.X, nowY + 2, hrp.Position.Z)
		end)
	else
		if conn1 then conn1:Disconnect() conn1 = nil end
		killForces()
	end
end)

fly2Btn.MouseButton1Click:Connect(function()
	fly2On = not fly2On
	if fly2On then
		if conn2 then conn2:Disconnect() end
		conn2 = startFly(FLY_HEIGHT, false, true, nil)
	else
		if conn2 then conn2:Disconnect() conn2 = nil end
		killForces()
	end
end)

shiftBtn.MouseButton1Click:Connect(function()
	if shiftLockOn then
		disableShiftLock()
		shiftBtn.Text = "Shift Lock : OFF"
	else
		enableShiftLock()
		shiftBtn.Text = "Shift Lock : ON"
	end
end)

collectBtn.MouseButton1Click:Connect(function()
	autoCollectOn = not autoCollectOn
	if autoCollectOn then
		collectBtn.Text = "Auto Collect Money : ON"
		startAutoCollect()
	else
		collectBtn.Text = "Auto Collect Money : OFF"
		stopAutoCollect()
	end
end)

--------------------------------------------------
-- CLEAN ON DEATH
--------------------------------------------------
if humanoid then
	humanoid.Died:Connect(function()
		fly1On, fly2On = false, false
		autoCollectOn = false
		stopAutoCollect()
		if conn1 then conn1:Disconnect() conn1 = nil end
		if conn2 then conn2:Disconnect() conn2 = nil end
		killForces()
		disableShiftLock()
		if collectBtn then
			collectBtn.Text = "Auto Collect Money : OFF"
		end
	end)
end