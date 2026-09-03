-- EGG TOOLS V4
-- ANTI VANG + RETURN TO SAFE POSITION + TELEPORT + AUTO PICK
-- (UI đã được sửa – siêu nhỏ gọn, không đụng logic)

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
-- UI MỚI – SIÊU NHỎ GỌN
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "PHUCMAX_EGG_TOOLS"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 210)
main.Position = UDim2.new(0.5, -140, 0.5, -105)
main.BackgroundColor3 = Color3.fromRGB(9, 11, 18)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 16)

local outline = Instance.new("UIStroke", main)
outline.Color = Color3.fromRGB(72, 88, 125)
outline.Transparency = 0.18
outline.Thickness = 1

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 56)
header.BackgroundColor3 = Color3.fromRGB(18, 23, 36)
header.BorderSizePixel = 0
header.Active = true
header.Parent = main

local hc = Instance.new("UICorner", header)
hc.CornerRadius = UDim.new(0, 16)

local accent = Instance.new("Frame")
accent.Size = UDim2.new(1, 0, 0, 2)
accent.Position = UDim2.fromOffset(0, 54)
accent.BackgroundColor3 = Color3.fromRGB(72, 154, 255)
accent.BorderSizePixel = 0
accent.Parent = header

local logo = Instance.new("Frame")
logo.Size = UDim2.fromOffset(34, 34)
logo.Position = UDim2.fromOffset(8, 11)
logo.BackgroundColor3 = Color3.fromRGB(31, 46, 73)
logo.BorderSizePixel = 0
logo.Parent = header
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 10)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.fromScale(1, 1)
logoText.BackgroundTransparency = 1
logoText.Text = "EGG"
logoText.TextColor3 = Color3.fromRGB(220, 235, 255)
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 9
logoText.Parent = logo

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(48, 12)
title.Size = UDim2.new(1, -70, 0, 20)
title.Text = "EGG TOOLS"
title.TextColor3 = Color3.fromRGB(248, 250, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(49, 32)
subtitle.Size = UDim2.new(1, -70, 0, 14)
subtitle.Text = "MOBILE  •  FAST"
subtitle.TextColor3 = Color3.fromRGB(126, 145, 177)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 7
subtitle.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(28, 28)
minimize.Position = UDim2.new(1, -34, 0, 12)
minimize.BackgroundColor3 = Color3.fromRGB(31, 38, 55)
minimize.Text = "—"
minimize.TextColor3 = Color3.fromRGB(235, 240, 250)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 14
minimize.AutoButtonColor = false
minimize.Parent = header
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)

-- Body
local body = Instance.new("Frame")
body.Size = UDim2.new(1, -16, 1, -70)
body.Position = UDim2.fromOffset(8, 62)
body.BackgroundTransparency = 1
body.Parent = main

-- Hàm tạo section
local function makeSection(y, text)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(2, y)
    label.Size = UDim2.new(1, -4, 0, 14)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(100, 126, 166)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 8
    label.Parent = body
end

-- Hàm tạo toggle
local function makeToggle(y, name, desc, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 50)
    card.Position = UDim2.fromOffset(0, y)
    card.BackgroundColor3 = Color3.fromRGB(17, 22, 34)
    card.BorderSizePixel = 0
    card.Parent = body
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(55, 69, 96)
    cs.Transparency = 0.35

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.fromOffset(10, 7)
    nameLabel.Size = UDim2.new(1, -85, 0, 16)
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(240, 244, 252)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 11
    nameLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.fromOffset(10, 25)
    descLabel.Size = UDim2.new(1, -85, 0, 14)
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(126, 141, 166)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 8
    descLabel.Parent = card

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(54, 26)
    button.Position = UDim2.new(1, -64, 0.5, -13)
    button.BackgroundColor3 = default and Color3.fromRGB(48, 170, 112) or Color3.fromRGB(45, 52, 70)
    button.Text = default and "ON" or "OFF"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 9
    button.AutoButtonColor = false
    button.Parent = card
    Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = state and "ON" or "OFF"
        button.BackgroundColor3 = state and Color3.fromRGB(48, 170, 112) or Color3.fromRGB(45, 52, 70)
        callback(state)
    end)
end

-- Tạo section và các toggle
makeSection(0, "ACTIONS")
makeToggle(18, "TELEPORT", "Giữ khoảng cách với spawn", false, function(v)
    teleportActive = v
end)
makeToggle(75, "AUTO PICK", "Tự động nhặt trứng gần", false, function(v)
    autoPickActive = v
end)

-- Status label
local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(0, 128)
status.Size = UDim2.new(1, 0, 0, 14)
status.Text = "● SYSTEM READY"
status.TextColor3 = Color3.fromRGB(92, 190, 135)
status.TextXAlignment = Enum.TextXAlignment.Center
status.Font = Enum.Font.GothamBold
status.TextSize = 8
status.Parent = body

-- =========================
-- Drag (giữ nguyên logic)
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
    main.Size = minimized and UDim2.fromOffset(280, 56) or UDim2.fromOffset(280, 210)
    minimize.Text = minimized and "+" or "—"
end)

-- =========================
-- Teleport (giữ nguyên)
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
-- Egg helpers (giữ nguyên)
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
-- Anti fling + safe position (giữ nguyên)
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

    if not lastGoodPosition or (root.Position - lastGoodPosition).Magnitude <= SAFE_UPDATE_DISTANCE then
        setSafe(root)
    end
end

-- =========================
-- Heartbeat (giữ nguyên)
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
-- Auto Pick (giữ nguyên)
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