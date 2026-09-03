-- EGG TOOLS V4
-- ANTI VANG + RETURN TO SAFE POSITION + TELEPORT + AUTO PICK
-- BYPASS / SPEED / ANTI NGA / DELETE DA DUOC LOAI BO

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local destroyed = false
local teleportActive = false
local autoPickActive = false
local antiVangActive = true

local TELE_DISTANCE = 400
local FLING_SPEED = 90
local SAFE_UPDATE_DISTANCE = 12

local Remote
pcall(function()
    Remote = ReplicatedStorage:WaitForChild("Packages", 5)
        :WaitForChild("Networking", 5)
        :WaitForChild("RF/EggWorld/AskFieldEggCarry", 5)
end)

-- =========================
-- UI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "PHUCMAX_EGG_TOOLS"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(345, 315)
main.Position = UDim2.new(0.5, -172, 0.5, -157)
main.BackgroundColor3 = Color3.fromRGB(9, 11, 18)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 22)

local outline = Instance.new("UIStroke", main)
outline.Color = Color3.fromRGB(72, 88, 125)
outline.Transparency = 0.18
outline.Thickness = 1.2

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 82)
header.BackgroundColor3 = Color3.fromRGB(18, 23, 36)
header.BorderSizePixel = 0
header.Active = true
header.Parent = main

local hc = Instance.new("UICorner", header)
hc.CornerRadius = UDim.new(0, 22)

local accent = Instance.new("Frame")
accent.Size = UDim2.new(1, 0, 0, 3)
accent.Position = UDim2.fromOffset(0, 79)
accent.BackgroundColor3 = Color3.fromRGB(72, 154, 255)
accent.BorderSizePixel = 0
accent.Parent = header

local logo = Instance.new("Frame")
logo.Size = UDim2.fromOffset(50, 50)
logo.Position = UDim2.fromOffset(16, 16)
logo.BackgroundColor3 = Color3.fromRGB(31, 46, 73)
logo.BorderSizePixel = 0
logo.Parent = header
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 15)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.fromScale(1, 1)
logoText.BackgroundTransparency = 1
logoText.Text = "EGG"
logoText.TextColor3 = Color3.fromRGB(220, 235, 255)
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 11
logoText.Parent = logo

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(78, 16)
title.Size = UDim2.new(1, -95, 0, 27)
title.Text = "PM"
title.TextColor3 = Color3.fromRGB(248, 250, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBlack
title.TextSize = 19
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(79, 44)
subtitle.Size = UDim2.new(1, -95, 0, 18)
subtitle.Text = "ANTI FLING  •  MOVEMENT  •  PICKUP"
subtitle.TextColor3 = Color3.fromRGB(126, 145, 177)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 9
subtitle.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(38, 38)
minimize.Position = UDim2.new(1, -52, 0, 22)
minimize.BackgroundColor3 = Color3.fromRGB(31, 38, 55)
minimize.Text = "—"
minimize.TextColor3 = Color3.fromRGB(235, 240, 250)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.AutoButtonColor = false
minimize.Parent = header
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 12)

local body = Instance.new("Frame")
body.Size = UDim2.new(1, -28, 1, -96)
body.Position = UDim2.fromOffset(14, 91)
body.BackgroundTransparency = 1
body.Parent = main

local function makeSection(y, text)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(5, y)
    label.Size = UDim2.new(1, -10, 0, 18)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(100, 126, 166)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9
    label.Parent = body
end

local function makeToggle(y, name, desc, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 68)
    card.Position = UDim2.fromOffset(0, y)
    card.BackgroundColor3 = Color3.fromRGB(17, 22, 34)
    card.BorderSizePixel = 0
    card.Parent = body
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(55, 69, 96)
    cs.Transparency = 0.35

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.fromOffset(15, 11)
    nameLabel.Size = UDim2.new(1, -105, 0, 21)
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(240, 244, 252)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.fromOffset(15, 34)
    descLabel.Size = UDim2.new(1, -105, 0, 20)
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(126, 141, 166)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 9
    descLabel.Parent = card

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(66, 32)
    button.Position = UDim2.new(1, -82, 0.5, -16)
    button.BackgroundColor3 = default and Color3.fromRGB(48, 170, 112) or Color3.fromRGB(45, 52, 70)
    button.Text = default and "ON" or "OFF"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    button.AutoButtonColor = false
    button.Parent = card
    Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = state and "cac" or "lon"
        button.BackgroundColor3 = state and Color3.fromRGB(48, 170, 112) or Color3.fromRGB(45, 52, 70)
        callback(state)
    end)
end



makeSection(99, "ACTIONS")
makeToggle(120, "TELEPORT 100", "caclon.", false, function(v)
    teleportActive = v
end)

makeToggle(198, "AUTO PICK", "Tu dong nhat.", false, function(v)
    autoPickActive = v
end)

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(8, 275)
status.Size = UDim2.new(1, -16, 0, 18)
status.Text = "● SYSTEM READY"
status.TextColor3 = Color3.fromRGB(92, 190, 135)
status.TextXAlignment = Enum.TextXAlignment.Center
status.Font = Enum.Font.GothamBold
status.TextSize = 9
status.Parent = body

-- =========================
-- Drag
-- =========================
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(345, 82) or UDim2.fromOffset(345, 315)
    minimize.Text = minimized and "+" or "—"
end)

-- =========================
-- Teleport
-- =========================
local function teleport100()
    local spawn = Workspace:FindFirstChild("SpawnLocation")
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not spawn or not root then return end

    local flat = Vector3.new(
        root.Position.X - spawn.Position.X,
        0,
        root.Position.Z - spawn.Position.Z
    )

    if flat.Magnitude > TELE_DISTANCE then
        local p = spawn.Position + flat.Unit * TELE_DISTANCE
        root.CFrame = CFrame.new(p.X, root.Position.Y, p.Z)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

-- =========================
-- Egg helpers
-- =========================
local function extractUid(obj)
    local a = obj:GetAttribute("Uid") or obj:GetAttribute("UID")
    if a then return tostring(a) end

    local c = obj:FindFirstChild("Uid") or obj:FindFirstChild("UID")
    if c and c:IsA("StringValue") then
        return tostring(c.Value)
    end

    if obj.Name:match("FirstAreaEgg")
        or obj.Name:match("%x%x%x%x%x%x%x%x%-%x%x%x%x")
        or #obj.Name == 32 then
        return obj.Name
    end
end

local function getSize(obj)
    if obj:IsA("BasePart") then
        return obj.Size.X * obj.Size.Y * obj.Size.Z
    end

    if obj:IsA("Model") then
        local ok, size = pcall(function()
            return obj:GetExtentsSize()
        end)
        if ok and size then
            return size.X * size.Y * size.Z
        end
    end

    return 0
end

-- =========================
-- Anti fling + safe position
-- =========================
local safeCFrame
local lastGoodPosition
local lastSafeUpdate = 0

local function setSafe(root)
    safeCFrame = root.CFrame
    lastGoodPosition = root.Position
    lastSafeUpdate = os.clock()
end

local function antiFling(root)
    if not antiVangActive then return end

    local v = root.AssemblyLinearVelocity
    local horizontal = Vector3.new(v.X, 0, v.Z)

    -- Detect a real fling BEFORE updating the safe position.
    if horizontal.Magnitude > FLING_SPEED or math.abs(v.Y) > FLING_SPEED then
        if safeCFrame then
            root.CFrame = safeCFrame
        end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        return
    end

    local av = root.AssemblyAngularVelocity
    if av.Magnitude > 35 then
        root.AssemblyAngularVelocity = av.Unit * 35
    end

    -- Keep a recent safe position, but don't chase a bad fling frame.
    if not lastGoodPosition or (root.Position - lastGoodPosition).Magnitude <= SAFE_UPDATE_DISTANCE then
        setSafe(root)
    end
end

-- =========================
-- Heartbeat
-- =========================
local hb
hb = RunService.Heartbeat:Connect(function()
    if destroyed then
        hb:Disconnect()
        return
    end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if root and hum then
        antiFling(root)

        if teleportActive then
            teleport100()
        end
    end
end)

-- =========================
-- Auto Pick
-- Delay giữ nguyên như bản boss gửi
-- =========================
task.spawn(function()
    while not destroyed do
        if autoPickActive and Remote then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local best, bestSize = nil, -math.huge

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") or obj:IsA("BasePart") then
                        local uid = extractUid(obj)

                        if uid then
                            local pos
                            pcall(function()
                                pos = obj:IsA("BasePart")
                                    and obj.Position
                                    or obj:GetPivot().Position
                            end)

                            if pos and (hrp.Position - pos).Magnitude <= 10 then
                                local size = getSize(obj)

                                if size > bestSize then
                                    bestSize = size
                                    best = {uid = uid}
                                end
                            end
                        end
                    end
                end

                if best then
                    pcall(function()
                        Remote:InvokeServer({Uid = best.uid})
                    end)
                end
            end
        end
        task.wait(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005)
    end
end)

-- Reset safe position after respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    if destroyed then return end

    task.wait(0.25)

    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        setSafe(root)
    end
end)

-- Initial safe position
task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart", 10)
    if root and not destroyed then
        setSafe(root)
    end
end)
